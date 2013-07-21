//
//  RegisterViewController.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "RegisterViewController.h"
#import "EXRegisterView.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    
    EXRegisterView *registerView = [[EXRegisterView alloc]init];
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

@end
