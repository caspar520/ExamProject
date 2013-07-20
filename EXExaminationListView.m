//
//  EXExaminationListView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExaminationListView.h"
#import "EXExaminationView.h"
#import "TopicData.h"

@implementation EXExaminationListView

@synthesize delegate;
@synthesize dataArray=_dataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView=[[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.backgroundColor=[UIColor clearColor];
        _scrollView.delegate=delegate;
        [_scrollView setCanCancelContentTouches:NO];
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _scrollView.showsVerticalScrollIndicator=YES;
        _scrollView.clipsToBounds = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
//        [self generateFakeData];
//        [self refreshUI];
    }
    return self;
}

- (void)dealloc{
    [_scrollView release];
    [_dataArray release];
    [super dealloc];
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    if (_dataArray != dataArray) {
        [_dataArray release];
        _dataArray=[dataArray retain];
    }
    [self refreshUI];
}

- (void)refreshUI{
    if (_dataArray) {
        [_dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj) {
                EXExaminationView *view = [[EXExaminationView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_scrollView.frame)+10, CGRectGetMinY(_scrollView.frame)+10, CGRectGetWidth(_scrollView.frame)-20, CGRectGetHeight(_scrollView.frame)-20)];
                view.delegate=delegate;
                view.index=idx;
                view.metaData=obj;
                
                [_scrollView addSubview:view];
                [view release];
            }
        }];
    }
}

- (void)generateFakeData{
    _dataArray =[[NSMutableArray alloc] initWithCapacity:0];
    
    TopicData *tData = [[TopicData alloc]init];
    
    tData.topicId = [NSNumber numberWithInt:1];
    tData.question = @"你的名字()?";
    tData.type = [NSNumber numberWithInt:1];
    //答案选项
    tData.answers = [NSString stringWithFormat:@"option1|option2|option3"];
    //正确答案
    tData.selected = [NSString stringWithFormat:@"%u",1];
    tData.value = @"20";
    tData.analysis = @"答案2";
    [_dataArray addObject:tData];
    [tData release];
}

@end
