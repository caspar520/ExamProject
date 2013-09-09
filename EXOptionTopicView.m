//
//  EXOptionTopicView.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXOptionTopicView.h"

@interface EXOptionTopicView ()<EXCheckBoxDelegate>

@end

@implementation EXOptionTopicView

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
    //获得上一次的答题情况
//    NSArray *components=[self.metaData.analysis componentsSeparatedByString:@"|"];
//    
//    NSArray *optionsArray=[self.metaData.answers componentsSeparatedByString:@"|"];
//    if (optionsArray) {
//        NSInteger height=2;
//        for (NSString *obj in optionsArray) {
//            if (obj) {
//                NSInteger idx=[optionsArray indexOfObject:obj];
//                
//                BOOL isChecked=NO;
//                if (components && components.count>0) {
//                    for (NSString *item in components) {
//                        if (item && [item integerValue]==idx) {
//                            isChecked=YES;
//                        }
//                    }
//                }
//                EXCheckOptionView *checkView=[[EXCheckOptionView alloc] initWithFrame:CGRectMake(5, height, 45, 45) checked:NO];
//                checkView.backgroundColor=[UIColor clearColor];
//                checkView.delegate=self;
//                checkView.exclusiveTouch=YES;
//                checkView.index=idx+1;
//                checkView.enabled=YES;
//                checkView.checked=isChecked;
//                [checkView updateCheckBoxImage];
//                [answerContainerView addSubview:checkView];
//                [checkView release];
//                
//                UILabel *optionLabel=[[UILabel alloc] init];
//                optionLabel.textColor=[UIColor blackColor];
//                CGSize size=[obj sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//                if (size.height<50) {
//                    size.height=50;
//                }
//                optionLabel.frame=CGRectMake(CGRectGetMaxX(checkView.frame)+8, height, 200, size.height);
//                optionLabel.backgroundColor=[UIColor clearColor];
//                optionLabel.textAlignment=UITextAlignmentLeft;
//                optionLabel.numberOfLines=0;
//                optionLabel.text=obj;
//                [answerContainerView addSubview:optionLabel];
//                [optionLabel release];
//                
//                height+=size.height+2;
//            }
//        }
//        
//        if (answerContainerView.contentSize.height<height) {
//            answerContainerView.contentSize=CGSizeMake(answerContainerView.contentSize.width, height);
//        }
//    }
    
    
    //临时
    NSArray *components=[NSArray arrayWithObjects:@"1",@"3", nil];
    
    NSArray *optionsArray=[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    if (optionsArray) {
        NSInteger height=2;
        for (NSString *obj in optionsArray) {
            if (obj) {
                NSInteger idx=[optionsArray indexOfObject:obj];
                
                BOOL isChecked=NO;
                if (components && components.count>0) {
                    for (NSString *item in components) {
                        if (item && [item integerValue]==idx) {
                            isChecked=YES;
                        }
                    }
                }
                EXCheckOptionView *checkView=[[EXCheckOptionView alloc] initWithFrame:CGRectMake(5, height, 45, 45) checked:NO];
                checkView.backgroundColor=[UIColor clearColor];
                checkView.delegate=self;
                checkView.exclusiveTouch=YES;
                checkView.index=idx+1;
                checkView.enabled=YES;
                checkView.checked=isChecked;
                [checkView updateCheckBoxImage];
                [answerContainerView addSubview:checkView];
                [checkView release];
                
                UILabel *optionLabel=[[UILabel alloc] init];
                optionLabel.textColor=[UIColor blackColor];
                CGSize size=[obj sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                if (size.height<50) {
                    size.height=50;
                }
                optionLabel.frame=CGRectMake(CGRectGetMaxX(checkView.frame)+8, height, 200, size.height);
                optionLabel.backgroundColor=[UIColor clearColor];
                optionLabel.textAlignment=UITextAlignmentLeft;
                optionLabel.numberOfLines=0;
                optionLabel.text=@"option x";
                [answerContainerView addSubview:optionLabel];
                [optionLabel release];
                
                height+=size.height+2;
            }
        }
        
        if (_isDisplayAnswer==YES) {
            if (answerAnalysisTipLabel==nil) {
                answerAnalysisTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,height+20,80,30)];
                answerAnalysisTipLabel.textColor=[UIColor blackColor];
                answerAnalysisTipLabel.text=@"答题解析";
                answerAnalysisTipLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_index_bg.png"]];
                answerAnalysisTipLabel.textAlignment=UITextAlignmentLeft;
                [answerContainerView addSubview:answerAnalysisTipLabel];
            }
            height+=CGRectGetHeight(answerAnalysisTipLabel.frame)+25;
            
            if (answerAnalysisBackground==nil) {
                answerAnalysisBackground=[[UIImageView alloc] initWithFrame:
                                    CGRectMake(CGRectGetMinX(answerAnalysisTipLabel.frame)-10,CGRectGetMaxY(answerAnalysisTipLabel.frame)+5,CGRectGetWidth(self.frame)-2*CGRectGetMinX(answerAnalysisTipLabel.frame),90)];
                answerAnalysisBackground.backgroundColor=[UIColor clearColor];
                answerAnalysisBackground.image=[UIImage imageNamed:@"topic_bg.png"];
                [answerContainerView addSubview:answerAnalysisBackground];
            }
            
            height+=CGRectGetHeight(answerAnalysisBackground.frame)+5;
            
            if (answerAnalysisLabel==nil) {
                answerAnalysisLabel=[[UILabel alloc] initWithFrame:CGRectMake(25, 5, CGRectGetWidth(answerAnalysisBackground.frame)-40, CGRectGetHeight(answerAnalysisBackground.frame)-22)];
                answerAnalysisLabel.textColor=[UIColor blackColor];
                answerAnalysisLabel.text=@"答题解析呢哦容答题解析呢哦容答呢哦容答解析呢哦容";
                answerAnalysisLabel.numberOfLines=0;
                answerAnalysisLabel.textAlignment=UITextAlignmentLeft;
                answerAnalysisLabel.backgroundColor=[UIColor clearColor];
                [answerAnalysisBackground addSubview:answerAnalysisLabel];
            }
        }
        height+=10;
        
        if (answerContainerView.contentSize.height<height) {
            answerContainerView.contentSize=CGSizeMake(answerContainerView.contentSize.width, height);
        }
    }

}

#pragma mark EXCheckBoxDelegate
- (void)checkeStateChange:(BOOL)isChecked withObject:(id)obj{
//    EXCheckOptionView *sender=(EXCheckOptionView *)obj;
//    NSArray *subViews=[answerContainerView subviews];
//    
//    if ([self.metaData.type integerValue]==1) {
//        //单选:取消其它按纽的选中状态
//        for (UIView *item in subViews) {
//            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
//                ((EXCheckOptionView *)item).enabled=YES;
//                if (item != sender) {
//                    ((EXCheckOptionView *)item).checked=NO;
//                }
//            }
//        }
//    }
//    
//    [self updateSelectedResult];
}

@end
