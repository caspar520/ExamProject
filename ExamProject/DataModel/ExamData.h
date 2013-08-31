//
//  ExamData.h
//  ExamProject
//
//  Created by magic on 13-8-24.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbBaseProtocol.h"

@class Exam;

@interface ExamData : NSObject<ExamDataProtocol>

@property (nonatomic,retain) NSArray *papers;

- (id)initWithExam:(Exam *)aExam;

@end
