//
//  EXPaperCell.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXPaperCell.h"
#import "PaperData.h"

@implementation EXPaperCell

@synthesize paperData=_paperData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    [titleLabel release];
    [authorLabel release];
    [super dealloc];
}

- (void)setPaperData:(PaperData *)paperData{
    if (_paperData!=paperData) {
        [_paperData release];
        _paperData=[paperData retain];
    }
    [self refreshUI];
}

- (void)refreshUI{
    if (titleLabel==nil) {
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMinY(self.frame)+5, CGRectGetWidth(self.frame)-80, 20)];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.textAlignment=UITextAlignmentLeft;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:18];
        
        [self addSubview:titleLabel];
    }
    titleLabel.text=_paperData.title;
    
    if (authorLabel==nil) {
        authorLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMaxY(titleLabel.frame)+7, CGRectGetWidth(self.frame)-80, 12)];
        authorLabel.textColor=[UIColor blackColor];
        authorLabel.textAlignment=UITextAlignmentLeft;
        authorLabel.backgroundColor=[UIColor clearColor];
        authorLabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:authorLabel];
    }
    authorLabel.text=_paperData.creator;
}

@end
