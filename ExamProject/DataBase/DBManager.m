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

+ (NSArray *)paperDataWithPapers:(NSArray *)papers;     //paper转换为PaperData
+ (Paper *)getPaperByID:(int)paperId;       //通过PaperID获得Paper对象
+ (NSArray *)readAllPapers;                 //取得所有试卷
+ (NSArray *)readWrongPapers;               //取得所有错题试卷
+ (NSArray *)readCollectedPapers;           //取得所有收藏的试卷
+ (Topic *)getTopicByID:(int)topicId;       //通过topicID获得Topic对象
+ (User *) getDefaultUser;

@end

@implementation DBManager

+ (NSArray *)fetchAllPapersFromDB
{
    NSArray *result = [DBManager readAllPapers];
    return [DBManager paperDataWithPapers:result];
}

//取所有错题
+ (NSArray *)fetchWrongPapers
{
    NSArray *result = [DBManager readWrongPapers];
    return [DBManager paperDataWithPapers:result];
}

//取所有收藏的试卷
+ (NSArray *)fetchCollectedPapers
{
    NSArray *result = [DBManager readCollectedPapers];
    return [DBManager paperDataWithPapers:result];
}

+ (NSArray *)readAllPapers
{
    return [DBManager readPapersWithCondition:nil];
}

//取得所有错题试卷
+ (NSArray *)readWrongPapers
{
    return [DBManager readPapersWithCondition:@"wrong=YES"];
}

//取得所有收藏的试卷
+ (NSArray *)readCollectedPapers
{
    return [DBManager readPapersWithCondition:@"fav=YES"];
}

//根据条件取得相应的试卷
+ (NSArray *)readPapersWithCondition:(NSString *)condition
{
    NSFetchRequest *request = [Paper defaultFetchRequest];
    
    if (condition && ![@"" isEqualToString:condition]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
        [request setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"paperId"
                                                                   ascending:NO];
    [request setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    NSArray *result = [Paper executeFetchRequest:request error:nil];
    return result;
}


#pragma mark - Paper
+ (NSArray *)paperDataWithPapers:(NSArray *)papers
{
    NSMutableArray *resultData = [[NSMutableArray alloc]initWithCapacity:0];
    for (Paper *paper in papers) {
        PaperData *paperData = [[PaperData alloc]initWithPaper:paper];
        [resultData addObject:paperData];
        [paperData release];
    }
    return [resultData autorelease];
}

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

//添加考试
+ (Exam *)addExam:(ExamData *)examData
{
    //考试每次都会创建一个新的记录
    Exam *aExam = [Exam createNewObject];
    aExam.examId = examData.examId;
    aExam.examTotalTm = examData.examTotalTm;
    aExam.examBeginTm = examData.examBeginTm;
    aExam.examTimes = examData.examTimes;
    aExam.examPassing = examData.examPassing;
    aExam.examPassingAgainFlg = examData.examPassingAgainFlg;
    aExam.examSubmitDisplayAnswerFlg = examData.examSubmitDisplayAnswerFlg;
    aExam.examPublishAnswerFlg = examData.examPublishAnswerFlg;
    aExam.examPublishResultTm = examData.examPublishResultTm;
    aExam.examDisableMinute = examData.examDisableMinute;
    aExam.examDisableSubmit = examData.examDisableSubmit;
    aExam.updateTm = examData.updateTm;
    aExam.createTm = examData.createTm;
    
    NSSet *papers = [DBManager addPapersWithArray:examData.papers];
    [aExam addPapers:papers];
    
    [Exam save];
    
    return aExam;
}


//取得所有已提交考试
+ (NSArray *)fetchALlExamsFromDB
{
    return nil;
}

+ (Paper *)addPaper:(PaperData *)paperData
{
    Paper *aPaper = [DBManager getPaperByID:[paperData.paperId intValue]];
    if (aPaper == nil) {
        aPaper = [Paper createNewObject];
    }
    aPaper.paperId = paperData.paperId;
    aPaper.paperName = paperData.paperName;
    aPaper.paperStatus = paperData.paperStatus;
    
    NSSet *topics = [DBManager addTopicsWithArray:paperData.topics];
    [aPaper addTopics:topics];
    
    return aPaper;
}

+ (NSSet *)addPapersWithArray:(NSArray *)papers
{
    NSMutableSet *tSet = [NSMutableSet setWithCapacity:0];
    for (PaperData *paperData in papers) {
        Paper *paper = [DBManager addPaper:paperData];
        [tSet addObject:paper];
    }
    
    return tSet;
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
    topic.topicQuestion = topicData.topicQuestion;
    topic.topicType = topicData.topicType;
    topic.topicAnalysis = topicData.topicAnalysis;
    topic.topicValue = topicData.topicValue;
    topic.topicImage = topicData.topicImage;

    return topic;
}

+ (NSSet *)addTopicsWithArray:(NSArray *)topics
{
    NSMutableSet *tSet = [NSMutableSet setWithCapacity:0];
    for (TopicData *topicData in topics) {
        Topic *topic = [DBManager addTopic:topicData];
        [tSet addObject:topic];
    }
    
    return tSet;
}

//添加答案
+ (Answer *)addAnswer:(AnswerData *)anserData
{
    Answer *answer = [Answer createNewObject];
    answer.content = anserData.content;
    answer.isCorrect = anserData.isCorrect;
    answer.isSelected = anserData.isSelected;

    return answer;
}

//批量添加答案
+ (NSSet *)addAnsersWithArray:(NSArray *)answers
{
    NSMutableSet *tSet = [NSMutableSet setWithCapacity:0];
    for (AnswerData *answerData in answers) {
        Answer *answer = [DBManager addAnswer:answerData];
        [tSet addObject:answer];
    }
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

//获取默认用户信息
+ (UserData *)getDefaultUserData
{
    UserData *userData = nil;
    User *user = [DBManager getDefaultUser];
    if (user) {
        userData = [[[UserData alloc]initWithUser:[DBManager getDefaultUser]] autorelease];
    }
    
    return userData;
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

//删除用户信息
+ (void)deleteAllUser
{
    [User deleteAllObjects];
    [User save];
}

@end
