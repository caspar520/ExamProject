//
//  MoreViewController.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "MoreViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AboutViewController.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"

@interface MoreViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray     *_cellNames;
}


@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _cellNames = [[NSArray arrayWithObjects:@"帮助",@"版本更新",@"关于", nil] retain];
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-43) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView release];
    
    //退出登录
    UIButton *exitLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exitLogin.backgroundColor = [UIColor clearColor];
    exitLogin.frame = CGRectMake(40, 240, 240, 40);
    [exitLogin setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitLogin addTarget:self action:@selector(exitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tableView addSubview:exitLogin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //显示TabBar
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController showTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"moreTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"帐号";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [_cellNames objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //进入帐号
        RegisterViewController *registerController = [[RegisterViewController alloc]initWithUserData:[DBManager getDefaultUserData]];
        registerController.modifyMode = YES;
        [self.navigationController pushViewController:registerController animated:YES];
        [registerController release];
        
        //隐藏TabBar
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        CustomTabBarController *tabBarController=appDelegate.tabController;
        [tabBarController hideTabBar];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            //进入关于
            AboutViewController *aboutController = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:aboutController animated:YES];
            [aboutController release];
            
            //隐藏TabBar
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            CustomTabBarController *tabBarController=appDelegate.tabController;
            [tabBarController hideTabBar];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button Event Callback
- (void)exitClicked:(id)sender
{
    //TODO删除数据库User
    
    //跳转到登录界面
    LoginViewController *loginController = [[LoginViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginController];
    [self.navigationController presentModalViewController:navController animated:YES];
    [loginController release];
    [navController release];
}

@end
