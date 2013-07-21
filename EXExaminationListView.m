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
#import "EXOptionTopicView.h"
#import "EXJudgeTopicView.h"
#import "EXShortAnswerTopicView.h"

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
        _scrollView.contentSize=CGSizeMake(_dataArray.count*CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        [_dataArray enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
            if (obj) {
                EXExaminationView *view=nil;
                if ([obj.type integerValue]==1 || [obj.type integerValue]==2) {
                    view= [[EXOptionTopicView alloc] init];
                }else if ([obj.type integerValue]==3){
                    view= [[EXJudgeTopicView alloc] init];
                }else{
                    view= [[EXShortAnswerTopicView alloc] init];
                }
                view.frame=CGRectMake(idx*CGRectGetWidth(_scrollView.frame) +CGRectGetMinX(_scrollView.frame)+10, CGRectGetMinY(_scrollView.frame)+10, CGRectGetWidth(_scrollView.frame)-20, CGRectGetHeight(_scrollView.frame)-20);
                 
                view.delegate=delegate;
                view.index=idx+1;
                view.metaData=obj;
                
                [_scrollView addSubview:view];
                [view release];
            }
        }];
    }
    [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y)];
}

- (void)preTopic{
    if (_scrollView.contentOffset.x>=CGRectGetWidth(_scrollView.frame)) {
        [UIView animateWithDuration:0.2 animations:^{
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x-CGRectGetWidth(_scrollView.frame), _scrollView.contentOffset.y)];
            _scrollView.scrollEnabled=NO;
        } completion:^(BOOL finished) {
            _scrollView.scrollEnabled=YES;
        }];
    }
}

- (void)nextTopic{
    if (_scrollView.contentOffset.x<CGRectGetWidth(_scrollView.frame)*(_dataArray.count-1)) {
        [UIView animateWithDuration:0.2 animations:^{
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+CGRectGetWidth(_scrollView.frame), _scrollView.contentOffset.y)];
            _scrollView.scrollEnabled=NO;
        } completion:^(BOOL finished) {
            _scrollView.scrollEnabled=YES;
        }];
    }
}


@end
