//
//  XKRWPostDetailVC.m
//  XKRW
//
//  Created by 忘、 on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPostDetailVC.h"
#import "XKRWBelongTeamCell.h"
#import "XKRWPostDeatilCell.h"
#import "XKRWFitCommentCell.h"
#import "XKRWMoreCommetCell.h"
#import "XKRWCommentEditCell.h"
#import "XKRWGroupViewController.h"
#import "XKRWInputBoxView.h"
#import "XKRWGroupApi.h"
#import "XKRWGroupService.h"
#import "XKRWNewWebView.h"

#import "XKRW-Swift.h"
@interface XKRWPostDetailVC ()<UITableViewDataSource,UITableViewDelegate,KMImageBroswerViewDelegate,XKRWFitCommentCellDelegate, XKRWInputBoxViewDelegate,MJRefreshBaseViewDelegate,XKRWActionSheetDelegate,XKRWTipViewDelegate,UIAlertViewDelegate,RTLabelDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet XKRWUITableViewBase *postTableView;
@property (strong,nonatomic) MJRefreshFooterView *refreshFooter;
@property (strong,nonatomic) MJRefreshHeaderView *refreshHeader;
@property (weak,nonatomic) XKRWBelongTeamCell *belongTeamCell;
@property (weak,nonatomic) XKRWPostDeatilCell *postDetailCell;
@property (strong,nonatomic) XKRWMoreCommetCell *nonCommentCell;
@property (strong,nonatomic) XKRWCommentEditCell *allPostCell;
@property (nonatomic, strong) UIView *deletedView;
@property (strong,nonatomic) KMImageBroswerView *broswerView ;
@property (strong,nonatomic) XKRWUserPostEntity *entity;
@property (assign,nonatomic) NSInteger likeNum;
@property (strong,nonatomic) NSArray *reportReasonArray;
@property (strong,nonatomic) XKRWInputBoxView *inputBoxView;
@property (strong,nonatomic) XKRWTipView *tipView;
@property (strong,nonatomic) XKRWReplyEntity *replyEntity;
@property (assign,nonatomic) BOOL isReplyComment;
@property (strong,nonatomic) NSArray <NSIndexPath *> *seletCommentIndexs;
@property (strong,nonatomic) NSMutableArray <XKRWCommentEtity *> *commentArray;
@property (strong,nonatomic) UIView *joinGroupView;
@property (assign,nonatomic) XKRWUserReport userReport;
@property (strong,nonatomic) NSString *reportId;
@property (assign,nonatomic) BOOL isSelfsArticle;

@property (assign,nonatomic) BOOL isreload;

@property (assign,nonatomic) BOOL  userWebViewShowContent;  //使用UIWebView 代替 RTLabel

@end

@implementation XKRWPostDetailVC
{
    __weak UIView *clickedCommentView;
    
    NSInteger __commentsNumber;
    NSInteger webviewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _replyEntity = [XKRWReplyEntity new];
    [self initData];
    [self initView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self getLimitInfo];
}

- (void)dealloc {
    [_refreshFooter free];
    _refreshFooter = nil;
    [_refreshHeader free];
    _refreshHeader = nil;
}

- (void)initView {
    self.title = @"帖子";
    
    [self addNaviBarBackButton];
    [self addNaviBarRightButtonWithNormalImageName:@"more" highlightedImageName:@"more_p" selector:@selector(moreOperationClick)];
    
    
    if(_postDeleted){
        [self deletedView];
    }else{
        _postTableView.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight);
        _postTableView.delegate = self;
        _postTableView.dataSource = self;
        _postTableView.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight - 40);
        _postTableView.backgroundColor = XK_BACKGROUND_COLOR;
        _postTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_postTableView registerNib:[UINib nibWithNibName:@"XKRWBelongTeamCell" bundle:nil] forCellReuseIdentifier:@"belongTeamCell"];
        [_postTableView registerNib:[UINib nibWithNibName:@"XKRWPostDeatilCell" bundle:nil] forCellReuseIdentifier:@"postDetailCell"];
        [_postTableView registerClass:[XKRWFitCommentCell class] forCellReuseIdentifier:@"fitCommentCell"];
        _allPostCell = [[XKRWCommentEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"allPostCell"];
        _allPostCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _nonCommentCell = [[XKRWMoreCommetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nonCommentCell"];
        
        _refreshFooter = [MJRefreshFooterView footer];
        _refreshFooter.scrollView = _postTableView;
        _refreshFooter.delegate = self;
        _refreshHeader = [MJRefreshHeaderView header];
        _refreshHeader.scrollView = _postTableView;
        _refreshHeader.delegate = self;
        
        _inputBoxView = [[XKRWInputBoxView alloc] initWithPlaceholder:@"写跟帖" style:footer];
        _inputBoxView.delegate = self;
        [_inputBoxView showIn:self.view];
        
        _tipView = [[XKRWTipView alloc] init];
        _tipView.delegate = self;
    }
}

- (UIView *)joinGroupView {
    if (_joinGroupView == nil) {
        _joinGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 40)];
        UILabel *joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth - 70 - 20 , 40)];
        _joinGroupView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        joinLabel.backgroundColor = XKClearColor;
        joinLabel.textColor = [UIColor whiteColor];
        joinLabel.font = XKDefaultFontWithSize(16);
        joinLabel.textAlignment = NSTextAlignmentLeft;
        joinLabel.text = @"  需要加入该小组才能评论。";
        [_joinGroupView addSubview:joinLabel];
        
        UIButton * joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        joinButton.frame = CGRectMake(XKAppWidth - 70 - 10, 7, 70, 26);
        joinButton.layer.cornerRadius = 2.5;
        joinButton.clipsToBounds = YES;
        [joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        joinButton.titleLabel.font = XKDefaultFontWithSize(16);
        [joinButton setBackgroundColor:XKMainSchemeColor];
        [joinButton setTitle:@"加入" forState:UIControlStateNormal];
        UIImage *highlightedImage = [UIImage createImageWithColor:[XKMainSchemeColor colorWithAlphaComponent:0.6]];
        [joinButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        [joinButton addTarget:self action:@selector(joinGroupAction) forControlEvents:UIControlEventTouchUpInside];
        [_joinGroupView addSubview:joinButton];
    }
    return _joinGroupView;
}

