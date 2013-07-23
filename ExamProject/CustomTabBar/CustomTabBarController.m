//
//  BTCustomTabBarController.m
//  AABabyTing3
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarController.h"
//#import "BTConstant.h"
//#import "BTUtilityClass.h"
//#import "BTBadgeImageView.h"

@interface CustomTabBarController (Private)

-(void)initCustomTabBar;

@end

@implementation CustomTabBarController

@synthesize customTabBarView = _customTabBarView;
@synthesize tabBarItems = _tabBarItems;


-(id)init{
    
    self = [super init];
    if(self){
        self.view.backgroundColor=[UIColor whiteColor];
        [self hideRealTabBar];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailure:) name:NOTIFICATION_DOWNLOAD_FAILURE object:nil];
    }
    
    return self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [super setViewControllers:viewControllers animated:animated];
    
    [self initCustomTabBar];
}

-(void)initCustomTabBar{
    
    self.tabBarItems = [NSMutableArray array];
    
    CGRect tabBarFrame = self.tabBar.frame;
    
    self.customTabBarView = [[[UIView alloc] initWithFrame:tabBarFrame] autorelease];
    _customTabBarView.backgroundColor = [UIColor colorWithRed:0xe3/255.0f green:0xe6/255.0f blue:0xe8/255.0f alpha:1.0f];
    _customTabBarView.tag = TAG_TABBAR;
    [self.view addSubview:_customTabBarView];
    
//    UIImageView *bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, -12, 320, 66)];
//    bottom.image = [UIImage imageNamed:@"player_green.png"];
//    [_customTabBarView addSubview:bottom];
//    [bottom release];
    
    float originX = 0;
    UIImage *image = nil;
    for (int i = 0; i < 4; i++) {
        UIButton *bt = [[UIButton alloc]init];
        bt.frame = CGRectMake(originX,0,80,60);
//        UIViewController *vc = [self.viewControllers objectAtIndex:i];
//        
//        [bt setTitle:vc.title forState:UIControlStateNormal];
//        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        NSString *pic = [NSString stringWithFormat:@"tabBarItem_%d.png",i+1];
        image = [UIImage imageNamed:pic];
        if (image) {
            [bt setImage:image forState:UIControlStateNormal];
            pic = [NSString stringWithFormat:@"tabBarItem_selected_%d.png",i+1];
            image = [UIImage imageNamed:pic];
            [bt setImage:image forState:UIControlStateSelected];
        }
        bt.tag = TAG_BUTTON_ORIGIN + i;
        [bt addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventTouchUpInside];
        [bt setExclusiveTouch:YES];
        [_tabBarItems addObject:bt];
        [bt release];
        
        UILabel *tabBarTitle = [[UILabel alloc]initWithFrame:CGRectMake(originX, 0, 0, 0)];
        tabBarTitle.tag = TAG_TABBAR_TITLE_ORIGIN+i;
        
        UIViewController *vc = [self.viewControllers objectAtIndex:i];
        tabBarTitle.text = vc.title;
        tabBarTitle.textAlignment = NSTextAlignmentCenter;
        tabBarTitle.textColor = [UIColor blackColor];
        [bt addSubview:tabBarTitle];
        [tabBarTitle release];
        
        if (i == 0) 
            bt.selected = YES;
        [_customTabBarView addSubview:bt];
        originX += 80;
        
        //调整位置
        [bt setImageEdgeInsets:UIEdgeInsetsMake(5, 25, 31, 25)];       
    }
    
}

-(void)tabChanged:(UIButton *)bt{
    
    UIView *tabBarView = [self.view viewWithTag:TAG_TABBAR];
    for (UIView *view in tabBarView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *bt = (UIButton *)view;
            bt.selected = NO;
        }
    }
    bt.selected = YES;
    
    int currentIndex = bt.tag - TAG_BUTTON_ORIGIN;
	
    if (self.selectedIndex != currentIndex) {
        self.selectedIndex = bt.tag - TAG_BUTTON_ORIGIN;
    }else{
        UINavigationController *navTabCtr = [self.viewControllers objectAtIndex:currentIndex];
        [navTabCtr popToRootViewControllerAnimated:YES];
    }
}

- (void)hideTabBar{
    
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, SCREEN_HEIGHT , view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, SCREEN_HEIGHT)];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.customTabBarView.frame=CGRectMake(CGRectGetMinX(self.customTabBarView.frame), CGRectGetHeight(self.view.frame) , CGRectGetWidth(self.customTabBarView.frame), CGRectGetHeight(self.customTabBarView.frame));
        
    } completion:^(BOOL finished) {
        [self.customTabBarView setHidden:YES];
    }];
}

- (void)showTabBar{
    
    [self.customTabBarView setHidden:NO];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.customTabBarView.frame=CGRectMake(CGRectGetMinX(self.customTabBarView.frame), SCREEN_HEIGHT-49, CGRectGetWidth(self.customTabBarView.frame), CGRectGetHeight(self.customTabBarView.frame));
        
    } completion:^(BOOL finished) {
        for(UIView *view in self.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                [view setFrame:CGRectMake(view.frame.origin.x, SCREEN_HEIGHT-49 , view.frame.size.width, view.frame.size.height)];
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, SCREEN_HEIGHT - 49)];
            }
        }
    }];
    
}

- (void)downloadFailure:(NSNotification *)notification{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"下载失败，请重新下载" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void)dealloc{
    [_tabBarItems release];
    [_customTabBarView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
