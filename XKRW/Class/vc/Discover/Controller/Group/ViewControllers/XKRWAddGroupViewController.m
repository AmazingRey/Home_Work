//
//  XKRWAddGroupViewController.m
//  XKRW
//
//  Created by Seth Chen on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWAddGroupViewController.h"
#import "XKRWAddGroupViewCell.h"
#import "XKRWGroupApi.h"
#import "XKRWGroupItem.h"
#import "UIImageView+WebCache.h"
#import "XKRWUserService.h"

#import "XKRWReportViewController.h"

#import "XKRWGroupViewController.h"
#import "XKRWNonePostTableViewCell.h"

NSString const * RefreshGroupLishNotice = @"refreshGroupLishNotice";

@interface XKRWAddGroupViewController ()
{
    XKRWAddGroupViewCell * __cacultaHeightCell;
    XKRWGroupApi * __groupApi;
    XKRWGroupApi * __groupAddApi;
    NSMutableArray <XKRWGroupItem *>* __allGroupDataSource;
    
    NSString * __currentRank;
    BOOL   __isreFresh;
}

@property (nonatomic, strong) XKRWUITableViewBase *tableView;
@property (nonatomic, strong) MJRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) MJRefreshFooterView *refreshFooterView;
@end

@implementation XKRWAddGroupViewController

#pragma mark - life cycle ...

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"in_MoreGroup"];
    self.title = @"添加小组";
    
    __allGroupDataSource = [NSMutableArray array];
    __groupApi = [XKRWGroupApi new];
    __groupAddApi = [XKRWGroupApi new];
    __currentRank = @"";
    __isreFresh = NO;
    
    
    self.tableView = ({
        XKRWUITableViewBase * tabel = [[XKRWUITableViewBase alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, self.view.height - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        tabel.backgroundColor = colorSecondary_f4f4f4;
        [tabel registerNib:[UINib nibWithNibName:@"XKRWAddGroupViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XKRWAddGroupViewCell class])];
        tabel.separatorStyle = UITableViewCellSeparatorStyleNone;
        tabel.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        tabel.delaysContentTouches = NO;
        tabel.bounces = YES;
        tabel.delegate = (id)self;
        tabel.dataSource = (id)self;
        tabel;
    });
    
    {
        self.refreshHeaderView = [MJRefreshHeaderView header];
        self.refreshHeaderView.scrollView = self.tableView;
        self.refreshHeaderView.delegate = (id)self;
        self.refreshFooterView = [MJRefreshFooterView footer];
        self.refreshFooterView.scrollView = self.tableView;;
        self.refreshFooterView.delegate = (id)self;
    }
    
    [self.view addSubview:self.tableView];
    
    [self requsetDataNeedRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tableView reloadData];
}

#pragma mark - response & action
- (void)refreshGroupLishNotice:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - Net request ..
//请求小组展示数据
- (void)requsetDataNeedRefresh:(BOOL)abool
{
    if (![XKUtil isNetWorkAvailable]) {
        [self showRequestArticleNetworkFailedWarningShow];
        return;
    }
    __isreFresh = abool;
//    [[XKHudHelper instance] showProgressHudAnimationInView:self.view];
    [XKRWCui showProgressHud:@"加载中"];
    if ([__groupApi registerTarget:self andResponseMethod:@selector(getGroupRes:)]) {
        [__groupApi getAllGroupBytype:0 size:10 rank:__currentRank];
    }
}

//小组数据的回调
- (void)getGroupRes:(NSMutableArray *)data
{
    [self endRefresh];
    [XKRWCui hideProgressHud];
    if (!data) {
        [self showRequestArticleNetworkFailedWarningShow];
        return;
    }
//    [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
    [self hiddenRequestArticleNetworkFailedWarningShow];
    if (__isreFresh) {
        [__allGroupDataSource removeAllObjects];
    }
    [__allGroupDataSource addObjectsFromArray:data];
    
    [self.tableView reloadData];
}

/*!
 *  @param button 无网络的按钮
 */
- (void)reLoadDataFromNetwork:(UIButton *)button
{
    [self requsetDataNeedRefresh:YES];
}

//加入小组的请求
- (BOOL)addGroupById:(NSString *)groupId
{
    if (![XKUtil isNetWorkAvailable]) {
        [XKRWCui hideProgressHud];
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        return NO;
    }
    
    NSDictionary * data = [__groupAddApi joinGroupWithGroupId:groupId];
    NSString * success = data[@"success"];
    [XKRWCui hideProgressHud];
    
    if (success.integerValue == 1){
        [XKUtil postRefreshGroupTeamInDiscover]; // 通知发现小组变更
        return YES;
    }else{
        [XKDispatcher syncExecuteTask:^{
            [XKRWCui showInformationHudWithText:data[@"error"][@"msg"]];
        }];
        return NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return __allGroupDataSource.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * v = [UIView new];
    v.frame = (CGRect){0, 0, XKAppWidth, 10};
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        XKRWAddGroupHeaderViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWAddGroupHeaderViewCell class])];
        if (!cell) {
            cell = [[XKRWAddGroupHeaderViewCell alloc]initWithStyle:0 reuseIdentifier:NSStringFromClass([XKRWAddGroupHeaderViewCell class])];
        }
        cell.title.text = @"全部小组";
        return cell;
    }else{
        XKRWAddGroupViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWAddGroupViewCell class]) forIndexPath:indexPath];

        XKRWGroupItem * item = __allGroupDataSource[indexPath.row - 1];
        cell.groupTitle.text = item.groupDescription;
        [cell.groupheadImage setImageWithURL:[NSURL URLWithString:item.groupIcon] placeholderImage:nil options:SDWebImageRetryFailed];
        cell.groupNameLabel.text = item.groupName;
        cell.groupMemberCount.text = [NSString stringWithFormat:@"人数:%@人",item.groupNum];

        cell.groupId = item.groupId;
        
        if ([[XKRWUserService sharedService].currentGroups containsObject:item.groupId]) {
            [cell setjoinOrsignOutButtonSelected:YES];
        }else{
            [cell setjoinOrsignOutButtonSelected:NO];
        }
        
        __weak typeof(self) weakSelf = self;
        __block BOOL  success = NO;
        cell.handle = ^(BOOL isSelect, NSString * groupId){
            [MobClick event:@"clk_JoinGroup3"];
            
            [XKRWCui showProgressHud:@"处理中"];
            success = [weakSelf addGroupById:groupId];
            if (success && ![[XKRWUserService sharedService].currentGroups containsObject:groupId]) {
                [[XKRWUserService sharedService].currentGroups addObject: groupId];
            }
            return success;
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 45;
    }else{
        XKRWGroupItem * item = __allGroupDataSource[indexPath.row - 1];
        __cacultaHeightCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWAddGroupViewCell class])];
        __cacultaHeightCell.groupTitle.text = item.groupDescription;
        __cacultaHeightCell.groupTitle.preferredMaxLayoutWidth = XKAppWidth - 150;
        float height = [XKRWUtil  getViewSize:__cacultaHeightCell.contentView].height + 1.5 ;
        NSLog(@"%@",__cacultaHeightCell.groupTitle.text);
        return height;
    }
}

