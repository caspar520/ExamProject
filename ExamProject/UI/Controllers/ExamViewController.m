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

- (void)downloadPaperFinish:(NSNotification *)notification{
    [_localPaperList removeAllObjects];
    [_localPaperList addObjectsFromArray:[DBManager fetchAllPapersFromDB]];
    [_paperListView refresh];
}


@end
