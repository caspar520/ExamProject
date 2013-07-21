//
//  WrongViewController.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "WrongViewController.h"
#import "PaperData.h"
#import "EXListView.h"
#import "EXPaperCell.h"
#import "TopicData.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "EXExamineViewController.h"


@interface WrongViewController ()

@end

@implementation WrongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_paperListView release];
    [_wrongPaperList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"错题解析";
    self.view.backgroundColor=[UIColor blueColor];
    UIBarButtonItem *clearPaperButton = [[UIBarButtonItem alloc] initWithTitle:@"清空错题" style:UIBarButtonItemStyleBordered target:self action:@selector(clearWrongPapersClicked:)];
    self.navigationItem.rightBarButtonItem= clearPaperButton;
    
    if (_wrongPaperList==nil) {
        _wrongPaperList=[[NSMutableArray alloc] initWithCapacity:0];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    [_wrongPaperList removeAllObjects];
    [_wrongPaperList addObjectsFromArray:[DBManager fetchWrongPapers]];
    
    if (_paperListView==nil) {
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        CustomTabBarController *tabBarController=appDelegate.tabController;
        
        _paperListView=[[EXListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(tabBarController.tabBar.frame))];
        _paperListView.delegate=self;
        _paperListView.backgroundColor=[UIColor grayColor];
        [self.view addSubview:_paperListView];
    }
    
    [_paperListView refresh];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearWrongPapersClicked:(id)sender{
    if (_wrongPaperList) {
        [_wrongPaperList enumerateObjectsUsingBlock:^(PaperData *obj, NSUInteger idx, BOOL *stop) {
            if (obj) {
                obj.wrong=[NSNumber numberWithBool:NO];
                [DBManager addPaper:obj];
            }
        }];
    }
    [_wrongPaperList removeAllObjects];
    [_wrongPaperList addObjectsFromArray:[DBManager fetchWrongPapers]];
    [_paperListView refresh];
}

#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _wrongPaperList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"StoryListCell";
    EXPaperCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[EXPaperCell alloc] init] autorelease];
        if (indexPath.row<_wrongPaperList.count) {
            cell.paperData=[_wrongPaperList objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaperData *paperMetaData=[_wrongPaperList objectAtIndex:indexPath.row];
    if (paperMetaData) {
        
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        CustomTabBarController *tabBarController=appDelegate.tabController;
        [tabBarController hideTabBar];
        
        EXExamineViewController *examineController=[[[EXExamineViewController alloc] init] autorelease];
        examineController.displayTopicType=kDisplayTopicType_Wrong;
        [self.navigationController pushViewController:examineController animated:YES];
        examineController.paperData=paperMetaData;
    }
}

@end
