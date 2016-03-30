//
//  XKRWRecommendListVC.m
//  XKRW
//
//  Created by Shoushou on 16/1/20.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecommendListVC.h"
#import "XKRW-Swift.h"
#import "XKRWIntelligentListVC.h"
#import "MJRefresh.h"
#import "XKRWFitnessShareCell.h"
#import "XKRWIntelligentListEnterCell.h"
#import "XKRWTopicListView.h"

@interface XKRWRecommendListVC ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate, XKRWTopicListViewDelegate>
{
    SCBackToUpView *recomendBackView;
    XKRWIntelligentListEnterCell *_intelligentListEnterCell;
}
@property (nonatomic, strong) MJRefreshHeaderView *refreshHeader;
@property (nonatomic, strong) MJRefreshFooterView *refreshFooter;
@property (nonatomic, strong) XKRWTopicListView *topicListView;
@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic, strong) NSMutableArray *topicTitles;
@property (nonatomic, strong) NSDictionary *rankListDic;
@property (nonatomic, assign) BOOL isTopicList;
@end

@implementation XKRWRecommendListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64) style:UITableViewStylePlain];
    self.tableView.scrollsToTop = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XKRWFitnessShareCell" bundle:nil] forCellReuseIdentifier:@"fitnessShareCell"];
    _intelligentListEnterCell = [[NSBundle mainBundle] loadNibNamed:@"XKRWIntelligentListEnterCell" owner:nil  options:nil].firstObject;
    [self.view addSubview:self.tableView];
    
    _topicListView = [[XKRWTopicListView alloc] init];
    _topicListView.delegate = self;
    
    self.refreshHeader = [MJRefreshHeaderView header];
    self.refreshHeader.delegate = self;
    self.refreshHeader.scrollView = self.tableView;
    
    self.refreshFooter = [MJRefreshFooterView footer];
    self.refreshFooter.delegate = self;
    self.refreshFooter.scrollView = self.tableView;
    
    _dataArray = [NSMutableArray array];
    recomendBackView = ({
        SCBackToUpView *back = [[SCBackToUpView alloc] initShowInSomeViewSize:CGSizeMake(XKAppWidth, XKAppHeight) minitor:self.tableView withImage:@"group_backtotop"];
        back.backOffsettY = XKAppHeight;
        back;
    });
    [self.view addSubview:recomendBackView];
    
    [self initOnlyRankListData:NO];
    [self showTip];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initOnlyRankListData:YES];
}

- (void)dealloc {
    [self.refreshHeader free];
    self.refreshHeader = nil;

    [self.refreshFooter free];
    self.refreshFooter = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initOnlyRankListData:(BOOL)abool {
    
    if ([XKRWUtil isNetWorkAvailable]) {
        [self hiddenRequestArticleNetworkFailedWarningShow];
        
        if (!abool) {
            [self downloadWithTaskID:@"recommend_refresh" outputTask:^id{
                return [[XKRWManagementService5_0 sharedService] getBlogRecommendFromServerWithPage:@(1)];
            }];
            
            [self downloadWithTaskID:@"getTopicList" outputTask:^id{
                return [[XKRWUserArticleService shareService] getTopicList];
            }];
        }
        
        [self downloadWithTaskID:@"getRankList" outputTask:^id{
            return [[XKRWManagementService5_0 sharedService] getBlogRankListFromServer];
        }];
       
    } else {
        [self showRequestArticleNetworkFailedWarningShow];
    }
}
- (void)reLoadDataFromNetwork:(UIButton *)sender {
    [self hiddenRequestArticleNetworkFailedWarningShow];
    
    [self initOnlyRankListData:NO];
}
- (void)showTip {
    // 判断用户是否第一次进入此界面（是：显示提示tips 否：不显示tip）
    NSString *key = [NSString stringWithFormat:@"XKRWFitnessShareVC_%ld",(long)[XKRWUserDefaultService getCurrentUserId]];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:key] && [self.navigationItem.title isEqualToString:@"瘦身分享"]) {
        [defaults setValue:@YES forKey:key];
        [defaults synchronize];
        
        KMHeaderTips *tips = [[KMHeaderTips alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 64) text:@"点击“写分享”来分享你的瘦身故事。精彩的故事会被哦！~" type:KMHeaderTipsTypeDefault];
        [self.view addSubview:tips];
        [tips startAnimationWithStartOrigin:CGPointMake(0, -tips.height) endOrigin:CGPointMake(0, 0)];
    }
}


