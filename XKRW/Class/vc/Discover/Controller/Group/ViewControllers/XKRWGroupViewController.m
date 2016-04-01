//
//  XKRWGroupViewController.m
//  XKRW
//
//  Created by Seth Chen on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWGroupViewController.h"

#import "GroupHeaderCell.h"
#import "XKRWAddGroupViewCell.h"
#import "AnnouncementCell.h"
#import "GroupContentCell.h"

#import "PLSCScrollButtonView.h"
#import "SCBackToUpView.h"

#import "GroupHeaderDetailView.h"

#import "XKRWGroupManageViewController.h"
#import "XKRWAddGroupViewController.h"
#import "UIImageView+WebCache.h"
#import "XKRWArticleVC.h"

#import "XKRWGroupService.h"
#import "XKRWGroupApi.h"
#import "XKRWPostEntity.h"

#import "MJRefresh.h"
#import <XKRW-Swift.h>
#import "XKRWPostDetailVC.h"
#import "XKRWNonePostTableViewCell.h"
#import "UserHadReadPostEntity.h"


@interface XKRWGroupViewController ()<MJRefreshBaseViewDelegate>
{
    UIButton                    * _rightBarBtn;
    UIActivityIndicatorView     * _indictor;
    UIBarButtonItem             * _rightBarItem;
    
    PLSCScrollButtonView        * __scrollButton;       ///< Scroll Button
    SCBackToUpView              * __backToUpView;
    GroupHeaderDetailView       * __groupHeaderDetailView;
    XKRWFocusView               * __focusView;
    
    UIScrollView                * _theBgGroupScrollView;
    
    CGFloat                     __currentOffset__Y;
    CGFloat                     __currentHeaderDetail_y;
    NSInteger                   __currentIndex;
    
    NSMutableArray              * __allPostDataSource;
    NSMutableArray              * __essencePostDataSource;
    NSMutableArray              * __ctimePostDataSource;
    NSMutableArray              * __helpPostDataSource;
    
    XKRWGroupApi                * _joinOrSignGroupApi;
    
    NSInteger                   _getAllPostlistPage;
    NSInteger                   _getCtimePostlistPage;
    NSInteger                   _getEsencePostlistPage;
    NSInteger                   _getHelpPostlistPage;
    
    GroupContentCell            * __cacultaHeightCell;
    AnnouncementCell            * __announceCaculateCell;
    UIButton                    * __customButton;
    
    BOOL                        _isShowFocus;
    BOOL                        _isShowNotice;
    NSMutableArray              *__focusDataSource;
    NSMutableArray              *__noticeDataSource;
    
    XKRWArticleWebView          *__articleWebView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * history;                 ///< 记录已经发送过的请求
@property (nonatomic, strong) MJRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) MJRefreshFooterView *refreshFooterView;

@property (nonatomic, assign) BOOL requestDataError;


@property (nonatomic, assign) postShowType allPostlistPostShowType;     ///< 记录allPostlist类型
@property (nonatomic, assign) postShowType ctimePostlistPostShowType;   ///< 记录ctimePostlist类型
@property (nonatomic, assign) postShowType esencePostlistPostShowType;  ///< 记录esencePostlist类型
@property (nonatomic, assign) postShowType helpPostlistPostShowType;    ///< 记录helpPostlist类型


@property (nonatomic, assign) BOOL requestDataAgian;
@end

@implementation XKRWGroupViewController

#pragma mark - lyfe cycle & init selector

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:[NSString stringWithFormat:@"in_group%@",self.groupId]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportSuccessTorefreshData:) name:@"ReportSuccessTorefreshData" object:nil];
    
    self.view.backgroundColor = colorSecondary_f4f4f4;
    
    __currentIndex = 0;
    __allPostDataSource = [NSMutableArray array];
    __essencePostDataSource = [NSMutableArray array];
    __ctimePostDataSource = [NSMutableArray array];
    __helpPostDataSource = [NSMutableArray array];
    __focusDataSource = [NSMutableArray array];
    __noticeDataSource = [NSMutableArray array];
    _history = [NSMutableArray array];
    _joinOrSignGroupApi = [XKRWGroupApi new];
    
    self.allPostlistPostShowType = postShowNor;
    self.ctimePostlistPostShowType = postShowNor;
    self.esencePostlistPostShowType = postShowNor;
    self.helpPostlistPostShowType = postShowNor;
    
    self.requestDataError = NO;
    self.requestDataAgian = NO;  //发完贴 刷新
    {
        [_history addObject:[NSNumber numberWithInteger:0]]; // "全部"发帖  存入
        
        _getAllPostlistPage = 1;
        _getCtimePostlistPage = 1;
        _getEsencePostlistPage = 1;
        _getHelpPostlistPage = 1;
    }
    
    [self requestGroupData];

    NSString * key = XKSTR(@"%ld_hasShowGroupView",(long)[XKRWUserDefaultService getCurrentUserId]);
    BOOL abool = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (!abool) {
        UIImageView * groupView = [[UIImageView alloc]initWithFrame:self.navigationController.view.bounds];
        groupView.image = [UIImage imageNamed:@"groupView"];
        [self.navigationController.view addSubview:groupView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGroupView:)];
        groupView.userInteractionEnabled = YES;
        [groupView addGestureRecognizer:tap];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.requestDataAgian) {
        [self shouldRequestDataAgian];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!__groupHeaderDetailView.hidden) {
        __groupHeaderDetailView.hidden = YES;
    }
}

