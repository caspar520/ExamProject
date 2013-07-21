//
//  EXRegisterView.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXRegisterView.h"
#import "Toast.h"

#define NUMBER_OF_INPUTS        6       //需要输入项的总数
#define INPUT_TAG               100     //输入框起始tag

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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
        [self initRegisterUI];
    }
    return self;
}

- (void)dealloc
{
    [_userData release];
    [_inputBgView release];
    
    [super dealloc];
}

- (void)initRegisterUI
{
    /*
     输入框
     */
    
    //背景
    _inputBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 18, 300, 40 * NUMBER_OF_INPUTS)];
    _inputBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_inputBgView];
    
    for (int i = 0; i < NUMBER_OF_INPUTS; i++) {
        //分割线
        UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+1), 300, 1)];
        separateLine.backgroundColor = [UIColor colorWithRed:0xEC/255.0f green:0xE4/255.0f blue:0xEB/255.0f alpha:1.0f];
        [_inputBgView addSubview:separateLine];
        [separateLine release];
    }
    
    NSArray *registerNames = [NSArray arrayWithObjects:@"邮箱",@"姓名",@"地区",@"部门", @"密码" , @"确认密码",nil];
    NSArray *registerPlaceholderNames = [NSArray arrayWithObjects:@"请输入邮箱",@"请输入姓名",@"请选择地区",@"请输入部门", @"请输入密码" , @"请重复输入密码",nil];
    
    for (int i = 0; i < NUMBER_OF_INPUTS; i++) {
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
        [_inputBgView addSubview:mailTitleView];
        [mailTitleView release];
        
        if (i == RegisterTag_Region) {
            UILabel *regionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mailTitleView.frame), 40*i+10, 90, 20)];
            regionLabel.backgroundColor = [UIColor clearColor];
            regionLabel.textColor = [UIColor colorWithRed:0xA4/255.0f green:0xA4/255.0f blue:0xA4/255.0f alpha:1.0f];
            regionLabel.textAlignment = NSTextAlignmentLeft;
            regionLabel.font = [UIFont systemFontOfSize:17];
            regionLabel.text = [registerPlaceholderNames objectAtIndex:i];
            [_inputBgView addSubview:regionLabel];
        } else {
            UITextField *mailTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mailTitleView.frame), 8 + 40*i, 240, 30)];
            mailTextField.delegate = self;
            mailTextField.tag = i+INPUT_TAG;
            mailTextField.backgroundColor = [UIColor clearColor];
            mailTextField.textAlignment = NSTextAlignmentLeft;
            mailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            mailTextField.placeholder = [registerPlaceholderNames objectAtIndex:i];
            [_inputBgView addSubview:mailTextField];
            [mailTextField release];
            
            //密码
            if (i == RegisterTag_Pwd || i == RegisterTag_PwdAgain) {
                mailTextField.secureTextEntry = YES;
            }
        }
    }
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerBtn.backgroundColor = [UIColor clearColor];
    registerBtn.frame = CGRectMake(20, CGRectGetMaxY(_inputBgView.frame)+15, 280, 40);
    registerBtn.backgroundColor = [UIColor colorWithRed:0xCD/255.0f green:0xCE/255.0f blue:0xCC/255.0f alpha:1.0f];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(doRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registerBtn];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Nofication Callback
- (void)textDidChange:(NSNotification *)notification
{
    UITextField *currentTextField = (UITextField *)[notification object];
    RegisterInputViewTag inputTag = currentTextField.tag - INPUT_TAG;
    switch (inputTag) {
        case RegisterTag_Mail:
            _userData.email = currentTextField.text;
            break;
        case RegisterTag_Name:
            _userData.fullName = currentTextField.text;
            break;
        case RegisterTag_Dept:
            _userData.deptName = currentTextField.text;
            break;
        default:
            break;
    }
}

#pragma mark - Button Event
- (void)doRegister:(id)sender
{
    //检查输入合法性
    if (![self checkInputAvailiable]) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(doRegister)]) {
        [_delegate doRegister];
    }
}

//检查输入合法性 YES:输入合法，可以注册 NO:输入不合法给出提示
- (BOOL)checkInputAvailiable
{
    //非空检查
    BOOL isCheckedOut = YES;
    NSString *errorMsg = nil;
    for (int i = 0; i < NUMBER_OF_INPUTS; i++) {
        UITextField *textField = (UITextField*)[_inputBgView viewWithTag:i+INPUT_TAG];
        if (textField && (textField.text == nil || [@"" isEqualToString:textField.text])) {
            isCheckedOut = NO;
            errorMsg = @"输入项目不能为空!";
        }
    }
    if (!isCheckedOut) {
        
        [[Toast sharedInstance]show:errorMsg duration:TOAST_DEFALT_DURATION];
    }
    
    return isCheckedOut;
}

@end
