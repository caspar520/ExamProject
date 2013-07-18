//
//  AppDelegate.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "CustomTabBarController.h"
#import "ExamViewController.h"
#import "WrongViewController.h"
#import "CollectViewController.h"
#import "MoreViewController.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self initUIControllers];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initUIControllers
{
    //先使用系统NavigationBar
    ExamViewController * tabBarController1 = [[ExamViewController alloc] init];
    tabBarController1.title = @"考试";
    UINavigationController* navController1 = [[UINavigationController alloc] initWithRootViewController:tabBarController1];
    [tabBarController1 release];
    
    UIViewController * tabBarController2 = [[UIViewController alloc] init];
    tabBarController2.title = @"错题";
    UINavigationController* navController2 = [[UINavigationController alloc] initWithRootViewController:tabBarController2];
    [tabBarController2 release];
    
    UIViewController * tabBarController3 = [[UIViewController alloc] init];
    tabBarController3.title = @"收藏";
    UINavigationController* navController3 = [[UINavigationController alloc] initWithRootViewController:tabBarController3];
    [tabBarController3 release];
    
    UIViewController * tabBarController4 = [[UIViewController alloc] init];
    tabBarController4.title = @"更多";
    UINavigationController* navController4 = [[UINavigationController alloc] initWithRootViewController:tabBarController4];
    [tabBarController4 release];
    
    NSArray *subTabControllers = [NSArray arrayWithObjects:navController1, navController2, navController3, navController4, nil];
    CustomTabBarController * customTabController = [[CustomTabBarController alloc] init];
    self.tabController = customTabController;
    [customTabController release];
    
    [_tabController setViewControllers:subTabControllers];
    _tabController.view.frame = CGRectMake(0, 0, 320, WINDOW_HEIGHT);
    _tabController.view.backgroundColor = [UIColor clearColor];
    _tabController.delegate = self;
    [_window setRootViewController:_tabController];
    
    [navController1 release];
    [navController2 release];
    [navController3 release];
    [navController4 release];
}

@end
