//
//  XKRWArticleCommentVC.m
//  XKRW
//
//  Created by Shoushou on 15/9/28.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWArticleCommentVC.h"
#import "XKRW-Swift.h"
#import "XKRWManagementService5_0.h"
#import "XKRWUserService.h"

#import "define.h"
#import "XKCuiUtil.h"
#import "MJRefresh.h"

#import "XKRWFitCommentCell.h"
#import "XKRWCommentEtity.h"
#import "XKRWActionSheet.h"
#import "XKRWInputBoxView.h"
#import "XKRWTipView.h"

@interface XKRWArticleCommentVC ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,XKRWActionSheetDelegate,XKRWFitCommentCellDelegate,XKRWTipViewDelegate,XKRWInputBoxViewDelegate>

@property (nonatomic, strong) MJRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) MJRefreshFooterView *refreshFooterView;

@property (nonatomic, strong) XKRWUITableViewBase *tableView;
@property (nonatomic, strong) NSMutableArray<XKRWCommentEtity *> *dataSource;
@property (nonatomic, strong) NSArray *reportReasonArray;

@property (nonatomic, strong) XKRWInputBoxView *inputBoxView;
@property (nonatomic, assign) NSInteger reportCommentId;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) XKRWTipView *tipView;

@end

@implementation XKRWArticleCommentVC
{
  __weak UIView *clickView;
    XKRWReplyEntity *replyEntity;
    NSArray <NSIndexPath *> *selectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"评论";
    
    _dataSource = [NSMutableArray array];
    replyEntity = [XKRWReplyEntity new];
    [self addNaviBarBackButton];
    [self initUI];
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)loadData {
    
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
        [self showRequestArticleNetworkFailedWarningShow];
        return;
    } else
        [self downloadWithTaskID:@"downLoadComment" outputTask:^id{
            return  [[XKRWManagementService5_0 sharedService] getCommentFromServerWithBlogId:self.blogId Index:@(0) andRows:@(10) type:nil][@"comment"];
        }];
    
    [self downloadWithTaskID:@"getReportReasons" outputTask:^id{
        return [[XKRWUserArticleService shareService] getReportReasonByEnabled:1];
    }];
}

- (void)initUI {
    
    _tableView = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [self addHeaderRefresh];
    [self addFooterRefresh];
    
    self.tipView = [[XKRWTipView alloc] init];
    self.tipView.delegate = self;
    
    _inputBoxView = [[XKRWInputBoxView alloc] initWithPlaceholder:@"评论" style:original];
    _inputBoxView.delegate = self;
    [_inputBoxView showIn:self.view];
    
}

#pragma mark - Networking


- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    
    if ([taskID isEqualToString:@"downLoadComment"]) {
        [self showRequestArticleNetworkFailedWarningShow];
    }
}

