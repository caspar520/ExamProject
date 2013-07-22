//
//  UserData.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbBaseProtocol.h"

@class User;

@interface UserData : NSObject <UserDataProtocol>

- (id)initWithUser:(User *)user;

@property (nonatomic,copy) NSString *city;      //市
@property (nonatomic,copy) NSString *area;      //区

@end
