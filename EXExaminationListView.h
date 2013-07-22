//
//  EXExaminationListView.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kDisplayTopicType_Default=0,
    kDisplayTopicType_Wrong,
    kDisplayTopicType_Collected,
}DisplayTopicType;

@interface EXExaminationListView : UIView{
    UIScrollView            *_scrollView;
}

@property (nonatomic,assign)id                      delegate;
@property (nonatomic,retain)NSArray                 *dataArray;
@property (nonatomic,assign)DisplayTopicType        dipalyTopicType;

- (void)preTopic;
- (void)nextTopic;
- (void)collectionTopic;

@end
