//
//  TopicData.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "TopicData.h"
#import "Topic.h"

@implementation TopicData

@synthesize topicId;
@synthesize question;
@synthesize type;
@synthesize answers;
@synthesize corrects;
@synthesize selected;
@synthesize analysis;
@synthesize value;
@synthesize image;
@synthesize favourite;
@synthesize wrong;

- (id)initWithTopic:(Topic *)topic
{
    self = [super init];
    if (self) {
        self.topicId = topic.topicId;
        self.question = topic.question;
        self.type = topic.type;
        self.answers = topic.answers;
        self.corrects = topic.corrects;
        self.selected = topic.selected;
        self.analysis = topic.analysis;
        self.value = topic.value;
        self.image = topic.image;
        self.favourite = topic.favourite;
        self.wrong = topic.wrong;
    }
    return self;
}

- (void)dealloc
{
    [topicId release];
    [question release];
    [type release];
    [answers release];
    [corrects release];
    [selected release];
    [analysis release];
    [value release];
    [image release];
    [favourite release];
    [wrong release];
    
    [super dealloc];
}

@end
