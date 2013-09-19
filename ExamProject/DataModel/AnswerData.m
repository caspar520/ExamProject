//
//  AnswerData.m
//  ExamProject
//
//  Created by magic on 13-8-24.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "AnswerData.h"
#import "Answer.h"
#import "TopicData.h"

@implementation AnswerData

@synthesize content;
@synthesize isCorrect;
@synthesize isSelected;

- (id)initWithAnswer:(Answer *)answer
{
    self = [super init];
    if (self) {
        self.objectID = answer.objectID;
        self.content = answer.content;
        self.isCorrect = answer.isCorrect;
        self.isSelected = answer.isSelected;
    }
    return self;
}

- (void)dealloc
{
    [content release];
    [isCorrect release];
    [isSelected release];
    
    [super dealloc];
}

@end
