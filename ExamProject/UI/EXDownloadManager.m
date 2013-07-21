//
//  EXDownloadManager.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXDownloadManager.h"
#import "EXNetDataManager.h"
#import "ASIHTTPRequest.h"

static EXDownloadManager *instance=nil;

@interface EXDownloadManager ()<ASIHTTPRequestDelegate>

@end

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
        [ASIHTTPRequest setMaxBandwidthPerSecond:0];
    }
    return self;
}

- (void)dealloc{
    
    [super dealloc];
}

- (void)cancelRequest{
    if (request) {
        [request clearDelegatesAndCancel];
        [request release];
        request=nil;
    }
}

- (void)downloadPaper:(id)paper{
    //判断有没有，如果没有则直接去下载
    NSURL *url = nil;
    if ([paper isKindOfClass:[NSDictionary class]]) {
        [NSURL URLWithString:[paper objectForKey:@"url"]];
        request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setTimeOutSeconds:10];
        request.numberOfTimesToRetryOnTimeout = 2;
        request.delegate = self;
        [request setDownloadDestinationPath:@""];
        
//        [request startAsynchronous];
    }
}

- (void)downloadPaperList{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"examlist" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [EXNetDataManager shareInstance].netPaperDataArray=[result objectForKey:@"arrayData"];
    
    //后续改成从网络拉取
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAPERS_DOWNLOAD_FINISH object:nil];
}


#pragma mark 下载回调
- (void)requestFinished:(ASIHTTPRequest *)request{
    //下载成功后的回调
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    //下载失败
    
}

@end
