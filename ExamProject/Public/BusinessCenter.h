//
//  BusinessCenter.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KeychainItemWrapper;

@interface BusinessCenter : NSObject
{
    KeychainItemWrapper *_keychainWrapper;
}

+ (BusinessCenter *)sharedInstance;

/*
 *  登录相关类
 */
- (BOOL)isLogin;            //判断是否登录    从keychain中读取登录信息
- (void)saveUsername:(NSString *)userName andPassword:(NSString *)password; //保存用户密码到keychain

@end
