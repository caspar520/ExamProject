//
//  PaperData.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "PaperData.h"
#import "Paper.h"

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
    
    [super dealloc];
}

@end
