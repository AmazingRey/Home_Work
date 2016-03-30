 //
//  XKRWReportViewController.m
//  XKRW
//
//  Created by Seth Chen on 16/1/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWReportViewController.h"
#import "GroupContentCell.h"
#import "XKRWSCPopSelector.h"
#import "XKRWGroupService.h"
#import "XKRWNonePostTableViewCell.h"

@interface XKRWReportViewController ()
{
    NSMutableArray <XKRWPostEntity *>* __reportDataSource;
    NSMutableArray <XKRWPostEntity *>* __replyDataSource;
    NSInteger   __currentIndex;
    
    GroupContentCell  * __cacultaHeightCell;
    
    NSString * reportRefreshPostId;
    NSString * replyRefreshCMT_Time;
  
}
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) XKRWUIScrollViewBase *tablebgScroller;
@property (nonatomic, strong) XKRWUITableViewBase *reportTable;
@property (nonatomic, strong) XKRWUITableViewBase *replyTable;


@property (nonatomic, strong) MJRefreshHeaderView *reportrefreshHeaderView;
@property (nonatomic, strong) MJRefreshFooterView *reportrefreshFooterView;
@property (nonatomic, strong) MJRefreshHeaderView *replyrefreshHeaderView;
@property (nonatomic, strong) MJRefreshFooterView *replyrefreshFooterView;

@property (nonatomic, strong) NSMutableArray * history;                 ///< 记录已经发送过的请求


@property (nonatomic, assign) postShowType reportPostShowType;      ///< 记录report类型
@property (nonatomic, assign) postShowType replyPostShowType;       ///< 记录reply类型
@end

@implementation XKRWReportViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的帖子";
    __replyDataSource = [NSMutableArray array];
    __reportDataSource = [NSMutableArray array];
    _history = [NSMutableArray array];
    [_history addObject:[NSNumber numberWithInteger:0]]; // 0  存入
    reportRefreshPostId = @"0";
    replyRefreshCMT_Time = @"0";
    
    __currentIndex = 0;
    
    self.reportPostShowType = postShowNor;
    self.replyPostShowType = postShowNor;
    
    [self.view addSubview:self.tablebgScroller];
    [self.tablebgScroller addSubview:self.reportTable];
    [self.tablebgScroller addSubview:self.replyTable];
    [self.view addSubview:self.segmentedControl];
    [self setupRefreshTools];
    [XKRWCui showProgressHud:@"加载中"];
    [self initDataIfNeedFresh:YES];

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
    [XKRWCui hideProgressHud];
}

- (void)setupRefreshTools
{
    self.reportrefreshHeaderView = [MJRefreshHeaderView header];
    self.reportrefreshHeaderView.scrollView = self.reportTable;
    self.reportrefreshHeaderView.delegate = (id)self;
    self.reportrefreshFooterView = [MJRefreshFooterView footer];
    self.reportrefreshFooterView.scrollView = self.reportTable;;
    self.reportrefreshFooterView.delegate = (id)self;
    
    self.replyrefreshHeaderView = [MJRefreshHeaderView header];
    self.replyrefreshHeaderView.scrollView = self.replyTable;
    self.replyrefreshHeaderView.delegate = (id)self;
    self.replyrefreshFooterView = [MJRefreshFooterView footer];
    self.replyrefreshFooterView.scrollView = self.replyTable;;
    self.replyrefreshFooterView.delegate = (id)self;
    
}

