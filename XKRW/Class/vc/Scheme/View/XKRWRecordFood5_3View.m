//
//  XKRWRecordFood5_3View.m
//  XKRW
//
//  Created by ss on 16/4/13.
//  Copyright © 2016年 XiKang. All rights reserved.
//
#define labStatus_RecordWeight @"_labRecordWeight"
#define labStatus_PushMenu @"_labPushMenu"

#import "XKRWRecordFood5_3View.h"
#import "XKRWRecordSport5_3Cell.h"
#import "XKRWPushMenu5_3Cell.h"

@interface XKRWRecordFood5_3View () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
@end

@implementation XKRWRecordFood5_3View
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordFood5_3View");
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.tableView.frame];
    _scrollView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    
    _tableRecord = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    _tableRecord.tag = 5031;
    [_tableRecord registerNib:[UINib nibWithNibName:@"XKRWRecordSport5_3Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"recordSportCell"];
    
    _tableMenu = [[UITableView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    _tableMenu.tag = 5032;
    [_tableMenu registerNib:[UINib nibWithNibName:@"XKRWPushMenu5_3Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"pushMenuCell"];
    
    [_scrollView addSubview:_tableRecord];
    [_scrollView addSubview:_tableMenu];
    [self addSubview:_scrollView];
    
    _tableRecord.delegate = self;
    _tableRecord.dataSource = self;
    _tableMenu.delegate = self;
    _tableMenu.dataSource = self;
}

-(void)setDicRecord:(NSArray *)dicRecord{
    if (_dicRecord != dicRecord) {
        _dicRecord = dicRecord;
        [_tableRecord reloadData];
    }
}

-(void)setDicMenu:(NSArray *)dicMenu{
    if (_dicMenu != dicMenu) {
        _dicMenu = dicMenu;
        [_tableMenu reloadData];
    }
}

-(void)scrollToPage:(NSInteger)page{
    if (_pageIndex == page) {
        return;
    }
    CGFloat offset = (page-1) *self.tableView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    _pageIndex = page;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (IBAction)actCancle:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)actRecordWeight:(id)sender {
    _labRecordWeight.textColor = XKMainToneColor_29ccb1;
    _labRecordWeightNum.textColor = XKMainToneColor_29ccb1;
    _labPushMenu.textColor = colorSecondary_666666;
    _labPushMenuNum.textColor = colorSecondary_666666;
    [self scrollToPage:1];
}

- (IBAction)actPushMenu:(id)sender {
    _labPushMenu.textColor = XKMainToneColor_29ccb1;
    _labPushMenuNum.textColor = XKMainToneColor_29ccb1;
    _labRecordWeight.textColor = colorSecondary_666666;
    _labRecordWeightNum.textColor = colorSecondary_666666;
    [self scrollToPage:2];
}

- (IBAction)actMore:(id)sender {
}

- (IBAction)actAnalyze:(id)sender {
}

- (IBAction)actRecordSport:(id)sender {
}

- (IBAction)actRecordFood:(id)sender {
}

#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 5031) {
        return 10;
    }else if (tableView.tag == 5032){
        return 10;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 5031) {
        XKRWRecordSport5_3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordSportCell"];
        cell.labMain.text = @"haha";
        return cell;
    }else if (tableView.tag == 5032){
        XKRWPushMenu5_3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushMenuCell"];
        cell.labMain.text = @"hehe";
        return cell;
    }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end