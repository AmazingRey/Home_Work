//
//  XKRWLikeVC.m
//  XKRW
//
//  Created by Shoushou on 16/2/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWLikeVC.h"
#import "MJRefresh.h"
#import "XKRWNonePostTableViewCell.h"
#import "GroupContentCell.h"
#import <XKRW-Swift.h>

@interface XKRWLikeVC ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    //    NSString *_nickName;
    NSMutableArray <XKRWPostEntity *>*_postArray;
    NSMutableArray <XKRWArticleListEntity *>*_fitnessShareArray;
    NSInteger _currentIndex;
    
    NSInteger _page;
    NSInteger _pageTime;
    NSString *_postId;
    GroupContentCell  * __cacultaHeightCell;
    
    BOOL _postNetAvailable;
    BOOL _fitNetAvailable;
}

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) XKRWUIScrollViewBase *tablebgScroller;
@property (nonatomic, strong) XKRWUITableViewBase *postTable;
@property (nonatomic, strong) XKRWUITableViewBase *fitnessShareTable;

@property (nonatomic, strong) MJRefreshHeaderView *postRefreshHeader;
@property (nonatomic, strong) MJRefreshFooterView *postRefreshFooter;
@property (nonatomic, strong) MJRefreshHeaderView *fitnessShareRefreshHeader;
@property (nonatomic, strong) MJRefreshFooterView *fitnessShareRefreshFooter;
@end

@implementation XKRWLikeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.selfType != ShareArticle) {
        self.selfType = LikeArticle;
        self.title = @"喜欢的内容";
    } else {
        _postId = @"0";
        self.title = @"发布的内容";
    }
    
    _postNetAvailable = YES;
    _fitNetAvailable = YES;
    _postArray = [NSMutableArray array];
    _fitnessShareArray = [NSMutableArray array];
    __cacultaHeightCell = [[NSBundle mainBundle] loadNibNamed:@"GroupContentCell" owner:nil options:nil].firstObject;
    _currentIndex = 0;
    self.segmentedControl.selectedSegmentIndex = _currentIndex;
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tablebgScroller];
    [self.tablebgScroller addSubview:self.postTable];
    [self.tablebgScroller addSubview:self.fitnessShareTable];
    
    [self setupRefreshTools];
   
    [XKRWCui showProgressHud:@"加载中"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initDataIfNeedFresh:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [XKRWCui hideProgressHud];
}
- (void)setupRefreshTools
{
    self.postRefreshHeader = [MJRefreshHeaderView header];
    self.postRefreshHeader.scrollView = self.postTable;
    self.postRefreshHeader.delegate = (id)self;
    self.postRefreshFooter = [MJRefreshFooterView footer];
    self.postRefreshFooter.scrollView = self.postTable;;
    self.postRefreshFooter.delegate = (id)self;
    
    self.fitnessShareRefreshHeader = [MJRefreshHeaderView header];
    self.fitnessShareRefreshHeader.scrollView = self.fitnessShareTable;
    self.fitnessShareRefreshHeader.delegate = (id)self;
    self.fitnessShareRefreshFooter = [MJRefreshFooterView footer];
    self.fitnessShareRefreshFooter.scrollView = self.fitnessShareTable;;
    self.fitnessShareRefreshFooter.delegate = (id)self;
    
}

