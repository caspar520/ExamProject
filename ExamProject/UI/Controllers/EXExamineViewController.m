//
//  EXExamineViewController.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExamineViewController.h"
#import "EXExaminationView.h"
#import "PaperData.h"
#import "Topic.h"
#import "EXResultViewController.h"
#import "CustomTabBarController.h"
#import "AppDelegate.h"
#import "DBManager.h"

@interface EXExamineViewController ()<EXQuestionDelegate,UIScrollViewDelegate>

@end

@implementation EXExamineViewController

@synthesize paperData=_paperData;
@synthesize displayTopicType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_examineListView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"考试";
    self.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(backwardItemClicked:)];
    self.navigationItem.leftBarButtonItem= backButton;
    
    if (displayTopicType==kDisplayTopicType_Default) {
        UIBarButtonItem*submitButton = [[UIBarButtonItem alloc] initWithTitle:@"submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitExaminationItemClicked:)];
        self.navigationItem.rightBarButtonItem= submitButton;
        
        UIBarButtonItem *collectButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(collectItemClicked:)];
        UIBarButtonItem *preButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(preItemClicked:)];
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextItemClicked:)];
        
        [self.navigationController setToolbarHidden:NO animated:NO];
        [self setToolbarItems:[NSArray arrayWithObjects:preButton,nextButton,collectButton,nil]];
    }else{
        [self.navigationController setToolbarHidden:YES animated:NO];
    }
    
	// Do any additional setup after loading the view.
    if (_examineListView==nil) {
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        CustomTabBarController *tabBarController=appDelegate.tabController;
        
        _examineListView=[[EXExaminationListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(tabBarController.tabBar.frame)-CGRectGetHeight(self.navigationController.navigationBar.frame)-20)];
        _examineListView.backgroundColor=[UIColor clearColor];
        _examineListView.delegate=self;
        [self.view addSubview:_examineListView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableArray *questions=[NSMutableArray arrayWithCapacity:0];
    
    if (_examineListView) {
        _examineListView.dataArray=questions;
    }
    
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController hideTabBar];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController showTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark set方法
- (void)setPaperData:(PaperData *)paperData{
    if (_paperData != paperData) {
        [_paperData release];
        _paperData =[paperData retain];
    }
    _examineListView.dipalyTopicType=displayTopicType;
    
    NSMutableArray *selectedArray=[NSMutableArray arrayWithCapacity:0];
    if (displayTopicType==kDisplayTopicType_Default) {
        [selectedArray addObjectsFromArray:_paperData.topics];
    }else if (displayTopicType==kDisplayTopicType_Wrong){
        if (_paperData.topics) {
            [_paperData.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
                if (obj && [obj.wrong boolValue]==YES) {
                    [selectedArray addObject:obj];
                }
            }];
        }
    }else if (displayTopicType==kDisplayTopicType_Collected){
        if (_paperData.topics) {
            [_paperData.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
                if (obj && [obj.favourite boolValue]==YES) {
                    [selectedArray addObject:obj];
                }
            }];
        }
    }
    _examineListView.dataArray=selectedArray;
}

#pragma mark 按钮点击事件
- (void)backwardItemClicked:(id)sender{
    if (displayTopicType==kDisplayTopicType_Default) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你正在考试，要返回主界面吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        [alert release];
    }else{
        if(self.navigationController){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//submit paper
- (void)submitExaminationItemClicked:(id)sender{
    [self markPaper];
    //批改试卷完成后需要上传服务器：暂不做
    
    
	//跳转到成绩界面
    EXResultViewController *resultController=[[EXResultViewController alloc] init];
    resultController.paperData=self.paperData;
    [self.navigationController pushViewController:resultController animated:YES];
}

- (void)nextItemClicked:(id)sender{
    [_examineListView nextTopic];
}

- (void)preItemClicked:(id)sender{
    [_examineListView preTopic];
}

- (void)collectItemClicked:(id)sender{
	_paperData.fav=[NSNumber numberWithBool:YES];
    [_examineListView collectionTopic];
    
    [DBManager addPaper:_paperData];
}

//批改试卷
- (void)markPaper{
    //计算总成绩并判断答过的题是否有错误，有标记该试卷有错误
    __block NSInteger mark=0;
    if (_paperData.topics) {
        [_paperData.topics enumerateObjectsUsingBlock:^(Topic *obj, NSUInteger idx, BOOL *stop) {
            if (obj && ([obj.type integerValue]==1 || [obj.type integerValue]==2 || [obj.type integerValue]==3)) {
                //先判断试题类型：只有选择题和判断题可以进行判断，简答暂不做判断
                if (obj.analysis) {
                    if ([obj.analysis isEqualToString:obj.selected]) {
                        //正确
                        obj.wrong=[NSNumber numberWithBool:NO];
                        mark+=[obj.value integerValue];
                    }else{
                        //错误
                        obj.wrong=[NSNumber numberWithBool:YES];
                        if ([_paperData.wrong boolValue]==NO) {
                            _paperData.wrong=[NSNumber numberWithBool:YES];
                            [DBManager addPaper:_paperData];
                        }
                    }
                }
            }
        }];
        _paperData.userScore=[NSNumber numberWithInteger:mark];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if(self.navigationController){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
