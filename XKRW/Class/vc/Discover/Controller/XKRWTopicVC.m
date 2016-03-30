//
//  XKRWTopicVC.m
//  XKRW
//
//  Created by Shoushou on 15/12/4.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWTopicVC.h"
#import "define.h"
#import "XKRWUtil.h"
#import "MJRefresh.h"
#import "XKRW-Swift.h"

#import "XKRWManagementService5_0.h"

#import "XKRWFitnessShareCell.h"
#import "XKRWUserArticleVC.h"
#import "SCBackToUpView.h"

@interface XKRWTopicVC ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate>
{
    SCBackToUpView    *_backToUpView;
}
@property (strong, nonatomic) XKRWUITableViewBase *tableView;
@property (strong, nonatomic) NSMutableArray *dataMutArray;
@property (strong, nonatomic) NSNumber *pagetime;

@property (strong, nonatomic) MJRefreshHeaderView *refreshHeaderView;
@property (strong, nonatomic) MJRefreshFooterView *refreshFooterView;

@end

@implementation XKRWTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNaviBarBackButton];
    self.title = _topicStr;
    self.dataMutArray = [NSMutableArray array];
    
    [MobClick event:@"in_topic"];
    
    _tableView = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"XKRWFitnessShareCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_tableView];
    
    self.refreshHeaderView = [MJRefreshHeaderView header];
    _refreshHeaderView.scrollView = _tableView;
    _refreshHeaderView.delegate = self;
    
    self.refreshFooterView = [MJRefreshFooterView footer];
    _refreshFooterView.scrollView = _tableView;
    _refreshFooterView.delegate = self;
    
    _backToUpView = [[SCBackToUpView alloc]initShowInSomeViewSize:self.view.bounds.size minitor:_tableView withImage:@"group_backtotop"];
    _backToUpView.backOffsettY = XKAppHeight*2;
    [self.view addSubview:_backToUpView];
    
    [self loadData];
    
}

- (void)loadData {
    
    if ([XKRWUtil isNetWorkAvailable]) {
        [self downloadWithTaskID:@"topic_refresh" outputTask:^id{
            return [[XKRWManagementService5_0 sharedService] getBlogMoreArticlesWithTopic:self.topicId AndPagetime:@(0)];
        }];
        [self hiddenRequestArticleNetworkFailedWarningShow];
    } else {
        [self showRequestArticleNetworkFailedWarningShow];
    }
}

- (void)reLoadDataFromNetwork:(UIButton *)sender {
    [self loadData];
}

#pragma - mark NetWorking

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    if ([taskID isEqualToString:@"topic_refresh"]) {
        [_dataMutArray removeAllObjects];
        _dataMutArray = result;
        [_tableView reloadData];
        [_refreshHeaderView endRefreshing];
        
    } else if ([taskID isEqualToString:@"topic_loadMore"]) {
        
        if (((NSArray *)result).count%10 || ((NSArray *)result).count == 0) {
            _refreshFooterView.hidden = YES;
        }
        [_dataMutArray addObjectsFromArray:result];
        [_tableView reloadData];
        [_refreshFooterView endRefreshing];
    }
    
}

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [super handleDownloadProblem:problem withTaskID:taskID];
    
    if ([taskID isEqualToString:@"topic_refresh"]) {
        [self showRequestArticleNetworkFailedWarningShow];
    }
    if (_refreshHeaderView.refreshing) {
        [_refreshHeaderView endRefreshing];
    }
    if (_refreshFooterView.refreshing) {
        [_refreshFooterView endRefreshing];
    }
}

#pragma - mark Cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataMutArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKRWFitnessShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    typeof(self) __weak weakSelf = self;
    [cell setContentWithEntity:_dataMutArray[indexPath.section] style:topicArticle andSuperVC:weakSelf];
    cell.bgButton.tag = indexPath.section;
    [cell.bgButton addTarget:self action:@selector(pushToUserArticleVC:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 9*XKAppWidth/16.0;
}

- (void)pushToUserArticleVC:(UIButton *)sender {
    XKRWUserArticleVC *articleVC = [[XKRWUserArticleVC alloc] init];
    if (_dataMutArray.count > sender.tag) {
        
        XKRWArticleListEntity *entity = _dataMutArray[sender.tag];
        articleVC.aid = entity.blogId;
        [self.navigationController pushViewController:articleVC animated:YES];
    }
   
}

#pragma - mark Header

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    headerView.backgroundColor = XKClearColor;
    
    return headerView;
}

#pragma mark - UIScroller delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_tableView]) {
        
        [_backToUpView scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_tableView]) {
        
        [_backToUpView scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_tableView]) {
        
        [_backToUpView scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:_tableView]) {
        
        [_backToUpView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma - mark Refresh

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
   
    if (![XKRWUtil isNetWorkAvailable]) {
        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
            [XKRWCui showInformationHudWithText:@"没有网络无法刷新哦~"];
        } else if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
            [XKRWCui showInformationHudWithText:@"没有网络无法加载哦~"];
        }
        [refreshView endRefreshing];
        return;
    }
    
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        if (!refreshView.refreshing) {
            [self loadData];
        }
        
    } else {
        
        if (!refreshView.refreshing) {
            
            XKRWArticleListEntity *entity = [_dataMutArray lastObject];
            if (entity) {
                _pagetime = [NSNumber numberWithLong:entity.createTime];
            }
            if (_pagetime != nil) {
                
                [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
                
                [self downloadWithTaskID:@"topic_loadMore" outputTask:^id{
                    return [[XKRWManagementService5_0 sharedService] getBlogMoreArticlesWithTopic:self.topicId AndPagetime:_pagetime];
                }];
                
            }
        }
    }
}

- (void)endRefresh {
    
}

- (void)dealloc {
    
    [_refreshHeaderView free];
    _refreshHeaderView = nil;
    
    [_refreshFooterView free];
    _refreshFooterView = nil;
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
