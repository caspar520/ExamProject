//
//  EXExaminationView.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EXQuestionDelegate

@optional
- (void)selectOption:(NSInteger)pIndex withObject:(id)pObj;
- (void)cancelOption:(NSInteger)pIndex withObject:(id)pObj;

@end

@class TopicData;

@interface EXExaminationView : UIView


@property (nonatomic,assign)id<EXQuestionDelegate>	delegate;
@property (nonatomic,retain)TopicData         		*metaData;
@property (nonatomic,assign)NSInteger				index;

@end