#pragma mark - Networking

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [super handleUploadProblem:problem withTaskID:taskID];
    
    if ([taskID isEqualToString:@"recommend_refresh"]) {
        [self showRequestArticleNetworkFailedWarningShow];
    }
    if (_refreshFooter.refreshing) {
        [_refreshFooter endRefreshing];
    }
    if (_refreshHeader.refreshing) {
        [_refreshHeader endRefreshing];
    }
    
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    if ([taskID isEqualToString:@"getTopicList"]) {
        self.topics = [self disorderArray:(NSArray *)result];
        NSMutableArray *array = [NSMutableArray array];
        for (XKRWTopicEntity *entity in self.topics) {
            [array addObject:entity.name];
        }
        self.topicTitles = array;
        [self.topicListView setViewTitles:self.topicTitles];
        typeof(self) __weak weakSelf = self;
        self.topicListView.foldCell.foldCellClicked = ^(){
            [MobClick event:@"in_TopicAll"];
            [weakSelf.tableView reloadData];
        };
        [self.tableView reloadData];
        
    } else if ([taskID isEqualToString:@"getRankList"]) {
        self.rankListDic = result;
        [_intelligentListEnterCell IntelligentListIsNew:_rankListDic[@"week_start"]];
        [self.tableView reloadData];
        
    } else if ([taskID isEqualToString:@"recommend_loadMore"]) {
        if ([result count] == 0 || [result count] != 10) {
            self.refreshFooter.hidden = YES;
        } else {
            self.refreshFooter.hidden = NO;
        }
        [_dataArray addObjectsFromArray:result];
        [self.tableView reloadData];
        [_refreshFooter endRefreshing];
        
    } else if ([taskID isEqualToString:@"recommend_refresh"]) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:result];
        if ([result count] == 0 || [result count] != 10) {
            self.refreshFooter.hidden = YES;
        } else {
            self.refreshFooter.hidden = NO;
            [self hiddenRequestArticleNetworkFailedWarningShow];
        }
        [self.refreshHeader endRefreshing];
        [self.tableView reloadData];
        
    }
}

#pragma mark - MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    
    if ([refreshView isEqual:_refreshFooter]) {
        NSNumber *page = [NSNumber numberWithInteger:_dataArray.count/10 + 1];
        [self downloadWithTaskID:@"recommend_loadMore" outputTask:^id{
            return [[XKRWManagementService5_0 sharedService] getBlogRecommendFromServerWithPage:page];
        }];
        
    } else {
        [self initOnlyRankListData:NO];
    }
}

#pragma mark - Cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [_intelligentListEnterCell setContentWithArray:_rankListDic[@"entityArray"]];
        return _intelligentListEnterCell;
        
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicListCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topicListCell"];
            [cell.contentView addSubview:self.topicListView];
        }
        return cell;
        
    } else {
        XKRWFitnessShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fitnessShareCell" forIndexPath:indexPath];
        cell.bgButton.tag = indexPath.section;
        [cell.bgButton addTarget:self action:@selector(pushToUserArticleVC:) forControlEvents:UIControlEventTouchUpInside];
        
        XKRWArticleListEntity *entity = _dataArray.count > (indexPath.section - 2) ? _dataArray[indexPath.section - 2]:[XKRWArticleListEntity new];
        typeof(self) __weak weakSelf = self;
        [cell setContentWithEntity:entity style:recommendArticle andSuperVC:weakSelf];
        return cell;
        
    }
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        XKRWIntelligentListVC *vc = [[XKRWIntelligentListVC alloc] init];
        [_intelligentListEnterCell XKRWIntelligentListEnterCellClicked];
        vc.rankDictionary = self.rankListDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushToUserArticleVC:(UIButton *)sender {
    
    XKRWUserArticleVC *articleVC = [[XKRWUserArticleVC alloc] init];
    XKRWArticleListEntity *entity = _dataArray[sender.tag - 2];
    articleVC.aid = entity.blogId;
    [self.navigationController pushViewController:articleVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count + 2;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    footer.backgroundColor = XKClearColor;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 60;
        
    } else if (indexPath.section == 1) {
        return _topicListView.height;
        
    } else {
        return XKAppWidth * 9.0 / 16.0 + 35;
    }
}

#pragma mark - UIScroller delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        [recomendBackView scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        [recomendBackView scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        [recomendBackView scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.tableView]) {
        [recomendBackView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark - XKRWTopicListViewDelegate

- (void)topicListView:(XKRWTopicListView *)topicListView didSelectItemAtIndex:(NSInteger)index {
    if (index <= 3) {
        NSString *eventName = [NSString stringWithFormat:@"in_topic%ld",(long)(index + 1)];
        [MobClick event:eventName];
    }
    NSNumber *topicId = [NSNumber numberWithInteger:((XKRWTopicEntity *)_topics[index]).topicId];
    XKRWTopicVC *topicVC = [[XKRWTopicVC alloc] init];
    topicVC.topicId = topicId;
    topicVC.topicStr = ((XKRWTopicEntity *)_topics[index]).name;
    [self.navigationController pushViewController:topicVC animated:YES];
}

#pragma mark - topicsDisorder
- (NSMutableArray *)disorderArray:(NSArray *)array {
    NSMutableArray *mutArray = [NSMutableArray arrayWithArray:array];
    NSInteger i = array.count;
    while (--i>0) {
        NSInteger index = rand()%(i+1);
        [mutArray exchangeObjectAtIndex:index withObjectAtIndex:i];
        
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