- (void)initUI
{
    self.title = self.groupItem.groupName;
    
    if (self.tableView) {
        return;
    }
    self.tableView = ({
        UITableView * tabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        tabel.backgroundColor = colorSecondary_f4f4f4;
        tabel.separatorStyle = UITableViewCellSeparatorStyleNone;
        tabel.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tabel.delaysContentTouches = NO;
        tabel.bounces = YES;
        tabel.delegate = (id)self;
        tabel.dataSource = (id)self;
        tabel;
    });
    
    {
        self.refreshHeaderView = [MJRefreshHeaderView header];
        _refreshHeaderView.scrollView = _tableView;
        _refreshHeaderView.delegate = self;
        self.refreshFooterView = [MJRefreshFooterView footer];
        _refreshFooterView.scrollView = _tableView;
        _refreshFooterView.delegate = self;
        
    }
    
    [self registerCells];
    [self addRightBarItem];
    [self.view addSubview:self.tableView];
    
    __focusView = [[NSBundle mainBundle] loadNibNamed:@"XKRWFocusView" owner:nil options:nil].firstObject;
    __focusView.frame = CGRectMake(0, 0, XKAppWidth,XKAppWidth/5.0);
    __announceCaculateCell = [[NSBundle mainBundle] loadNibNamed:@"AnnouncementCell" owner:nil options:nil].firstObject;
    
    __scrollButton = ({
        PLSCScrollButtonView * scb = [[PLSCScrollButtonView alloc]initWithFrame:CGRectMake(0,0, XKAppWidth, 45)norColor:[UIColor darkGrayColor] selectColor:XKMainSchemeColor withGap:0 isShowBottomline:YES handler:^(NSInteger index, UIButton * currentButton, UILabel *currentNotice, PLSCScrollButtonView * selfButton, SEL sel)
                                      {
                                          __currentIndex = index;
                                          [MobClick event:[NSString stringWithFormat:@"clk_post%ld",(long)(__currentIndex + 1)]];
                                          
                                          if ([self.history containsObject:[NSNumber numberWithInteger:index]]) {
                                              [self.tableView reloadData];
                                              return;
                                          }else{
                                              //                                              [self recoverPosistion];
                                              if (index == 3&& ![self.history containsObject:[NSNumber numberWithInteger:3]]) {
                                                  
                                                  [[NSUserDefaults standardUserDefaults]setObject:self.groupItem.groupHelp_nums forKey:XKSTR(@"%@_help_nums",self.groupItem.groupId)];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                  
                                              }
                                              
                                              [self.history addObject:[NSNumber numberWithInteger:index]];
                                          }
                                          [selfButton performSelector:sel withObject:@"0"];
                                          [self initItemDataNeedFresh:NO];
                                          
                                      }];
        [scb setTitles:@[@"全部",@"新帖",@"精华",@"求助"]];
        scb.backgroundColor = [UIColor whiteColor];
        UIView * bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, scb.frame.size.height , scb.frame.size.width, 1)];
        bottomline.backgroundColor = XKMainSchemeColor;
        [scb addSubview:bottomline];
        scb;
    });
    
    // 初始化notice的值
    NSString * num = [[NSUserDefaults standardUserDefaults] objectForKey:XKSTR(@"%@_help_nums",self.groupItem.groupId)];
    [__scrollButton setNotices:@[@"0",@"0",@"0",XKSTR(@"%d",self.groupItem.groupHelp_nums.intValue - num.intValue)]];//
    
    // top
    __backToUpView = ({
        SCBackToUpView * back = [[SCBackToUpView alloc]initShowInSomeViewSize:CGSizeMake(XKAppWidth, XKAppHeight) minitor:self.tableView withImage:@"group_backtotop"];
        back.backOffsettY = XKAppWidth;
        back;
    });
    [self.view addSubview:__backToUpView];
    
    [self initHeader];
    
    [self initItemDataNeedFresh:NO];
}

#if 1
- (void)initHeader
{
    __groupHeaderDetailView = [[NSBundle mainBundle] loadNibNamed:@"GroupHeaderDetailView" owner:nil options:nil].lastObject;
    //
    CGRect rect = __groupHeaderDetailView.frame;
    rect.origin.y = 64 + 44;
    __groupHeaderDetailView.frame = rect;
    __groupHeaderDetailView.center = CGPointMake(XKAppWidth/2, __groupHeaderDetailView.center.y);
    __groupHeaderDetailView.groupAuthType = self.groupAuthType;
    __groupHeaderDetailView.delegate = (id)self;
    __groupHeaderDetailView.alpha = 0;
    __groupHeaderDetailView.memberNumLabel.text = [NSString stringWithFormat:@"%@",self.groupItem.groupNum];
    
    [self.tableView addSubview:__groupHeaderDetailView];
    
    [XKDispatcher syncExecuteTask:^{
        __groupHeaderDetailView.hidden = YES;
    }];
}

- (void)registerCells
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GroupHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GroupHeaderCell class])];
    //    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XKRWGroupADViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XKRWGroupADViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AnnouncementCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AnnouncementCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GroupContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GroupContentCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XKRWNonePostTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class])];
}

- (void)addRightBarItem
{
    __customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [__customButton addTarget:self action:@selector(rightBarItemEvent) forControlEvents:UIControlEventTouchUpInside];

    NSString *text ;

    if (self.groupAuthType == groupAuthNone) {
        text = @"加入";
    }else{
        text = @"发言";
    }
    
    CGFloat titleWidth = [text boundingRectWithSize:CGSizeMake(XKAppWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: XKDefaultFontWithSize(15)}
                                            context:nil].size.width;
    __customButton.frame = CGRectMake(0, 0, titleWidth, 20);
    [__customButton.titleLabel setFont:XKDefaultFontWithSize(15)];
    [__customButton setTitle:text forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:__customButton];
}

#pragma mark - action & response..

- (void)refreshTableAfterDelay:(NSTimeInterval)ctime
{
    [XKDispatcher syncExecuteTask:^{
        [UIView performWithoutAnimation:^{
            [self.tableView reloadData];
        }];
    } afterSeconds:ctime];
}
/**
 *  因为此vc中元素显示是不定的  所以需要根据Grouptype刷新  (1.right tabbar item 2. header 的退出 加入按钮)
 */
- (void)refreshStatus
{
    NSString *text ;
    if (self.groupAuthType == groupAuthNone) {
        text = @"加入";
    }else{
        text = @"发言";
    }
    [__customButton setTitle:text forState:UIControlStateNormal];
}

// right tabbar item
- (void)rightBarItemEvent
{
    if (self.groupAuthType == groupAuthNone) {
        [MobClick event:@"clk_JoinGroup1"];
        
        [self joinGroup];
    }else{
        [self checkAuth]; //鉴定是否具备发言的权限
    }
}

/*!
 * 四个帖子类别数据请求
 */
