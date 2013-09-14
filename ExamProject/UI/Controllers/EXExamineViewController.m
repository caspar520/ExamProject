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
#import "EXNetDataManager.h"
#import "EXDownloadManager.h"
#import "MBProgressHUD.h"
#import "ExamData.h"
#import "JSONKit.h"

@interface EXExamineViewController ()<EXQuestionDelegate,UIScrollViewDelegate>

- (void)triggerExamTimer;
- (void)destroyExamTimer;
- (void)timeCountIncrease;
- (void)backToPreViewAfterSubmitted;
- (NSData *)markAndConstructResultParameter;
- (void)fetchData;

@end

@implementation EXExamineViewController

@synthesize paperData=_paperData;
@synthesize examData=_examData;
@synthesize displayTopicType;
@synthesize isNotOnAnswering;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_examMSGBarView release];
    [_examineListView release];
    [_paperCountLabel release];
    [_examLeftTime release];
    [_examDuration release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"考试";
    _examTimer=nil;
    _currentExamTime=0;
    _isExamSubmitted=NO;
    
    self.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backwardItemClicked:)];
    self.navigationItem.leftBarButtonItem= backButton;
   // self.navigationController.toolbar.tintColor = [UIColor colorWithRed:0x74/255.0f green:0xa2/255.0f blue:0x40/255.0f alpha:1.0f];
    [self.navigationController.toolbar setHidden:YES];
    
    float width=CGRectGetWidth(self.navigationController.toolbar.frame)/3;
    
    if (displayTopicType==kDisplayTopicType_Default) {
        UIBarButtonItem*submitButton = [[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(submitExaminationItemClicked:)] autorelease];
        self.navigationItem.rightBarButtonItem= submitButton;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadPaperListFinish:) name:NOTIFICATION_SOME_PAPER_DOWNLOAD_FINISH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailure:) name:NOTIFICATION_DOWNLOAD_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadPaperListFinish:) name:NOTIFICATION_SUBMIT_EXAM_DATA_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailure:) name:NOTIFICATION_SUBMIT_EXAM_DATA_FAILURE object:nil];
    
	// Do any additional setup after loading the view.
    if (_examineListView==nil) {
        _examineListView=[[EXExaminationListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(self.navigationController.navigationBar.frame)-35)];
        _examineListView.backgroundColor=[UIColor clearColor];
        _examineListView.delegate=self;
        [self.view addSubview:_examineListView];
    }
    
    if (_examMSGBarView==nil) {
        _examMSGBarView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-100, CGRectGetWidth(self.view.frame), 40)];
        _examMSGBarView.backgroundColor=[UIColor colorWithRed:0x74/255.0f green:0xa2/255.0f blue:0x40/255.0f alpha:1.0f];
        
        [self.view addSubview:_examMSGBarView];
    }
    
    if (_paperCountLabel==nil) {
        _paperCountLabel= [[UILabel alloc] initWithFrame:CGRectMake(5, 5, (CGRectGetWidth(self.view.frame)-10)/3, 30)];
        _paperCountLabel.textColor=[UIColor blackColor];
        _paperCountLabel.textAlignment=UITextAlignmentLeft;
        _paperCountLabel.backgroundColor=[UIColor clearColor];
        _paperCountLabel.font=[UIFont systemFontOfSize:16];
        
        [_examMSGBarView addSubview:_paperCountLabel];
    }
    NSMutableArray *papers=[[EXNetDataManager shareInstance].paperListInExam objectForKey:[NSString stringWithFormat:@"%@",_examData.examId]];
    _paperCountLabel.text=[NSString stringWithFormat:@"试卷数量："];
    
    if (_examLeftTime==nil) {
        _examLeftTime= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_paperCountLabel.frame)+5, 5, (CGRectGetWidth(self.view.frame)-10)/3, 30)];
        _examLeftTime.textColor=[UIColor blackColor];
        _examLeftTime.textAlignment=UITextAlignmentLeft;
        _examLeftTime.backgroundColor=[UIColor clearColor];
        _examLeftTime.font=[UIFont systemFontOfSize:16];
        
        [_examMSGBarView addSubview:_examLeftTime];
    }
    _examLeftTime.text=[NSString stringWithFormat:@"用时：%d",0];
    
    if (_examDuration==nil) {
        _examDuration= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_examLeftTime.frame)+5, 5, (CGRectGetWidth(self.view.frame)-10)/3, 30)];
        _examDuration.textColor=[UIColor blackColor];
        _examDuration.textAlignment=UITextAlignmentLeft;
        _examDuration.backgroundColor=[UIColor clearColor];
        _examDuration.font=[UIFont systemFontOfSize:16];
        
        [_examMSGBarView addSubview:_examDuration];
    }
    _examDuration.text=[NSString stringWithFormat:@"时间："];
    
    isNotOnAnswering=YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (NO==_isExamSubmitted) {
        NSMutableArray *questions=[NSMutableArray arrayWithCapacity:0];
        
        if (_examineListView) {
            _examineListView.dataArray=questions;
        }
        
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        CustomTabBarController *tabBarController=appDelegate.tabController;
        [tabBarController hideTabBar];
    }else{
        if(self.navigationController){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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

#pragma mark 定时器
- (void)triggerExamTimer{
    if (_examTimer == nil) {
        _examTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeCountIncrease) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_examTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)destroyExamTimer{
    if (_examTimer) {
        [_examTimer invalidate];
        _examTimer=nil;
    }
    _currentExamTime=0;
}

- (void)timeCountIncrease{
    _currentExamTime++;
    
    NSInteger tMinute=_currentExamTime/60;
    NSInteger tSecond=_currentExamTime%60;
    _examLeftTime.text=[NSString stringWithFormat:@"用时：%2d:%2d",tMinute,tSecond];
    
    //判断是否考试时间到
    NSInteger tExamTotalTime=[_examData.examTotalTm integerValue]*60;
    
    if (_currentExamTime>=tExamTotalTime) {
        [self submitExaminationItemClicked:nil];
    }
}

#pragma mark 拉取数据
//拉取考试的试卷数据
- (void)fetchData{
    [[EXDownloadManager shareInstance] downloadPaperList:[_examData.examId integerValue]];
}

#pragma mark 通知事件
- (void)downloadPaperListFinish:(NSNotification *)notification{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    //fetch the papers data success of some examination：resove the exam info to the exam object
    
    NSMutableArray *selectedArray=[NSMutableArray arrayWithCapacity:0];
    if ([EXNetDataManager shareInstance].paperListInExam && [[EXNetDataManager shareInstance].paperListInExam objectForKey:[NSString stringWithFormat:@"%@",_examData.examId]]) {
        //存在
        NSMutableArray *papers=[[EXNetDataManager shareInstance].paperListInExam objectForKey:[NSString stringWithFormat:@"%@",_examData.examId]];
        if (papers) {
            for (PaperData *obj in papers) {
                if (obj && obj.topics) {
                    [selectedArray addObjectsFromArray:obj.topics];
                }
            }
        }
        _paperCountLabel.text=[NSString stringWithFormat:@"试卷数量：%d",papers.count];
        _examDuration.text=[NSString stringWithFormat:@"时间：%@分钟",_examData.examTotalTm];
    }
    _examineListView.dataArray=selectedArray;
    
    //[self triggerExamTimer];
}

- (void)downloadFailure:(NSNotification *)notification{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)submitExamDataSuccess:(NSNotification *)notification{
    if ([_examData.examSubmitDisplayAnswerFlg integerValue]==1) {
        //show the exam result and save the exam result to DB
        EXResultViewController *resultController=[[EXResultViewController alloc] init];
        resultController.examTime=_currentExamTime;
        resultController.examData=self.examData;
        [self.navigationController pushViewController:resultController animated:YES];
    }else{
        //提示提交成功
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交考试数据成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(backToPreViewAfterSubmitted:) withObject:alert afterDelay:2];
        [alert release];
    }
    
    _isExamSubmitted=YES;
}

- (void)submitExamDataFailure:(NSNotification *)notification{
    //提示提交失败
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交考试数据失败，请检查网络后重新提交" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(removeAlertTip:) withObject:alert afterDelay:2];
    [alert release];
}

#pragma mark set方法

- (void)setExamData:(ExamData *)examData{
    if (_examData != examData) {
        [_examData release];
        _examData =[examData retain];
    }
    _examineListView.dipalyTopicType=displayTopicType;
    
    NSMutableArray *selectedArray=[NSMutableArray arrayWithCapacity:0];
    //判断考试的试卷数据是否已经存在
    if (displayTopicType==kDisplayTopicType_Default) {
        if ([EXNetDataManager shareInstance].paperListInExam && [[EXNetDataManager shareInstance].paperListInExam objectForKey:[NSString stringWithFormat:@"%@",_examData.examId]]) {
            //存在
            NSMutableArray *papers=[[EXNetDataManager shareInstance].paperListInExam objectForKey:[NSString stringWithFormat:@"%@",_examData.examId]];
            
            if (papers) {
                [papers enumerateObjectsUsingBlock:^(PaperData *obj, NSUInteger idx, BOOL *stop) {
                    if (obj) {
                        [selectedArray addObjectsFromArray:obj.topics];
                    }
                }];
            }
            _paperCountLabel.text=[NSString stringWithFormat:@"试卷数量：%d",papers.count];
            _examDuration.text=[NSString stringWithFormat:@"时间：%@分钟",_examData.examTotalTm];
            
            [self triggerExamTimer];
        }else{
            //不存在
            [self fetchData];
        }
        
    }else if (displayTopicType==kDisplayTopicType_Wrong){
        if (_examData.papers) {
            [_examData.papers enumerateObjectsUsingBlock:^(PaperData *pObj, NSUInteger pIdx, BOOL *pStop) {
                if (pObj) {
                    [pObj.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
                        if (obj && [obj.topicIsWrong boolValue]==YES) {
                            [selectedArray addObject:obj];
                        }
                    }];
                }
            }];
        }
    }else if (displayTopicType==kDisplayTopicType_Collected){
        if (_examData.papers) {
            [_examData.papers enumerateObjectsUsingBlock:^(PaperData *pObj, NSUInteger pIdx, BOOL *pStop) {
                if (pObj) {
                    [pObj.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
                        if (obj && [obj.topicIsCollected boolValue]==YES) {
                            [selectedArray addObject:obj];
                        }
                    }];
                }
            }];
        }
    }else if (displayTopicType==kDisplayTopicType_Record){
        //答题记录
        if (_examData.papers) {
            [_examData.papers enumerateObjectsUsingBlock:^(PaperData *pObj, NSUInteger pIdx, BOOL *pStop) {
                if (pObj) {
                    [pObj.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
                        if (obj) {
                            [selectedArray addObject:obj];
                        }
                    }];
                }
            }];
        }
    }
    
    _examineListView.dataArray=selectedArray;
}

