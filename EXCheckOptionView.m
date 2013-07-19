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
    
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [self checkBoxImage:_checked];
    CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
    _checkBoxImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    _checkBoxImageView.image = img;
    [self addSubview:_checkBoxImageView];
    
    return self;
}

- (void)dealloc{
    if (_checkBoxImageView) {
        [_checkBoxImageView release];
    }
    [super dealloc];
}

- (void) setEnabled:(BOOL)enabled
{
    _enabled = enabled;
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
            if ([_delegate respondsToSelector:@selector(checkeStateChange:)]) {
                [_delegate checkeStateChange:_checked];
            }
        }
    }
}


#pragma mark -
#pragma mark Private

- (UIImage *) checkBoxImage:(BOOL)isChecked
{
    NSString *suffix = !isChecked ? @"normal" : @"cancel";
    NSString *imageName = [NSString stringWithFormat:@"add_story_to_local_category_%@.png", suffix];
    return [UIImage imageNamed:imageName];
}

- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img
{
    CGFloat y = floorf((kHeight - img.size.height) / 2.0f);
    return CGRectMake(5.0f, y, img.size.width, img.size.height);
}

- (void) updateCheckBoxImage
{
    _checkBoxImageView.image = [self checkBoxImage:_checked];
}

@end
