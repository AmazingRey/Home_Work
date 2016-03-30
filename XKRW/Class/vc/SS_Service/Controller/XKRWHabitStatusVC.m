//
//  XKRWHabitStatusVC.m
//  XKRW
//
//  Created by y on 15-1-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWHabitStatusVC.h"
#import "XKRWHabitStateCellTableViewCell.h"

#import "XKRWHabitModel.h"
#import "XKRWDescribeModel.h"


@interface XKRWHabitStatusVC ()

@end

@implementation XKRWHabitStatusVC
@synthesize habitModel,dataArray,headDataArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addNaviBarBackButton];
    [self setTitle:@"习惯情况"];
    
    self.mianTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64 ) style:UITableViewStylePlain];
    self.mianTableView.delegate = self ;
    self.mianTableView.dataSource = self ;
    _mianTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mianTableView.backgroundColor = XK_BACKGROUND_COLOR;

    if (self.headDataArray.count != 0) {
        self.mianTableView.tableHeaderView  = [self getHabitHeadViewByData:headDataArray];
        self.headView.backgroundColor = [UIColor grapeColor];
    }
    [self.view addSubview:self.mianTableView];
}

- (UIView *)getHabitHeadViewByData:(NSMutableArray *)array
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 199)];
    
    CGFloat width = (XKAppWidth - 30.f - 20.f) / 3;
    
    CGFloat _xPoint = 15.f;
    CGFloat _yPoint = 15.f;
    
    NSInteger num = 0;
    
    for (NSString *string in array) {
        
        if (num && (num % 3 == 0)) {
            _yPoint += 40 + 10.f;
            _xPoint = 15.f;
        }
        num ++;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_xPoint, _yPoint, width, 40)];
        label.font = XKDefaultFontWithSize(16.f);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.backgroundColor = XK_STATUS_COLOR_LESS;
        label.text = string;
        
        label.layer.cornerRadius = 2.5;
        label.layer.masksToBounds = YES;
        
        _xPoint += width + 10.f;
        
        [view addSubview:label];
    }
    view.height = _yPoint + 40.f + 15.f;
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    line.backgroundColor = XK_ASSIST_LINE_COLOR;
    
    [view addSubview:line];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 0.5, XKAppWidth, 0.5)];
    line.backgroundColor = XK_ASSIST_LINE_COLOR;
    
    [view addSubview:line];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *inderyCell = [NSString stringWithFormat:@"123text%ld%ld",(long)indexPath.section,(long)indexPath.row];
    XKRWHabitStateCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inderyCell];
    
    if (cell == nil) {
        cell = [[XKRWHabitStateCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inderyCell];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        [cell loadDescribeData:[dataArray objectAtIndex:indexPath.section]];
        
    }
    return cell.cell_h;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *inderyCell = [NSString stringWithFormat:@"123text%ld%ld",(long)indexPath.section,(long)indexPath.row];
    XKRWHabitStateCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inderyCell];
    
    if (cell == nil) {
        cell = [[XKRWHabitStateCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inderyCell];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        [cell loadDescribeData:[dataArray objectAtIndex:indexPath.section]];

    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