- (void)initDataIfNeedFresh:(BOOL)abool
{
    if (![XKUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        if (_currentIndex == 0) {
            _fitNetAvailable = NO;
            abool ? [_fitnessShareRefreshHeader endRefreshing]:[_fitnessShareRefreshFooter endRefreshing];
            [_fitnessShareTable reloadData];
            
        }else if(_currentIndex == 1){
            _postNetAvailable = NO;
            abool ? [_postRefreshHeader endRefreshing]:[_postRefreshFooter endRefreshing];
            [_postTable reloadData];
        }
        return;
    }
    
    if (_currentIndex == 0) {
        _fitNetAvailable = YES;
        
        _page = (self.selfType == ShareArticle && !abool)?(_fitnessShareArray.count/10+1):0;
        _pageTime = abool?0:(self.selfType == ShareArticle?_fitnessShareArray.lastObject.createTime:_fitnessShareArray.lastObject.praisedTime);
        [self downloadWithTaskID:abool?@"getFitData":@"loadMoreFitData" outputTask:^id{
            
            return [[XKRWUserService sharedService] getUserShareOrLikeInfoFrom:self.nickName andInfoType:self.selfType andpageTime:_pageTime andSize:10 andPage:_page];
        }];
    }else{
        _postNetAvailable = YES;
        if (self.selfType == ShareArticle) {
            
            _postId = abool?0:_postArray.lastObject.postid;
            [self downloadWithTaskID:abool?@"getMyPostData":@"loadMoreMyPost" outputTask:^id{
                return [[XKRWGroupService shareInstance] getMyReportPostWithNickName:self.nickName postId:_postId size:@"10"];
            }];
        } else {
            
            _pageTime = abool?0:_postArray.lastObject.praiseTime;
            [self downloadWithTaskID:abool?@"getPostData":@"loadMorePostData" outputTask:^id{
                return [[XKRWUserService sharedService] getUserShareOrLikeInfoFrom:self.nickName andInfoType:postLikeArticle andpageTime:_pageTime andSize:10 andPage:0];
            }];
        }
        
    }
}

#pragma mark -- NetWork

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [XKRWCui hideProgressHud];
    
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"getFitData"]) {
        [_fitnessShareRefreshHeader endRefreshing];
        _fitnessShareArray = [[XKRWManagementService5_0 sharedService] dealDataArrayToArticleListEntityArray:result[@"data"]];

    } else if ([taskID isEqualToString:@"loadMoreFitData"]) {
        [_fitnessShareRefreshFooter endRefreshing];
        [_fitnessShareArray addObjectsFromArray:[[XKRWManagementService5_0 sharedService] dealDataArrayToArticleListEntityArray:result[@"data"]]];
    }
    
    if ([taskID isEqualToString:@"getPostData"]) {
        [_postRefreshHeader endRefreshing];
        _postArray = [NSMutableArray arrayWithArray:[self dataToPostEntitys:result[@"data"]]];
    } else if ([taskID isEqualToString:@"loadMorePostData"]) {
        [_postRefreshFooter endRefreshing];
        [_postArray addObjectsFromArray:[self dataToPostEntitys:result[@"data"]]];
    }
    
    if ([taskID isEqualToString:@"getMyPostData"]) {
        [_postRefreshHeader endRefreshing];
        _postArray = (NSMutableArray *)result;
    } else if ([taskID isEqualToString:@"loadMoreMyPost"]) {
        [_postRefreshFooter endRefreshing];
        [_postArray addObjectsFromArray:result];
    }
    
    if (_currentIndex == 0) {
        _fitnessShareRefreshFooter.hidden = (_fitnessShareArray.count % 10) ? YES:NO;
        [_fitnessShareTable reloadData];
    } else {
        _postRefreshFooter.hidden = (_postArray.count % 10) ? YES:NO;
        [_postTable reloadData];
    }
}

#pragma mark -- Refresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    BOOL isRefresh = [refreshView isKindOfClass:[MJRefreshHeaderView class]];
        
    [self initDataIfNeedFresh:isRefresh];
}

