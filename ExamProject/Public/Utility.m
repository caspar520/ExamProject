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
#import "ExamData.h"
#import "EXNetDataManager.h"
#import <CommonCrypto/CommonDigest.h>

#define CHUNK_SIZE 1024

@implementation Utility

+ (NSArray *)convertJSONToPaperData:(NSData *)data{
    NSMutableArray *result=[NSMutableArray arrayWithCapacity:0];
    
    if (data) { 
        NSDictionary *tExamPaper=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *tExamPaperInfoDic=[tExamPaper objectForKey:@"data"];
        
        if ([EXNetDataManager shareInstance].netExamDataArray) {
            [[EXNetDataManager shareInstance].netExamDataArray enumerateObjectsUsingBlock:^(ExamData *obj, NSUInteger idx, BOOL *stop) {
                if (obj && [obj.examId integerValue]==[[tExamPaperInfoDic objectForKey:@"id"] integerValue]) {
                    obj.examPassing=[NSNumber numberWithFloat:[[tExamPaperInfoDic objectForKey:@"passing"] floatValue]];
                    obj.examPassingAgainFlg=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"passingAgainFlg"] intValue]];
                    obj.examTimes=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"times"] intValue]];
                    obj.examSubmitDisplayAnswerFlg=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"submitDisplayResult"] intValue]];
                    obj.examPublishAnswerFlg=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"publishAnswerFlg"] intValue]];
                    obj.examPublishResultTm=[NSNumber numberWithLongLong:[[tExamPaperInfoDic objectForKey:@"publishResultTm"] longLongValue]];
                    obj.examDisableMinute=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"disableMinute"] intValue]];
                    obj.examDisableSubmit=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"disableSubmit"] intValue]];
                    obj.updateTm=[NSNumber numberWithLongLong:[[tExamPaperInfoDic objectForKey:@"updateTm"] longLongValue]];
                }
            }];
        }
        
        NSString *tExamID=[NSString stringWithFormat:@"%@",[tExamPaperInfoDic objectForKey:@"id"]];
        NSArray *papers=[tExamPaperInfoDic objectForKey:@"paperList"];
        if (papers) {
            [papers enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                if (obj) {
                    PaperData *paperData = [[[PaperData alloc]init] autorelease];
//                    paperData.paperId = [NSNumber numberWithInt:[[result objectForKey:@"id"] intValue]];
//                    paperData.title = [result objectForKey:@"title"];
//                    paperData.desc = [result objectForKey:@"description"];
//                    paperData.creator = [result objectForKey:@"creator"];
//                    paperData.totalTime = [NSNumber numberWithInt:[[result objectForKey:@"totalTime"] intValue]];
//                    paperData.totalScore = [NSNumber numberWithInt:[[result objectForKey:@"totalScore"] intValue]];
//                    paperData.topicCount = [NSNumber numberWithInt:[[result objectForKey:@"topicCount"] intValue]];
//                    paperData.passingScore = [NSNumber numberWithInt:[[result objectForKey:@"passingScore"] intValue]];
//                    paperData.eliteScore = [NSNumber numberWithInt:[[result objectForKey:@"eliteScore"] intValue]];
                }
            }];
        }
    }
    
    
    
    return result;
}

+ (NSArray *)convertJSONToTopicData:(NSData *)data{
    NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSDictionary *array=[result objectForKey:@"topicList"];
    NSMutableArray *topics = nil;
    if (array && [array count] > 0) {
        topics = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
        for (NSDictionary *topicDic in array) {
//            TopicData *tData = [[TopicData alloc]init];
//            
//            tData.topicId = [topicDic objectForKey:@"id"];
//            tData.question = [topicDic objectForKey:@"question"];
//            tData.type = [topicDic objectForKey:@"type"];
//            
//            NSArray *answers = [topicDic objectForKey:@"answerList"];
//            for (NSDictionary *answer in answers) {
//                //答案选项
//                if (tData.answers == nil) {
//                    tData.answers = [answer objectForKey:@"content"];
//                } else {
//                    tData.answers = [tData.answers stringByAppendingFormat:@"|%@",[answer objectForKey:@"content"]];
//                }
//                
//                //正确答案
//                if ([[answer objectForKey:@"isCorrect"]boolValue]) {
//                    if (tData.selected == nil) {
//                        if ([tData.type integerValue]==3) {
//                            tData.selected = [NSString stringWithFormat:@"%d",0-[answers indexOfObject:answer]];
//                        }else{
//                            tData.selected = [NSString stringWithFormat:@"%u",[answers indexOfObject:answer]];
//                        }
//                    } else {
//                        tData.selected = [tData.selected stringByAppendingFormat:@"|%u",[answers indexOfObject:answer]];
//                    }
//                }
//            }
//            tData.value = [[topicDic objectForKey:@"value"]stringValue];
//            if ([tData.type integerValue]==1 || [tData.type integerValue]==2 || [tData.type integerValue]==3) {
//                tData.analysis = [NSString stringWithFormat:@"%d",-100];
//            }else{
//                tData.analysis = [topicDic objectForKey:@"analysis"];
//            }
//            tData.image = [topicDic objectForKey:@"image"];
//            [topics addObject:tData];
//            [tData release];
        }
    }
    return topics;
}

+ (NSArray *)convertJSONToExamData:(NSData *)data
{
    NSMutableArray *result=[[NSMutableArray alloc] initWithCapacity:0];;
    
    if (data) {
        NSDictionary *tExamDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray *tExamDicArray=[tExamDic objectForKey:@"data"];
        if (tExamDicArray) {
            [tExamDicArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                if (obj) {
                    ExamData *examItem=[[ExamData alloc] init];
                    examItem.examId=[NSNumber numberWithInteger:[[obj objectForKey:@"id"] integerValue]];
                    examItem.examCategory=[obj objectForKey:@"category"];
                    examItem.examCreator=[obj objectForKey:@"creater"];
                    examItem.examBeginTm=[NSNumber numberWithLongLong:[[obj objectForKey:@"beginTm"] longLongValue]];
                    examItem.examEndTm=[NSNumber numberWithLongLong:[[obj objectForKey:@"endTm"] longLongValue]];
                    examItem.examTitle=[obj objectForKey:@"name"];
                    examItem.examNotice=[obj objectForKey:@"notice"];
                    examItem.examStatus=[NSNumber numberWithInteger:[[obj objectForKey:@"status"] integerValue]];
                    examItem.examTotalTm=[NSNumber numberWithInteger:[[obj objectForKey:@"totalTm"] integerValue]];
                    
                    [result addObject:examItem];
                    [examItem release];
                }
            }];
        }
    }
    
    
    return result;
}

+ (NSString *)md5:(NSString *)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

@end
