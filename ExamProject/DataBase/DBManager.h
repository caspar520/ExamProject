//
//  DBManager.h
//  ExamProject
//
//  Created by magic on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paper.h"
#import "PaperData.h"

@interface DBManager : NSObject

+ (Paper *)addPaper:(PaperData *)paperData;
+ (NSArray *)fetchAllPapersFromDB;

@end
