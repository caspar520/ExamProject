//
//  PublicDefine.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#define SCREEN_WIDTH    320
#define SCREEN_HEIGHT	([UIScreen mainScreen].bounds.size.height)      //屏幕高度

#define KEYCHAIN_IDENTIFIER     @"exam_proj_keychain_identifier"
#define KEYCHAIN_USRNAME        @"kcUserName"
#define KEYCHAIN_PWD            @"kcPassword"

#define NOT_FIRST_RUN           @"notfirstRun"      //首次启动(首次肯定为NO，以后设置为YES)
#define AUTO_LOGIN              @"isAutoLogin"      //自动登录开关

//brown...............................
#define NET_PAPERDATA_URL       @"http://xiaotu.net/examjson/examlist.json"



//通知
#define NOTIFICATION_PAPERS_DOWNLOAD_FINISH     @"papersDownloadedFinish"
#define NOTIFICATION_SOME_PAPER_DOWNLOAD_FINISH @"specialPaperDownloadedFinish"
#define NOTIFICATION_DOWNLOAD_FAILURE           @"downloadFailure"
