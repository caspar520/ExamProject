//
//  EXExamineViewController.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EXExaminationListView;

@interface EXExamineViewController : UIViewController{
    EXExaminationListView       *_examineListView;
}

@property (nonatomic,retain)id          paperData;

@end
