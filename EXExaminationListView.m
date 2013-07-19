//
//  EXExaminationListView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExaminationListView.h"
#import "EXExaminationView.h"

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
        [_dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj) {
                EXExaminationView *view = [[EXExaminationView alloc] initWithFrame:_scrollView.frame];
                view.backgroundColor=[UIColor clearColor];
                view.delegate=delegate;
                view.index=idx;
                view.metaData=obj;
                
                [_scrollView addSubview:view];
                [view release];
            }
        }];
    }
}

@end
