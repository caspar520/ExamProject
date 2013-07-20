//
//  EXDownloadManager.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXDownloadManager : NSObject

+ (EXDownloadManager *)shareInstance;
+ (void)destroyInstance;

//download method
- (void)downloadPaper:(id)paper;

@end
