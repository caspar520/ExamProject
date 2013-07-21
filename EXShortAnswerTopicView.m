//
//  EXShortAnswerTopicView.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXShortAnswerTopicView.h"

@interface EXShortAnswerTopicView ()<UITextViewDelegate>

@end

@implementation EXShortAnswerTopicView

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
    NSLog(@"short answer");
    if (answerTextView==nil) {
        answerTextView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(answerContainerView.frame), CGRectGetHeight(answerContainerView.frame))];
        answerTextView.delegate = self;
        answerTextView.returnKeyType = UIReturnKeyDone;
        answerTextView.keyboardType = UIKeyboardTypeDefault;
        answerTextView.backgroundColor = [UIColor grayColor];
        answerTextView.font = [UIFont systemFontOfSize:20];
        answerTextView.alpha=1.0;
        answerTextView.editable=YES;
        [answerContainerView addSubview:answerTextView];
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self updateSelectedResult];
}

@end
