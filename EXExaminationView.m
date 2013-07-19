//
//  EXExaminationView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExaminationView.h"
#import "EXCheckOptionView.h"

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

- (void)setMetaData:(id)metaData{
	if(_metaData != metaData){
		_metaData=[metaData retain];
	}
	[self refreshUI];
}

- (void)refreshUI{
	UILabel *orderLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,10,100,40)];
	orderLabel.textColor=[UIColor blackColor];
	orderLabel.text=[NSString stringWithFormat:@"%d",index];
	orderLabel.backgroundColor=[UIColor clearColor];
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
	questionLabel.text=@"question:......";
	questionLabel.backgroundColor=[UIColor clearColor];
	questionLabel.textAlignment=UITextAlignmentLeft;
	questionLabel.numberOfLines=3;
	[self addSubview:questionLabel];
    [questionLabel release];
	
	UILabel *optionTipLabel=[[UILabel alloc] initWithFrame:
                             CGRectMake(CGRectGetMinX(orderLabel.frame),CGRectGetMaxY(questionBackground.frame)+5,100,40)];
	optionTipLabel.textColor=[UIColor blackColor];
	optionTipLabel.text=@"答案选项";
	optionTipLabel.backgroundColor=[UIColor clearColor];
	optionTipLabel.textAlignment=UITextAlignmentLeft;
	[self addSubview:optionTipLabel];
    [optionTipLabel release];
	
	//options check view
	
}


- (void)optionItemClicked:(id)sender{
	
}

@end
