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
#import "BusinessCenter.h"
#import "ASIHTTPRequest.h"

@interface LoginViewController () <LoginViewDelegate,ASIHTTPRequestDelegate>

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

- (void)dealloc
{
    [_loginView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _loginView = [[EXLoginView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    _loginView.delegate = self;
    _loginView.backgroundColor = [UIColor colorWithRed:0x8e/255.0f green:0xcb/255.0f blue:0x49/255.0f alpha:1.0f];
    [self.view addSubview:_loginView];
    
    [self testRegister];
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
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)registerClicked
{
    RegisterViewController *registerController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerController animated:YES];
    [registerController release];
}

//验证用户名和密码
- (BOOL)verifyIdentifier
{
    //本地验证是否合法(只能验证登录过的)
    NSString *userName = _loginView.mailTextField.text;
    NSString *pwd = _loginView.pwdTextField.text;
    if ([[BusinessCenter sharedInstance]verifyWithUserName:userName andPwd:pwd]) {
        return YES;
    }
    
    //验证用户名密码是否匹配 网络验证
    
    return YES;
}

- (void)testRegister
{
    //注册测试
    NSURL *url = [NSURL URLWithString:@"http://www.kanbook.cn/yonghu/su_add"];
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url]autorelease];
    request.delegate = self;
    NSDictionary *postBodyDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"magicTest@sina.com",@"email",
                                 @"magicTest",@"fullName",
                                 @"611025",@"regionId",
                                 @"magic_deptName",@"deptName",
                                 @"magic_pwd", @"password",nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postBodyDic options:kNilOptions error:nil];
    [request appendPostData:jsonData];
    [request startAsynchronous];
    
    //登录测试
//    NSURL *url = [NSURL URLWithString:@"http://www.kanbook.cn/yonghu/user_login"];
//    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url]autorelease];
//    request.delegate = self;
//    NSDictionary *postBodyDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"magicTest@sina.com",@"userName",
//                                 @"magic_pwd", @"password",nil];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postBodyDic options:kNilOptions error:nil];
//    [request appendPostData:jsonData];
//    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"[request responseStatusMessage] = %@ responseStatusCode = %d", [request responseStatusMessage], [request responseStatusCode]);
    NSLog(@"responseString = %@", [request responseString]);
    
    NSDictionary *responsePostBody = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
    NSLog(@"responsePostBody = %@", responsePostBody);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
