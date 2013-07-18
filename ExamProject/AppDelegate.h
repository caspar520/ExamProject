//
//  AppDelegate.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WINDOW_HEIGHT	([UIScreen mainScreen].bounds.size.height)

@class ViewController;
@class CustomTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,retain) CustomTabBarController *tabController;

@property (strong, nonatomic) ViewController *viewController;

@end
