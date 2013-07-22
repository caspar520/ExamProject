//
//  EXJudgeTopicView.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXJudgeTopicView.h"

@interface EXJudgeTopicView ()<EXCheckBoxDelegate>

@end

@implementation EXJudgeTopicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)refreshUI{
    [super refreshUI];
    //options check view
    EXCheckOptionView *rightCheckView=[[EXCheckOptionView alloc] initWithFrame:CGRectMake(5, 0, 40, 40) checked:NO];
    rightCheckView.backgroundColor=[UIColor clearColor];
    rightCheckView.delegate=self;
    rightCheckView.exclusiveTouch=YES;
    rightCheckView.index=0;
    [answerContainerView addSubview:rightCheckView];
    [rightCheckView release];
    
    EXCheckOptionView *wrongCheckView=[[EXCheckOptionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rightCheckView.frame)+10, 0, 40, 40) checked:NO];
    wrongCheckView.backgroundColor=[UIColor clearColor];
    wrongCheckView.delegate=self;
    wrongCheckView.exclusiveTouch=YES;
    wrongCheckView.index=-1;
    [answerContainerView addSubview:wrongCheckView];
    [wrongCheckView release];
    
    if (answerContainerView.contentSize.height<45*2) {
        answerContainerView.contentSize=CGSizeMake(answerContainerView.contentSize.width, 45*2);
    }
}

#pragma mark EXCheckBoxDelegate

- (void)checkeStateChange:(BOOL)isChecked withObject:(id)obj{
    EXCheckOptionView *sender=(EXCheckOptionView *)obj;
    NSArray *subViews=[answerContainerView subviews];
    
    if ([self.metaData.type integerValue]==3) {
        //单选:取消其它按纽的选中状态
        for (UIView *item in subViews) {
            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
                ((EXCheckOptionView *)item).enabled=YES;
                if (item != sender) {
                    ((EXCheckOptionView *)item).checked=NO;
                }
            }
        }
    }
    
    [self updateSelectedResult];
}

@end
