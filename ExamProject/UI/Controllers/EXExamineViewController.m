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
	UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backwardItemClicked:)];
    self.navigationItem.leftBarButtonItem= backButton;
    self.navigationController.toolbar.tintColor = [UIColor colorWithRed:0x74/255.0f green:0xa2/255.0f blue:0x40/255.0f alpha:1.0f];
    
    float width=CGRectGetWidth(self.navigationController.toolbar.frame)/3;
    UIBarButtonItem*submitButton = [[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(submitExaminationItemClicked:)] autorelease];
    self.navigationItem.rightBarButtonItem= submitButton;
    
    UIBarButtonItem *collectButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(collectItemClicked:)] autorelease];
    
    UIBarButtonItem *flexibleSpace1 = [[[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:nil
                                       action:nil] autorelease];
    
    UIBarButtonItem *preButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(preItemClicked:)] autorelease];
    preButton.width=width;
    
    UIBarButtonItem *flexibleSpace2 = [[[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:nil
                                       action:nil] autorelease];
    
    UIBarButtonItem *nextButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextItemClicked:)] autorelease];
    nextButton.width=width;
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    if (displayTopicType==kDisplayTopicType_Default) {
        [self setToolbarItems:[NSArray arrayWithObjects:preButton,flexibleSpace1,nextButton,flexibleSpace2,collectButton,nil]];
    }else{
        [self setToolbarItems:[NSArray arrayWithObjects:preButton,flexibleSpace1,nextButton,nil]];
    }
    
    
	// Do any additional setup after loading the view.
    if (_examineListView==nil) {
        _examineListView=[[EXExaminationListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(self.navigationController.navigationBar.frame)-62)];
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

- (void)viewWillDisappear:(BOOL)animated
{
    //返回回调
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经将改试题添加到收藏" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(removeAlertTip:) withObject:alert afterDelay:2];
    [alert release];
}

- (void)removeAlertTip:(id)object{
    if ([object isKindOfClass:[UIAlertView class]]) {
        [((UIAlertView *)object)dismissWithClickedButtonIndex:0 animated:YES];
    }
}

//批改试卷
- (void)markPaper{
    //计算总成绩并判断答过的题是否有错误，有标记该试卷有错误
    __block NSInteger mark=0;
    if (_paperData.topics) {
        [_paperData.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
            if (obj && ([obj.type integerValue]==1 || [obj.type integerValue]==2 || [obj.type integerValue]==3)) {
                //先判断试题类型：只有选择题和判断题可以进行判断，简答暂不做判断
                NSLog(@"answer:%@,result:%@,score:%@",obj.selected,obj.analysis,obj.value);
                if (obj.analysis && [obj.analysis integerValue]!=-100) {
                    if ([obj.analysis isEqualToString:obj.selected]) {
                        //正确
                        obj.wrong=[NSNumber numberWithBool:NO];
                        mark+=[obj.value integerValue];
                    }else{
                        //错误
                        obj.wrong=[NSNumber numberWithBool:YES];
                        if ([_paperData.wrong boolValue]==NO) {
                            _paperData.wrong=[NSNumber numberWithBool:YES];
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
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            CustomTabBarController *tabBarController=appDelegate.tabController;
            [tabBarController showTabBar];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
