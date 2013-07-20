//
//  EXNetDataManager.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXNetDataManager : NSObject

+ (EXNetDataManager *)shareInstance;
+ (void)destroyInstance;

@property (nonatomic,retain)NSMutableArray  *netPaperDataArray;

@end
