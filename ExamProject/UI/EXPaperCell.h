//
//  EXPaperCell.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaperData;

@interface EXPaperCell : UITableViewCell{
    UILabel         *examTitleLabel;
    UILabel         *examTypeLabel;
    UILabel         *examDurationLabel;
    UILabel         *examMSGLabel;                   //考试须知
    UILabel         *authorLabel;
}

@property (nonatomic,retain)PaperData      *paperData;

@end
