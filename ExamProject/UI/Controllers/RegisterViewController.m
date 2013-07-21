//
//  RegisterViewController.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "RegisterViewController.h"
#import "EXRegisterView.h"
#import "DBManager.h"
#import "Toast.h"

@interface RegisterViewController () <RegisterViewDelegate>

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (_userData == nil) {
            _userData = [[UserData alloc]init];
        }
    }
    return self;
}

- (id)initWithUserData:(UserData *)aUserData
{
    self = [super init];
    if (self) {
        _userData = [aUserData retain];
    }
    return self;
}

- (void)dealloc
{
    [_userData release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    EXRegisterView *registerView = [[EXRegisterView alloc]init];
    registerView.delegate = self;
    registerView.userData = _userData;
    registerView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-44);
    registerView.backgroundColor = [UIColor colorWithRed:0xE3/255.0f green:0xEC/255.0f blue:0xEC/255.0f alpha:1.0f];
    [self.view addSubview:registerView];
    [registerView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma RegisterViewDelegate
- (void)doRegister
{
    //这里暂时在本地保存注册信息
    [DBManager addUser:_userData];
    
    [[Toast sharedInstance]show:@"注册成功！" duration:TOAST_DEFALT_DURATION];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
