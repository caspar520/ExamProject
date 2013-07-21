//
//  EXExamineViewController.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExamineViewController.h"
#import "EXExaminationListView.h"
#import "EXExaminationView.h"
#import "PaperData.h"
#import "EXResultViewController.h"

@interface EXExamineViewController ()<EXQuestionDelegate,UIScrollViewDelegate>

@end

@implementation EXExamineViewController

@synthesize paperData=_paperData;

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
	UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(backwardItemClicked:)];
    UIBarButtonItem*submitButton = [[UIBarButtonItem alloc] initWithTitle:@"submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitExaminationItemClicked:)];
    
    self.navigationItem.leftBarButtonItem= backButton;
    self.navigationItem.rightBarButtonItem= submitButton;
    
    UIBarButtonItem *collectButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(collectItemClicked:)];
	UIBarButtonItem *preButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(preItemClicked:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextItemClicked:)];
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    [self setToolbarItems:[NSArray arrayWithObjects:preButton,nextButton,collectButton,nil]];
    
    
	// Do any additional setup after loading the view.
    if (_examineListView==nil) {
        _examineListView=[[EXExaminationListView alloc] initWithFrame:self.view.bounds];
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
    _examineListView.dataArray=_paperData.topics;
}

#pragma mark 按钮点击事件
- (void)backwardItemClicked:(id)sender{
	if(self.navigationController){
		[self.navigationController popViewControllerAnimated:YES];
	}
}

//submit paper
- (void)submitExaminationItemClicked:(id)sender{
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
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"begin dragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"end dragging");
}

@end