#pragma mark 按钮点击事件
- (void)backwardItemClicked:(id)sender{
    if (displayTopicType==kDisplayTopicType_Default && isNotOnAnswering==NO) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"返回将清除考试纪录，要保存考试纪录请先提交，确定继续返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
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
    //根据需求判断是否跳转到答题结果界面，清理EXNetDataManager中的试卷的考试记录
    //submit the exam result to server
    NSData *parameter=[self markAndConstructResultParameter];
    [[EXDownloadManager shareInstance] submitExamData:parameter];
    
    //销毁定时器，停止倒计时
    [self destroyExamTimer];
    
    //临时
//    EXResultViewController *resultController=[[EXResultViewController alloc] init];
//    resultController.examTime=_currentExamTime;
//    resultController.examData=self.examData;
//    [self.navigationController pushViewController:resultController animated:YES];
    
}

- (void)backToPreViewAfterSubmitted:(id)object{
    [self removeAlertTip:nil];
    [self clearPaperInfo];
    
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)nextItemClicked:(id)sender{
    [_examineListView nextTopic];
}

- (void)preItemClicked:(id)sender{
    [_examineListView preTopic];
}

- (void)collectItemClicked:(id)sender{
//	_paperData.fav=[NSNumber numberWithBool:YES];
//    [_examineListView collectionTopic];
//    [DBManager addPaper:_paperData];
    
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经将改试题添加到收藏" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alert show];
//    [self performSelector:@selector(removeAlertTip:) withObject:alert afterDelay:2];
//    [alert release];
    
    
    //added by magic
    
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
//        [_paperData.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
//            if (obj && ([obj.type integerValue]==1 || [obj.type integerValue]==2 || [obj.type integerValue]==3)) {
//                //先判断试题类型：只有选择题和判断题可以进行判断，简答暂不做判断
//                if (obj.analysis && [obj.analysis integerValue]!=-100) {
//                    if ([obj.analysis isEqualToString:obj.selected]) {
//                        //正确
//                        obj.wrong=[NSNumber numberWithBool:NO];
//                        mark+=[obj.value integerValue];
//                    }else{
//                        //错误
//                        obj.wrong=[NSNumber numberWithBool:YES];
//                        if ([_paperData.wrong boolValue]==NO) {
//                            _paperData.wrong=[NSNumber numberWithBool:YES];
//                        }
//                    }
//                }
//            }
//        }];
//        _paperData.userScore=[NSNumber numberWithInteger:mark];
//        [DBManager addPaper:_paperData];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if(self.navigationController){
            [self clearPaperInfo];
            
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            CustomTabBarController *tabBarController=appDelegate.tabController;
            [tabBarController showTabBar];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    [self destroyExamTimer];
}

