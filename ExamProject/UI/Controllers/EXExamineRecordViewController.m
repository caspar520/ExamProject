//
//  EXExamineRecordViewController.m
//  ExamProject
//
//  Created by Brown on 13-9-7.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExamineRecordViewController.h"
#import "EXExaminationListView.h"
#import "PaperData.h"
#import "AppDelegate.h"
#import "TopicData.h"

@interface EXExamineRecordViewController ()

@end

@implementation EXExamineRecordViewController
@synthesize paperData=_paperData;
@synthesize currentIndex;

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
    
    self.title=@"考试记录";
    self.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backwardItemClicked:)];
    self.navigationItem.leftBarButtonItem= backButton;
    self.navigationController.toolbar.hidden=YES;
	// Do any additional setup after loading the view.
    
    if (_examineListView==nil) {
        _examineListView=[[EXExaminationListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(self.navigationController.navigationBar.frame))];
        _examineListView.backgroundColor=[UIColor grayColor];
        _examineListView.delegate=self;
        [self.view addSubview:_examineListView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController hideTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPaperData:(PaperData *)paperData{
    if (_paperData != paperData) {
        [_paperData release];
        _paperData =[paperData retain];
    }
    _examineListView.dipalyTopicType=kDisplayTopicType_Record;
    
    NSMutableArray *selectedArray=[NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<10; i++) {
        TopicData *obj=[[TopicData alloc] init];
        [selectedArray addObject:obj];
    }
    
    
    _examineListView.dataArray=selectedArray;
}

- (void)backwardItemClicked:(id)sender{
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
