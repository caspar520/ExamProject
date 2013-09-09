//
//  EXResultViewController.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXResultViewController.h"
#import "PaperData.h"
#import "TopicData.h"
#import "DBManager.h"
#import <QuartzCore/QuartzCore.h>
#import "EXExamineRecordViewController.h"

#define ANSWERSHEET_COUNT_PER_LINE  8                   //每行的序号数量

@interface EXResultViewController ()

- (void)constructUI;

@end

@implementation EXResultViewController

@synthesize paperData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [paperData release];
    [titleLabel release];
    [authorLabel release];
    [resultTipLabel release];
    [resultLabel release];
    [markLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"考试结果";
	UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(backwardItemClicked:)];
    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*
    if (titleLabel==nil) {
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), 20)];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.textAlignment=UITextAlignmentLeft;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:18];
        
        [self.view addSubview:titleLabel];
    }
//    titleLabel.text=[NSString stringWithFormat:@"试卷名称：%@",paperData.title];
    
    if (authorLabel==nil) {
        authorLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame)+5, CGRectGetMaxY(titleLabel.frame)+5, CGRectGetWidth(self.view.frame), 12)];
        authorLabel.textColor=[UIColor blackColor];
        authorLabel.textAlignment=UITextAlignmentLeft;
        authorLabel.backgroundColor=[UIColor clearColor];
        authorLabel.font=[UIFont systemFontOfSize:12];
        [self.view addSubview:authorLabel];
    }
//    authorLabel.text=[NSString stringWithFormat:@"创建者：%@",paperData.creator];
    
    if (resultTipLabel==nil) {
        
        UIImageView *preTipView=[[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(authorLabel.frame)+5+3, 8, 4)];
        preTipView.backgroundColor=[UIColor greenColor];
        [self.view addSubview:preTipView];
        [preTipView release];
        
        resultTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(preTipView.frame)+3, CGRectGetMaxY(authorLabel.frame)+5, 50, 10)];
        resultTipLabel.textColor=[UIColor blackColor];
        resultTipLabel.textAlignment=UITextAlignmentLeft;
        resultTipLabel.backgroundColor=[UIColor clearColor];
        resultTipLabel.font=[UIFont systemFontOfSize:10];
        resultTipLabel.text=@"成绩详情";
        [self.view addSubview:resultTipLabel];
        
        UIImageView *backTipSplitView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(resultTipLabel.frame)+3, CGRectGetMaxY(authorLabel.frame)+5+3, CGRectGetWidth(self.view.frame)-CGRectGetWidth(resultTipLabel.frame)-40, 4)];
        backTipSplitView.backgroundColor=[UIColor greenColor];
        [self.view addSubview:backTipSplitView];
        [backTipSplitView release];
    }
    
//    NSInteger mark=[paperData.userScore integerValue];
    if (markLabel==nil) {
        markLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame)+5, CGRectGetMaxY(resultTipLabel.frame)+5, CGRectGetWidth(self.view.frame), 12)];
        markLabel.textColor=[UIColor blackColor];
        markLabel.textAlignment=UITextAlignmentLeft;
        markLabel.backgroundColor=[UIColor clearColor];
        markLabel.font=[UIFont systemFontOfSize:12];
        [self.view addSubview:markLabel];
    }
//    markLabel.text=[NSString stringWithFormat:@"考试成绩：%d",mark];
    
    if (resultLabel==nil) {
        resultLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame)+5, CGRectGetMaxY(markLabel.frame)+5, CGRectGetWidth(self.view.frame), 12)];
        resultLabel.textColor=[UIColor blackColor];
        resultLabel.textAlignment=UITextAlignmentLeft;
        resultLabel.backgroundColor=[UIColor clearColor];
        resultLabel.font=[UIFont systemFontOfSize:12];
        [self.view addSubview:resultLabel];
    }
