//
//  EXListView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXListView.h"

@implementation EXListView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tableView= [[UITableView alloc] initWithFrame:self.frame];
		[_tableView setDelegate:delegate];
 		[_tableView setDataSource:delegate];
 		[self addSubview: _tableView];
    }
    return self;
}

- (void)dealloc{
    
    [super dealloc];
}

@end
