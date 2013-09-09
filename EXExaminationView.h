//
//  EXExaminationView.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicData.h"
#import "EXCheckOptionView.h"

@protocol EXQuestionDelegate

@optional
- (void)selectOption:(NSInteger)pIndex withObject:(id)pObj;
- (void)cancelOption:(NSInteger)pIndex withObject:(id)pObj;

@end


@interface EXExaminationView : UIView{
    NSString        *result;
    
    UILabel         *orderLabel;
    UIImageView     *questionBackground;
    UILabel         *questionLabel;
    UILabel         *optionTipLabel;
    UITextView      *answerTextView;
    UILabel         *answerAnalysisTipLabel;
    UIImageView     *answerAnalysisBackground;
    UILabel         *answerAnalysisLabel;
    
    UIScrollView    *answerContainerView;
    UIImageView     *shortAnswerBGView;
    UILabel         *shortAnswerLabel;
    
    BOOL            _isDisplayAnswer;
}


@property (nonatomic,assign)id<EXQuestionDelegate>	delegate;
@property (nonatomic,retain)TopicData         		*metaData;
@property (nonatomic,assign)NSInteger				index;
@property (nonatomic,assign)BOOL                    isDisplayAnswer;

- (void)refreshUI;
- (void)updateSelectedResult;

@end