#pragma mark -- Cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:_fitnessShareTable] && _fitnessShareArray.count) {
        return _fitnessShareArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_postTable] && _postArray.count) {
        return _postArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_postTable]) {
        
        if (!_postArray.count) {
            XKRWNonePostTableViewCell *nonePostTableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class]) forIndexPath:indexPath];
            nonePostTableViewCell.handle = ^{
                [self initDataIfNeedFresh:YES];
            };
            
            if (!_postNetAvailable) {
                [nonePostTableViewCell setIsNoneData:NO];
            }else [nonePostTableViewCell setIsNoneData:YES];
            
            nonePostTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return nonePostTableViewCell;
            
        }else{
            GroupContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
            cell.hotInddictor.hidden = YES;
            
            XKRWPostEntity * item = _postArray[indexPath.row];
            [cell setTopIndictor:YES essenceIndictor:YES helpIndictor:YES hasImageIndictor:YES timeLabel:YES];
            
            cell.titleLabel.text = item.title;
            cell.replyLabel.text = [NSString stringWithFormat:@"%@",item.comment_nums];
            
            if (self.selfType == ShareArticle) {
                cell.creatTimeLabel.text = [NSString stringWithFormat:@"更新于 %@",[XKRWUtil calculateTimeShowStr:item.latest_comment_time.integerValue]];
                
            } else {
                cell.creatTimeLabel.text = [NSString stringWithFormat:@"发布于 %@",[XKRWUtil calculateTimeShowStr:item.create_time.integerValue]];
            }
            if (item.del_status != 1 && self.selfType == LikeArticle) {
                cell.titleLabel.text = @"此帖子已删除";
                cell.creatTimeLabel.text = @"";
                cell.replyTitleLabel.hidden = YES;
                cell.replyLabel.text = @"";
            }
            
            return cell;
        }
        
        
    } else if ([tableView isEqual:_fitnessShareTable]) {
        
        if (!_fitnessShareArray.count) {
            
            XKRWNonePostTableViewCell *nonePostTableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWNonePostTableViewCell class]) forIndexPath:indexPath];
            nonePostTableViewCell.handle = ^{
                [self initDataIfNeedFresh:YES];
            };
            
            if (!_fitNetAvailable) {
                [nonePostTableViewCell setIsNoneData:NO];
            }else [nonePostTableViewCell setIsNoneData:YES];
            
            nonePostTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return nonePostTableViewCell;
            
        } else {
            XKRWFitnessShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fitnessShareCell" forIndexPath:indexPath];
           
            XKRWArticleListEntity *entity = _fitnessShareArray[indexPath.section];

            typeof(self) __weak weakSelf = self;
            XKRWFitnessShareCellStyle fitStyle = (self.selfType == ShareArticle)? othersShareArticle:likeArticle;
            [cell setContentWithEntity:entity style:fitStyle andSuperVC:weakSelf];
            cell.bgButton.tag = indexPath.section;
            [cell.bgButton addTarget:self action:@selector(pushToUserArticleVC:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_postTable]) {
        if (!_postArray.count) {
            return XKAppHeight - 114;
        } else {
            XKRWPostEntity * item = _postArray[indexPath.row];
            
            __cacultaHeightCell = [tableView dequeueReusableCellWithIdentifier:@"postCell"];
            __cacultaHeightCell.titleLabel.text = item.title;
            __cacultaHeightCell.titleLabel.preferredMaxLayoutWidth = XKAppWidth - 14;
            
            float height = [XKRWUtil  getViewSize:__cacultaHeightCell.contentView].height + 1.5 ;
            
            return height;
        }
        
    } else if ([tableView isEqual:_fitnessShareTable]) {
        if (!_fitnessShareArray.count) {
            return XKAppHeight - 114;
        } else if (_fitnessShareArray[indexPath.section].articleState != XKRWUserArticleStatusDeleteByUser && _fitnessShareArray[indexPath.section].articleState != XKRWUserArticleStatusDeleteByAdmin){
            return XKAppWidth * 9.0 / 16.0 + 35;
        } else {
            return XKAppWidth * 9.0 / 16.0;
        }
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([tableView isEqual:_fitnessShareTable]) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
        footer.backgroundColor = XKClearColor;
        return footer;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView isEqual:_fitnessShareTable]) {
        return 10;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[XKRWNonePostTableViewCell class]]) {
        return;
    }
    
    if ([tableView isEqual:self.postTable]) {
        XKRWPostDetailVC * vc = [[XKRWPostDetailVC alloc]initWithNibName:@"XKRWPostDetailVC" bundle:nil];
        vc.postID = _postArray[indexPath.row].postid;
        if (_postArray[indexPath.row].del_status != 1 && self.selfType == LikeArticle ) {
            vc.postDeleted = YES;
        }
        if (!self.nickName || [self.nickName isEqualToString:[[XKRWUserService sharedService] getUserNickName]]) {
            vc.likePostDeleted = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        return;
    }
}
- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"瘦身分享",@"帖子"]];
        _segmentedControl.frame = (CGRect){15, 10, XKAppWidth - 30, 30};
        _segmentedControl.tintColor = XKMainSchemeColor;
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)segmentedControlIndexChanged:(UISegmentedControl *)segmentCtl {
    _currentIndex = segmentCtl.selectedSegmentIndex;
    _pageTime = 0;
    [self.tablebgScroller scrollRectToVisible:CGRectMake(XKAppWidth*_currentIndex, 0, XKAppWidth, _tablebgScroller.height) animated:NO];
    
    if (_currentIndex == 0) {
        _postTable.scrollsToTop = NO;
        _fitnessShareTable.scrollsToTop = YES;
        
        if (_fitnessShareArray.count == 0) [self initDataIfNeedFresh:YES];
        
    } else {
        _postTable.scrollsToTop = YES;
        _fitnessShareTable.scrollsToTop = NO;
        
        if (_postArray.count == 0) [self initDataIfNeedFresh:YES];
        
    }
 
    
}