- (UIView *)deletedView {
    
    if (_deletedView == nil) {
        _deletedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
        _deletedView.backgroundColor = XK_BACKGROUND_COLOR;
        [self.view addSubview:_deletedView];
        _deletedView.alpha = 1;
        UILabel *text = [[UILabel alloc]init];
        text.font = [UIFont systemFontOfSize:14];
        text.textColor = XK_TEXT_COLOR;
        text.textAlignment = NSTextAlignmentCenter;
        text.text = @"该帖子已被删除";
        
        
        text.frame = CGRectMake(0, _deletedView.height / 2 - 60, XKAppWidth, 30);
        UIImage *image = [UIImage imageNamed:@"del_like"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((XKAppWidth-image.size.width)/2, text.top - 109  , image.size.width, image.size.height)];
        imageView.image = image;
        [_deletedView addSubview:imageView];
        
        if (_likePostDeleted) {
            NZLabel *textLabel = [[NZLabel alloc]initWithFrame:CGRectMake(0, text.bottom, XKAppWidth, 30)];
            textLabel.text = @"点这里 取消喜欢 本内容";
            textLabel.font = [UIFont systemFontOfSize:14];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.textColor = XK_TEXT_COLOR;
            [textLabel setFontColor:XKMainToneColor_29ccb1 string:@"取消喜欢"];
            [_deletedView addSubview:textLabel];
            textLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelLikeArticle)];
            
            [textLabel addGestureRecognizer:tapGesture];
        }
        
        
        _deletedView.backgroundColor = [UIColor whiteColor];
        [_deletedView addSubview:text];
    }
    
    return _deletedView;
}

- (void)isJoinThisGroup {
    if (IOS_8_OR_LATER) {
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"此操作需要加入小组，是否加入？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"加入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self joinGroupAction];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertCtl addAction:okAction];
        [alertCtl addAction:cancelAction];
        [self presentViewController:alertCtl animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此操作需要加入小组，是否加入？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"加入", nil];
        alert.tag = 111;
        [alert show];
    }
    
}

- (void)joinGroupAction {
    
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
        
    } else {
        NSDictionary * data = [[[XKRWGroupApi alloc] init] joinGroupWithGroupId:_entity.postGroupID];
        NSString * success = data[@"success"];
        if (success.integerValue == 1) {
            
            if (![[XKRWUserService sharedService].currentGroups containsObject:_entity.postGroupID]) {
                [[XKRWUserService sharedService].currentGroups addObject:_entity.postGroupID];
            }
            
            [XKUtil postRefreshGroupTeamInDiscover];
            _entity.groupUserJoin = YES;
            [XKRWCui showInformationHudWithText:@"加入成功"];
            [_inputBoxView isForbidActions:NO];
            [_joinGroupView removeFromSuperview];
            
        } else {
            [XKRWCui showInformationHudWithText:data[@"error"][@"msg"]];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 111 && buttonIndex != alertView.cancelButtonIndex) {
        [self joinGroupAction];
    }
}

- (XKRWBelongTeamCell *)getBelongTeamCellFromTable:(UITableView *)tableView{
    _belongTeamCell = [tableView dequeueReusableCellWithIdentifier:@"belongTeamCell"];
    return _belongTeamCell;
}

- (XKRWPostDeatilCell *)getPostDetailCellFromTable:(UITableView *)tableView{
    _postDetailCell = [tableView dequeueReusableCellWithIdentifier:@"postDetailCell"];
    return _postDetailCell;
}

