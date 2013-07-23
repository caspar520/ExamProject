//
//  AboutViewController.m
//  ExamProject
//
//  Created by magic on 13-7-21.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.title = @"关于";
    
    UILabel *aboutContent1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 300, 100)];
    aboutContent1.backgroundColor = [UIColor clearColor];
    aboutContent1.numberOfLines = 0;
    aboutContent1.font = [UIFont systemFontOfSize:14];
    aboutContent1.text = @"健教天地V1.0(iPhone)Beta1\n\n榆林市榆阳区政府创建办公室 版权所有\n\n网址：";
    [self.view addSubview:aboutContent1];
    [aboutContent1 release];
    
    UITextView *urlTextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMinX(aboutContent1.frame)-8, CGRectGetMaxY(aboutContent1.frame)-12, 300, 30)];
    urlTextView.backgroundColor = [UIColor clearColor];
    urlTextView.textAlignment = NSTextAlignmentLeft;
    urlTextView.text = @"http://www.yuyang.gov.cn";
    urlTextView.font = [UIFont systemFontOfSize:14];
    urlTextView.editable = NO;
    urlTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    [self.view addSubview:urlTextView];
    [urlTextView release];
    
    UILabel *aboutContent2 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(urlTextView.frame), 300, 240)];
    aboutContent2.backgroundColor = [UIColor clearColor];
    aboutContent2.numberOfLines = 0;
    aboutContent2.font = [UIFont systemFontOfSize:14];
    aboutContent2.text = @"电话：\n(+86)0912-3525024\n\n\n申明\n\n此版本适用于iOS5.1以上版本操作系统手机，对于在使用其他操作系统的手机上使用本软件，出现的任何问题，不承担任何责任。本软件的下载，安装和使用完全免费，不收取任何费用，下载，使用过程中产生的GPRS数据流量费用，由运营商收取。";
    [self.view addSubview:aboutContent2];
    [aboutContent2 release];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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

@end
