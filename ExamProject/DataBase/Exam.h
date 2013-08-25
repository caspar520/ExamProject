//
//  Exam.h
//  ExamProject
//
//  Created by magic on 13-8-24.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DbBaseProtocol.h"

@class Paper;

@interface Exam : NSManagedObject <ExamDataProtocol>

@property (nonatomic, retain) NSSet * papers;

@end


@interface Exam (CoreDataGeneratedAccessors)

- (void)addPapersObject:(Paper *)object;
- (void)removePapersObject:(Paper *)object;
- (void)addPapers:(NSSet *)objects;
- (void)removePapers:(NSSet *)objects;

@end