- (void)initItemDataNeedFresh:(BOOL)abool
{
    if (![XKUtil isNetWorkAvailable]) {
        if (__currentIndex == 0) {
            self.allPostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
        }else if(__currentIndex == 1){
            self.ctimePostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
        }else if(__currentIndex == 2){
            self.esencePostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
        }else {
            self.helpPostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
        }
        return;
    }
    
    if (__currentIndex == 0) {
        
        [XKRWCui showProgressHud:@"加载中"];
        [self downloadWithTaskID:abool?@"getAllPostlistFresh":@"getAllPostlist" outputTask:^id{
            return [[XKRWGroupService shareInstance] getPostlistWithGroupId:self.groupItem.groupId type:@"all" page:_getAllPostlistPage size:10];
        }];
    }else if (__currentIndex == 1){
        [XKRWCui showProgressHud:@"加载中"];
        [self downloadWithTaskID:abool?@"getCtimePostlistFresh":@"getCtimePostlist" outputTask:^id{
            return [[XKRWGroupService shareInstance] getPostlistWithGroupId:self.groupItem.groupId type:@"ctime" page:_getCtimePostlistPage size:10];
        }];
    }else if (__currentIndex == 2){
        [XKRWCui showProgressHud:@"加载中"];
        [self downloadWithTaskID:abool?@"getEsencePostlistFresh":@"getEsencePostlist" outputTask:^id{
            return [[XKRWGroupService shareInstance] getPostlistWithGroupId:self.groupItem.groupId type:@"essence" page:_getEsencePostlistPage size:10];
        }];
    }else{
        [XKRWCui showProgressHud:@"加载中"];
        [self downloadWithTaskID:abool?@"getHelpPostlistFresh":@"getHelpPostlist" outputTask:^id{
            return [[XKRWGroupService shareInstance] getPostlistWithGroupId:self.groupItem.groupId type:@"help" page:_getHelpPostlistPage size:10];
        }];
    }
}

/*!
 * header hiden
 */
- (void)changeGroupHeaderDetailStatus
{
    __groupHeaderDetailView.hidden = !__groupHeaderDetailView.hidden;
    
    CGRect rect = __groupHeaderDetailView.frame;
    rect.origin.y = ( __currentHeaderDetail_y > 0?__currentHeaderDetail_y:44);
    __groupHeaderDetailView.frame = rect;
}

/*!
 * header 的按钮事件 sign out the groups ..
 */
- (void)buttonClickHandler:(groupAuthType)type
{
    if (type == groupAuthNone) {
        [MobClick event:@"clk_JoinGroup2"];
        
        [self joinGroup];   // 加入
    }else {
        [self signOutGroup];// 退出
    }
    
    [self changeGroupHeaderDetailStatus];
}

///< 位置还原
- (void)recoverPosistion
{
    self.tableView.contentOffset = (CGPoint){0, 0};
}

/*!
 *  @param button 无网络的按钮
 */
- (void)reLoadDataFromNetwork:(UIButton *)button
{
    [self requestGroupData];
}

- (void)dismissGroupView:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
}

#pragma mark - Notification ....

//发言成功以后刷新列表
- (void)reportSuccessTorefreshData:(NSNotification *)notification
{
    self.requestDataAgian = YES;
}

- (void)shouldRequestDataAgian
{
    [__allPostDataSource removeAllObjects];
    [__essencePostDataSource removeAllObjects];
    [__ctimePostDataSource removeAllObjects];
    [__helpPostDataSource removeAllObjects];
    [self.history removeAllObjects];
    [self.history addObject:[NSNumber numberWithInteger:__currentIndex]];
    [self initItemDataNeedFresh:YES];
    self.requestDataAgian = NO;
}

#pragma mark - Net Data
#pragma mark - 新版网络层调用
- (void)requestGroupData
{
    if (![XKUtil isNetWorkAvailable]) {
        [self showRequestArticleNetworkFailedWarningShow];
        return;
    }
    if (!self.groupItem.groupId && !self.groupId) {
        XKLog(@"groupid lost......");
        [self showRequestArticleNetworkFailedWarningShow];
        return;
    }
    
    [[XKHudHelper instance] showProgressHudAnimationInView:self.view];
    [self downloadWithTaskID:@"getGroupDetailData" outputTask:^id{
        return [[XKRWGroupService shareInstance] getGroupDetailWithGroupId:self.groupItem.groupId?self.groupItem.groupId:self.groupId];
    }];
    
    [self downloadWithTaskID:@"getFocusData" outputTask:^id{
        return [[XKRWAdService sharedService] downLoadAdWithPosition:self.groupId andCommerce_type:@"focus"];
    }];
    
    [self downloadWithTaskID:@"getNoticeData" outputTask:^id{
        return [[XKRWAdService sharedService] downLoadAdWithPosition:self.groupId andCommerce_type:@"notice"];
    }];
}

