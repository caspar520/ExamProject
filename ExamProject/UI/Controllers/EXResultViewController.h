//
//  EXResultViewController.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaperData;

@interface EXResultViewController : UIViewController{
    UILabel         *titleLabel;
    UILabel         *authorLabel;
    UILabel         *markLabel;
    UILabel         *resultLabel;
    
    UILabel         *resultTipLabel;
    
    //new version
    UIScrollView    *answerSheet;
}

@property (nonatomic,retain)PaperData       *paperData;

@end
