//
//  PaperData.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbBaseProtocol.h"

@class Paper;

@interface PaperData : NSObject <PaperDataProtocol>

@property (nonatomic, retain) NSArray *topics;

- (id)initWithPaper:(Paper *)aPaper;

@end
