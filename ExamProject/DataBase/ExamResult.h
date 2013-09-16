//
//  ExamResult.h
//  ExamProject
//
//  Created by magic on 13-9-15.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DbBaseProtocol.h"

@class Exam;

@interface ExamResult : NSManagedObject <ExamResultDataProtocol>

@property (nonatomic, retain) Exam *aExam;

@end

@interface ExamResult (CoreDataGeneratedAccessors)

- (void)addAExam:(Exam *)object;
- (void)removeAExam:(Exam *)object;

@end