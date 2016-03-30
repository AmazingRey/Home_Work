//
//  XKRWHowToExchangeVC.m
//  XKRW
//
//  Created by XiKang on 15-1-20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWHowToExchangeVC.h"
#import "XKRWInfoCell.h"
#import "XKRWServerPageService.h"

@interface XKRWHowToExchangeVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XKRWInfoCell *prototypeCell;

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation XKRWHowToExchangeVC

#pragma mark - System's functions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"如何获取兑换码";
    
    [self initSubviews];
    [self initData];
    
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

#pragma mark - initialize

- (void)initSubviews {
    
    [self addNaviBarBackButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = XK_BACKGROUND_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"XKRWInfoCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    
    [self.view addSubview:_tableView];
    
    _prototypeCell = [_tableView dequeueReusableCellWithIdentifier:@"infoCell"];
}

- (void)initData {
    
    _datasource = [NSMutableArray array];
    
//    [_datasource addObject:@{@"title": @"方法一：微信活动",
//                             @"content": @"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊"}];
//    [_datasource addObject:@{@"title": @"方法二：微信活动",
//                             @"content": @"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊"}];
//    [_datasource addObject:@{@"title": @"方法三：微信活动",
//                             @"content": @"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊"}];
    
    [XKRWCui showProgressHud:@"载入中"];
    [self downloadWithTaskID:@"getExchangeWays" outputTask:^id{
        return [[XKRWServerPageService sharedService] getExchangeWaysWithIdentifer:@"iSlimExchangeCode"];
    }];
}

#pragma mark - UITableView's delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKRWInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    
    [cell setTitle:_datasource[indexPath.section][@"title"]
           content:_datasource[indexPath.section][@"msg"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_prototypeCell setTitle:_datasource[indexPath.section][@"title"]
                     content:_datasource[indexPath.section][@"msg"]];
    
    CGFloat height = [_prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    
    NSLog(@"h===== %f", height);
    return height + 1;
}

#pragma mark - Networking

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication {
    return YES;
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"getExchangeWays"]) {
        
        [_datasource addObjectsFromArray:result];
        [_tableView reloadData];
    }
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"getExchangeWays"]) {
        
        [XKRWCui showInformationHudWithText:@"获取信息失败"];
    }
}
@end