- (void)initDataIfNeedFresh:(BOOL)abool
{
    if (![XKUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        if (__currentIndex == 0) {
            self.reportPostShowType = postShowNetError; [self refreshTable];
        }else if(__currentIndex == 1){
            self.replyPostShowType = postShowNetError; [self refreshTable];
        }
        return;
    }

    if (__currentIndex == 0) {
        reportRefreshPostId = abool?@"0":__reportDataSource.lastObject.postid;
        [self downloadWithTaskID:abool?@"getMyReportPostFresh":@"getMyReportPost" outputTask:^id{
            return [[XKRWGroupService shareInstance]getMyReportPostWithNickName:@"" postId:reportRefreshPostId size:@"10"];
        }];
    }else{
        replyRefreshCMT_Time = abool?@"0":__replyDataSource.lastObject.user_latest_cmt_time;
        [self downloadWithTaskID:abool?@"getMyReplytPostFresh":@"getMyReplytPost" outputTask:^id{
            return [[XKRWGroupService shareInstance]getMyReplyPostWithTime:replyRefreshCMT_Time andSize:@"10"];
        }];
    }
}

#pragma mark - Net call back ....................................................

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [super handleDownloadProblem:problem withTaskID:taskID];
    if ([taskID isEqualToString:@"getMyReportPost"]) {
        self.reportPostShowType = postShowNetError; [self refreshTable];
    }else if([taskID isEqualToString:@"getMyReportPostFresh"]){
        self.reportPostShowType = postShowNetError; [self refreshTable];
    }
    
    if ([taskID isEqualToString:@"getMyReplytPost"]) {
        self.replyPostShowType = postShowNetError; [self refreshTable];
    }else if([taskID isEqualToString:@"getMyReplytPostFresh"]){
        self.replyPostShowType = postShowNetError; [self refreshTable];
    }
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {

    [XKDispatcher syncExecuteTask:^{
        [XKRWCui hideProgressHud];
        [self endRefresh];
    }];
    
    if ([taskID isEqualToString:@"getMyReportPost"]) {
        [__reportDataSource addObjectsFromArray:result];
        
        if (__reportDataSource.count >0) {
            self.reportPostShowType = postShowNor;
        }else self.reportPostShowType = postShowNone;
        
        [XKDispatcher syncExecuteTask:^{
            [self.reportTable reloadData];
        }];
    }else if([taskID isEqualToString:@"getMyReportPostFresh"]) //刷新
    {
        [__reportDataSource removeAllObjects];
        [__reportDataSource addObjectsFromArray:result];
        
        if (__reportDataSource.count >0) {
            self.reportPostShowType = postShowNor;
        }else self.reportPostShowType = postShowNone;

        [XKDispatcher syncExecuteTask:^{
            [self.reportTable reloadData];
        }];
    }
    
    
    if ([taskID isEqualToString:@"getMyReplytPost"]) {
        [__replyDataSource addObjectsFromArray:result];
        
        if (__replyDataSource.count >0) {
            self.replyPostShowType = postShowNor;
        }else self.replyPostShowType = postShowNone;
        
        [XKDispatcher syncExecuteTask:^{
            [self.replyTable reloadData];
        }];
    }else if([taskID isEqualToString:@"getMyReplytPostFresh"]) // 刷新
    {
        [__replyDataSource removeAllObjects];
        [__replyDataSource addObjectsFromArray:result];
        
        if (__replyDataSource.count >0) {
            self.replyPostShowType = postShowNor;
        }else self.replyPostShowType = postShowNone;
        
        [XKDispatcher syncExecuteTask:^{
            [self.replyTable reloadData];
        }];
    }
}
#pragma mark - response & action

- (void)segmentedControlIndexChanged:(UISegmentedControl *)seg
{
    __currentIndex = seg.selectedSegmentIndex;
    if (__currentIndex == 0) {
        [MobClick event:@"clk_PushPost1"];
    } else {
        [MobClick event:@"clk_ReplyPost"];
    }
    [self.tablebgScroller scrollRectToVisible:CGRectMake(XKAppWidth*__currentIndex, 0, XKAppWidth, _tablebgScroller.height) animated:NO];
    if ([self.history containsObject:[NSNumber numberWithInteger:__currentIndex]]) {
       
        return;
    }else{
        //                                              [self recoverPosistion];
        [self.history addObject:[NSNumber numberWithInteger:__currentIndex]];
    }
    if ((__currentIndex == 0 && !__reportDataSource.count) || (__currentIndex == 1 && !__replyDataSource.count)) {
        [self initDataIfNeedFresh:YES];
    }
}

- (void)refreshTable
{
    if (__currentIndex == 0) {
        [UIView performWithoutAnimation:^{
            [self.reportTable reloadData];
        }];
    }else{
        [UIView performWithoutAnimation:^{
            [self.replyTable reloadData];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.reportTable]){
        if (self.reportPostShowType != postShowNor) {
            return 1;
        }else  return __reportDataSource.count;
    }else{
        if (self.replyPostShowType != postShowNor) {
            return 1;
        }else  return __replyDataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.reportTable]) {
        
        if (self.reportPostShowType != postShowNor) {
            
            XKRWNonePostTableViewCell *nonePostTableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class]) forIndexPath:indexPath];
            nonePostTableViewCell.handle = ^{
                [self initDataIfNeedFresh:YES];
            };
            
            if (self.reportPostShowType != postShowNetError) {
                [nonePostTableViewCell setIsNoneData:YES];
            }else [nonePostTableViewCell setIsNoneData:NO];
            
            nonePostTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return nonePostTableViewCell;
            
        }else{
            
            GroupContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell" forIndexPath:indexPath];
            cell.hotInddictor.hidden = YES;
            
            XKRWPostEntity * item = __reportDataSource[indexPath.row];
            
                cell.titleLabel.text = item.title;
            
            cell.replyLabel.text = [NSString stringWithFormat:@"%@",item.comment_nums];
            [cell setTopIndictor:item.is_top.intValue == 0?YES:NO essenceIndictor:item.is_essence.intValue == 0?YES:NO helpIndictor:item.is_help.intValue == 0?YES:NO hasImageIndictor:item.is_pic.intValue == 0?YES:NO timeLabel:YES];
            cell.creatTimeLabel.text = XKSTR(@"更新于%@",[XKRWUtil calculateTimeShowStr:item.latest_comment_time.integerValue]);
            
            return cell;
        }
        
    }else{
        
        if (self.replyPostShowType != postShowNor) {
            
            XKRWNonePostTableViewCell *nonePostTableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class]) forIndexPath:indexPath];
            nonePostTableViewCell.handle = ^{
                [self initDataIfNeedFresh:YES];
            };
            
            if (self.replyPostShowType != postShowNetError) {
                [nonePostTableViewCell setIsNoneData:YES];
            }else [nonePostTableViewCell setIsNoneData:NO];
            
            nonePostTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return nonePostTableViewCell;
            
        }else{
            
            GroupContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"replyCell" forIndexPath:indexPath];
            cell.hotInddictor.hidden = YES;
            [cell setTopIndictor:YES essenceIndictor:YES helpIndictor:YES hasImageIndictor:YES timeLabel:YES];
            XKRWPostEntity * item = __replyDataSource[indexPath.row];
            cell.replyLabel.text = [NSString stringWithFormat:@"%@",item.comment_nums];
            cell.creatTimeLabel.text = XKSTR(@"更新于%@",[XKRWUtil calculateTimeShowStr:item.latest_comment_time.integerValue]);
            
            if(item.del_status == 2 || item.del_status == 3){
                cell.titleLabel.text = @"帖子已被删除";
                cell.creatTimeLabel.text = @"";
                cell.replyTitleLabel.hidden = YES;
                cell.replyLabel.text = @"";
            }else{
                cell.replyTitleLabel.hidden = NO;
                cell.titleLabel.text = item.title;
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.reportTable]) {
        
        if (self.reportPostShowType!= postShowNor) {
            return XKAppHeight - 114;
        }
        
        XKRWPostEntity * item = __reportDataSource[indexPath.row];
        
        __cacultaHeightCell = [tableView dequeueReusableCellWithIdentifier:@"reportCell"];
        __cacultaHeightCell.titleLabel.text = item.title;
        __cacultaHeightCell.titleLabel.preferredMaxLayoutWidth = XKAppWidth - 14;
        
        float height = [XKRWUtil  getViewSize:__cacultaHeightCell.contentView].height + 1.5 ;
        
        return height;
    }else{
        
        if (self.replyPostShowType!= postShowNor) {
            return XKAppHeight - 114;
        }
        
        XKRWPostEntity * item = __replyDataSource[indexPath.row];
        
        __cacultaHeightCell = [tableView dequeueReusableCellWithIdentifier:@"replyCell"];
        __cacultaHeightCell.titleLabel.text = item.title;
        __cacultaHeightCell.titleLabel.preferredMaxLayoutWidth = XKAppWidth - 14;
        
        float height = [XKRWUtil  getViewSize:__cacultaHeightCell.contentView].height + 1.5 ;
        
        return height;
    }
}

