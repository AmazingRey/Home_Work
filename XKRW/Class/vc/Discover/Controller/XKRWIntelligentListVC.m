//
//  XKRWIntelligentListVC.m
//  XKRW
//
//  Created by Shoushou on 16/1/13.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWIntelligentListVC.h"
#import "XKRW-Swift.h"
#import "XKRWManagementService5_0.h"
#import "XKRWIntelligentListCell.h"
#import "XKRWReceiveLikeNumCell.h"
#import "XKRWIntelligentListHeader.h"
#import "XKRWExplainView.h"
#import "MJRefreshHeaderView.h"

@interface XKRWIntelligentListVC ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate>

@property (nonatomic, strong) XKRWUITableViewBase *tableView;
@property (nonatomic, strong) MJRefreshHeaderView *refreshHeader;
@end

@implementation XKRWIntelligentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"分享达人榜";
    
    [self initData];
    
    self.view.backgroundColor = XKBGDefaultColor;
    self.tableView = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = XKBGDefaultColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    XKRWIntelligentListHeader *header = [[NSBundle mainBundle] loadNibNamed:@"XKRWIntelligentListHeader" owner:nil options:nil].lastObject;
    [header setStartTime:_rankDictionary[@"week_start"] endTime:_rankDictionary[@"week_end"]];
    self.tableView.tableHeaderView = header;
    [self.tableView registerNib:[UINib nibWithNibName:@"XKRWIntelligentListCell" bundle:nil] forCellReuseIdentifier:@"intelligentListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XKRWReceiveLikeNumCell" bundle:nil] forCellReuseIdentifier:@"receiveLikeNumCell"];
    [self.view addSubview:self.tableView];
    
    self.refreshHeader = [MJRefreshHeaderView header];
    self.refreshHeader.scrollView = self.tableView;
    self.refreshHeader.delegate = self;
    
}

- (void)initData {
    
    if ([XKRWUtil isNetWorkAvailable]) {
        [self downloadWithTaskID:@"downLoadBlogRank" outputTask:^id{
            return [[XKRWManagementService5_0 sharedService] getBlogRankListFromServer];
        }];
        
    } else {
        [self showRequestArticleNetworkFailedWarningShow];
    }
 }

- (void)reLoadDataFromNetwork:(id)sender {
    [self hiddenRequestArticleNetworkFailedWarningShow];
    [self.refreshHeader beginRefreshing];
}

- (void)dealloc {
    [self.refreshHeader free];
    self.refreshHeader = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWorking

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [self showRequestArticleNetworkFailedWarningShow];
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    if ([taskID isEqualToString:@"downLoadBlogRank"]) {
        _rankDictionary = result;
        if (result[@"success"]) {
            [self.tableView reloadData];
            [_refreshHeader endRefreshing];
      
        } else {
            return;
        }
        
    } else {
        return;
    }
}


#pragma mark - refresh

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    [self initData];
}

- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView {
    
}
#pragma mark - Cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.rankDictionary[@"entityArray"] count];
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        XKRWIntelligentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"intelligentListCell" forIndexPath:indexPath];
        [cell setContentWithEntity:_rankDictionary[@"entityArray"][indexPath.row] rankNum:indexPath.row];
        cell.bgButton.tag = indexPath.row;
        typeof(self) __weak weakSelf = self;
        cell.cellClickBlock = ^(NSString *nickName) {
            XKRWUserInfoVC *vc = [[XKRWUserInfoVC alloc] init];
            vc.userNickname = nickName;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
        
    } else if (indexPath.section == 1) {
        XKRWReceiveLikeNumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"receiveLikeNumCell" forIndexPath:indexPath];
        cell.receiveLikeNum.text = [NSString stringWithFormat:@"%@",_rankDictionary[@"my_score"]];
            return cell;
        
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"explainCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"explainCell"];
            XKRWExplainView *explainView = [[NSBundle mainBundle] loadNibNamed:@"XKRWExplainView" owner:nil options:nil].lastObject;
            explainView.frame = CGRectMake(0,0,XKAppWidth,180);
            [cell.contentView addSubview:explainView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 60;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 180;
        default:
            return 0;
            break;
    }
}

#pragma mark - Footer

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    footer.backgroundColor = XKClearColor;
    return footer;
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
