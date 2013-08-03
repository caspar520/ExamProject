//
//  ExamViewController.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "ExamViewController.h"
#import "PaperData.h"
#import "TopicData.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "EXPaperListViewController.h"
#import "EXListView.h"
#import "EXPaperCell.h"
#import "EXExamineViewController.h"
#import "EXResultViewController.h"

@interface ExamViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation ExamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_paperListView release];
    [_localPaperList release];
    [_nullView release];
    [_nullLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self clearPaperInfo];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadPaperFinish:) name:NOTIFICATION_SOME_PAPER_DOWNLOAD_FINISH object:nil];
	// Do any additional setup after loading the view.
    self.title=@"考试";
    UIBarButtonItem *addPaperButton = [[UIBarButtonItem alloc] initWithTitle:@"添加试卷" style:UIBarButtonItemStyleBordered target:self action:@selector(addPaperItemClicked:)];
    self.navigationItem.rightBarButtonItem= addPaperButton;
    
    if (_localPaperList==nil) {
        _localPaperList=[[NSMutableArray alloc] initWithCapacity:0];
    }
//    [self clearPaperInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //每次都要清理数据库中的试题信息：总分、答过试题的答案
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    //读数据
    [_localPaperList removeAllObjects];
    [_localPaperList addObjectsFromArray:[DBManager fetchAllPapersFromDB]];
    
//    [self clearPaperInfo];
    
    if (_paperListView==nil) {
        _paperListView=[[EXListView alloc] initWithFrame:self.view.frame];
        _paperListView.delegate=self;
        _paperListView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_paperListView];
    }
    
    [_paperListView refresh];
    
    if ([_localPaperList count] > 0) {
        [self showNullView:YES];
    } else {
        [self showNullView:NO];
    }
}

- (void)showNullView:(BOOL)isHidden
{
    if (_nullView == nil && !isHidden) {
        _nullView = [[UIImageView alloc]initWithFrame:CGRectMake(94, 40, 132, 132)];
        _nullView.image = [UIImage imageNamed:@"list_null.png"];
        [self.view addSubview:_nullView];
    }
    _nullView.hidden = isHidden;
    if (_nullLabel == nil && !isHidden) {
        _nullLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nullView.frame)+10, 320, 30)];
        _nullLabel.text = @"你还没有试题!";
        _nullLabel.textAlignment = UITextAlignmentCenter;
        _nullLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_nullLabel];
    }
    _nullLabel.hidden = isHidden;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController showTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearPaperInfo{
    for (PaperData *item in _localPaperList) {
        if (item) {
            NSArray *topics=item.topics;
            if (topics) {
                for (TopicData *topic in topics) {
                    if (topic) {
                        if ([topic.type integerValue]==1 || [topic.type integerValue]==2 || [topic.type integerValue]==3) {
                            topic.analysis=[NSString stringWithFormat:@"%d",-100];
                        }else{
                            topic.analysis=nil;
                        }
                    }
                }
            }
            item.userScore=[NSNumber numberWithInteger:0];
            [DBManager addPaper:item];
        }
    }
}


#pragma mark 按钮点击事件
- (void)addPaperItemClicked:(id)sender{
    
    EXPaperListViewController *paperListController=[[EXPaperListViewController alloc] init];
    [self.navigationController pushViewController:paperListController animated:YES];
    [paperListController release];
}

#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _localPaperList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"StoryListCell";
    EXPaperCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[EXPaperCell alloc] init] autorelease];
        if (indexPath.row<_localPaperList.count) {
            cell.paperData=[_localPaperList objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //需要判断是否答过，如果答过直接进入答题界面，否则弹出选择框
    if ([self judgeIsPaperUsed:[_localPaperList objectAtIndex:indexPath.row]]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"试卷已经提交过" delegate:self cancelButtonTitle:@"查看结果" otherButtonTitles:@"重新考试", nil];
        [alert show];
        [alert release];
        
        _selectedPaper=[_localPaperList objectAtIndex:indexPath.row];
    }else{
        id paperMetaData=[_localPaperList objectAtIndex:indexPath.row];
        if (paperMetaData) {
            EXExamineViewController *examineController=[[[EXExamineViewController alloc] init] autorelease];
            [self.navigationController pushViewController:examineController animated:YES];
            examineController.displayTopicType=kDisplayTopicType_Default;
            examineController.paperData=paperMetaData;
        }
    }
}

- (void)downloadPaperFinish:(NSNotification *)notification{
    [_localPaperList removeAllObjects];
    [_localPaperList addObjectsFromArray:[DBManager fetchAllPapersFromDB]];
    [_paperListView refresh];
}

- (BOOL)judgeIsPaperUsed:(PaperData *)aPaper{
    BOOL result=NO;
    
    if (aPaper) {
        if ([aPaper.userScore integerValue]>0) {
            result=YES;
        }else{
            NSArray *topics=aPaper.topics;
            if (topics) {
                for (TopicData *topic in topics) {
                    if (topic) {
                        if ([topic.type integerValue]==1 || [topic.type integerValue]==2 || [topic.type integerValue]==3) {
                            if (![topic.analysis isEqualToString:[NSString stringWithFormat:@"%d",-100]]) {
                                result=YES;
                                break;
                            }
                        }else{
                            if (topic.analysis) {
                                result=YES;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    
    return result;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex==0) {
//        EXResultViewController *resultController=[[EXResultViewController alloc] init];
//        resultController.paperData=_selectedPaper;
//        [self.navigationController pushViewController:resultController animated:YES];
        
//    }else
    if (buttonIndex==1){
        if (_selectedPaper) {
            [self clearPaperInfo];
        }
    }
    
    EXExamineViewController *examineController=[[[EXExamineViewController alloc] init] autorelease];
    [self.navigationController pushViewController:examineController animated:YES];
    examineController.displayTopicType=kDisplayTopicType_Default;
    examineController.paperData=_selectedPaper;
}

@end