- (XKRWFitCommentCell *)getCommentCellFromTable:(UITableView *)tableView {
    XKRWFitCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fitCommentCell"];
    if (!cell) {
        cell = [[XKRWFitCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fitCommentCell"];
    }
    cell.delegate = self;
    
    return cell;
}

- (void)initData {
    
    if(!_postDeleted){
        _isreload = NO;
        [self getPostDetailInfo];
    }
    
}

- (void) getPostDetailInfo{
    if ([XKRWUtil isNetWorkAvailable]){
        [XKRWCui showProgressHud:@"帖子加载中..."];
        [self downloadWithTaskID:@"getPostDetail" outputTask:^id{
            return [[XKRWUserArticleService shareService] getUserPostDetailById:_postID];
        }];
        
    }else{
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
    }
}

- (void) getLimitInfo{
    if ([XKRWUtil isNetWorkAvailable]){
        [self downloadWithTaskID:@"getPostLimit" outputTask:^id{
            return [[XKRWUserArticleService shareService] getPostUserLimit];
        }];
        
    }else{
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
    }
}

- (void) getCommentAndReport{
    if ([XKRWUtil isNetWorkAvailable]){
        
        [self downloadWithTaskID:@"downloadComment" outputTask:^id{
            return [[XKRWManagementService5_0 sharedService] getCommentFromServerWithBlogId:_postID Index:@(0) andRows:@(10) type:@(2)];
        }];
        [self downloadWithTaskID:@"getReportReasons" outputTask:^id{
            return [[XKRWUserArticleService shareService] getReportReasonByEnabled:1];
        }];
    }else{
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
    }
    
}


- (void)getGroupInfo{
    if ([XKRWUtil isNetWorkAvailable]){
        [self downloadWithTaskID:@"getGroupFetailInfo" outputTask:^id{
            return  [[XKRWGroupService shareInstance]getGroupDetailWithGroupId:_entity.postGroupID];
        }];
    }else{
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
    }
    
}

- (void)likeAction:(UIButton *)button {
    if(!button.selected){
        if(!_entity.groupUserJoin){
            [self isJoinThisGroup];
            return ;
        }
        
        if([XKRWUtil isNetWorkAvailable]){
            [self downloadWithTaskID:@"addLike" outputTask:^id{
                return @([[XKRWUserArticleService shareService] addUserArticleLikeById:_entity.postID type:@"post"]);
            }];
        }else{
            [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
        }
    }else{
        if([XKRWUtil isNetWorkAvailable]){
            [self downloadWithTaskID:@"delLike" outputTask:^id{
                return @([[XKRWUserArticleService shareService] delUserArticleLikeById:_entity.postID type:@"post"]);
            }];
        }else{
            [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
        }
    }
}

- (void)entryUserInfo:(UIButton *)button
{
    XKRWUserInfoVC *vc = [[XKRWUserInfoVC alloc] init];
    vc.userNickname = _entity.userName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreOperationClick {
    XKRWActionSheet *actionSheet;
    if ([self isMineNickName:_entity.userName]) {
        actionSheet = [[XKRWActionSheet alloc] initShareHeaderSheetWithCancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitle:nil];
        actionSheet.tag = 2;
    } else {
        actionSheet = [[XKRWActionSheet alloc] initShareHeaderSheetWithCancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@"举报"];
        actionSheet.tag = 1;
    }
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)setIsSelfsArticle {
    if (!self.entity) {
        _isSelfsArticle = NO;
    }
    NSLog(@"%@",self.entity.userName);
    _isSelfsArticle = [self.entity.userName isEqualToString:[[XKRWUserService sharedService] getUserNickName]];
}

- (void)cancelLikeArticle {
    if([XKRWUtil isNetWorkAvailable]){
        [self downloadWithTaskID:@"cancelLike" outputTask:^id{
            return @([[XKRWUserArticleService shareService] delUserArticleLikeById:_postID type:@"post"]);
        }];
    }else{
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
    }
}

#pragma --mark UIwebViewDelegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    XKRWNewWebView *webView = [[XKRWNewWebView alloc]init];
    webView.contentUrl = [url absoluteString];
    webView.isFromPostDetail = YES;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    frame = webView.frame;
    frame.size = [webView sizeThatFits:CGSizeZero];
    webviewHeight = frame.size.height;
    
  
    if (webviewHeight != 20 && _isreload == NO){
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_postTableView reloadData];
            [XKRWCui hideProgressHud];
        });
        _isreload = YES;
    }
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(webView.isLoading){
        if([request.URL.absoluteString rangeOfString:@"v.qq.com"].location == NSNotFound){
            XKRWNewWebView *webView = [[XKRWNewWebView alloc]init];
            webView.contentUrl = request.URL.absoluteString;
            webView.isFromPostDetail = YES;
            [self.navigationController pushViewController:webView animated:YES];
            return NO;
        }
        return YES;
    }else{
        
        if([request.URL.absoluteString rangeOfString:@"v.qq.com"].location == NSNotFound && [request.URL.absoluteString rangeOfString:@"about:blank"].location == NSNotFound){
            XKRWNewWebView *webView = [[XKRWNewWebView alloc]init];
            webView.contentUrl = request.URL.absoluteString;
            webView.isFromPostDetail = YES;
            [self.navigationController pushViewController:webView animated:YES];
            return NO;
        }
        
        return YES;
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [XKRWCui hideProgressHud];
    [XKRWCui showInformationHudWithText:@"帖子加载失败..."];
}

#pragma --mark XKRWInputBoxViewDelegate

- (void)inputBoxView:(XKRWInputBoxView *)inputBoxView sendMessage:(NSString *)message {
    [MobClick event:@"clk_PushComment"];
    
    if (message.length == 0) {
        [XKRWCui showInformationHudWithText:@"评论内容不能为空哦~"];
    } else {
        if (!_entity.groupUserJoin && [self isMineNickName:_entity.userName]) {
            self.joinGroupView.hidden = NO;
            [self.inputBoxView isForbidActions:YES];
        } else {
            
        }
        [self downloadWithTaskID:@"sendComment" outputTask:^id{
            if (_isReplyComment) {
                return  [[XKRWManagementService5_0 sharedService] writeCommentWithMessage:message Blogid:_postID sid:_replyEntity.sid fid:_replyEntity.fid type:2];
            } else {
                return [[XKRWManagementService5_0 sharedService] writeCommentWithMessage:message Blogid:_postID sid:0 fid:0 type:2];
            }
            
        }];
    }
    [self.inputBoxView setPlaceholder:@"写跟帖"];
}

- (void)inputBoxView:(XKRWInputBoxView *)inputBoxView inHeight:(CGFloat)height willShowDuration:(CGFloat)duration {
    
    CGFloat bottom = clickedCommentView.bottom;
    UIView *view = clickedCommentView;
    while (view != nil) {
        view = view.superview;
        bottom += view.frame.origin.y;
        if ([view isKindOfClass:[UIScrollView class]]) {
            bottom -= ((UIScrollView *)view).contentOffset.y;
        }
    }
    
    CGFloat moveHeight =  bottom + height - XKAppHeight;
    if (moveHeight > 0) {
        [UIView animateWithDuration:duration animations:^{
            CGPoint point = CGPointMake(self.postTableView.contentOffset.x, self.postTableView.contentOffset.y + moveHeight);
            self.postTableView.contentOffset = point;
        }];
    }
    clickedCommentView = nil;
}

- (void)inputBoxView:(XKRWInputBoxView *)inputBoxView WillHideDuration:(CGFloat)duration inHeigh:(CGFloat)height {
    [self.inputBoxView setPlaceholder:@"写跟帖"];
    if (!_entity.groupUserJoin && [self isMineNickName:_entity.userName]) {
        self.joinGroupView.hidden = NO;
        [self.inputBoxView isForbidActions:YES];
    } else {
        
    }
}

#pragma --mark XKRWActionSheetDelegate

- (void)actionSheet:(XKRWActionSheet *)actionSheet clickedHeaderAtIndex:(NSInteger)buttonIndex {
    NSString *shareTitle = nil;
    
    shareTitle = [NSString stringWithFormat:@"%@ - %@\n - 分享自瘦瘦", _entity.postGroupName,_entity.postTitle];
    
    if (buttonIndex == 1) {
        [MobClick event:@"clk_ShareWechat"];
        
        //微信分享
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = _entity.sharePostUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession]
                                                           content:nil
                                                             image:nil
                                                          location:nil
                                                       urlResource:nil
                                               presentedController:self
                                                        completion:^(UMSocialResponseEntity *response){
                                                            if (response.responseCode == UMSResponseCodeSuccess) {
                                                                XKLog(@"分享成功！");
                                                            } else {
                                                                XKLog(@"分享微信好友失败");
                                                            }
                                                        }];
    } else if (buttonIndex == 2) {
        [MobClick event:@"clk_ShareWechat2"];
        
        //朋友圈
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _entity.sharePostUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline]
                                                           content:nil
                                                             image:nil
                                                          location:nil
                                                       urlResource:nil
                                               presentedController:self
                                                        completion:^(UMSocialResponseEntity *response){
                                                            if (response.responseCode == UMSResponseCodeSuccess) {
                                                                XKLog(@"分享成功！");
                                                            } else {
                                                                XKLog(@"分享朋友圈失败");
                                                            }
                                                        }];
    } else if (buttonIndex == 4) {
        
        [MobClick event:@"clk_ShareQzone"];
        
        //QZone
        [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
        [UMSocialData defaultData].extConfig.qzoneData.url = _entity.sharePostUrl;
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone]
                                                           content:nil
                                                             image:nil
                                                          location:nil
                                                       urlResource:nil
                                               presentedController:self
                                                        completion:^(UMSocialResponseEntity *response){
                                                            if (response.responseCode == UMSResponseCodeSuccess) {
                                                                XKLog(@"分享成功！");
                                                            }
                                                        }];
    } else if (buttonIndex == 3) {
        
        [MobClick event:@"clk_ShareWebo"];
        //weibo
        NSString *shareText = [NSString stringWithFormat:@"%@ - %@ - %@\n - 分享自瘦瘦", _entity.postGroupName, _entity.postTitle, _entity.sharePostUrl];
        
        [[UMSocialControllerService defaultControllerService] setShareText:shareText
                                                                shareImage:nil
                                                          socialUIDelegate:(id)self];
        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    
}