#pragma mark - Table view delegate

//In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[XKRWNonePostTableViewCell class]]) {
        return;
    }
    
    XKRWPostDetailVC * vc = [[XKRWPostDetailVC alloc]initWithNibName:@"XKRWPostDetailVC" bundle:nil];
    if ([tableView isEqual:self.reportTable]) {
        vc.postID = __reportDataSource[indexPath.row].postid;
    }else
    {
        vc.postID = __replyDataSource[indexPath.row].postid;
    }
    
    
    [self.navigationController pushViewController:vc animated:YES];

//    NSMutableArray * arr = [NSMutableArray array];
//    for (int i = 0;i < 10; i ++) {
//        XKRWGroupItem * item = [XKRWGroupItem new];
//        item.groupId = XKSTR(@"%d",i);
//        [arr addObject:item];
//    }
//    XKRWSCPopSelector * alert =[[ XKRWSCPopSelector alloc]initWithFrame:KeyWindow.bounds];
//    alert.dataSource = arr;
//    [KeyWindow addSubview:alert];
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
        if (!refreshView.refreshing) {
            

            
            [self initDataIfNeedFresh:YES];
            
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
            
        }
    } else { //上拉加载
        
        if (!refreshView.refreshing) {
            

            [self initDataIfNeedFresh:NO];
            
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
            
        }
    }
}

