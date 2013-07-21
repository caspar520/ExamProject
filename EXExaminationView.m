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
    [answerContainerView release];
    [super dealloc];
}

- (void)setMetaData:(TopicData *)metaData{
	if(_metaData != metaData){
		_metaData=[metaData retain];
	}
	[self refreshUI];
}

- (void)refreshUI{
	orderLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,10,100,40)];
	orderLabel.textColor=[UIColor blackColor];
	orderLabel.text=[NSString stringWithFormat:@"第%d题",index];
	orderLabel.backgroundColor=[UIColor grayColor];
	orderLabel.textAlignment=UITextAlignmentLeft;
	[self addSubview:orderLabel];
	
	questionBackground=[[UIImageView alloc] initWithFrame:
                                     CGRectMake(CGRectGetMinX(orderLabel.frame),CGRectGetMaxY(orderLabel.frame)+5,CGRectGetWidth(self.frame)-2*CGRectGetMinX(orderLabel.frame),100)];
	questionBackground.backgroundColor=[UIColor grayColor];
	questionBackground.image=nil;
	[self addSubview:questionBackground];
	
	questionLabel=[[UILabel alloc] initWithFrame:questionBackground.frame];
	questionLabel.textColor=[UIColor blackColor];
	questionLabel.text=[NSString stringWithFormat:@"%@",_metaData.question];
	questionLabel.backgroundColor=[UIColor grayColor];
	questionLabel.textAlignment=UITextAlignmentLeft;
	questionLabel.numberOfLines=3;
	[self addSubview:questionLabel];
	
	optionTipLabel=[[UILabel alloc] initWithFrame:
                             CGRectMake(CGRectGetMinX(orderLabel.frame),CGRectGetMaxY(questionBackground.frame)+5,100,40)];
	optionTipLabel.textColor=[UIColor blackColor];
	optionTipLabel.text=@"答案选项";
	optionTipLabel.backgroundColor=[UIColor grayColor];
	optionTipLabel.textAlignment=UITextAlignmentLeft;
	[self addSubview:optionTipLabel];
    
    answerContainerView=[[UIScrollView alloc] initWithFrame:
                         CGRectMake(CGRectGetMinX(self.frame),
                                   CGRectGetMaxY(optionTipLabel.frame)+5,
                                   CGRectGetWidth(self.frame),
                                   CGRectGetHeight(self.frame)-(CGRectGetMaxY(optionTipLabel.frame)+5))];
    answerContainerView.userInteractionEnabled=YES;
    answerContainerView.backgroundColor=[UIColor clearColor];
    [self addSubview:answerContainerView];
}

//实时更新选择活这判断的答案
- (void)updateSelectedResult{
    NSArray *subViews=[answerContainerView subviews];
    if ([_metaData.type integerValue]==1) {
        //单选题
        for (UIView *item in subViews) {
            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
                if (((EXCheckOptionView *)item).enabled==YES) {
                    result=[NSString stringWithFormat:@"%d",((EXCheckOptionView *)item).index];
                    break;
                }
            }
        }
    }else if ([_metaData.type integerValue]==2){
        //多选题
        for (UIView *item in subViews) {
            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
                if (((EXCheckOptionView *)item).enabled==YES) {
                    if (result==nil || result.length==0) {
                        result=[NSString stringWithFormat:@"%d",((EXCheckOptionView *)item).index];
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
                if (((EXCheckOptionView *)item).enabled==YES) {
                    result=[NSString stringWithFormat:@"%d",((EXCheckOptionView *)item).index];
                    break;
                }
            }
        }
    }else{
        //简单题
        _metaData.answers=answerTextView.text;
    }
}

@end
