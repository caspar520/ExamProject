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

@interface EXResultViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