- (void)reLoadDataFromNetwork:(UIButton *)button {
    [self loadData];
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    if ([taskID isEqualToString:@"loadMoreComment"]) {
        
        if (![(NSMutableArray *)result count] || [(NSMutableArray *)result count] % 10) {
            self.refreshFooterView.hidden = YES;
            
        } else {
            self.refreshFooterView.hidden = NO;
        }
        [_dataSource addObjectsFromArray:result];
        
        [_refreshFooterView endRefreshing];
        if (_dataSource.count) {
            [self.tableView reloadData];
        }
        
    } else if ([taskID isEqualToString:@"downLoadComment"]) {
        
        if (![(NSMutableArray *)result count] || [(NSMutableArray *)result count] % 10) {
            self.refreshFooterView.hidden = YES;
        } else {
            self.refreshFooterView.hidden = NO;
        }
        
        if ([(NSMutableArray *)result count]) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:result];
        }
        
        [_refreshHeaderView endRefreshing];
        if (_dataSource.count) {
            [self hiddenRequestArticleNetworkFailedWarningShow];
            [self.tableView reloadData];
        }
        
    } else if ([taskID isEqualToString:@"getReportReasons"]) {
        _reportReasonArray = (NSArray *)result;
        
    } else if ([taskID isEqualToString:@"addReport"]) {
        
        if (result) {
            [XKRWCui showInformationHudWithText:@"举报成功"];
            
        } else {
            [XKRWCui showInformationHudWithText:@"举报失败"];
        }
        
    } else if ([taskID isEqualToString:@"deleteComment"]) {
        if ([[result objectForKey:@"success"] boolValue]) {
            [XKRWCui showInformationHudWithText:@"成功删除"];
            
            if (selectArray.count == 1) {
                [self.dataSource removeObjectAtIndex:selectArray.firstObject.row];
                [self.tableView reloadData];
                
            } else if (selectArray.count == 2){
                [[self.dataSource[selectArray.firstObject.row] sub_Array] removeObjectAtIndex:selectArray.lastObject.row];
                [self.tableView reloadRowsAtIndexPaths:@[selectArray.firstObject] withRowAnimation:UITableViewRowAnimationNone];
            }
        } else {
            [XKRWCui showInformationHudWithText:@"删除失败"];
        }
        
    } else if ([taskID isEqualToString:@"commitComment"]) {
        if (result[@"message"]) {
            
            if (IOS_8_OR_LATER) {
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"评论失败" message:result[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertCtl addAction:okAction];
                [self presentViewController:alertCtl animated:YES completion:nil];
                
            } else {
                [XKRWCui showAlertWithMessage:result[@"message"]];
            }
            
        } else if ([result[@"success"] boolValue]) {
            XKRWCommentEtity *entity = _dataSource[selectArray.firstObject.row];
            if (entity.sub_Array == nil) {
                entity.sub_Array = [NSMutableArray arrayWithObject:result[@"comment"]];
            } else {
                [entity.sub_Array addObject:result[@"comment"]];
            }
            [self.tableView reloadRowsAtIndexPaths:@[selectArray.firstObject] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKRWFitCommentCell *cell = [[XKRWFitCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fitCommentCell"];
    cell.entity = _dataSource[indexPath.row];
    return cell.line.bottom + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKRWFitCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fitCommentCell"];
    if (!cell) {
        cell = [[XKRWFitCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fitCommentCell"];
    }
    cell.selectIndexPath = indexPath;
    [cell setEntity:_dataSource[indexPath.row]];
    cell.floorLabel.hidden = YES;
    cell.delegate = self;
    
    cell.iconBtn.tag = indexPath.row + 1625;
    
    [cell.iconBtn addTarget:self action:@selector(readReviewerInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    typeof(self) __weak weakSelf = self;
    cell.openBlock = ^(NSIndexPath *indexPath , BOOL state){
        XKRWCommentEtity *entity = _dataSource[indexPath.row];
        
        entity.isOpen = !state;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    if (indexPath.row == _dataSource.count - 1) {
        cell.line.hidden = YES;
    } else {
        cell.line.hidden = NO;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark --MJRefreshDelegate
- (void)addHeaderRefresh {
    self.refreshHeaderView = [MJRefreshHeaderView header];
    _refreshHeaderView.scrollView = _tableView;
    _refreshHeaderView.delegate = self;
}

- (void)addFooterRefresh {
    self.refreshFooterView = [MJRefreshFooterView footer];
    _refreshFooterView.scrollView = _tableView;
    _refreshFooterView.delegate = self;
}

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
        [self loadData];
        
    } else {
        if (!refreshView.refreshing) {
            [self downloadWithTaskID:@"loadMoreComment" outputTask:^id{
                return  [[XKRWManagementService5_0 sharedService] getCommentFromServerWithBlogId:self.blogId Index:_dataSource.lastObject.comment_id andRows:@(10) type:nil][@"comment"];
            }];
        }
    }
}


- (void)endRefresh:(MJRefreshBaseView*)refreshView {
    [refreshView endRefreshing];
    
    //刷新结束，重载tableView数据
    if (_dataSource.count) {
        [self.tableView reloadData];
        
    }
}

- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state {
    switch (state) {
        case MJRefreshStateNormal:
            XKLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            XKLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            XKLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [_refreshHeaderView free];
    _refreshHeaderView = nil;
    
    [_refreshFooterView free];
    _refreshFooterView = nil;
}


#pragma mark -Action
- (void)readReviewerInfo:(UIButton *)iconButton {
    NSInteger tag = iconButton.tag - 1625;
    NSString *userNickName = [_dataSource[tag] nameStr];
    [self readCommentatorInfo:userNickName];
    
}

- (void)readCommentatorInfo:(NSString *)nickName {
    XKRWUserInfoVC *vc = [[XKRWUserInfoVC alloc] init];
    vc.userNickname = nickName;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)isReportComment {
    
    [XKRWCui showConfirmWithMessage:@"举报评论" okButtonTitle:@"确定" cancelButtonTitle:@"取消" onOKBlock:^{
        [MobClick event:@"clk_report"];
        if ([XKUtil isNetWorkAvailable] == FALSE) {
            [XKRWCui showInformationHudWithText:@"没有网络，请检查网络设置"];
            return;
        }
        XKRWActionSheet *actionSheet = [[XKRWActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:nil];
        
        actionSheet.delegate = self;
        for (NSDictionary *temp in _reportReasonArray) {
            [actionSheet addButtonWithTitle:temp[@"name"]];
        }
        [actionSheet showInView:self.view];
    }];
    
}

#pragma mark - XKRWActionSheetDelegate

- (void)actionSheet:(XKRWActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *reason = [NSString stringWithFormat:@"%@",[_reportReasonArray[buttonIndex] objectForKey:@"id"]];
    [self downloadWithTaskID:@"addReport" outputTask:^id{
        return @( [[XKRWUserArticleService shareService] reportWithItem_id:[NSString stringWithFormat:@"%ld",(long)_reportCommentId] type:XKRWUserReportComment blogId:self.blogId reason:reason]);
    }];
    
}

#pragma mark -XKRWFitCommentCellDelegate

-(void)fitCommentCell:(XKRWFitCommentCell *)fitCommentCell didReplyComment:(XKRWCommentEtity *)comment {
    selectArray = @[fitCommentCell.selectIndexPath];
    clickView = fitCommentCell.commentLabel;
    replyEntity.fid = [comment.comment_id integerValue];
    replyEntity.sid = 0;
    [_inputBoxView beginEditWithPlaceholder:[NSString stringWithFormat:@"回复%@：",comment.nameStr]];
}

- (void)fitCommentCell:(XKRWFitCommentCell *)fitCommentCell clickedComment:(XKRWCommentEtity *)comment {
    
    selectArray = @[fitCommentCell.selectIndexPath];
    replyEntity.fid = [comment.comment_id integerValue];
    replyEntity.sid = 0;
    clickView = fitCommentCell.commentLabel;
    if ([comment.nameStr isEqualToString:[[XKRWUserService sharedService] getUserNickName]]) {
        [self deleteComment:comment.comment_id];
    } else {
        [_inputBoxView beginEditWithPlaceholder:[NSString stringWithFormat:@"回复%@：",comment.nameStr]];
    }
}



- (void)fitCommentCell:(XKRWFitCommentCell *)fitCommentCell longPressedComment:(XKRWCommentEtity *)comment {
    
    selectArray = @[fitCommentCell.selectIndexPath];
    __weak UIView *view = fitCommentCell.commentLabel;
    [self compareUserName:comment.nameStr showTipsUpView:view];
    self.tipView.commentId = [comment.comment_id integerValue];
}

- (void)fitSubComment:(XKRWReplyView *)replyView userNameDidClicked:(NSString *)userName {
    [self readCommentatorInfo:userName];
}

- (void)fitSubComment:(XKRWReplyView *)replyView didSelectAtIndexPath:(NSIndexPath *)selfIndexPath subIndexPath:(NSIndexPath *)subCellIndexPath {
    selectArray = @[selfIndexPath,subCellIndexPath];
    clickView = [replyView.tableView cellForRowAtIndexPath:subCellIndexPath];
    
    XKRWReplyEntity *entity = [_dataSource[selfIndexPath.row] sub_Array][subCellIndexPath.row];
    
    if ([entity.nickName isEqualToString:[[XKRWUserService sharedService] getUserNickName]]) {
        //删除Tip
        [self deleteComment:[NSNumber numberWithInteger:entity.mainId]];
    } else {
        replyEntity.fid = [_dataSource[selfIndexPath.row].comment_id integerValue];
        replyEntity.sid = entity.mainId;
        [_inputBoxView beginEditWithPlaceholder:[NSString stringWithFormat:@"回复%@：",entity.nickName]];
    }
}

- (void)fitSubComment:(XKRWReplyView *)replyView longPressedAtIndexPath:(NSIndexPath *)selfIndexPath subIndexPath:(NSIndexPath *)subCellIndexPath {
    
    selectArray = @[selfIndexPath,subCellIndexPath];
    XKRWReplyEntity *entity = [_dataSource[selfIndexPath.row] sub_Array][subCellIndexPath.row];
    UIView *view = [replyView.tableView cellForRowAtIndexPath:subCellIndexPath];
    [self compareUserName:entity.nickName showTipsUpView:view];
    self.tipView.commentId = entity.mainId;
}

#pragma mark - XKRWInputBoxViewDelegate

- (void)inputBoxView:(XKRWInputBoxView *)inputBoxView sendMessage:(NSString *)message {
    if (message.length == 0) {
        [XKRWCui showInformationHudWithText:@"评论内容不能为空哦~"];
        
    } else {
        [self downloadWithTaskID:@"commitComment" outputTask:^id{
            return  [[XKRWManagementService5_0 sharedService] writeCommentWithMessage:message Blogid:self.blogId sid:replyEntity.sid fid:replyEntity.fid type:0];
        }];
  
    }
}

- (void)inputBoxView:(XKRWInputBoxView *)inputBoxView inHeight:(CGFloat)height willShowDuration:(CGFloat)duration {
    CGFloat h = clickView.bottom;
    while (clickView != nil) {
        clickView = clickView.superview;
        h += clickView.origin.y;
        if ([clickView isKindOfClass:[UIScrollView class]]) {
            h -= ((UIScrollView *)clickView).contentOffset.y;
        }
    }
    
    CGFloat moveHeight = height + h - XKAppHeight;
    if (height + h - XKAppHeight > 0) {
        [UIView animateWithDuration:duration animations:^{
            CGPoint point = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + moveHeight);
            self.tableView.contentOffset = point;
        }];
    } else return;

}


#pragma mark -XKRWTipViewDelegate
- (void)tipView:(XKRWTipView *)tipView delectCommentWithCommentId:(NSInteger)commentId {
    [self downloadWithTaskID:@"deleteComment" outputTask:^id{
        
        return [[XKRWManagementService5_0 sharedService] deleteCommentWithBlogId:self.blogId andComment_id:[NSNumber numberWithInteger:commentId]];
    }];
    
}

- (void)tipView:(XKRWTipView *)tipView reportCommentWithCommentId:(NSInteger)commentId {
    _reportCommentId = commentId;
    [self isReportComment];
}

- (void)tipView:(XKRWTipView *)tipView copyAtIndexPath:(NSIndexPath *)mainIndexPath subIndexPath:(NSIndexPath *)subIndexPath {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (subIndexPath != nil) {
        [pasteboard setString:[[_dataSource[mainIndexPath.row] sub_Array][subIndexPath.row] replyContent]];
    } else {
        [pasteboard setString:[_dataSource[mainIndexPath.row] commentStr]];
    }
}

- (void)compareUserName:(NSString *)userName showTipsUpView:(UIView *)view {
    if ([userName isEqualToString:[[XKRWUserService sharedService] getUserNickName]]) {
        [self.tipView showUpView:view titles:@[@"删除",@"复制"]];
    } else {
        [self.tipView showUpView:view titles:@[@"举报",@"复制"]];
    }
    self.tipView.indexArray = selectArray;
}
- (void)deleteComment:(NSNumber *)comment_id {
    __weak __typeof(self) weakSelf = self;
    [XKRWCui showConfirmWithMessage:@"删除评论" okButtonTitle:@"确定" cancelButtonTitle:@"取消" onOKBlock:^{
        [weakSelf downloadWithTaskID:@"deleteComment" outputTask:^id{
            return [[XKRWManagementService5_0 sharedService] deleteCommentWithBlogId:self.blogId andComment_id:comment_id];
        }];
    }];
}
@end
