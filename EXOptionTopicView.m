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
