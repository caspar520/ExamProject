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

@interface EXExaminationView : UIView


@property (nonatomic,assign)id<EXQuestionDelegate>	delegate;
@property (nonatomic,retain)id         				metaData;
@property (nonatomic,assign)NSInteger				index;

@end
