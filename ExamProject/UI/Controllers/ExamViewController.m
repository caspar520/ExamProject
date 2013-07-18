//
//  ExamViewController.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "ExamViewController.h"

@interface ExamViewController ()

@end

@implementation ExamViewController

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
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    testLabel.backgroundColor = [UIColor greenColor];
    testLabel.text = @"测试测试";
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.font = [UIFont systemFontOfSize:24];
    testLabel.adjustsLetterSpacingToFitWidth = YES;
    testLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:testLabel];
    [testLabel release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
