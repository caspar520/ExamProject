//
//  EXDownloadManager.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXDownloadManager.h"


static EXDownloadManager *instance=nil;

@implementation EXDownloadManager

+ (EXDownloadManager *)shareInstance{
    if (instance==nil) {
        instance=[[EXDownloadManager alloc] init];
    }
    return instance;
}

+ (void)destroyInstance{
    [instance release];
    instance=nil;
}

- (id)init{
    self=[super init];
    if (self) {
        //TODO:initializations
        
    }
    return self;
}

- (void)dealloc{
    
    [super dealloc];
}

- (void)downloadPaper:(id)paper{
    //判断有没有，如果没有则直接去下载
    
}


@end