//    NSString *result=nil;
//    if (mark<[paperData.passingScore integerValue]) {
//        result=@"成绩不合格";
//    }else if (mark<[paperData.eliteScore integerValue]){
//        result=@"成绩合格";
//    }else{
//        result=@"成绩优秀";
//    }
//    resultLabel.text=result;
     */
    [self constructUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)constructUI
{
    NSArray *subViews=[self.view subviews];
    for (UIView *item in subViews) {
        if (item) {
            [item removeFromSuperview];
            item=nil;
        }
    }
    answerSheet=nil;
    
    UILabel *markTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(15,20,50,30)];
    markTipLabel.textColor=[UIColor blackColor];
    markTipLabel.textAlignment=UITextAlignmentLeft;
    markTipLabel.backgroundColor=[UIColor clearColor];
    markTipLabel.font=[UIFont systemFontOfSize:18];
    [markTipLabel setText:@"得分:"];
    [self.view addSubview:markTipLabel];
    [markTipLabel release];
    
    UILabel *topicCountTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markTipLabel.frame)+120,markTipLabel.frame.origin.y,50,30)];
    topicCountTipLabel.textColor=[UIColor blackColor];
    topicCountTipLabel.textAlignment=UITextAlignmentLeft;
    topicCountTipLabel.backgroundColor=[UIColor clearColor];
    topicCountTipLabel.font=[UIFont systemFontOfSize:18];
    [topicCountTipLabel setText:@"答题:"];
    [self.view addSubview:topicCountTipLabel];
    [topicCountTipLabel release];
    
    UILabel *rightTopicCountTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(markTipLabel.frame),CGRectGetMaxY(markTipLabel.frame)+5,50,30)];
    rightTopicCountTipLabel.textColor=[UIColor blackColor];
    rightTopicCountTipLabel.textAlignment=UITextAlignmentLeft;
    rightTopicCountTipLabel.backgroundColor=[UIColor clearColor];
    rightTopicCountTipLabel.font=[UIFont systemFontOfSize:18];
    [rightTopicCountTipLabel setText:@"答对:"];
    [self.view addSubview:rightTopicCountTipLabel];
    [rightTopicCountTipLabel release];
    
    UILabel *wrongTopicCountTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(topicCountTipLabel.frame),rightTopicCountTipLabel.frame.origin.y,50,30)];
    wrongTopicCountTipLabel.textColor=[UIColor blackColor];
    wrongTopicCountTipLabel.textAlignment=UITextAlignmentLeft;
    wrongTopicCountTipLabel.backgroundColor=[UIColor clearColor];
    wrongTopicCountTipLabel.font=[UIFont systemFontOfSize:18];
    [wrongTopicCountTipLabel setText:@"答错:"];
    [self.view addSubview:wrongTopicCountTipLabel];
    [wrongTopicCountTipLabel release];
    
    UILabel *rightRateTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(markTipLabel.frame),CGRectGetMaxY(rightTopicCountTipLabel.frame)+5,60,30)];
    rightRateTipLabel.textColor=[UIColor blackColor];
    rightRateTipLabel.textAlignment=UITextAlignmentLeft;
    rightRateTipLabel.backgroundColor=[UIColor clearColor];
    rightRateTipLabel.font=[UIFont systemFontOfSize:18];
    [rightRateTipLabel setText:@"正确率:"];
    [self.view addSubview:rightRateTipLabel];
    [rightRateTipLabel release];
    
    UILabel *answerDurationTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(topicCountTipLabel.frame),rightRateTipLabel.frame.origin.y,50,30)];
    answerDurationTipLabel.textColor=[UIColor blackColor];
    answerDurationTipLabel.textAlignment=UITextAlignmentLeft;
    answerDurationTipLabel.backgroundColor=[UIColor clearColor];
    answerDurationTipLabel.font=[UIFont systemFontOfSize:18];
    [answerDurationTipLabel setText:@"用时:"];
    [self.view addSubview:answerDurationTipLabel];
    [answerDurationTipLabel release];
    
    UILabel *answerSheetTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightRateTipLabel.frame),CGRectGetMaxY(rightRateTipLabel.frame)+10,80,30)];
    answerSheetTipLabel.textColor=[UIColor blackColor];
    answerSheetTipLabel.text=@"答案卡";
    answerSheetTipLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_index_bg.png"]];
    answerSheetTipLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:answerSheetTipLabel];
    [answerSheetTipLabel release];
    
    //答题卡
    answerSheet=[[UIScrollView alloc] initWithFrame:
                                    CGRectMake(CGRectGetMinX(answerSheetTipLabel.frame),
                                               CGRectGetMaxY(answerSheetTipLabel.frame)+5,
                                               CGRectGetWidth(self.view.frame)-CGRectGetMinX(answerSheetTipLabel.frame)*2,
                                               CGRectGetHeight(self.view.frame)-(CGRectGetMaxY(answerSheetTipLabel.frame)+5)-5)];
    answerSheet.scrollEnabled=YES;
    answerSheet.backgroundColor=[UIColor grayColor];
    [self.view addSubview:answerSheet];
    
    //初始化answer sheet的内容，首先获取试题的数量
    unsigned int tTopicsCount=100;
    
    unsigned int tLines=tTopicsCount/ANSWERSHEET_COUNT_PER_LINE;
    tLines=tTopicsCount%ANSWERSHEET_COUNT_PER_LINE?(tLines+1):tLines;
    for (int lIndex=0; lIndex<tLines; lIndex++ ) {
        for (int vIndex=0; vIndex<ANSWERSHEET_COUNT_PER_LINE; vIndex++) {
            UIButton *topicOrder=[UIButton buttonWithType:UIButtonTypeCustom];
            topicOrder.tag=lIndex*ANSWERSHEET_COUNT_PER_LINE+vIndex+1;
            [topicOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [topicOrder setTitle:[NSString stringWithFormat:@"%d",topicOrder.tag] forState:UIControlStateNormal];
            topicOrder.frame=CGRectMake(1+vIndex*36,1+lIndex*20, 36, 20);
            topicOrder.layer.borderColor=[UIColor blackColor].CGColor;
            topicOrder.layer.borderWidth=1;
            
            //根据答题是否正确设置背景颜色
            int tType=vIndex%3;
            if (tType==0) {
                topicOrder.backgroundColor=[UIColor greenColor];
            }else if(tType==1){
                topicOrder.backgroundColor=[UIColor redColor];
            }else{
                topicOrder.backgroundColor=[UIColor whiteColor];
            }
            
            [topicOrder addTarget:self action:@selector(topicOrderInAnswerSheetClicked:) forControlEvents:UIControlEventTouchUpInside];
            [answerSheet addSubview:topicOrder];
        }
    }
    
    if (answerSheet.contentSize.height<tLines*20+10) {
        answerSheet.contentSize=CGSizeMake(answerSheet.contentSize.width, tLines*20+10);
    }
}

- (void)topicOrderInAnswerSheetClicked:(UIButton *)sender
{
    NSLog(@"topicOrderInAnswerSheetClicked:%d",sender.tag);
    //跳转到试卷列表：显示考试的详细结果
    EXExamineRecordViewController *examineController=[[[EXExamineRecordViewController alloc] init] autorelease];
    [self.navigationController pushViewController:examineController animated:YES];
    examineController.currentIndex=sender.tag-1;
    examineController.paperData=nil;
}

- (void)backwardItemClicked:(id)sender{
    if(self.navigationController){
        [self.navigationController popToRootViewControllerAnimated:YES];
	}
}

- (void)clearPaperInfo{
//    NSArray *topics=paperData.topics;
//    if (topics) {
//        for (TopicData *topic in topics) {
//            if (topic) {
//                if ([topic.type integerValue]==1 || [topic.type integerValue]==2 || [topic.type integerValue]==3) {
//                    topic.analysis=[NSString stringWithFormat:@"%d",-100];
//                }else{
//                    topic.analysis=nil;
//                }
//            }
//        }
//    }
//    paperData.userScore=[NSNumber numberWithInteger:0];
//    [DBManager addPaper:paperData];
}

@end
