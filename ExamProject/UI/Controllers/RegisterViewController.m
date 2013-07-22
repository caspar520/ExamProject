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
#import "CustomPickerView.h"

@interface RegisterViewController () <RegisterViewDelegate,CustomPickerViewDelegate>

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
    [_cPickerView release];
    [_registerView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _registerView = [[EXRegisterView alloc]init];
    _registerView.delegate = self;
    _registerView.modifyMode = _modifyMode;
    [_registerView initRegisterUI];
    _registerView.userData = _userData;
    _registerView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-44);
    _registerView.backgroundColor = [UIColor colorWithRed:0xE3/255.0f green:0xEC/255.0f blue:0xEC/255.0f alpha:1.0f];
    [self.view addSubview:_registerView];
    
    _cPickerView = [[CustomPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
    _cPickerView.delegate = self;
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"region" ofType:@"plist"];
    _cPickerView.regionsDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [self.view addSubview:_cPickerView];
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
    
    if (_modifyMode) {
        [[Toast sharedInstance]show:@"修改成功！" duration:TOAST_DEFALT_DURATION];
    } else {
        [[Toast sharedInstance]show:@"注册成功！" duration:TOAST_DEFALT_DURATION];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)wakeupPickerView
{
    [self showPickerView];
}

#pragma mark - CustomPickerViewDelegate
- (void)saveContent:(NSString *)city area:(NSString *)area
{
    NSNumber *regionId = [self regionIdWithCity:city area:area];
    _userData.regionId = regionId;
    _userData.city = city;
    _userData.area = area;
    [_registerView refreshUIWithUserData];  //刷新UI
    
    [self hidePickerView];
}

- (void)cancelledSelectRegion
{
    [self hidePickerView];
}

- (NSNumber *)regionIdWithCity:(NSString *)city area:(NSString *)area
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"regionData" ofType:@"plist"];
    NSArray *regionData = [NSArray arrayWithContentsOfFile:filePath];
    NSArray *filteredRegions = [regionData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"city=%@&&area=%@",city,area]];
    if (filteredRegions && [filteredRegions count] > 0) {
        NSDictionary *dic = [filteredRegions objectAtIndex:0];
        return [dic objectForKey:@"regionId"];
    }
    return nil;
}

//显示PickerView
- (void)showPickerView
{
    [UIView animateWithDuration:0.3f animations:^{
        _cPickerView.frame = CGRectMake(0, SCREEN_HEIGHT-CGRectGetHeight(_cPickerView.frame), CGRectGetWidth(_cPickerView.frame), CGRectGetHeight(_cPickerView.frame));
    } completion:nil];
}

//隐藏PickerView
- (void)hidePickerView
{
    [UIView animateWithDuration:0.3f animations:^{
        _cPickerView.frame = CGRectMake(0, SCREEN_HEIGHT, CGRectGetWidth(_cPickerView.frame), CGRectGetHeight(_cPickerView.frame));
    } completion:nil];
}

@end
