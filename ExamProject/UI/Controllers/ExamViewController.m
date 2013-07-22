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

@interface ExamViewController ()<UITableViewDataSource,UITableViewDelegate>

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    //读数据
    [_localPaperList removeAllObjects];
    [_localPaperList addObjectsFromArray:[DBManager fetchAllPapersFromDB]];
    
    if (_paperListView==nil) {
        _paperListView=[[EXListView alloc] initWithFrame:self.view.frame];
        _paperListView.delegate=self;
        _paperListView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_paperListView];
    }
    
    [_paperListView refresh];
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


#pragma mark 按钮点击事件
- (void)addPaperItemClicked:(id)sender{
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController hideTabBar];
    
    EXPaperListViewController *paperListController=[[EXPaperListViewController alloc] init];
    [self.navigationController pushViewController:paperListController animated:YES];
    [paperListController release];
}

#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
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
    id paperMetaData=[_localPaperList objectAtIndex:indexPath.row];
    if (paperMetaData) {
        EXExamineViewController *examineController=[[[EXExamineViewController alloc] init] autorelease];
        [self.navigationController pushViewController:examineController animated:YES];
        examineController.displayTopicType=kDisplayTopicType_Default;
        examineController.paperData=paperMetaData;
    }
}

#pragma mark 测试用

//测试添加试卷，json从本地读取
- (void)testAddPaper
{    
    //解析本地json文件
    NSString *path = [[NSBundle mainBundle]pathForResource:@"hangyeceshi-1" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSLog(@"result=%@", result);
    
    PaperData *paperData = [[PaperData alloc]init];
    paperData.paperId = [NSNumber numberWithInt:[[result objectForKey:@"id"] intValue]];
    paperData.title = [result objectForKey:@"title"];
    paperData.desc = [result objectForKey:@"description"];
    paperData.creator = [result objectForKey:@"creator"];
    paperData.totalTime = [NSNumber numberWithInt:[[result objectForKey:@"totalTime"] intValue]];
    paperData.totalScore = [NSNumber numberWithInt:[[result objectForKey:@"totalScore"] intValue]];
    paperData.topicCount = [NSNumber numberWithInt:[[result objectForKey:@"topicCount"] intValue]];
    paperData.passingScore = [NSNumber numberWithInt:[[result objectForKey:@"passingScore"] intValue]];
    paperData.eliteScore = [NSNumber numberWithInt:[[result objectForKey:@"eliteScore"] intValue]];
    
    //添加试题
//    paperData.topics = [self makeTopicsWithArray:[result objectForKey:@"topicList"]];
    
    [DBManager addPaper:paperData];
    [paperData release];

    //测试读数据库逻辑
//    NSArray *allPapers = [DBManager fetchAllPapersFromDB];
//    NSArray *collectedPapers = [DBManager fetchCollectedPapers];
//    NSArray *wrongPapers = [DBManager fetchWrongPapers];
//    NSLog(@"allPapers=%@ collectedPapers=%@ wrongPapers=%@",allPapers,collectedPapers,wrongPapers);
}

- (void)downloadPaperFinish:(NSNotification *)notification{
    [_localPaperList removeAllObjects];
    [_localPaperList addObjectsFromArray:[DBManager fetchAllPapersFromDB]];
    [_paperListView refresh];
}
@end
