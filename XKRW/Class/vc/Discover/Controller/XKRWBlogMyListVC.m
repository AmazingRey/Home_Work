//
//  XKRWBlogMyListVC.m
//  XKRW
//
//  Created by Shoushou on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBlogMyListVC.h"
#import "XKRW-Swift.h"
#import "MJRefreshFooterView.h"
#import "XKRWFitnessShareCell.h"
#import "XKRWNonArticleCell.h"

@interface XKRWBlogMyListVC ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    SCBackToUpView    * mineBackView;
}
@property (nonatomic, strong) MJRefreshFooterView *footerRefreshView;

@property (nonatomic, strong) NSMutableArray *myArticleArray;
@property (nonatomic, strong) NSMutableArray *myArticleDBArray;
@property (nonatomic, strong) NSMutableArray *draftMutArray; // “我的分享”草稿文章数组
@property (nonatomic, assign) NSInteger draftNum; // “我的分享”草稿数
@end

@implementation XKRWBlogMyListVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _draftMutArray = [NSMutableArray array];
    _myArticleArray = [NSMutableArray array];
    _myArticleDBArray = [NSMutableArray array];
    
    _myArticleTable = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64) style:UITableViewStylePlain];
    _myArticleTable.delegate = self;
    _myArticleTable.dataSource = self;
    _myArticleTable.backgroundColor = XKClearColor;
    _myArticleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myArticleTable registerNib:[UINib nibWithNibName:@"XKRWFitnessShareCell" bundle:nil] forCellReuseIdentifier:@"fitnessShareCell"];
    [_myArticleTable registerNib:[UINib nibWithNibName:@"XKRWNonArticleCell" bundle:nil] forCellReuseIdentifier:@"nonArticleCell"];
    [self.view addSubview:_myArticleTable];
    
    mineBackView = ({
        SCBackToUpView *back = [[SCBackToUpView alloc] initShowInSomeViewSize:CGSizeMake(XKAppWidth, XKAppHeight) minitor:_myArticleTable withImage:@"group_backtotop"];
        back.backOffsettY = XKAppHeight;
        back;
    });
    [self.view addSubview:mineBackView];
    
    self.footerRefreshView = [MJRefreshFooterView footer];
    _footerRefreshView.scrollView = _myArticleTable;
    _footerRefreshView.delegate = self;
    
    [MobClick event:@"in_SlimmingShare"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData {
    
    if ([XKRWUtil isNetWorkAvailable]) {
        [self downloadWithTaskID:@"downLoadMyArticleList" outputTask:^id{
            return [[XKRWUserArticleService shareService] getUserArticleListWithNickName:nil page:1 pagesize:10];
        }];
        
    } else {
        [self getMyArticleArrayFromDB];
    }
    
}

- (void)clearMyArticleArray {
    [_myArticleArray removeAllObjects];
    [_draftMutArray removeAllObjects];
    [_myArticleDBArray removeAllObjects];
}

/**<无网络请求时数据库*/
- (void)getMyArticleArrayFromDB {
    
    [self clearMyArticleArray];
    [self.draftMutArray addObjectsFromArray:[[XKRWUserArticleService shareService] getUserArticleDraft]];
    _draftNum = self.draftMutArray.count;
    for (XKRWUserArticleEntity* entity in self.draftMutArray) {
        [self.myArticleArray addObject:[entity convertToListEntity]];
    }
    [self.myArticleArray addObjectsFromArray: [[XKRWUserArticleService shareService] getAllLocalUserArticles]];
    
    for (XKRWUserArticleEntity *entity in [[XKRWUserArticleService shareService] getAllLocalUserArticles]) {
        [_myArticleDBArray addObject:[entity convertToListEntity]];
    }
    [_myArticleTable reloadData];
}

- (void)reLoadDataFromNetwork:(UIButton *)button {
    [self initData];
}

#pragma mark - Networking

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [super handleUploadProblem:problem withTaskID:taskID];

    if ([taskID isEqualToString:@"downLoadMyArticleList"]) {
        [self getMyArticleArrayFromDB];
    } else if ([taskID isEqualToString:@"loadMoreMyArticle"] && _footerRefreshView.refreshing) {
        [_footerRefreshView endRefreshing];
    }
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    if ([taskID isEqualToString:@"downLoadMyArticleList"]) {
        if (result[@"success"]) {
            [self clearMyArticleArray];
            [self.draftMutArray addObjectsFromArray:[[XKRWUserArticleService shareService] getUserArticleDraft]];
            for (XKRWUserArticleEntity *entity in self.draftMutArray) {
                [self.myArticleArray addObject:[entity convertToListEntity]];
            }
            [self.myArticleArray addObjectsFromArray:result[@"data"]];
            if ([(NSArray *)result[@"data"] count]%10 || (!result[@"data"])) {
                _footerRefreshView.hidden = YES;
            } else {
                _footerRefreshView.hidden = NO;
            }
            self.draftNum = self.draftMutArray.count;
            [_myArticleTable reloadData];
        } else {
            [self initData];
        }
        
    } else if ([taskID isEqualToString:@"loadMoreMyArticle"]) {
        
        if (result[@"success"]) {
            if ([(NSArray *)result[@"data"] count]%10 || (!result[@"data"])) {
                _footerRefreshView.hidden = YES;
            } else {
                _footerRefreshView.hidden = NO;
            }
            [self.myArticleArray addObjectsFromArray:result[@"data"]];
            [_footerRefreshView endRefreshing];
            [_myArticleTable reloadData];
        } else {
            [_footerRefreshView endRefreshing];
        }
        
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (_myArticleArray.count == 0) {
            _footerRefreshView.hidden = YES;
            XKRWNonArticleCell *noArticleCell = [tableView dequeueReusableCellWithIdentifier:@"nonArticleCell"];
            if (!noArticleCell) {
                noArticleCell = (XKRWNonArticleCell *)[[[NSBundle mainBundle] loadNibNamed:@"XKRWNonArticleCell" owner:self options:nil] lastObject];
            }
            noArticleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView * topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
            topline.backgroundColor = XKSepDefaultColor;
            UIView * bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, noArticleCell.editUserArticleBtn.height-.5, XKAppWidth, 0.5)];
            bottomline.backgroundColor = XKSepDefaultColor;
            [noArticleCell.editUserArticleBtn addSubview:topline];
            [noArticleCell.editUserArticleBtn addSubview:bottomline];
            [noArticleCell.editUserArticleBtn addTarget:self action:@selector(editArticleItemClicked) forControlEvents:UIControlEventTouchUpInside];
            [noArticleCell.editUserArticleBtn setBackgroundImage:[UIImage createImageWithColor:RGB(217, 217, 217, 1)] forState:UIControlStateHighlighted];
            
            UIImage * image = [UIImage imageNamed:@"myArticle"];
            UIImageView * aback = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppWidth*(image.size.height/image.size.width))];
            aback.image = image;
            [noArticleCell insertSubview:aback atIndex:0];
            return noArticleCell;
            
        } else {
            XKRWFitnessShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fitnessShareCell" forIndexPath:indexPath];
            cell.bgButton.tag = indexPath.section;
            [cell.bgButton addTarget:self action:@selector(pushToUserArticleVC:) forControlEvents:UIControlEventTouchUpInside];
            
            XKRWArticleListEntity *entity;
            if ([_myArticleArray[indexPath.section] isKindOfClass:[XKRWUserArticleEntity class]]) {
                entity = _myArticleDBArray[indexPath.section - _draftNum];
            } else {
                entity = _myArticleArray[indexPath.section];
            }
            
            typeof(self) __weak weakSelf = self;
            if (indexPath.section >= _draftNum) {
                [cell setContentWithEntity:entity style:myArticle andSuperVC:weakSelf];
            } else {
                [cell setContentWithEntity:entity style:myDraft andSuperVC:weakSelf];
            }
            return cell;
        }
   
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (void)pushToUserArticleVC:(UIButton *)sender {
    if (self.myArticleArray.count != 0) {
        if (sender.tag < self.draftNum) { // 草稿 -> 编辑VC
            XKRWArticleEditVC* articleEditVC = [[XKRWArticleEditVC alloc] init];
            articleEditVC.articleEntity = self.draftMutArray[sender.tag];
            [articleEditVC.articleEntity loadLocalImageCache];
            [self.navigationController pushViewController:articleEditVC animated:YES];
            
        } else { // 已发布 -> 查看文章时可删除
            XKRWUserArticleVC *articleVC = [[XKRWUserArticleVC alloc] init];
            articleVC.showDeleteButton = NO;
            
            if ([self.myArticleArray[sender.tag] isKindOfClass:[XKRWUserArticleEntity class]]) { // 无网 -> 预览状态
                articleVC.isPreview = YES;
                articleVC.articleEntity = self.myArticleArray[sender.tag];
                
            } else if ([self.myArticleArray[sender.tag] articleState] == XKRWUserArticleStatusDeleteByAdmin) { // 有网被管理员删除 -> 预览状态
                articleVC.isPreview = YES;
                articleVC.aid = [(XKRWArticleListEntity *)self.myArticleArray[sender.tag] blogId];
            } else { // 有网，正常已发布文章
                articleVC.aid = [(XKRWArticleListEntity *)self.myArticleArray[sender.tag] blogId];
            }
            [self.navigationController pushViewController:articleVC animated:YES];
        }
        
    }
 
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_myArticleArray.count) {
        return _myArticleArray.count;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    headerView.backgroundColor = XKClearColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myArticleArray.count == 0) {
        UIImage * image = [UIImage imageNamed:@"myArticle"];
        return XKAppWidth*(image.size.height/image.size.width) + 52;
        
    } else if (indexPath.section < _draftNum) {
        return XKAppWidth * 9.0 / 16.0;
    }
    
    return XKAppWidth * 9.0 / 16.0 + 35;
}

#pragma mark --MJRefreshDelegate

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    
    if (![XKRWUtil isNetWorkAvailable]) {
            [XKRWCui showInformationHudWithText:@"没有网络无法加载哦~"];
        [refreshView endRefreshing];
        return;
    }
    
    if (!refreshView.refreshing) {
        NSInteger page = self.myArticleArray.count/10 + 1;
        [self downloadWithTaskID:@"loadMoreMyArticle" outputTask:^id{
            return [[XKRWUserArticleService shareService] getUserArticleListWithNickName:nil page:page pagesize:10];
        }];
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
    }
}

- (void)endRefresh {
    
    //刷新结束，重载tableView数据
}

#pragma mark - UIScroller delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_myArticleTable]){
        [mineBackView scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_myArticleTable]){
        [mineBackView scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_myArticleTable]){
        [mineBackView scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:_myArticleTable]){
        [mineBackView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_footerRefreshView free];
    _footerRefreshView = nil;
}

#pragma mark - Action
- (void)editArticleItemClicked {
    [MobClick event:@"clk_WriteShare"];
    XKRWArticleEditVC *vc = [[XKRWArticleEditVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
