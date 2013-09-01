//
//  EXExamineViewController.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXExaminationListView.h"

@class EXExaminationListView,PaperData;

@interface EXExamineViewController : UIViewController{
    EXExaminationListView       *_examineListView;
    
    UIView                      *_examMSGBarView;
    UILabel                     *_paperCountLabel;
    UILabel                     *_examLeftTime;
    UILabel                     *_examDuration;
}

@property (nonatomic,retain)PaperData          *paperData;
@property (nonatomic,assign)DisplayTopicType    displayTopicType;
@property (nonatomic,assign)BOOL                isNotOnAnswering;

@end
