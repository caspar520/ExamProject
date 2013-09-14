//
//  EXExamineRecordViewController.h
//  ExamProject
//
//  Created by Brown on 13-9-7.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EXExaminationListView,PaperData,ExamData;

@interface EXExamineRecordViewController : UIViewController{
    EXExaminationListView              *_examineListView;
}

@property (nonatomic,retain)PaperData          *paperData;
@property (nonatomic,retain)ExamData            *examData;
@property (nonatomic,assign)int                 currentIndex;           //当前应该显示的试题的索引值

@end
