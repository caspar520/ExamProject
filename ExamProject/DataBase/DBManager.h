//
//  DBManager.h
//  ExamProject
//
//  Created by magic on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paper.h"
#import "PaperData.h"
#import "Topic.h"
#import "TopicData.h"
#import "User.h"
#import "UserData.h"

@interface DBManager : NSObject

+ (Paper *)addPaper:(PaperData *)paperData;        //添加或者更新试卷
+ (NSArray *)fetchAllPapersFromDB;                 //取得所有数据库试卷
+ (NSArray *)fetchWrongPapers;                     //取所有错题
+ (NSArray *)fetchCollectedPapers;                 //取所有收藏的试卷

+ (Topic *)addTopic:(TopicData *)topicData;         //添加试题
+ (NSSet *)addTopicsWithArray:(NSArray *)topics;    //批量添加试题

+ (User *)addUser:(UserData *)userData;             //添加用户信息
+ (UserData *)getDefaultUserData;                           //获取默认用户信息
+ (NSString *)getRegisterUserName;                  //获取注册用户名

@end
