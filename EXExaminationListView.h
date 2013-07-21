//
//  EXExaminationListView.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXExaminationListView : UIView{
    UIScrollView            *_scrollView;
}

@property (nonatomic,assign)id              delegate;
@property (nonatomic,retain)NSArray         *dataArray;

- (void)preTopic;
- (void)nextTopic;

@end
