//
//  BusinessCenter.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "BusinessCenter.h"
#import "KeychainItemWrapper.h"
#import "DBManager.h"

static BusinessCenter *instance = nil;

@implementation BusinessCenter

- (id)init
{
    self = [super init];
    if (self) {
        _keychainWrapper = [[KeychainItemWrapper alloc]initWithIdentifier:KEYCHAIN_IDENTIFIER accessGroup:nil];
    }
    return self;
}

+ (BusinessCenter *)sharedInstance
{
    if (instance == nil) {
        instance = [[BusinessCenter alloc]init];
    }
    return instance;
}

- (BOOL)isLogin            //判断是否登录    从keychain中读取登录信息
{
    return [DBManager getDefaultUser] != nil;
}

//保存用户密码到keychain
- (void)saveUsername:(NSString *)userName andPassword:(NSString *)password
{
    if (userName && password) {
        [_keychainWrapper setObject:password forKey:userName];
    }
}

- (void)dealloc
{
    
    [super dealloc];
}

@end