- (void)endRefresh {
    
    [self.reportrefreshHeaderView endRefreshing];
    [self.reportrefreshFooterView endRefreshing];
    [self.replyrefreshHeaderView endRefreshing];
    [self.replyrefreshFooterView endRefreshing];
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

#pragma mark - get&set

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"发布的帖子",@"回复的帖子"]];
        _segmentedControl.frame = (CGRect){15, 10, XKAppWidth - 30, 30};
        _segmentedControl.tintColor = XKMainSchemeColor;
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (XKRWUIScrollViewBase *)tablebgScroller
{
    if (!_tablebgScroller) {
        _tablebgScroller = [[XKRWUIScrollViewBase alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth , XKAppHeight - 64)];
        _tablebgScroller.backgroundColor = XKClearColor;
        _tablebgScroller.contentSize = CGSizeMake(XKAppWidth*2, _tablebgScroller.height);
        _tablebgScroller.pagingEnabled = YES;
        _tablebgScroller.scrollEnabled = NO;
    }
    return _tablebgScroller;
}


- (XKRWUITableViewBase *)reportTable
{
    if (!_reportTable) {
        _reportTable = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 50, XKAppWidth, _tablebgScroller.height -50) style:UITableViewStylePlain];
        _reportTable.delegate = (id)self;
        _reportTable.dataSource = (id)self;
        _reportTable.backgroundColor = XKClearColor;
        _reportTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_reportTable registerNib:[UINib nibWithNibName:NSStringFromClass([GroupContentCell class]) bundle:nil] forCellReuseIdentifier:@"reportCell"];
        [_reportTable registerNib:[UINib nibWithNibName:NSStringFromClass([XKRWNonePostTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class])];
    }
    return _reportTable;
}


- (XKRWUITableViewBase *)replyTable
{
    if (!_replyTable) {
        _replyTable = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(XKAppWidth, 50, XKAppWidth, _tablebgScroller.height- 50) style:UITableViewStylePlain];
        _replyTable.delegate = (id)self;
        _replyTable.dataSource = (id)self;
        _replyTable.backgroundColor = XKClearColor;
        _replyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_replyTable registerNib:[UINib nibWithNibName:NSStringFromClass([GroupContentCell class]) bundle:nil] forCellReuseIdentifier:@"replyCell"];
         [_replyTable registerNib:[UINib nibWithNibName:NSStringFromClass([XKRWNonePostTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class])];
    }
    return _replyTable;
}

- (void)dealloc
{
    [self.reportrefreshHeaderView free];
    [self.reportrefreshFooterView free];
    [self.replyrefreshHeaderView free];
    [self.replyrefreshFooterView free];
}


@end
