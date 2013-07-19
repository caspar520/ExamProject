//
//  EXExaminationView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExaminationView.h"
#import "EXCheckOptionView.h"
#import "TopicData.h"


@interface EXExaminationView () <BTCheckBoxDelegate>

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
    [super dealloc];
}

- (void)setMetaData:(TopicData *)metaData{
	if(_metaData != metaData){
		_metaData=[metaData retain];
	}
	[self refreshUI];
}

- (void)refreshUI{
	UILabel *orderLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,10,100,40)];
	orderLabel.textColor=[UIColor blackColor];
	orderLabel.text=[NSString stringWithFormat:@"第%d题",index];
	orderLabel.backgroundColor=[UIColor grayColor];
	orderLabel.textAlignment=UITextAlignmentLeft;
	[self addSubview:orderLabel];
    [orderLabel release];
	
	UIImageView *questionBackground=[[UIImageView alloc] initWithFrame:
                                     CGRectMake(CGRectGetMinX(orderLabel.frame),CGRectGetMaxY(orderLabel.frame)+5,CGRectGetWidth(self.frame)-2*CGRectGetMinX(orderLabel.frame),100)];
	questionBackground.backgroundColor=[UIColor grayColor];
	questionBackground.image=nil;
	[self addSubview:questionBackground];
    [questionBackground release];
	
	UILabel *questionLabel=[[UILabel alloc] initWithFrame:questionBackground.frame];
	questionLabel.textColor=[UIColor blackColor];
	questionLabel.text=[NSString stringWithFormat:@"%@",_metaData.question];
	questionLabel.backgroundColor=[UIColor grayColor];
	questionLabel.textAlignment=UITextAlignmentLeft;
	questionLabel.numberOfLines=3;
	[self addSubview:questionLabel];
    [questionLabel release];
	
	UILabel *optionTipLabel=[[UILabel alloc] initWithFrame:
                             CGRectMake(CGRectGetMinX(orderLabel.frame),CGRectGetMaxY(questionBackground.frame)+5,100,40)];
	optionTipLabel.textColor=[UIColor blackColor];
	optionTipLabel.text=@"答案选项";
	optionTipLabel.backgroundColor=[UIColor grayColor];
	optionTipLabel.textAlignment=UITextAlignmentLeft;
	[self addSubview:optionTipLabel];
    [optionTipLabel release];
	
	//options check view
	NSArray *optionsArray=[_metaData.answers componentsSeparatedByString:@"|"];
    if (optionsArray) {
        [optionsArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if (obj) {
                EXCheckOptionView *checkView=[[EXCheckOptionView alloc] initWithFrame:CGRectMake(CGRectGetMinX(orderLabel.frame), CGRectGetMaxY(optionTipLabel.frame)+5+idx*42, 40, 40) checked:NO];
                checkView.backgroundColor=[UIColor clearColor];
                checkView.delegate=self;
                checkView.exclusiveTouch=YES;
                checkView.index=idx;
                [self addSubview:checkView];
                [checkView release];
                
                UILabel *optionLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkView.frame)+5,CGRectGetMaxY(optionTipLabel.frame)+5+idx*42,100,40)];
                optionLabel.textColor=[UIColor blackColor];
                optionLabel.text=[NSString stringWithFormat:@"%@",obj];
                optionLabel.backgroundColor=[UIColor clearColor];
                optionLabel.textAlignment=UITextAlignmentLeft;
                [self addSubview:optionLabel];
                [optionLabel release];
            }
        }];
    }
}

#pragma mark BTCheckBoxDelegate
- (void)checkeStateChange:(BOOL)isChecked{
    if (isChecked==YES) {
        if (delegate && [delegate respondsToSelector:@selector(selectOption:withObject:)]) {
            [delegate selectOption:index withObject:self];
        }
    }else{
        if (delegate && [delegate respondsToSelector:@selector(cancelOption:withObject:)]) {
            [delegate cancelOption:index withObject:self];
        }
    }
}

@end
