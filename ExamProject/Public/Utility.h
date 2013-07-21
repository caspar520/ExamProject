//
//  Utility.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PaperData;

@interface Utility : NSObject

+ (PaperData *)convertJSONToPaperData:(NSData *)data;
+ (NSArray *)convertJSONToTopicData:(NSData *)data;

@end
