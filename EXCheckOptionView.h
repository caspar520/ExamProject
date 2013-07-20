//
//  EXCheckOptionView.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTCheckBoxDelegate <NSObject>

- (void)checkeStateChange:(BOOL)isChecked;

@end

@interface EXCheckOptionView : UIView{
    id              _delegate;
    BOOL            _checked;
    BOOL            _enabled;
    
    UIImageView     *_checkBoxImageView;
}

@property (nonatomic, assign) BOOL            checked;
@property (nonatomic,assign)id     delegate;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic,assign)int     index;

- (id) initWithFrame:(CGRect)aFrame checked:(BOOL)aChecked;

@end
