//
//  EXNetPaperCell.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXNetPaperCell.h"

@implementation EXNetPaperCell

@synthesize paperData=_paperData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPaperData:(id)paperData{
    if (_paperData!=paperData) {
        [_paperData release];
        _paperData=[paperData retain];
    }
    [self refreshUI];
}

- (void)refreshUI{
    
}

@end