- (void)joinGroup ///< 加入
{
    if (![XKUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        return;
    }
    [XKRWCui showProgressHud];
    if ([_joinOrSignGroupApi registerTarget:self andResponseMethod:@selector(joinGroupWithGroupIdRes:)]) {
        [_joinOrSignGroupApi joinTheGroupWithGroupId:self.groupItem.groupId];
    }
}

- (void)joinGroupWithGroupIdRes:(NSDictionary *)data
{
    [XKDispatcher syncExecuteTask:^{
        [XKRWCui hideProgressHud];
        NSString * success = data[@"success"];
        if (success.intValue == 1) {
            [XKRWCui showInformationHudWithText:@"加入成功"];
            self.groupAuthType = groupAuthNor;
            
            [XKUtil postRefreshGroupTeamInDiscover]; // 通知发现小组变更
            
            if (![[XKRWUserService sharedService].currentGroups containsObject:self.groupItem.groupId]) {
                [[XKRWUserService sharedService].currentGroups addObject:self.groupItem.groupId];
            }
        }else{
            self.groupAuthType = groupAuthNone;
            [XKRWCui showInformationHudWithText:data[@"error"][@"msg"]];
        }
        
        [self refreshStatus];
    }];
}

- (void)signOutGroup ///< 退出
{
    if (![XKUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        return;
    }
    [XKRWCui showProgressHud];
    if ([_joinOrSignGroupApi registerTarget:self andResponseMethod:@selector(signOutWithGroupIdRes:)]) {
        [_joinOrSignGroupApi signOutGroupWithGroupId:self.groupItem.groupId];
    }
}

- (void)signOutWithGroupIdRes:(NSDictionary *)data
{
    [XKDispatcher syncExecuteTask:^{
        [XKRWCui hideProgressHud];
        NSString * success = data[@"success"];
        if (success.intValue == 1) {
            [XKRWCui showInformationHudWithText:@"退出成功"];
            self.groupAuthType = groupAuthNone;
            
            [XKUtil postRefreshGroupTeamInDiscover]; // 通知发现小组变更
            
            if ([[XKRWUserService sharedService].currentGroups containsObject:self.groupItem.groupId]) {
                [[XKRWUserService sharedService].currentGroups removeObject:self.groupItem.groupId];
            }
        }else
        {
            self.groupAuthType = groupAuthNor;
            [XKRWCui showInformationHudWithText:data[@"error"][@"msg"]];
        }
        [self refreshStatus];
    }];
}

- (void)checkAuth
{
    if (![XKUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        return;
    }else{
        [XKRWCui showProgressHud:@""];
        [self downloadWithTaskID:@"checkGroupIdentifyWithGroupId" outputTask:^id{
            return [[XKRWGroupService shareInstance]checkGroupIdentifyWithGroupId:self.groupItem.groupId];}];
    }
}

#pragma mark - core data
// core data insertTeams Num
- (void)setTeamPostNum:(NSString *)teamId andPostNum:(NSInteger) postNum{
    XKRWAppDelegate *appdelegate = (XKRWAppDelegate *)[UIApplication sharedApplication].delegate ;
    
    NSManagedObjectContext *managedObjectContext =   appdelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TeamPostNumEntity"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"teamID = %@ and userID = %d",teamId,[[XKRWUserService sharedService ] getUserId]];
    
    NSArray *resultArray = [managedObjectContext executeFetchRequest:request error:nil];
    
    if(resultArray.count > 0 )
    {
        TeamPostNumEntity *entity  =  [resultArray objectAtIndex:0];
        entity.postNum = [NSNumber numberWithInteger:postNum];
        NSError * savingError = nil;
        if ([managedObjectContext save:&savingError]) {
            NSLog(@"success");
        }else {
            NSLog(@"failed to save the context error = %@", savingError);
        }
        
    }else{
        TeamPostNumEntity *entity  = [NSEntityDescription insertNewObjectForEntityForName:@"TeamPostNumEntity" inManagedObjectContext:appdelegate.managedObjectContext];
        
        if(entity != nil){
            entity.teamID = teamId;
            entity.postNum = [NSNumber numberWithInteger:postNum];
            entity.userID = [NSNumber numberWithInteger:[[XKRWUserService sharedService] getUserId]];
            NSError * savingError = nil;
            if ([managedObjectContext save:&savingError]) {
                NSLog(@"success");
            }else {
                NSLog(@"failed to save the context error = %@", savingError);
            }
        }else{
            NSLog(@"failed to create the new person");
        }
    }
}

#if 1

//core data insert user had read PostId
- (BOOL)insertUserhadreadPostId:(NSString *)postId postName:(NSString *)postName
{
    XKRWAppDelegate *appdelegate = (XKRWAppDelegate *)[UIApplication sharedApplication].delegate ;
    
    
    NSManagedObjectContext *managedObjectContext =   appdelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"UserHadReadPostEntity"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"postID = %@ and userID = %d",postId,[[XKRWUserService sharedService ] getUserId]];
    
    NSArray *resultArray = [managedObjectContext executeFetchRequest:request error:nil];
    
    if(resultArray.count > 0 )
    {
        UserHadReadPostEntity *entity  =  [resultArray objectAtIndex:0];
        entity.postName = postName;
        NSError * savingError = nil;
        if ([managedObjectContext save:&savingError]) {
            NSLog(@"success");
            return YES;
        }else {
            NSLog(@"failed to save the context error = %@", savingError);
            return NO;
        }
        
    }else{
        UserHadReadPostEntity *entity  = [NSEntityDescription insertNewObjectForEntityForName:@"UserHadReadPostEntity" inManagedObjectContext:appdelegate.managedObjectContext];
        
        if(entity != nil){
            entity.postID = postId;
            entity.postName = postName;
            entity.userID = [NSNumber numberWithInteger:[[XKRWUserService sharedService] getUserId]];
            NSError * savingError = nil;
            if ([managedObjectContext save:&savingError]) {
                return YES;
            }else {
                NSLog(@"failed to save the context error = %@", savingError);
                return NO;
            }
        }else{
            NSLog(@"failed to create the new person");
            return NO;
        }
    }

}

#endif

//查询coredata 是否已经阅读过  需要实时，不能一次性查询出来 不能体现实时性
- (BOOL)queryUserhadReadPsotByPostId:(NSString *)postId
{
    XKRWAppDelegate *appdelegate = (XKRWAppDelegate *)[UIApplication sharedApplication].delegate ;
    
    
    NSManagedObjectContext *managedObjectContext =   appdelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"UserHadReadPostEntity"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"postID = %@ and userID = %d",postId,[[XKRWUserService sharedService ] getUserId]];
    
    NSArray *resultArray = [managedObjectContext executeFetchRequest:request error:nil];
    if (resultArray.count > 0) {
        return YES;
    }return NO;
}

#pragma mark - 老版接口回调   四组帖子列表请求用的老版网络层  @see  initItemDataNeedFresh
- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    
    [super handleUploadProblem:problem withTaskID:taskID];
    
    if ([taskID isEqualToString:@"getGroupDetailData"]) {
        [self showRequestArticleNetworkFailedWarningShow];
    }
    if ([taskID isEqualToString:@"getFocusData"]) {
        _isShowFocus = NO;
    }
    
    if ([taskID isEqualToString:@"getNoticeData"]) {
        _isShowFocus = NO;
    }
    
    if ([taskID isEqualToString:@"getAllPostlist"]) {
        self.allPostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
    }else if([taskID isEqualToString:@"getAllPostlistFresh"]){
        self.allPostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
    }
    
    if ([taskID isEqualToString:@"getCtimePostlist"]) {
        self.ctimePostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
    }else if([taskID isEqualToString:@"getCtimePostlistFresh"]){
        self.ctimePostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
    }
    
    if ([taskID isEqualToString:@"getEsencePostlist"]) {
        self.esencePostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
    }else if([taskID isEqualToString:@"getEsencePostlistFresh"]){
        self.esencePostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
    }
    
    if ([taskID isEqualToString:@"getHelpPostlist"]) {
        self.helpPostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
    }else if([taskID isEqualToString:@"getHelpPostlistFresh"]){
        self.helpPostlistPostShowType = postShowNetError; [self refreshTableAfterDelay:.1];
    }
    
    if ([taskID isEqualToString:@"checkGroupIdentifyWithGroupId"]) {
        
    }
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    [XKDispatcher syncExecuteTask:^{
        [XKRWCui hideProgressHud];
        [self endRefresh];
        
        if ([taskID isEqualToString:@"getGroupDetailData"]) {
            
            [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
            if (result) {
                self.groupItem = (XKRWGroupItem *)result;
              
                if (self.groupItem.groupIs_add.integerValue == 1) {
                    self.groupAuthType = groupAuthNor;
                }else self.groupAuthType = groupAuthNone;
                
                [self initUI];
                
                return ;
            }else{
                [self showRequestArticleNetworkFailedWarningShow];
            }
        }
        
        if ([taskID isEqualToString:@"getFocusData"]) {
            if ([(NSMutableArray *)result count]) {
                _isShowFocus = YES;
                __focusDataSource = result;
            } else {
                _isShowFocus = NO;
            }
        }
        
        if ([taskID isEqualToString:@"getNoticeData"]) {
            if ([(NSMutableArray *)result count]) {
                _isShowNotice = YES;
                __noticeDataSource = result;
            } else {
                _isShowNotice = NO;
            }
        }
        
        if ([taskID isEqualToString:@"checkGroupIdentifyWithGroupId"]) { //检验权限
            NSDictionary * _dic = (NSDictionary *)result;
            NSString * success = _dic[@"success"];
            if (success.integerValue == 1) {                    //进入发帖页面
                [MobClick event:@"clk_talk"];
                
                XKRWEditPostVC * vc = [[XKRWEditPostVC alloc]initWithNibName:@"XKRWEditPostVC" bundle:nil];
                vc.groupID = self.groupItem.groupId;
                [self.navigationController presentViewController:[[XKRWNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
            }else{
                [XKRWCui showInformationHudWithText:_dic[@"error"][@"msg"]];
            }
        }
        
        if ([taskID isEqualToString:@"getAllPostlist"]) {
            
            [self setTeamPostNum:self.groupItem.groupId andPostNum:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"GROUPID_%@_%ld",self.groupItem.groupId,(long)[[XKRWUserService sharedService] getUserId]]] integerValue]];
            
            [__allPostDataSource addObjectsFromArray:result];
            if (__allPostDataSource.count >0) {
                self.allPostlistPostShowType = postShowNor;
            }else self.allPostlistPostShowType = postShowNone;
            
        }else if ([taskID isEqualToString:@"getAllPostlistFresh"]) {//刷新
            
            [self setTeamPostNum:self.groupItem.groupId andPostNum:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"GROUPID_%@_%ld",self.groupItem.groupId,(long)[[XKRWUserService sharedService] getUserId]]] integerValue]];
            
            [__allPostDataSource removeAllObjects];
            [__allPostDataSource addObjectsFromArray:result];
            
            if (__allPostDataSource.count >0) {
                self.allPostlistPostShowType = postShowNor;
            }else self.allPostlistPostShowType = postShowNone;
            
        }else if ([taskID isEqualToString:@"getCtimePostlist"]) {
            
            [__ctimePostDataSource addObjectsFromArray:result];
            if (__ctimePostDataSource.count >0) {
                self.ctimePostlistPostShowType = postShowNor;
            }else self.ctimePostlistPostShowType = postShowNone;
            
        }else if ([taskID isEqualToString:@"getCtimePostlistFresh"]) {//刷新
            
            [__ctimePostDataSource removeAllObjects];
            [__ctimePostDataSource addObjectsFromArray:result];
            if (__ctimePostDataSource.count >0) {
                self.ctimePostlistPostShowType = postShowNor;
            }else self.ctimePostlistPostShowType = postShowNone;
            
        }else if ([taskID isEqualToString:@"getEsencePostlist"]) {
            
            [__essencePostDataSource addObjectsFromArray:result];
            if (__essencePostDataSource.count >0) {
                self.esencePostlistPostShowType = postShowNor;
            }else self.esencePostlistPostShowType = postShowNone;
            
        }else if ([taskID isEqualToString:@"getEsencePostlistFresh"]) {//刷新
            
            [__essencePostDataSource removeAllObjects];
            [__essencePostDataSource addObjectsFromArray:result];
            if (__essencePostDataSource.count >0) {
                self.esencePostlistPostShowType = postShowNor;
            }else self.esencePostlistPostShowType = postShowNone;
            
        }else if ([taskID isEqualToString:@"getHelpPostlist"]) {
            
            [__helpPostDataSource addObjectsFromArray:result];
            if (__helpPostDataSource.count >0) {
                self.helpPostlistPostShowType = postShowNor;
            }else self.helpPostlistPostShowType = postShowNone;
            
        }else if ([taskID isEqualToString:@"getHelpPostlistFresh"]) { //刷新
            
            [__helpPostDataSource removeAllObjects];
            [__helpPostDataSource addObjectsFromArray:result];
            if (__helpPostDataSource.count >0) {
                self.helpPostlistPostShowType = postShowNor;
            }else self.helpPostlistPostShowType = postShowNone;
            
        }
        [self refreshTableAfterDelay:.1];
    }];
    
    if ([taskID isEqualToString:@"getFocusAndNoticeDetail"]) {
        __articleWebView.entity = (XKRWOperationArticleListEntity *)result;
        NSDate *date = [NSDate dateFromString:__articleWebView.entity.date];
        BOOL isToday = [date isDayEqualToDate:[NSDate date]];
        __articleWebView.requestUrl = [(XKRWOperationArticleListEntity *)result url];
        if (!isToday) {
            __articleWebView.entity.field_question_value = @"";
        } else {
            __articleWebView.entity.starState = 1;
        }
        __articleWebView.source = eFromToday;
        [self.navigationController pushViewController:__articleWebView animated:YES];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
        
    } else if (section == 1) {
        return _isShowFocus?1:0;
        
    } else if (section == 2) {
        return _isShowNotice?__noticeDataSource.count:0;
        
    }else{
        if (__currentIndex == 0) {
            if (self.allPostlistPostShowType != postShowNor) {
                return 1;
            }else  return __allPostDataSource.count;
        }else if(__currentIndex == 1){
            if (self.ctimePostlistPostShowType != postShowNor) {
                return 1;
            }else return __ctimePostDataSource.count;
        }else if (__currentIndex == 2){
            if (self.esencePostlistPostShowType != postShowNor) {
                return 1;
            }else return __essencePostDataSource.count;
        }else
            if (self.helpPostlistPostShowType != postShowNor) {
                return 1;
            }else return __helpPostDataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
        
    } else if (section == 1) {
        return _isShowFocus ? 10 : 0;
        
    } else if (section == 2) {
        return _isShowNotice ? 10 : 0;
        
    } else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return __scrollButton.frame.size.height;
    }return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || (section == 1 && _isShowFocus) || (section == 2 && _isShowNotice)) { 
        UIView * v = [UIView new];
        v.frame = (CGRect){0, 0, XKAppWidth, 10};
        v.backgroundColor = [UIColor clearColor];
        return v;
    }return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return __scrollButton;
    }return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        GroupHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupHeaderCell class]) forIndexPath:indexPath];
        [cell.headerImageView setImageWithURL:[NSURL URLWithString:self.groupItem.groupIcon] placeholderImage:nil];
        cell.groupName.text = self.groupItem.groupDescription;
        return cell;
        
    }else if (indexPath.section == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"focusCell"];
            cell.contentView.size = CGSizeMake(XKAppWidth, XKAppWidth/5.0);
            [cell.contentView addSubview:__focusView];
        }
        __focusView.dataSource = __focusDataSource;
        __weak typeof(self) weakSelf = self;
        __focusView.adImageClickBlock = ^(XKRWShareAdverEntity *entity) {
            [weakSelf noticeAndFocusPush:entity];
        };
        return cell;
        
    }else if (indexPath.section == 2){
        
        AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnnouncementCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = [__noticeDataSource[indexPath.row] title];
        return cell;
    }
    else{
        
        XKRWPostEntity * item;
        
        if (__currentIndex == 0) {
            
            if (self.allPostlistPostShowType != postShowNor) {
                
                XKRWNonePostTableViewCell *nonePostTableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class]) forIndexPath:indexPath];
                nonePostTableViewCell.handle = ^{
                    [self initItemDataNeedFresh:YES];
                };
                
                if (self.allPostlistPostShowType != postShowNetError) {
                    [nonePostTableViewCell setIsNoneData:YES];
                }else [nonePostTableViewCell setIsNoneData:NO];
                
                nonePostTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return nonePostTableViewCell;
                
            }else{
                
                GroupContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupContentCell class]) forIndexPath:indexPath];
                
                item = __allPostDataSource[indexPath.row];
                
                if (item.is_hot.intValue == 1)
                {
                    UIImage * image = [UIImage imageNamed:@"HOT"];
                    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
                    style.firstLineHeadIndent = image.size.width;
                    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc]initWithString:item.title];
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
                    cell.titleLabel.attributedText = attributedText;
                    cell.hotInddictor.hidden = NO;
                    
                }else{
                    cell.titleLabel.text = item.title;
                    cell.hotInddictor.hidden = YES;
                }
               
                if ([self queryUserhadReadPsotByPostId:item.postid]) {
                    cell.titleLabel.textColor = [UIColor lightGrayColor];
                }else cell.titleLabel.textColor = [UIColor darkGrayColor];
                
                cell.replyLabel.text = [NSString stringWithFormat:@"%@",item.comment_nums];
                [cell setTopIndictor:item.is_top.intValue == 0?YES:NO essenceIndictor:item.is_essence.intValue == 0?YES:NO helpIndictor:item.is_help.intValue == 0?YES:NO hasImageIndictor:item.is_pic.intValue == 0?YES:NO timeLabel:YES];
                cell.creatTimeLabel.text = [XKRWUtil calculateTimeShowStr:item.latest_comment_time.integerValue];
                
                return cell;
            }
            
        }else if (__currentIndex == 1){
            
            if (self.ctimePostlistPostShowType != postShowNor) {
                
                XKRWNonePostTableViewCell *nonePostTableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class]) forIndexPath:indexPath];
                nonePostTableViewCell.handle = ^{
                    [self initItemDataNeedFresh:YES];
                };
                
                if (self.ctimePostlistPostShowType != postShowNetError) {
                    [nonePostTableViewCell setIsNoneData:YES];
                }else [nonePostTableViewCell setIsNoneData:NO];
                
                nonePostTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return nonePostTableViewCell;
            }else{
                
                GroupContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupContentCell class]) forIndexPath:indexPath];
                
                item = __ctimePostDataSource[indexPath.row];
                
                if (item.is_hot.intValue == 1)
                {
                    UIImage * image = [UIImage imageNamed:@"HOT"];
                    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
                    style.firstLineHeadIndent = image.size.width;
                    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc]initWithString:item.title];
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
                    cell.titleLabel.attributedText = attributedText;
                    cell.hotInddictor.hidden = NO;
                }else{
                    
                    cell.titleLabel.text = item.title;
                    cell.hotInddictor.hidden = YES;
                }
                
                if ([self queryUserhadReadPsotByPostId:item.postid]) {
                    cell.titleLabel.textColor = [UIColor lightGrayColor];
                }else cell.titleLabel.textColor = [UIColor darkGrayColor];
                
                cell.replyLabel.text = [NSString stringWithFormat:@"%@",item.comment_nums];
                [cell setTopIndictor:YES essenceIndictor:item.is_essence.intValue == 0?YES:NO helpIndictor:item.is_help.intValue == 0?YES:NO hasImageIndictor:item.is_pic.intValue == 0?YES:NO timeLabel:YES];
                cell.creatTimeLabel.text = [XKRWUtil calculateTimeShowStr:item.create_time.integerValue];
                
                return cell;
            }
        }else if (__currentIndex == 2){
            
            
            if (self.esencePostlistPostShowType != postShowNor) {
                
                XKRWNonePostTableViewCell *nonePostTableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class]) forIndexPath:indexPath];
                nonePostTableViewCell.handle = ^{
                    [self initItemDataNeedFresh:YES];
                };
                
                if (self.esencePostlistPostShowType != postShowNetError) {
                    [nonePostTableViewCell setIsNoneData:YES];
                }else [nonePostTableViewCell setIsNoneData:NO];
                
                nonePostTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return nonePostTableViewCell;
                
            }else{
                
                GroupContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupContentCell class]) forIndexPath:indexPath];
                
                item = __essencePostDataSource[indexPath.row];
                
                if (item.is_hot.intValue == 1)
                {
                    UIImage * image = [UIImage imageNamed:@"HOT"];
                    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
                    style.firstLineHeadIndent = image.size.width;
                    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc]initWithString:item.title];
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
                    cell.titleLabel.attributedText = attributedText;
                    cell.hotInddictor.hidden = NO;
                }else{
                    
                    cell.titleLabel.text = item.title;
                    cell.hotInddictor.hidden = YES;
                }
                
                if ([self queryUserhadReadPsotByPostId:item.postid]) {
                    cell.titleLabel.textColor = [UIColor lightGrayColor];
                }else cell.titleLabel.textColor = [UIColor darkGrayColor];
                
                cell.replyLabel.text = [NSString stringWithFormat:@"%@",item.comment_nums];
                [cell setTopIndictor:YES essenceIndictor:item.is_essence.intValue == 0?YES:NO helpIndictor:item.is_help.intValue == 0?YES:NO hasImageIndictor:item.is_pic.intValue == 0?YES:NO timeLabel:YES];
                cell.creatTimeLabel.text = [XKRWUtil calculateTimeShowStr:item.latest_comment_time.integerValue];
                return cell;
            }
            
        }else{
            
            if (self.helpPostlistPostShowType != postShowNor) {
                
                XKRWNonePostTableViewCell *nonePostTableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class]) forIndexPath:indexPath];
                nonePostTableViewCell.handle = ^{
                    [self initItemDataNeedFresh:YES];
                };
                
                if (self.helpPostlistPostShowType != postShowNetError) {
                    [nonePostTableViewCell setIsNoneData:YES];
                }else [nonePostTableViewCell setIsNoneData:NO];
                
                nonePostTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return nonePostTableViewCell;
                
            }else{
                
                GroupContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupContentCell class]) forIndexPath:indexPath];
                
                item = __helpPostDataSource[indexPath.row];
                
                if (item.is_hot.intValue == 1)
                {
                    UIImage * image = [UIImage imageNamed:@"HOT"];
                    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
                    style.firstLineHeadIndent = image.size.width;
                    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc]initWithString:item.title];
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
                    cell.titleLabel.attributedText = attributedText;
                    cell.hotInddictor.hidden = NO;
                    
                }else{
                    
                    cell.titleLabel.text = item.title;
                    cell.hotInddictor.hidden = YES;
                }
                
                if ([self queryUserhadReadPsotByPostId:item.postid]) {
                    cell.titleLabel.textColor = [UIColor lightGrayColor];
                }else cell.titleLabel.textColor = [UIColor darkGrayColor];
                
                cell.replyLabel.text = [NSString stringWithFormat:@"%@",item.comment_nums];
                [cell setTopIndictor:YES essenceIndictor:item.is_essence.intValue == 0?YES:NO helpIndictor:item.is_help.intValue == 0?YES:NO hasImageIndictor:item.is_pic.intValue == 0?YES:NO timeLabel:YES];
                cell.creatTimeLabel.text = [XKRWUtil calculateTimeShowStr:item.latest_comment_time.integerValue];
                
                return cell;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        GroupHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupHeaderCell class])];
        cell.groupName.text = self.groupItem.groupDescription;
        cell.groupName.preferredMaxLayoutWidth = XKAppWidth - 100;
        __currentHeaderDetail_y = [XKRWUtil  getViewSize:cell.contentView].height + 1.5;
        return __currentHeaderDetail_y;
        
    }else if (indexPath.section == 1) {
        CGFloat height = _isShowFocus ? (XKAppWidth / 5.0) : 0;
        return height;
        
    } else if (indexPath.section == 2) {
        if (_isShowNotice) {
            __announceCaculateCell.titleLabel.text = [__noticeDataSource[indexPath.row] title];
            return __announceCaculateCell.height;
        } else return 0;
    } else {
        XKRWPostEntity * item;
        if (__currentIndex == 0) {
            
            if (self.allPostlistPostShowType!= postShowNor) {
                return XKAppHeight - 170;
            }
            
            item = __allPostDataSource[indexPath.row];
            
        }else if (__currentIndex == 1){
            
            if (self.ctimePostlistPostShowType!= postShowNor) {
                return XKAppHeight - 170;
            }
            
            item = __ctimePostDataSource[indexPath.row];
            
        }else if (__currentIndex == 2){
            
            if (self.esencePostlistPostShowType!= postShowNor) {
                return XKAppHeight - 170;
            }
            
            item = __essencePostDataSource[indexPath.row];
            
        }else{
            
            if (self.helpPostlistPostShowType!= postShowNor) {
                return XKAppHeight - 170;
            }
            
            item = __helpPostDataSource[indexPath.row];
            
        }
        __cacultaHeightCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupContentCell class])];
        __cacultaHeightCell.titleLabel.text = item.title;
        __cacultaHeightCell.titleLabel.preferredMaxLayoutWidth = XKAppWidth - 30;
        float height = [XKRWUtil  getViewSize:__cacultaHeightCell.contentView].height + 1.5 ;
        return height;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[XKRWNonePostTableViewCell class]]) {
        return;
    }
    
    if (indexPath.section == 0) {
        [MobClick event:@"clk_GroupIntroduce"];
        [self changeGroupHeaderDetailStatus];
        
    } else if (indexPath.section == 1) {
        return;
        
    }else if (indexPath.section == 2) {
        [self noticeAndFocusPush:__noticeDataSource[indexPath.row]];
        
    } else if (indexPath.section == 3){
        
        XKRWPostEntity * item;
        
        if (__currentIndex == 0) {
            item = __allPostDataSource[indexPath.row];
        }else if (__currentIndex == 1){
            
            item = __ctimePostDataSource[indexPath.row];
        }else if (__currentIndex == 2){
            item = __essencePostDataSource[indexPath.row];
        }else{
            
            item = __helpPostDataSource[indexPath.row];
        }
        
        //core data insert has postid

        {
           BOOL abool = [self insertUserhadreadPostId:item.postid postName:item.title];
            if (abool) {
                NSLog(@"success.....");
                [self refreshTableAfterDelay:.3];
            }else
                NSLog(@"failed.....");
        }


        
        XKRWPostDetailVC * vc = [XKRWPostDetailVC new];
        vc.postID = item.postid;
        vc.groupItem = self.groupItem;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)noticeAndFocusPush:(XKRWShareAdverEntity *)entity {
    
    if (!entity.type.length) {
        return;
    }
    
    UIViewController *vc;
    if ([entity.type isEqualToString:@"url"]) {
        //web
        vc = [[XKRWNewWebView alloc] init];
        [(XKRWNewWebView *)vc setWebTitle:entity.title];
        [(XKRWNewWebView *)vc setContentUrl:entity.imgUrl];
        BOOL isMall = [entity.imgUrl containsString:@"ssbuy.xikang.com"];
        BOOL isShare = [entity.imgUrl containsString:@"share_url="];
        if (isMall) {
            if (isShare) {
                NSRange range = [entity.imgUrl rangeOfString:@"share_url="];
                [(XKRWNewWebView *)vc setShareURL:[entity.imgUrl substringFromIndex:(range.location + range.length)]];
                
            } else {
                [(XKRWNewWebView *)vc setIsHidenRightNavItem:YES];
                
            }

        } else {
            [(XKRWNewWebView *)vc setShareURL:@""];
            [(XKRWNewWebView *)vc setIsHidenRightNavItem:NO];

        }
        
    } else if ([entity.type isEqualToString:@"share"]) { //瘦身分享
        vc = [[XKRWUserArticleVC alloc] init];
        [(XKRWUserArticleVC *)vc setAid:entity.nid];
        
    } else if ([entity.type isEqualToString:@"post"]) { //帖子
        vc = [XKRWPostDetailVC new];
        [(XKRWPostDetailVC *)vc setPostID:entity.nid];
        [(XKRWPostDetailVC *)vc setGroupItem:self.groupItem];
    } else {
        __articleWebView = [[XKRWArticleWebView alloc] init];
        __articleWebView.hidesBottomBarWhenPushed = YES;
        
        if ([entity.type isEqualToString:@"jfzs"]) {
            __articleWebView.isComplete = self.isCompeleteJfzs;
            [__articleWebView setCategory:eOperationKnowledge];
            
        } else if ([entity.type isEqualToString:@"pkinfo"]) {
            XKRWPKVC *pkVC = [[XKRWPKVC alloc] init];
            pkVC.hidesBottomBarWhenPushed = YES;
            pkVC.nid = entity.nid;
            [self.navigationController pushViewController:pkVC animated:YES];
            return;
            
        } else if ([entity.type isEqualToString:@"lizhi"]) {
            __articleWebView.isComplete = self.isCompeleteLiZhi;
            [__articleWebView setCategory:eOperationEncourage];
            
        } else if ([entity.type isEqualToString:@"ydtj"]) {
            __articleWebView.isComplete = self.isCompeleteYdtj;
            [__articleWebView setCategory:eOperationSport];
            
        }
        [__articleWebView setNavTitle:entity.title];
        [self requestFocusAndNoticeArticleDetail:entity.nid andType:entity.type];
        return;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestFocusAndNoticeArticleDetail:(NSString *)nid andType:(NSString *)type {

    [self downloadWithTaskID:@"getFocusAndNoticeDetail" outputTask:^id{
        return [[XKRWManagementService5_0 sharedService] getArticleDetailFromServerByNid:nid andType:type];
    }];
}

#if 1
#pragma mark - Scroller Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        
        [__backToUpView scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!__groupHeaderDetailView.hidden) {
        __groupHeaderDetailView.hidden = YES;
    }
    if ([scrollView isEqual:self.tableView]) {
        
        [__backToUpView scrollViewDidScroll:scrollView];
    }
}

//停止那一刹那
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        
        [__backToUpView scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.tableView]) {
        
        [__backToUpView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
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
        if (!refreshView.refreshing) {
            
            switch (__currentIndex) {
                case 0:
                {
                    _getAllPostlistPage = 1;
                    //                    [__allPostDataSource removeAllObjects];   不能在此立即清空数据  因滚动tabel 会复用，会获取数据源的数据 造成崩溃
                }
                    break;
                case 1:
                {
                    _getCtimePostlistPage = 1;
                }
                    break;
                case 2:
                {
                    _getEsencePostlistPage = 1;
                }
                    break;
                case 3:{
                    _getHelpPostlistPage = 1;
                }
                    break;
                default:
                    break;
            }
            [self initItemDataNeedFresh:YES];
            
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
            
        }
    } else { //上拉加载
        
        if (!refreshView.refreshing) {
            
            switch (__currentIndex) {
                case 0:
                {
                    _getAllPostlistPage += 1;
                }
                    break;
                case 1:
                {
                    _getCtimePostlistPage += 1;
                }
                    break;
                case 2:
                {
                    _getEsencePostlistPage += 1;
                }
                    break;
                case 3:{
                    _getHelpPostlistPage += 1;
                }
                    break;
                default:
                    break;
            }
            [self initItemDataNeedFresh:NO];
            
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
            
        }
    }
}

- (void)endRefresh {
    
    [_refreshHeaderView endRefreshing];
    [_refreshFooterView endRefreshing];
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

#endif

#endif
@end
