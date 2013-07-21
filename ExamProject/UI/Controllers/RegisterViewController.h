//
//  RegisterViewController.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserData;

@interface RegisterViewController : UIViewController
{
    UserData    *_userData;
}

- (id)initWithUserData:(UserData *)aUserData;

@end
