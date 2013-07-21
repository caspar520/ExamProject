//
//  EXDownloadManager.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  ASIHTTPRequest;

@interface EXDownloadManager : NSObject{
    ASIHTTPRequest      *request;
}

+ (EXDownloadManager *)shareInstance;
+ (void)destroyInstance;

- (void)cancelRequest;

//download method
- (void)downloadPaper:(id)paper;
- (void)downloadPaperList;

@end
