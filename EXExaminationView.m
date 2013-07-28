//
//  EXExaminationView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExaminationView.h"


@interface EXExaminationView ()

@end

@implementation EXExaminationView

@synthesize delegate;
@synthesize metaData=_metaData;
@synthesize index;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    [_metaData release];
    [orderLabel release];
    [questionBackground release];
    [questionLabel release];
    [optionTipLabel release];
    [answerTextView release];
    [shortAnswerBGView release];
    [answerContainerView release];
    [shortAnswerLabel release];
    [super dealloc];
}

- (void)setMetaData:(TopicData *)metaData{
	if(_metaData != metaData){
		_metaData=[metaData retain];
	}
	[self refreshUI];
}

- (void)refreshUI{
    if (orderLabel==nil) {
        orderLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,10,50,30)];
        orderLabel.textColor=[UIColor blackColor];
        orderLabel.text=[NSString stringWithFormat:@"第%d题",index];
        CGSize autoSize = [orderLabel sizeThatFits:CGSizeMake(0, 30)];
        orderLabel.frame = CGRectMake(10, 10, autoSize.width, 30);
        orderLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_index_bg.png"]];
        orderLabel.textAlignment=UITextAlignmentLeft;
        [self addSubview:orderLabel];
    }
	
	if (questionBackground==nil) {
        questionBackground=[[UIImageView alloc] initWithFrame:
                            CGRectMake(CGRectGetMinX(orderLabel.frame),CGRectGetMaxY(orderLabel.frame)+5,CGRectGetWidth(self.frame)-2*CGRectGetMinX(orderLabel.frame),90)];
        questionBackground.backgroundColor=[UIColor clearColor];
        questionBackground.image=[UIImage imageNamed:@"topic_bg.png"];
        [self addSubview:questionBackground];
    }
	
	if (questionLabel==nil) {
        questionLabel=[[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(questionBackground.frame)+4, CGRectGetWidth(questionBackground.frame)-25, CGRectGetHeight(questionBackground.frame)-22)];
        questionLabel.textColor=[UIColor blackColor];
        questionLabel.text=[NSString stringWithFormat:@"%@",_metaData.question];
        questionLabel.backgroundColor=[UIColor clearColor];
        questionLabel.textAlignment=UITextAlignmentLeft;
        questionLabel.numberOfLines=3;
        [self addSubview:questionLabel];
    }
	if (optionTipLabel==nil) {
        optionTipLabel=[[UILabel alloc] initWithFrame:
                        CGRectMake(CGRectGetMinX(orderLabel.frame),CGRectGetMaxY(questionBackground.frame)+5,70,30)];
        optionTipLabel.textColor=[UIColor blackColor];
        optionTipLabel.text=@"答案选项";
        optionTipLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_index_bg.png"]];
        optionTipLabel.textAlignment=UITextAlignmentLeft;
        [self addSubview:optionTipLabel];
    }
	
    if (answerContainerView==nil) {
        answerContainerView=[[UIScrollView alloc] initWithFrame:
                             CGRectMake(CGRectGetMinX(orderLabel.frame),
                                        CGRectGetMaxY(optionTipLabel.frame)+5,
                                        CGRectGetWidth(self.frame),
                                        CGRectGetHeight(self.frame)-(CGRectGetMaxY(optionTipLabel.frame)+5))];
        answerContainerView.scrollEnabled=YES;
        answerContainerView.backgroundColor=[UIColor clearColor];
        [self addSubview:answerContainerView];
    }
}

//实时更新选择活这判断的答案
- (void)updateSelectedResult{
    NSArray *subViews=[answerContainerView subviews];
    if ([_metaData.type integerValue]==1) {
        //单选题
        for (UIView *item in subViews) {
            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
                if (((EXCheckOptionView *)item).checked==YES) {
                    result=[NSString stringWithFormat:@"%d",((EXCheckOptionView *)item).index-1];
                    break;
                }
            }
        }
    }else if ([_metaData.type integerValue]==2){
        //多选题
        for (UIView *item in subViews) {
            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
                if (((EXCheckOptionView *)item).checked==YES) {
                    if (result==nil || result.length==0) {
                        result=[NSString stringWithFormat:@"%d",((EXCheckOptionView *)item).index-1];
                    }else{
                        result=[result stringByAppendingString:[NSString stringWithFormat:@"|%d",((EXCheckOptionView *)item).index]];
                    }
                }
            }
        }
    }else if([_metaData.type integerValue]==3){
        //判断题
        for (UIView *item in subViews) {
            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
                if (((EXCheckOptionView *)item).checked==YES) {
                    result=[NSString stringWithFormat:@"%d",((EXCheckOptionView *)item).index];
                    break;
                }
            }
        }
    }else{
        //简单题
        result=answerTextView.text;
    }
    _metaData.analysis=result;
}

@end
