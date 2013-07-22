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
}

@property (nonatomic,retain)PaperData          *paperData;
@property (nonatomic,assign)DisplayTopicType    displayTopicType;

@end
