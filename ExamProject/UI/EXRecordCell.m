//
//  EXRecordCell.m
//  ExamProject
//
//  Created by Brown on 13-9-15.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXRecordCell.h"
#import "ExamData.h"

@implementation EXRecordCell
@synthesize examData=_examData;
@synthesize index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    [examTitleLabel release];
    [examMarkLabel release];
    [examUsingTmLabel release];
    [examDurationLabel release];

    [_examData release];
    [super dealloc];
}

- (void)setExamData:(ExamData *)examData{
    if (_examData!=examData) {
        [_examData release];
        _examData=[examData retain];
    }
    [self refreshUI];
}

- (void)refreshUI{
    if (examTitleLabel==nil) {
        examTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMinY(self.frame)+5, CGRectGetWidth(self.frame)-80, 20)];
        examTitleLabel.textColor=[UIColor blackColor];
        examTitleLabel.textAlignment=UITextAlignmentLeft;
        examTitleLabel.backgroundColor=[UIColor clearColor];
        examTitleLabel.font=[UIFont systemFontOfSize:18];
        
        [self addSubview:examTitleLabel];
    }
    examTitleLabel.text=[NSString stringWithFormat:@"%d.%@",index,_examData.examTitle];
    
    if (examDurationLabel==nil) {
        examDurationLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(examTitleLabel.frame), CGRectGetMaxY(examTitleLabel.frame)+5, 150, 20)];
        examDurationLabel.textColor=[UIColor blackColor];
        examDurationLabel.textAlignment=UITextAlignmentLeft;
        examDurationLabel.backgroundColor=[UIColor clearColor];
        examDurationLabel.font=[UIFont systemFontOfSize:14];
        
        [self addSubview:examDurationLabel];
    }
    examDurationLabel.text=[NSString stringWithFormat:@"时间：%@",_examData.createTm];
    
    if (examMarkLabel==nil) {
        examMarkLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(examDurationLabel.frame)+5, CGRectGetMaxY(examTitleLabel.frame)+5, 65, 20)];
        examMarkLabel.textColor=[UIColor blackColor];
        examMarkLabel.textAlignment=UITextAlignmentLeft;
        examMarkLabel.numberOfLines=0;
        examMarkLabel.backgroundColor=[UIColor clearColor];
        examMarkLabel.font=[UIFont systemFontOfSize:14];
        
        [self addSubview:examMarkLabel];
    }
    examMarkLabel.text=[NSString stringWithFormat:@"得分：30"];
    
    if (examUsingTmLabel==nil) {
        examUsingTmLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(examMarkLabel.frame)+15, CGRectGetMaxY(examTitleLabel.frame)+5, 65, 20)];
        examUsingTmLabel.textColor=[UIColor blackColor];
        examUsingTmLabel.textAlignment=UITextAlignmentLeft;
        examUsingTmLabel.numberOfLines=0;
        examUsingTmLabel.backgroundColor=[UIColor clearColor];
        examUsingTmLabel.font=[UIFont systemFontOfSize:14];
        
        [self addSubview:examUsingTmLabel];
    }
    examUsingTmLabel.text=[NSString stringWithFormat:@"用时：%@",_examData.examUsingTm];
}

@end