- (void)actionSheet:(XKRWActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 2) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            if ([XKRWUtil isNetWorkAvailable]) {
                [self downloadWithTaskID:@"deleteMyPost" outputTask:^id{
                    return @([[XKRWUserArticleService shareService] deletePostById:_postID]);
                    
                }];
            } else {
                [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
            }
            
        }
    } else if (actionSheet.tag == 1) {
        [self isReportIt:XKRWUserReportPost reportId:@""];
        
    } else if (actionSheet.tag == 3) { // 举报原因选择
        NSString *reason = [NSString stringWithFormat:@"%@",[_reportReasonArray[buttonIndex] objectForKey:@"id"]];
        [self downloadWithTaskID:@"addReport" outputTask:^id{
            return @( [[XKRWUserArticleService shareService] reportWithItem_id:_postID type:_userReport blogId:_reportId reason:reason]);
        }];
    }
}

- (void)isReportIt:(XKRWUserReport)userReport reportId:(NSString *)reportId{
    _reportId = reportId;
    _userReport = userReport;
    
    NSString *title;
    if (userReport == XKRWUserReportComment) {
        title = @"是否举报此评论？";
    } else if (userReport == XKRWUserReportPost) {
        title = @"是否举报这篇帖子？";
    }
    [XKRWCui showConfirmWithMessage:title okButtonTitle:@"确定" cancelButtonTitle:@"取消" onOKBlock:^{
        [MobClick event:@"clk_report"];
        if ([XKUtil isNetWorkAvailable] == FALSE) {
            [XKRWCui showInformationHudWithText:@"没有网络，请检查网络设置"];
            return;
        }
        XKRWActionSheet *actionSheet = [[XKRWActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:nil];
        actionSheet.tag = 3;
        actionSheet.delegate = self;
        for (NSDictionary *temp in _reportReasonArray) {
            [actionSheet addButtonWithTitle:temp[@"name"]];
        }
        [actionSheet showInView:self.view];
    }];
    
}

#pragma --mark KMImageBroswerViewDelagate
- (void)imageBroswerView:(KMImageBroswerView *)view clickImageAtIndex:(NSInteger)index{
    XKRWPhotoBrowserVC *vc = [[XKRWPhotoBrowserVC alloc] init];
    vc.clickForBack = YES;
    vc.imageURLs = self.entity.imagePath;
    vc.currentIndex = index;
    vc.rightNavigationItemOption_oc = [[NSDictionary alloc] init];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:false completion:nil];
}