- (void)clearPaperInfo{
    NSArray *topics=_paperData.topics;
    if (topics) {
        for (TopicData *topic in topics) {
            if (topic) {
                if ([topic.topicType integerValue]==1 || [topic.topicType integerValue]==2 || [topic.topicType integerValue]==3) {
                    //选择题和判断题
                    if (topic.answers) {
                        [topic.answers enumerateObjectsUsingBlock:^(AnswerData *obj, NSUInteger idx, BOOL *stop) {
                            if (obj) {
                                obj.isSelected = [NSNumber numberWithBool:NO];
                            }
                        }];
                    }
                }else{
                    //简单题
                    
                }
            }
        }
    }
}

#pragma mark 构造上报参数
- (NSData *)markAndConstructResultParameter{
    NSMutableDictionary *result=[NSMutableDictionary dictionary];
    [result setValue:[NSNumber numberWithInt:[_examData.examStatus integerValue]] forKey:@"status"];
    
    UserData *tUserData=[DBManager getDefaultUserData];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithCapacity:0];
    [dataDic setValue:[NSNumber numberWithInt:[tUserData.userId integerValue]] forKey:@"userId"];
    [dataDic setValue:[NSNumber numberWithInt:[_examData.examId integerValue]] forKey:@"examId"];
    [dataDic setValue:[NSNumber numberWithInt:_currentExamTime] forKey:@"usedTm"];
    [dataDic setValue:[NSNumber numberWithInt:_beginExamTime] forKey:@"beginTm"];
    [dataDic setValue:[NSNumber numberWithInt:_submitExamTime] forKey:@"submitTm"];
    
    NSInteger tScore=0;
    NSMutableArray *topicsList=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *papers=[[EXNetDataManager shareInstance].paperListInExam objectForKey:[NSString stringWithFormat:@"%@",_examData.examId]];
    if (papers) {
        [papers enumerateObjectsUsingBlock:^(PaperData *pObj, NSUInteger pIdx, BOOL *pStop) {
            if (pObj) {
                NSMutableDictionary *tParameter=[[NSMutableDictionary alloc] initWithCapacity:0];
                if (pObj.topics) {
                    [pObj.topics enumerateObjectsUsingBlock:^(TopicData *tObj, NSUInteger tIdx, BOOL *tStop) {
                        if (tObj) {
                            [tParameter setValue:[NSNumber numberWithInt:[tObj.topicId integerValue]] forKey:@"id"];
                            [tParameter setValue:[NSNumber numberWithInt:[tObj.topicType integerValue]] forKey:@"type"];
                            [tParameter setValue:[NSNumber numberWithInt:[tObj.topicValue integerValue]] forKey:@"value"];
                            __block NSString *optionParameter=@"";
                            if (tObj.answers) {
                                [tObj.answers enumerateObjectsUsingBlock:^(AnswerData *aObj, NSUInteger aIdx, BOOL *aStop) {
                                    if (aObj) {
                                        if ([aObj.isCorrect boolValue] && [aObj.isSelected boolValue]) {
                                            if (optionParameter.length>0) {
                                                optionParameter=[optionParameter stringByAppendingString:@"|*|true"];
                                            }else{
                                                optionParameter=[optionParameter stringByAppendingString:@"true"];
                                            }
                                        }else{
                                            if (optionParameter.length>0) {
                                                optionParameter=[optionParameter stringByAppendingString:@"|*|false"];
                                            }else{
                                                optionParameter=[optionParameter stringByAppendingString:@"false"];
                                            }
                                        }
                                    }
                                }];
                            }
                            [tParameter setValue:optionParameter forKey:@"option"];
                        }
                    }];
                }
                
                [topicsList addObject:tParameter];
                [tParameter release];
            }
        }];
    }
    
    [dataDic setValue:topicsList forKey:@"topicList"];
    [dataDic setValue:[NSNumber numberWithInt:tScore] forKey:@"score"];
    [result setValue:dataDic forKey:@"data"];
    
    NSData *parameter=[result JSONData];
    return parameter;
}

@end
