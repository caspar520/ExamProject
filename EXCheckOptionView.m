//
//  EXCheckOptionView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXCheckOptionView.h"

static const CGFloat kHeight = 36.0f;

@interface EXCheckOptionView(Private)
- (UIImage *) checkBoxImage:(BOOL)isChecked;
- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img;
- (void) switchCheckBoxImage;
@end

@implementation EXCheckOptionView

@synthesize enabled=_enabled;
@synthesize checked=_checked;
@synthesize delegate=_delegate;
@synthesize index=_index;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)aFrame checked:(BOOL)aChecked{
    aFrame.size.height = kHeight;
    if (!(self = [super initWithFrame:aFrame])) {
        return self;
    }
    _checked = aChecked;
    self.enabled = YES;
    _index=-10;
    
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _boxFrameView=[[UIImageView alloc] initWithFrame:aFrame];
    _boxFrameView.contentMode=UIViewContentModeCenter;
    [self addSubview:_boxFrameView];
    
    UIImage *img = [self checkBoxImage:_checked];
    CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
    _checkBoxImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    _checkBoxImageView.backgroundColor=[UIColor clearColor];
    _checkBoxImageView.image = img;
    [self insertSubview:_checkBoxImageView aboveSubview:_boxFrameView];
    
    return self;
}

- (void)dealloc{
    if (_checkBoxImageView) {
        [_checkBoxImageView release];
    }
    [_boxFrameView release];
    [super dealloc];
}

- (void) setEnabled:(BOOL)enabled
{
    _enabled = enabled;
}

- (void)setIndex:(int)index{
    _index=index;
    UIImage *boxFrameImage=nil;
    if (index>0) {
        boxFrameImage=[UIImage imageNamed:@"answer_single_selected.png"];
    }else {
        boxFrameImage=[UIImage imageNamed:@"topic_index_bg.png"];
        if (_checkBoxImageView.image==nil) {
            UIImage *img = [self checkBoxImage:_checked];
            CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
            _checkBoxImageView.frame=imageViewFrame;
            _checkBoxImageView.image = img;
        }
    }
    _boxFrameView.backgroundColor=[UIColor colorWithPatternImage:boxFrameImage];
}

- (void)setChecked:(BOOL)checked{
    _checked=checked;
    UIImage *img = [self checkBoxImage:_checked];
    _checkBoxImageView.image = img;
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

#pragma mark -
#pragma mark Touch-related Methods

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_enabled) {
        return;
    }
    
    self.alpha = 0.8f;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_enabled) {
        return;
    }
    
    self.alpha = 1.0f;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_enabled) {
        return;
    }
    self.alpha = 1.0f;
    if ([self superview]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:[self superview]];
        CGRect validTouchArea = CGRectMake((self.frame.origin.x - 5),(self.frame.origin.y - 10),(self.frame.size.width + 5),(self.frame.size.height + 10));
        if (CGRectContainsPoint(validTouchArea, point)) {
            _checked = !_checked;
            [self updateCheckBoxImage];
            if (_delegate && [_delegate respondsToSelector:@selector(checkeStateChange:withObject:)]) {
                [_delegate checkeStateChange:_checked withObject:self];
            }
        }
    }
}


#pragma mark -
#pragma mark Private

- (UIImage *) checkBoxImage:(BOOL)isChecked
{
    NSString *imageName=nil;
    switch (_index) {
        case -1:
            if (isChecked) {
                imageName=@"answer_judge_false_selected.png";
            }else{
                imageName=@"answer_judge_false_normal.png";
            }
            break;
        case 0:
            if (isChecked) {
                imageName=@"answer_judge_true_selected.png";
            }else{
                imageName=@"answer_judge_true_normal.png";
            }
            break;
        case 1:
            if (isChecked) {
                imageName=@"answer_a.png";
            }
            
            break;
        case 2:
            if (isChecked) {
                imageName=@"answer_b.png";
            }
            
            break;
        case 3:
            if (isChecked) {
                imageName=@"answer_c.png";
            }
            
            break;
        case 4:
            if (isChecked) {
                imageName=@"answer_d.png";
            }
            
            break;
        case 5:
            if (isChecked) {
                imageName=@"answer_e.png";
            }
            
            break;
        case 6:
            if (isChecked) {
                imageName=@"answer_f.png";
            }
            break;
        case 7:
            if (isChecked) {
                imageName=@"answer_g.png";
            }
            break;
        default:
            break;
    }
    UIImage *targetImage=[UIImage imageNamed:imageName];
    return targetImage;
}

- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img
{
    CGFloat y = floorf((kHeight - img.size.height) / 2.0f);
    return CGRectMake(5.0f, y, img.size.width, img.size.height);
}

- (void) updateCheckBoxImage
{
    UIImage *img=[self checkBoxImage:_checked];
    CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
    _checkBoxImageView.frame=imageViewFrame;
    _checkBoxImageView.image = img;
}

@end
