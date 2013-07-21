//
//  LoginViewController.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "LoginViewController.h"
#import "EXLoginView.h"
#import "RegisterViewController.h"

@interface LoginViewController () <LoginViewDelegate>

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    EXLoginView *loginView = [[EXLoginView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    loginView.delegate = self;
    loginView.backgroundColor = [UIColor colorWithRed:0x8e/255.0f green:0xcb/255.0f blue:0x49/255.0f alpha:1.0f];
    [self.view addSubview:loginView];
    [loginView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoginViewDelegate
- (void)loginClicked
{
    //没有协议，故这里先暂时只检查非空,直接进入主页
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerClicked
{
    RegisterViewController *registerController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerController animated:YES];
    [registerController release];
}

@end
