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

- (void)dealloc{
    [answerTextView resignFirstResponder];
    [self keyboardWillDisapper];
    [super dealloc];
}

- (void)refreshUI{
    [super refreshUI];
    optionTipLabel.text=@"输入答案";
    if (answerTextView==nil) {
        answerTextView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(answerContainerView.frame)-20, CGRectGetHeight(answerContainerView.frame)-20)];
        answerTextView.delegate = self;
        answerTextView.returnKeyType = UIReturnKeyDone;
        answerTextView.keyboardType = UIKeyboardTypeDefault;
        answerTextView.backgroundColor = [UIColor clearColor];
        answerTextView.font = [UIFont systemFontOfSize:20];
        answerTextView.alpha=1.0;
        answerTextView.editable=YES;
        [answerContainerView addSubview:answerTextView];
    }
}

#pragma mark keyBoard Event
- (void)keyboardWillAppear {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.center=CGPointMake(self.center.x, self.center.y-160);
    [UIView commitAnimations];
}

-(void)keyboardWillDisapper {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.center=CGPointMake(self.center.x, self.center.y+160);
    [UIView commitAnimations];
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *returnChar = [[NSString alloc]initWithFormat:@"%c",0x000A];
    if ([text isEqualToString:returnChar]) {
        [answerTextView resignFirstResponder];
    }
    [returnChar release];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [answerTextView becomeFirstResponder];
    [self keyboardWillAppear];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self updateSelectedResult];
    [answerTextView resignFirstResponder];
    [self keyboardWillDisapper];
}

@end