#pragma mark - Table view delegate

//In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
//        XKRWReportViewController * vc = [[XKRWReportViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];

    }else{
        XKRWGroupViewController *noticeCenterVC = [XKRWGroupViewController new];
        noticeCenterVC.hidesBottomBarWhenPushed = YES;
        noticeCenterVC.groupItem = __allGroupDataSource[indexPath.row - 1];
        [self.navigationController pushViewController:noticeCenterVC animated:YES];
    }
}

#pragma mark - MJ Refresh Delegate

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    
    if (![XKRWUtil isNetWorkAvailable]) {
        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
            [XKRWCui showInformationHudWithText:@"没有网络无法刷新哦~"];
        } else if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
            [XKRWCui showInformationHudWithText:@"没有网络无法加载哦~"];
        }
        [refreshView endRefreshing];
        return;
    }
    
    //下拉刷新
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        
            __currentRank = @"";
            [self requsetDataNeedRefresh:YES];
        
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
        
    } else { //上拉加载
        
        if (!refreshView.refreshing) {
            
            __currentRank = __allGroupDataSource.lastObject.rank;
            if (__currentRank.integerValue == 1) {
                [self endRefresh];
                return;
            }
            [self requsetDataNeedRefresh:NO];
            
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
            
        }
    }
}

- (void)endRefresh {
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];

}

- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state {
    
    switch (state) {
        case MJRefreshStateNormal:
            NSLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
}

- (void)dealloc
{
    [self.refreshHeaderView free];
    [self.refreshFooterView free];
}

@end
