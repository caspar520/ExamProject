//
//  Utility.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "Utility.h"
#import "PaperData.h"
#import "TopicData.h"

@implementation Utility

+ (PaperData *)convertJSONToPaperData:(NSData *)data{
    NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    PaperData *paperData = [[[PaperData alloc]init] autorelease];
    paperData.paperId = [NSNumber numberWithInt:[[result objectForKey:@"id"] intValue]];
    paperData.title = [result objectForKey:@"title"];
    paperData.desc = [result objectForKey:@"description"];
    paperData.creator = [result objectForKey:@"creator"];
    paperData.totalTime = [NSNumber numberWithInt:[[result objectForKey:@"totalTime"] intValue]];
    paperData.totalScore = [NSNumber numberWithInt:[[result objectForKey:@"totalScore"] intValue]];
    paperData.topicCount = [NSNumber numberWithInt:[[result objectForKey:@"topicCount"] intValue]];
    paperData.passingScore = [NSNumber numberWithInt:[[result objectForKey:@"passingScore"] intValue]];
    paperData.eliteScore = [NSNumber numberWithInt:[[result objectForKey:@"eliteScore"] intValue]];
    
    return paperData;
}

+ (NSArray *)convertJSONToTopicData:(NSData *)data{
    NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSDictionary *array=[result objectForKey:@"topicList"];
    NSMutableArray *topics = nil;
    if (array && [array count] > 0) {
        topics = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
        for (NSDictionary *topicDic in array) {
            TopicData *tData = [[TopicData alloc]init];
            
            tData.topicId = [topicDic objectForKey:@"id"];
            tData.question = [topicDic objectForKey:@"question"];
            tData.type = [topicDic objectForKey:@"type"];
            
            NSArray *answers = [topicDic objectForKey:@"answerList"];
            for (NSDictionary *answer in answers) {
                //答案选项
                if (tData.answers == nil) {
                    tData.answers = [answer objectForKey:@"content"];
                } else {
                    tData.answers = [tData.answers stringByAppendingFormat:@"|%@",[answer objectForKey:@"content"]];
                }
                
                //正确答案
                if ([[answer objectForKey:@"isCorrect"]boolValue]) {
                    if (tData.selected == nil) {
                        tData.selected = [NSString stringWithFormat:@"%u",[answers indexOfObject:answer]];
                    } else {
                        tData.selected = [tData.selected stringByAppendingFormat:@"|%u",[answers indexOfObject:answer]];
                    }
                }
            }
            tData.value = [[topicDic objectForKey:@"value"]stringValue];
            tData.analysis = [topicDic objectForKey:@"analysis"];
            tData.image = [topicDic objectForKey:@"image"];
            [topics addObject:tData];
            [tData release];
        }
    }
    return topics;
}

@end
