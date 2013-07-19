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
    Paper *aPaper = [DBManager getPaperByID:[paperData.paperId integerValue]];
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
    [Paper save];
    
    return aPaper;
}

@end