#pragma --mark MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    
    if ([refreshView isEqual:_refreshFooter]) {
        if ([XKRWUtil isNetWorkAvailable]) {
            [self downloadWithTaskID:@"moreComments" outputTask:^id{
                return [[XKRWManagementService5_0 sharedService] getCommentFromServerWithBlogId:_postID Index:_commentArray.lastObject.comment_id andRows:@(10) type:@(2)];
            }];
        } else {
            [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
            return;
        }
        
    } else {
        [self initData];
    }
}

#pragma --mark UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        if (_commentArray.count == 0) {
            return 2;
        } else {
            return _commentArray.count + 1;
        }
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        XKRWBelongTeamCell  * belongTeamCell = [self getBelongTeamCellFromTable:tableView];
        [belongTeamCell.teamImageView setImageWithURL:[NSURL URLWithString:_groupItem.groupIcon] placeholderImage:nil];
        belongTeamCell.teamNameLabel.text = _groupItem.groupName;
        
        return  belongTeamCell;
    } else if (indexPath.section == 1) {
        
        XKRWPostDeatilCell *postDetailCell = [self getPostDetailCellFromTable:tableView];
        postDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(_entity != nil){
            [postDetailCell.userImageButton setBackgroundImageWithURL:[NSURL URLWithString:_entity.userHeadUrl] forState:UIControlStateNormal placeholderImage:nil];
            [postDetailCell.userImageButton addTarget:self action:@selector(entryUserInfo:) forControlEvents:UIControlEventTouchUpInside];
            postDetailCell.userNameLabel.text = _entity.userName;
            postDetailCell.postTimeLabel.text = [XKRWUtil dateFormatWithTime:_entity.postCreatTime];
            _likeNum = _entity.postBePraise;
            postDetailCell.personLikeNumLabel.text = [NSString stringWithFormat:@"已有%ld人喜欢",(long)_entity.postBePraise];
            _postDetailCell.postTitleLabel.attributedText = [XKRWUtil createAttributeStringWithString:_entity.postTitle font:XKDefaultFontWithSize(16) color:XK_TITLE_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
            
            if(_userWebViewShowContent){
                _postDetailCell.htmlStr = _entity.textContent;
            }else{
                _postDetailCell.postContentLabel.text = _entity.textContent ;
            }
            
            
            _postDetailCell.likeStateLabel.text = _entity.isThumpUp ? @"已喜欢":@"喜欢" ;
            _postDetailCell.likeStateButton.hidden = NO;
            _postDetailCell.likeStateButton.selected = _entity.isThumpUp;
            [_postDetailCell.likeStateButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if(_entity.imagePath.count > 0){
                [_broswerView setContentWithImageURLs:_entity.imagePath gapWidth:5];
                [_postDetailCell.postImageView addSubview:self.broswerView];
                //                _postDetailCell.postImageViewConstraint.constant = _broswerView.bottom;
            }
            
            _postDetailCell.showLikeButton = _isSelfsArticle;
            
        }
        
        return postDetailCell;
    } else {
        
        if (indexPath.row == 0) {
            _allPostCell.writeCommentBtn.hidden = YES;
            _allPostCell.recentCommentLb.hidden = YES;
            _allPostCell.titleLabel.text = @"全部跟帖";
            return _allPostCell;
            
        } else {
            if (_commentArray.count == 0) {
                _nonCommentCell.haveComment = NO;
                UIImage *no_gentie = [UIImage imageNamed:@"no_gentie"];
                [_nonCommentCell.nocommentImageView setImage:no_gentie];
                _nonCommentCell.nocommentImageView.size = no_gentie.size;
                _nonCommentCell.nocommentImageView.center = CGPointMake(XKAppWidth/2, 22);
                return _nonCommentCell;
                
            } else {
                
                XKRWFitCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fitCommentCell"];
                if (!cell) {
                    cell = [[XKRWFitCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fitCommentCell"];
                }
                cell.selectIndexPath = indexPath;
                [cell setEntity:_commentArray[indexPath.row - 1]];
                [cell setFloor:(__commentsNumber - indexPath.row)];
                cell.delegate = self;
                cell.iconBtn.tag = indexPath.row - 1;
                [cell.iconBtn addTarget:self action:@selector(readReviewerInfo:) forControlEvents:UIControlEventTouchUpInside];
                
                typeof(self) __weak weakSelf = self;
                cell.openBlock = ^(NSIndexPath *indexPath , BOOL state){
                    XKRWCommentEtity *entity = _commentArray[indexPath.row - 1];
                    entity.isOpen = !state;
                    [weakSelf.postTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                
                if (indexPath.row == _commentArray.count) {
                    cell.line.hidden = YES;
                } else {
                    cell.line.hidden = NO;
                }
                return cell;
            }
        }
        
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    headSectionView.backgroundColor = [UIColor clearColor];
    //    [XKRWUtil addViewUpLineAndDownLine:headSectionView andUpLineHidden:NO DownLineHidden:NO];
    return headSectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        XKRWBelongTeamCell  * belongTeamCell = [self getBelongTeamCellFromTable:tableView];
        belongTeamCell.teamNameLabel.text = _groupItem.groupName;
        CGFloat  height = [XKRWUtil getViewSize:belongTeamCell.contentView].height + 1 ;
        if(height < 44){
            return 44 ;
        }else{
            return height ;
        }
    }else if (indexPath.section == 1){
        if(_entity != nil){
            _postDetailCell.postTitleLabel.preferredMaxLayoutWidth = XKAppWidth-30;
            _postDetailCell.postTitleLabel.attributedText = [XKRWUtil createAttributeStringWithString:_entity.postTitle font:XKDefaultFontWithSize(16) color:XK_TITLE_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
            
            if(_userWebViewShowContent){
                _postDetailCell.postContentWebView.delegate = self;
                _postDetailCell.postContentWebView.scrollView.scrollEnabled = NO;
                _postDetailCell.postContentWebViewConstraint.constant = webviewHeight;
                _postDetailCell.postContentHeight.constant = webviewHeight;
                _postDetailCell.postContentWebView.hidden = NO;
                _postDetailCell.postContentLabel.hidden = YES;
            }else{
                
                _postDetailCell.postContentLabel.delegate = self;
                _postDetailCell.postContentLabel.lineSpacing = 3.5 ;
                _postDetailCell.postContentLabel.text = _entity.textContent ;
                _postDetailCell.postContentLabel.textAlignment = NSTextAlignmentJustified;
                _postDetailCell.postContentLabel.textColor = XK_TEXT_COLOR;
                _postDetailCell.postContentLabel.font = XKDefaultFontWithSize(16);
                _postDetailCell.postContentHeight.constant = [_postDetailCell.postContentLabel optimumSize].height;
                _postDetailCell.postContentWebViewConstraint.constant = [_postDetailCell.postContentLabel optimumSize].height;
                _postDetailCell.postContentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#29ccb1" forKey:@"color"];
                _postDetailCell.postContentWebView.hidden = YES;
                _postDetailCell.postContentLabel.hidden = NO;
            }
            if(_entity.imagePath.count > 0){
                _broswerView =  [[KMImageBroswerView alloc]initWithFrame:CGRectMake(0, 0, _postDetailCell.postImageView.width, _postDetailCell.postImageView.height)];
                [_broswerView calculateSizeWithImagesCount:_entity.imagePath.count gapWidth:5];
                
                _broswerView.delegate = self;
                //                [_postDetailCell.postImageView addSubview:_broswerView];
                _postDetailCell.postImageViewConstraint.constant = _broswerView.bottom;
            }else{
                _postDetailCell.postImageViewConstraint.constant = 0;
            }
        }
        
        
        return [XKRWUtil getViewSize:_postDetailCell.contentView].height + 1;
        
        
        
    }else{
        
        if (indexPath.row == 0) {
            return 25;
            
        } else if (_commentArray.count == 0) {
            return 44;
            
        } else {
            XKRWFitCommentCell *cell = [[XKRWFitCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fitCommentCell"];
            cell.entity = _commentArray[indexPath.row - 1];
            return cell.line.bottom + 1;
        }
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 0){
        XKRWGroupViewController *groupVC = [[XKRWGroupViewController alloc] init];
        groupVC.groupId = _groupItem.groupId;
        [self.navigationController pushViewController:groupVC animated:YES];
    }
}

#pragma -mark XKRWFitCommentCellDelegate
- (BOOL)isMineNickName:(NSString *)nickname {
    if ([nickname isEqualToString:[[XKRWUserService sharedService] getUserNickName]]) {
        return YES;
    } else {
        return NO;
    }
}
- (void)fitCommentCell:(XKRWFitCommentCell *)fitCommentCell clickedComment:(XKRWCommentEtity *)comment {
    
    _seletCommentIndexs = @[fitCommentCell.selectIndexPath];
    if ([self isMineNickName:comment.nameStr]) {
        [self deleteComment:comment.comment_id];
        
    } else if (_entity.groupUserJoin || [self isMineNickName:_entity.userName]) {
        clickedCommentView = fitCommentCell.commentLabel;
        _replyEntity.fid = [comment.comment_id integerValue];
        _replyEntity.sid = 0;
        _isReplyComment = YES;
        _joinGroupView.hidden = YES;
        [self.inputBoxView isForbidActions:NO];
        [_inputBoxView beginEditWithPlaceholder:[NSString stringWithFormat:@"回复%@:",comment.nameStr]];
        
    } else {
        [self isJoinThisGroup];
    }
    
}

- (void)fitCommentCell:(XKRWFitCommentCell *)fitCommentCell longPressedComment:(XKRWCommentEtity *)comment {
    
    _seletCommentIndexs = @[fitCommentCell.selectIndexPath];
    self.tipView.commentId = [comment.comment_id integerValue];
    self.tipView.indexArray = @[fitCommentCell.selectIndexPath];
    __weak UIView *view = fitCommentCell.commentLabel;
    
    if ([self isMineNickName:comment.nameStr]) {
        [self.tipView showUpView:view titles:@[@"删除",@"复制"]];
        
    } else if (_entity.groupUserJoin) {
        [self.tipView showUpView:view titles:@[@"举报",@"复制"]];
        
    } else {
        [self isJoinThisGroup];
    }
    
}

- (void)fitCommentCell:(XKRWFitCommentCell *)fitCommentCell didReplyComment:(XKRWCommentEtity *)comment {
    
    if (_entity.groupUserJoin || [self isMineNickName:_entity.userName]) {
        clickedCommentView = fitCommentCell.commentLabel;
        _seletCommentIndexs = @[fitCommentCell.selectIndexPath];
        _replyEntity.fid = [comment.comment_id integerValue];
        _replyEntity.sid = 0;
        _isReplyComment = YES;
        self.joinGroupView.hidden = YES;
        [self.inputBoxView isForbidActions:NO];
        [_inputBoxView beginEditWithPlaceholder:[NSString stringWithFormat:@"回复%@：",comment.nameStr]];
        
    } else {
        [self isJoinThisGroup];
    }
    
}


- (void)fitSubComment:(XKRWReplyView *)replyView userNameDidClicked:(NSString *)userName {
    XKRWUserInfoVC *userInfoVC = [[XKRWUserInfoVC alloc] init];
    userInfoVC.userNickname = userName;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (void)fitSubComment:(XKRWReplyView *)replyView didSelectAtIndexPath:(NSIndexPath *)selfIndexPath subIndexPath:(NSIndexPath *)subCellIndexPath {
    _seletCommentIndexs = @[selfIndexPath, subCellIndexPath];
    XKRWReplyEntity *entity = [_commentArray[selfIndexPath.row - 1] sub_Array][subCellIndexPath.row];
    if ([self isMineNickName:[_commentArray[selfIndexPath.row - 1].sub_Array[subCellIndexPath.row] nickName]]) {
        [self deleteComment:[NSNumber numberWithInteger:entity.mainId]];
        
    } else if (_entity.groupUserJoin || [self isMineNickName:_entity.userName]) {
        clickedCommentView = [replyView.tableView cellForRowAtIndexPath:subCellIndexPath];
        _replyEntity.fid = [_commentArray[selfIndexPath.row - 1].comment_id integerValue];
        _replyEntity.sid = entity.mainId;
        _isReplyComment = YES;
        self.joinGroupView.hidden = YES;
        [self.inputBoxView isForbidActions:NO];
        [_inputBoxView beginEditWithPlaceholder:[NSString stringWithFormat:@"回复%@：",entity.nickName]];
        
    } else {
        [self isJoinThisGroup];
    }
}

- (void)fitSubComment:(XKRWReplyView *)replyView longPressedAtIndexPath:(NSIndexPath *)selfIndexPath subIndexPath:(NSIndexPath *)subCellIndexPath {
    NSString *nickname = [_commentArray[selfIndexPath.row - 1].sub_Array[subCellIndexPath.row] nickName];
    __weak UIView *view = [replyView.tableView cellForRowAtIndexPath:subCellIndexPath];
    _seletCommentIndexs = @[selfIndexPath,subCellIndexPath];
    self.tipView.commentId = [_commentArray[selfIndexPath.row - 1].sub_Array[subCellIndexPath.row] mainId];
    self.tipView.indexArray = @[selfIndexPath,subCellIndexPath];
    if ([self isMineNickName:nickname]) {
        [self.tipView showUpView:view titles:@[@"删除",@"复制"]];
    } else if (_entity.groupUserJoin) {
        [self.tipView showUpView:view titles:@[@"举报",@"复制"]];
        
    } else {
        [self isJoinThisGroup];
    }
    
}

- (void)deleteComment:(NSNumber *)comment_id {
    __weak __typeof(self) weakSelf = self;
    [XKRWCui showConfirmWithMessage:@"删除评论" okButtonTitle:@"确定" cancelButtonTitle:@"取消" onOKBlock:^{
        [weakSelf downloadWithTaskID:@"deleteComment" outputTask:^id{
            return [[XKRWManagementService5_0 sharedService] deleteCommentWithBlogId:_postID andComment_id:comment_id];
        }];
    }];
}


#pragma mark -XKRWTipViewDelegate
- (void)tipView:(XKRWTipView *)tipView delectCommentWithCommentId:(NSInteger)commentId {
    [self deleteComment:[NSNumber numberWithInteger:commentId]];
}

- (void)tipView:(XKRWTipView *)tipView reportCommentWithCommentId:(NSInteger)commentId {
    [self isReportIt:XKRWUserReportComment reportId:[NSString stringWithFormat:@"%ld",(long)commentId]];
}

- (void)tipView:(XKRWTipView *)tipView copyAtIndexPath:(NSIndexPath *)mainIndexPath subIndexPath:(NSIndexPath *)subIndexPath {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (subIndexPath != nil) {
        [pasteboard setString:[[_commentArray[mainIndexPath.row - 1] sub_Array][subIndexPath.row] replyContent]];
    } else {
        [pasteboard setString:[_commentArray[mainIndexPath.row - 1] commentStr]];
    }
}

#pragma  --mark  NetWork

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    if([taskID isEqualToString:@"getPostDetail"]){
        _entity = (XKRWUserPostEntity *)result;
        
        if([_entity.textContent rangeOfString:@"href="].location != NSNotFound || [_entity.textContent rangeOfString:@"</p>"].location != NSNotFound){
            _userWebViewShowContent = YES;
        }else{
            [XKRWCui hideProgressHud];
        }
        
        if(_entity.status == XKRWPostStatusDeleteByAdmin || _entity.status
           == XKRWPostStatusDeleteByUser){
            [self deletedView];
            self.deletedView.alpha = 0.0;
            [UIView animateWithDuration:0.2 animations:^{
                self.deletedView.alpha = 1;
            }];
        }else{
            [self getCommentAndReport];
            [self setIsSelfsArticle];
            if(_groupItem == nil){
                [self getGroupInfo];
            }
            if (!_entity.groupUserJoin) {
                [self.inputBoxView.inputBgView addSubview:self.joinGroupView];
                [_inputBoxView isForbidActions:YES];
                
            } else {
                [self.joinGroupView removeFromSuperview];
                [_inputBoxView isForbidActions:NO];
            }
            [_postTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        [_refreshHeader endRefreshing];
    }
    
    if ([taskID isEqualToString:@"deleteMyPost"]) {
        if (result) {
            [XKRWCui showInformationHudWithText:@"删除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportSuccessTorefreshData" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [XKRWCui showInformationHudWithText:@"删除失败请重试~"];
        }
    }
    
    if ([taskID isEqualToString:@"getReportReasons"]) {
        _reportReasonArray = (NSArray *)result;
    }
    
    if([taskID isEqualToString:@"addLike"]){
        if ([result boolValue]) {
            _postDetailCell.likeStateButton.selected = YES;
            _postDetailCell.likeStateLabel.text = @"已喜欢";
            _likeNum = _likeNum + 1;
            _postDetailCell.personLikeNumLabel.text = [NSString stringWithFormat:@"已有%ld人喜欢",(long)_likeNum ];
        }
    }
    
    if([taskID isEqualToString:@"delLike"]){
        if ([result boolValue]) {
            _postDetailCell.likeStateButton.selected = NO;
            _postDetailCell.likeStateLabel.text = @"喜欢";
            _likeNum =  _likeNum -1;
            _postDetailCell.personLikeNumLabel.text = [NSString stringWithFormat:@"已有%ld人喜欢",(long)_likeNum ];
            [XKRWCui showInformationHudWithText:@"取消成功"];
        }
    }
    
    if([taskID isEqualToString:@"cancelLike"]){
        [XKRWCui showInformationHudWithText:@"取消成功"];
    }
    
    if ([taskID isEqualToString:@"addReport"]) {
        if (result) {
            [XKRWCui showInformationHudWithText:@"举报成功"];
        } else {
            [XKRWCui showInformationHudWithText:@"举报失败"];
        }
    }
    if ([taskID isEqualToString:@"downloadComment"]) {
        if (![(NSArray *)result[@"comment"] count] || [(NSArray *)result[@"comment"] count] % 10) {
            self.refreshFooter.hidden = YES;
        } else {
            self.refreshFooter.hidden = NO;
        }
        _commentArray = result[@"comment"];
        __commentsNumber = [result[@"commentNum"] integerValue];
        [_postTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if ([taskID isEqualToString:@"moreComments"]) {
        if (![(NSArray *)result[@"comment"] count] || [(NSArray *)result[@"comment"] count] % 10) {
            self.refreshFooter.hidden = YES;
        } else {
            self.refreshFooter.hidden = NO;
        }
        [_commentArray addObjectsFromArray:result[@"comment"]];
        [self.refreshFooter endRefreshing];
        [_postTableView reloadData];
    }
    
    if ([taskID isEqualToString:@"deleteComment"]) {
        if (result[@"success"]) {
            if (_seletCommentIndexs.count == 1) {
                __commentsNumber --;
                [_commentArray removeObjectAtIndex:_seletCommentIndexs.firstObject.row - 1];
            } else {
                [_commentArray[_seletCommentIndexs.firstObject.row - 1].sub_Array removeObjectAtIndex:_seletCommentIndexs.lastObject.row];
            }
            [self.postTableView reloadData];
        } else {
            [XKRWCui showInformationHudWithText:@"删除失败，请稍后再试~"];
        }
    }
    
    if ([taskID isEqualToString:@"sendComment"]) {
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
            if (_isReplyComment) {
                XKRWCommentEtity *entity = _commentArray[_seletCommentIndexs.firstObject.row - 1];
                if (entity.sub_Array == nil) {
                    entity.sub_Array = [NSMutableArray arrayWithObject:result[@"comment"]];
                } else {
                    [entity.sub_Array addObject:result[@"comment"]];
                }
                [self.postTableView reloadRowsAtIndexPaths:@[_seletCommentIndexs.firstObject] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                __commentsNumber ++;
                [_commentArray insertObject:result[@"comment"] atIndex:0];
                //                [self.postTableView reloadData];
                [self.postTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        _isReplyComment = NO;
    }
    
    if ([taskID isEqualToString:@"getGroupFetailInfo"]){
        _groupItem = (XKRWGroupItem *)result;
        [_postTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    if (_refreshHeader.refreshing) {
        [_refreshHeader endRefreshing];
    } else if (_refreshFooter.refreshing) {
        [_refreshFooter endRefreshing];
    }
    if([taskID isEqualToString:@"getPostDetail"]){
        [XKRWCui hideProgressHud];
        [XKRWCui showInformationHudWithText:@"帖子加载失败..."];
    }
    [super handleDownloadProblem:problem withTaskID:taskID];
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)readReviewerInfo:(UIButton *)sender {
    [MobClick event:@"clk_CommentUser"];
    
    XKRWUserInfoVC *vc = [[XKRWUserInfoVC alloc] init];
    vc.userNickname = [_commentArray[sender.tag] nameStr];
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
