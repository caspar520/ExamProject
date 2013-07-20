//
//  PaperData.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "PaperData.h"
#import "Paper.h"
#import "TopicData.h"
#import "Topic.h"

@implementation PaperData

@synthesize paperId;
@synthesize title;
@synthesize desc;
@synthesize creator;
@synthesize totalTime;
@synthesize totalScore;
@synthesize topicCount;
@synthesize passingScore;
@synthesize eliteScore;
@synthesize userScore;
@synthesize fav;
@synthesize wrong;
@synthesize sequence;
@synthesize addtime;
@synthesize url;
@synthesize topics;

- (id)initWithPaper:(Paper *)aPaper
{
    self = [super init];
    if (self) {
        self.paperId = aPaper.paperId;
        self.title = aPaper.title;
        self.desc = aPaper.desc;
        self.creator = aPaper.creator;
        self.totalTime = aPaper.totalTime;
        self.totalScore = aPaper.totalScore;
        self.topicCount = aPaper.topicCount;
        self.passingScore = aPaper.passingScore;
        self.eliteScore = aPaper.eliteScore;
        self.userScore = aPaper.userScore;
        self.fav = aPaper.fav;
        self.wrong = aPaper.wrong;
        self.sequence = aPaper.sequence;
        self.addtime = aPaper.addtime;
        self.url = aPaper.url;
        
        //先按照topicId升序排列
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"topicId" ascending:YES];
        NSArray *sortedArray = [aPaper.topics sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        [sortDescriptor release];
        
        //将数据以TopicData的形式传递出去
        NSMutableArray *topicDataArray = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
        for (Topic *topic in sortedArray) {
            TopicData *topicData = [[TopicData alloc]initWithTopic:topic];
            [topicDataArray addObject:topicData];
            [topicData release];
        }
        self.topics = topicDataArray;
    }
    return self;
}

- (void)dealloc
{
    [paperId release];
    [title release];
    [desc release];
    [creator release];
    [totalTime release];
    [totalScore release];
    [topicCount release];
    [passingScore release];
    [eliteScore release];
    [userScore release];
    [fav release];
    [wrong release];
    [sequence release];
    [addtime release];
    [url release];
    [topics release];
    
    [super dealloc];
}

@end
