//
//  EXLoginView.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXLoginView.h"
#import "Toast.h"

@interface EXLoginView () <UITextFieldDelegate>

@end

@implementation EXLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initLoginUI];
    }
    return self;
}

- (void)dealloc
{
    [_mailTextField release];
    [_pwdTextField release];
    
    [super dealloc];
}

- (void)initLoginUI
{
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(60, 58, 200, 40)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor colorWithRed:0xED/255.0f green:0xED/255.0f blue:0xED/255.0f alpha:1.0f];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.font = [UIFont systemFontOfSize:38];
    titleView.text = @"健教天地";
    [self addSubview:titleView];
    [titleView release];
    
    _mailTextField = [[UITextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(titleView.frame)+30, 270, 25)];
    _mailTextField.delegate = self;
    _mailTextField.backgroundColor = [UIColor whiteColor];
    _mailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _mailTextField.placeholder = @"请输入邮箱";
    [self addSubview:_mailTextField];
    
    _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(_mailTextField.frame), CGRectGetMaxY(_mailTextField.frame)+10, 270, 25)];
    _pwdTextField.delegate = self;
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.backgroundColor = [UIColor whiteColor];
    _pwdTextField.placeholder = @"请输入密码";
    [self addSubview:_pwdTextField];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = [UIColor whiteColor];
    loginBtn.frame = CGRectMake(CGRectGetMinX(_mailTextField.frame), CGRectGetMaxY(_pwdTextField.frame)+10, 270, 40);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = [UIColor whiteColor];
    registerBtn.frame = CGRectMake(CGRectGetMinX(_mailTextField.frame), CGRectGetMaxY(loginBtn.frame)+10, 270, 40);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registerBtn];
    
    //自动登录选项
    UIButton *autoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoLoginBtn.backgroundColor = [UIColor whiteColor];
    autoLoginBtn.frame = CGRectMake(CGRectGetMinX(_mailTextField.frame), CGRectGetMaxY(registerBtn.frame)+10, 100, 20);
    [autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
    [autoLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [autoLoginBtn addTarget:self action:@selector(autoLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:autoLoginBtn];
    
    //忘记密码
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPwdBtn.backgroundColor = [UIColor whiteColor];
    forgetPwdBtn.frame = CGRectMake(CGRectGetMinX(autoLoginBtn.frame) + 170, CGRectGetMaxY(registerBtn.frame)+10, 100, 20);
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetPwdBtn addTarget:self action:@selector(forgetPwdClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetPwdBtn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - 按钮回调事件
- (void)loginClicked:(id)sender
{
    //登录
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (![self checkInputAvailiable]) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(loginClicked)]) {
        [_delegate loginClicked];
    }
}

- (void)registerClicked:(id)sender
{
    //注册
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (_delegate && [_delegate respondsToSelector:@selector(registerClicked)]) {
        [_delegate registerClicked];
    }
}

- (void)autoLoginClicked:(id)sender
{
    //自动登录
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)forgetPwdClicked:(id)sender
{
    //忘记密码
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (_delegate && [_delegate respondsToSelector:@selector(forgetPwdClicked)]) {
        [_delegate forgetPwdClicked];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

- (BOOL)checkInputAvailiable
{
    //非空检查
    BOOL isCheckedOut = YES;
    NSString *errorMsg = nil;
    if ((_mailTextField.text == nil || [@"" isEqualToString:_mailTextField.text])
        || (_pwdTextField.text == nil || [@"" isEqualToString:_pwdTextField.text])) {
        isCheckedOut = NO;
        errorMsg = @"输入项目不能为空!";
    }
    
    if (!isCheckedOut) {
        [[Toast sharedInstance]show:errorMsg duration:TOAST_DEFALT_DURATION];
    }
    return isCheckedOut;
}

@end