- (XKRWUIScrollViewBase *)tablebgScroller
{
    if (!_tablebgScroller) {
        _tablebgScroller = [[XKRWUIScrollViewBase alloc]initWithFrame:CGRectMake(0, _segmentedControl.bottom + 10, XKAppWidth , XKAppHeight - 50 - 64)];
        _tablebgScroller.backgroundColor = XKClearColor;
        _tablebgScroller.contentSize = CGSizeMake(XKAppWidth*2, _tablebgScroller.height);
        _tablebgScroller.pagingEnabled = YES;
        _tablebgScroller.scrollEnabled = NO;
    }
    return _tablebgScroller;
}


- (XKRWUITableViewBase *)postTable
{
    if (!_postTable) {
        _postTable = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(XKAppWidth, 0, XKAppWidth, _tablebgScroller.height) style:UITableViewStylePlain];
        _postTable.delegate = (id)self;
        _postTable.dataSource = (id)self;
        _postTable.backgroundColor = XKClearColor;
        _postTable.scrollsToTop = NO;
        _postTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_postTable registerNib:[UINib nibWithNibName:@"GroupContentCell" bundle:nil] forCellReuseIdentifier:@"postCell"];
        [_postTable registerNib:[UINib nibWithNibName:@"XKRWNonePostTableViewCell" bundle:nil] forCellReuseIdentifier:@"XKRWNonePostTableViewCell"];
    }
    return _postTable;
}


- (XKRWUITableViewBase *)fitnessShareTable
{
    if (!_fitnessShareTable) {
        _fitnessShareTable = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, _tablebgScroller.height) style:UITableViewStylePlain];
        _fitnessShareTable.delegate = (id)self;
        _fitnessShareTable.dataSource = (id)self;
        _fitnessShareTable.backgroundColor = XKClearColor;
        _fitnessShareTable.scrollsToTop = YES;
        _fitnessShareTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_fitnessShareTable registerNib:[UINib nibWithNibName:@"XKRWFitnessShareCell" bundle:nil] forCellReuseIdentifier:@"fitnessShareCell"];
        [_fitnessShareTable registerNib:[UINib nibWithNibName:@"XKRWNonePostTableViewCell" bundle:nil] forCellReuseIdentifier:@"XKRWNonePostTableViewCell"];
    }
    return _fitnessShareTable;
}

- (void)pushToUserArticleVC:(UIButton *)sender {
    
    XKRWUserArticleVC *articleVC = [[XKRWUserArticleVC alloc] init];
    XKRWArticleListEntity *entity = _fitnessShareArray[sender.tag];
    if (self.nickName == nil || [self.nickName isEqualToString:[[XKRWUserService sharedService] getUserNickName]]) {
        articleVC.likeArticleDeleted = YES;
    }
    articleVC.aid = entity.blogId;
    [self.navigationController pushViewController:articleVC animated:YES];
}

- (void)dealloc
{
    [self.postRefreshHeader free];
    [self.postRefreshFooter free];
    [self.fitnessShareRefreshHeader free];
    [self.fitnessShareRefreshFooter free];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -DataDeal
- (NSArray *)dataToPostEntitys:(NSArray *)dataArray {
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary * temp in dataArray) {
        XKRWPostEntity *item = [XKRWPostEntity new];
        item.avatar = temp[@"avatar"];
        item.comment_nums = temp[@"comment_nums"];
        item.create_time = temp[@"create_time"];
        item.praiseTime = [temp[@"good_time"] integerValue];
        item.goods = temp[@"goods"];
        item.level = temp[@"level"];
        item.manifesto = temp[@"manifesto"];
        item.nickname = temp[@"nickname"];
        item.postid = temp[@"postid"];
        item.title = temp[@"title"];
        item.views = temp[@"views"];
        item.del_status = [temp[@"del_status"] integerValue];
        [mutArray addObject:item];
    }
    return mutArray;
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
