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
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    [_paperData release];
    [_titleLabel release];
    [_describeLabel release];
    [_authorLabel release];
    [super dealloc];
}

- (void)setPaperData:(id)paperData{
    if (_paperData!=paperData) {
        [_paperData release];
        _paperData=[paperData retain];
    }
    
    [self refreshUI];
}

- (void)refreshUI{
    if (_titleLabel==nil) {
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame)-80, 20)];
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.textAlignment=UITextAlignmentLeft;
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.font=[UIFont systemFontOfSize:18];
        
        [self addSubview:_titleLabel];
    }
    _titleLabel.text=[_paperData objectForKey:@"name"];
    
    if (_describeLabel==nil) {
        _describeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMaxY(_titleLabel.frame)+5, CGRectGetWidth(self.frame)-80, 10)];
        _describeLabel.textColor=[UIColor blackColor];
        _describeLabel.textAlignment=UITextAlignmentLeft;
        _describeLabel.backgroundColor=[UIColor clearColor];
        _describeLabel.font=[UIFont systemFontOfSize:10];
        
        [self addSubview:_describeLabel];
    }
    _describeLabel.text=[_paperData objectForKey:@"info"];
    
    if (_authorLabel==nil) {
        _authorLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMaxY(_describeLabel.frame)+2, CGRectGetWidth(self.frame)-80, 10)];
        _authorLabel.textColor=[UIColor blackColor];
        _authorLabel.textAlignment=UITextAlignmentLeft;
        _authorLabel.backgroundColor=[UIColor clearColor];
        _authorLabel.font=[UIFont systemFontOfSize:10];
        
        [self addSubview:_authorLabel];
    }
    _authorLabel.text=[_paperData objectForKey:@"author"];
    
    if (_downloadBtn==nil) {
        _downloadBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _downloadBtn.frame=CGRectMake(CGRectGetMaxX(_titleLabel.frame)+5, CGRectGetMinY(self.frame), 60, 40);
        [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadBtn addTarget:self action:@selector(downloadItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_downloadBtn];
    }
}

- (void)downloadItemClicked:(id)sender{
    if (delegate && [delegate respondsToSelector:@selector(downloadNetPaper:)]) {
        [delegate downloadNetPaper:_paperData];
    }
}

@end