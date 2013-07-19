//
//  Paper.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "Paper.h"
#import "KPStore.h"

@implementation Paper

@dynamic paperId;
@dynamic title;
@dynamic desc;
@dynamic creator;
@dynamic totalTime;
@dynamic totalScore;
@dynamic topicCount;
@dynamic passingScore;
@dynamic eliteScore;
@dynamic userScore;
@dynamic fav;
@dynamic wrong;
@dynamic sequence;
@dynamic addtime;
@dynamic url;

+ (void)initialize
{
    [KPStore registerStoreWithName:NSStringFromClass([self class]) modelFile:NSStringFromClass([self class])];
    //若有多个dataModel时，才需要bind操作
    //[KPStore bindObjectClass:[self class] toStore:store];
}

+ (id)createNewObject
{
    Paper *paper = [super createNewObject];
    return paper;
}

@end
