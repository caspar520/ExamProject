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
    _customTabBarView.backgroundColor = [UIColor clearColor];
    _customTabBarView.tag = TAG_TABBAR;
    [self.view addSubview:_customTabBarView];
    
    UIImageView *bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, -12, 320, 66)];
    bottom.image = [UIImage imageNamed:@"player_green.png"];
    [_customTabBarView addSubview:bottom];
    [bottom release];
    
    float originX = 0;
    UIImage *image = nil;
    for (int i = 0; i < 4; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bt.frame = CGRectMake(originX,0,80,60);
        NSString *pic = [NSString stringWithFormat:@"tabBarItem_%d.png",i+1];
        image = [UIImage imageNamed:pic];
        if (image) {
            [bt setImage:image forState:UIControlStateNormal];
            
            pic = [NSString stringWithFormat:@"tabBarItem_selected_%d.png",i+1];
            image = [UIImage imageNamed:pic];
            [bt setImage:image forState:UIControlStateSelected];
        } else {
            UIViewController *vc = [self.viewControllers objectAtIndex:i];
            [bt setTitle:vc.title forState:UIControlStateNormal];
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.backgroundColor = [UIColor whiteColor];
        }
        
        bt.tag = TAG_BUTTON_ORIGIN + i;
        [bt addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventTouchUpInside];
        [bt setExclusiveTouch:YES];
        [_tabBarItems addObject:bt];
        
        if (i == 0) 
            bt.selected = YES;
        [_customTabBarView addSubview:bt];
        originX += 80;
        
        //调整位置
        switch (i) {
            case 0:
                [bt setImageEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, 0)];
                break;
            case 1:
                [bt setImageEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
                break;
            case 2:
                [bt setImageEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
                break;          
            case 3:
                [bt setImageEdgeInsets:UIEdgeInsetsMake(-8.5, 0, 0, 0)];
                break;
            default:
                break;
        }
        
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
    [UIView animateWithDuration:0.2 animations:^{
        self.customTabBarView.frame=CGRectMake(CGRectGetMinX(self.customTabBarView.frame), CGRectGetHeight(self.view.frame) , CGRectGetWidth(self.customTabBarView.frame), CGRectGetHeight(self.customTabBarView.frame));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showTabBar{
    [UIView animateWithDuration:0.2 animations:^{
        self.customTabBarView.frame=CGRectMake(CGRectGetMinX(self.customTabBarView.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.customTabBarView.frame), CGRectGetWidth(self.customTabBarView.frame), CGRectGetHeight(self.customTabBarView.frame));
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc{
    [_tabBarItems release];
    [_customTabBarView release];
    [super dealloc];
}

@end
