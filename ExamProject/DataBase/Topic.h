//
//  Topic.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DbBaseProtocol.h"

@class Paper;

@interface Topic : NSManagedObject <TopicDataProtocol>

@property (nonatomic,retain) Paper *paper;

@end


@interface Topic (CoreDataGeneratedAccessors)

- (void)addPaperObject:(Paper *)value;
- (void)removePaperObject:(Paper *)value;

@end