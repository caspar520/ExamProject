//
//  EXRegisterView.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXRegisterView.h"

typedef enum
{
    RegisterTag_Mail,
    RegisterTag_Name,
    RegisterTag_Region,
    RegisterTag_Dept,
    RegisterTag_Pwd,
    RegisterTag_PwdAgain,
} RegisterInputViewTag;

@interface EXRegisterView () <UITextFieldDelegate>

@end

@implementation EXRegisterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initRegisterUI];
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)initRegisterUI
{
    //输入框
    
    //背景
    UIView *inputBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 18, 300, 40 * 6)];
    inputBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:inputBgView];
    [inputBgView release];
    
    int numberOfInputs = 6;
    for (int i = 0; i < numberOfInputs; i++) {
        //分割线
        UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+1), 300, 1)];
        separateLine.backgroundColor = [UIColor colorWithRed:0xEC/255.0f green:0xE4/255.0f blue:0xEB/255.0f alpha:1.0f];
        [inputBgView addSubview:separateLine];
        [separateLine release];
    }
    
    NSArray *registerNames = [NSArray arrayWithObjects:@"邮箱",@"姓名",@"地区",@"部门", @"密码" , @"确认密码",nil];
    NSArray *registerPlaceholderNames = [NSArray arrayWithObjects:@"请输入邮箱",@"请输入姓名",@"请选择地区",@"请输入部门", @"请输入密码" , @"请重复输入密码",nil];
    
    for (int i = 0; i < numberOfInputs; i++) {
        UILabel *mailTitleView = [[UILabel alloc]initWithFrame:CGRectMake(10, 40*i, 55, 40)];
        mailTitleView.backgroundColor = [UIColor clearColor];
        mailTitleView.textColor = [UIColor blackColor];
        mailTitleView.textAlignment = NSTextAlignmentLeft;
        mailTitleView.font = [UIFont systemFontOfSize:20];
        mailTitleView.text = [registerNames objectAtIndex:i];
        CGSize autoSize = [mailTitleView sizeThatFits:CGSizeMake(0, 20)];
        if (autoSize.width > mailTitleView.frame.size.width) {
            mailTitleView.frame = CGRectMake(5, 40*i, autoSize.width, 40);
        }
        [inputBgView addSubview:mailTitleView];
        [mailTitleView release];
        
        UITextField *mailTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mailTitleView.frame), 8 + 40*i, 240, 30)];
        mailTextField.delegate = self;
        mailTextField.backgroundColor = [UIColor clearColor];
        mailTextField.textAlignment = NSTextAlignmentLeft;
        mailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        mailTextField.placeholder = [registerPlaceholderNames objectAtIndex:i];
        [inputBgView addSubview:mailTextField];
        [mailTextField release];
        
        //密码
        if (i == 4 || i == 5) {
            mailTextField.secureTextEntry = YES;
        }
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
