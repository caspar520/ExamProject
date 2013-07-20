//
//  DBManager.m
//  ExamProject
//
//  Created by magic on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "DBManager.h"
#import "PaperData.h"

@interface DBManager ()

+ (Paper *)getPaperByID:(int)paperId;       //通过PaperID获得Paper对象
+ (NSArray *)readAllPapers;
+ (Topic *)getTopicByID:(int)topicId;       //通过topicID获得Topic对象

@end

@implementation DBManager

+ (NSArray *)fetchAllPapersFromDB
{
    NSArray *result = [DBManager readAllPapers];
    NSMutableArray *resultData = [[NSMutableArray alloc]initWithCapacity:0];
    for (Paper *paper in result) {
        PaperData *paperData = [[PaperData alloc]initWithPaper:paper];
        [resultData addObject:paperData];
        [paperData release];
    }
    return [resultData autorelease];
}

+ (NSArray *)readAllPapers
{
    NSFetchRequest *request = [Paper defaultFetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"paperId"
                                                                   ascending:NO];
    [request setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    NSArray *result = [Paper executeFetchRequest:request error:nil];
    return result;
}

#pragma mark - Paper
+ (Paper *)getPaperByID:(int)paperId
{
    NSFetchRequest *fetchRequest = [Paper defaultFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"paperId = %d", paperId]];
    NSArray *result = [Paper executeFetchRequest:fetchRequest error:nil];
    Paper *paper = nil;
    if ([result count] > 0) {
        paper = [result objectAtIndex:0];
    }
    return paper;
}

+ (Paper *)addPaper:(PaperData *)paperData
{
    Paper *aPaper = [DBManager getPaperByID:[paperData.paperId intValue]];
    if (aPaper == nil) {
        aPaper = [Paper createNewObject];
    }
    aPaper.paperId = paperData.paperId;
    aPaper.title = paperData.title;
    aPaper.desc = paperData.desc;
    aPaper.creator = paperData.creator;
    aPaper.totalTime = paperData.totalTime;
    aPaper.totalScore = paperData.totalScore;
    aPaper.topicCount = paperData.topicCount;
    aPaper.passingScore = paperData.passingScore;
    aPaper.eliteScore = paperData.eliteScore;
    aPaper.userScore = paperData.userScore;
    aPaper.fav = paperData.fav;
    aPaper.wrong = paperData.wrong;
    aPaper.sequence = paperData.sequence;
    aPaper.addtime = paperData.addtime;
    aPaper.url = paperData.url;
    
    NSSet *topics = [DBManager addTopicsWithArray:paperData.topics];
    [aPaper addTopics:topics];
    
    [Paper save];
    
    return aPaper;
}

#pragma mark - Topic

//通过topicID获得Topic对象
+ (Topic *)getTopicByID:(int)topicId
{
    NSFetchRequest *fetchRequest = [Topic defaultFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"topicId = %d", topicId]];
    NSArray *result = [Topic executeFetchRequest:fetchRequest error:nil];
    Topic *topic = nil;
    if ([result count] > 0) {
        topic = [result objectAtIndex:0];
    }
    return topic;
}

+ (Topic *)addTopic:(TopicData *)topicData
{
    Topic *topic = [DBManager getTopicByID:[topicData.topicId intValue]];
    if (topic == nil) {
        topic = [Topic createNewObject];
    }
    topic.topicId = topicData.topicId;
    topic.question = topicData.question;
    topic.type = topicData.type;
    topic.answers = topicData.answers;
    topic.corrects = topicData.corrects;
    topic.selected = topicData.selected;
    topic.analysis = topicData.analysis;
    topic.value = topicData.value;
    topic.image = topicData.image;
    topic.favourite = topicData.favourite;
    topic.wrong = topicData.wrong;

    return topic;
}

+ (NSSet *)addTopicsWithArray:(NSArray *)topics
{
    NSMutableSet *tSet = [NSMutableSet setWithCapacity:0];
    for (TopicData *topicData in topics) {
        Topic *topic = [DBManager addTopic:topicData];
        [tSet addObject:topic];
    }
    [Topic save];
    
    return tSet;
}

//添加用户信息
+ (User *)addUser:(UserData *)userData
{
    User *user = [DBManager getDefaultUser];
    if (user == nil) {
        user = [User createNewObject];
    }
    user.email = userData.email;
    user.fullName = userData.fullName;
    user.regionId = userData.regionId;
    user.deptName = userData.deptName;
    [User save];
    return user;
}

//获取默认用户信息
+ (User *)getDefaultUser
{
    NSFetchRequest *fetchRequest = [User defaultFetchRequest];
    NSArray *result = [User executeFetchRequest:fetchRequest error:nil];
    User *user = nil;
    if ([result count] > 0) {
        user = [result objectAtIndex:0];
    }
    return user;
}

//获取注册用户名
+ (NSString *)getRegisterUserName
{
    User *user = [DBManager getDefaultUser];
    if (user) {
        return user.fullName;
    }
    return nil;
}

@end
