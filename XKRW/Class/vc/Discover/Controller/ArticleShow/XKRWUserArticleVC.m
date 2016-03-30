//
//  XKRWUserArticleVC.m
//  XKRW
//
//  Created by Klein Mioke on 15/10/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWUserArticleVC.h"
#import "XKRW-Swift.h"
#import "NZLabel.h"
#import "XKRWUserArticleTitleCell.h"
#import "XKRWUserArticleEndCell.h"
#import "XKRWLikeView.h"

#import "XKRWCommentEditCell.h"
#import "XKRWFitCommentCell.h"
#import "XKRWMoreCommetCell.h"
#import "XKRWIconAndLevelView.h"
#import "XKRWActionSheet.h"
#import "XKRWUserService.h"
#import "XKRWManagementService5_0.h"
#import "XKRWArticleCommentVC.h"
#import "XKRWTopicVC.h"
#import "XKRWInputBoxView.h"

@interface XKRWUserArticleVC () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,XKRWActionSheetDelegate, XKRWInputBoxViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) XKRWUITableViewBase *tableView;

@property (nonatomic, strong) NSMutableArray *commentMutArr;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSMutableArray *reportReasonArray;
@property (nonatomic, strong) XKRWInputBoxView *inputBoxView;
@property (nonatomic, strong) XKRWLikeView *likeView;

@property (nonatomic, strong) XKRWCommentEditCell *editCell;
@property (nonatomic, strong) UIView *deletedView;

@property (nonatomic, assign) BOOL isSelfsArticle;

@property (nonatomic, assign) BOOL showNaviBar;
@property (nonatomic, strong) UIView *noNetWorkView;
@property (nonatomic, strong) UIImageView *noNetWorkImageView;
@property (nonatomic, strong) UIButton *noNetWorkButton;

@end

@implementation XKRWUserArticleVC {
    
    XKRWArticleSectionView *_computeCell;
    XKRWIconAndLevelView *_userHead;
    
    BOOL _isLoaded;
    BOOL _isNaviBarTransparent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //     Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addNaviBarBackButton];
    [self addNaviBarRightButtonWithNormalImageName:@"more_option_icon" highlightedImageName:@"more_option_icon" selector:@selector(moreOperationClick)];
    _commentMutArr = [[NSMutableArray alloc] init];
    
    self.tableView = ({
        XKRWUITableViewBase *view = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight) style:UITableViewStylePlain];
        view.backgroundColor = [UIColor clearColor];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.bounces = NO;
        
        view.delegate = self;
        view.dataSource = self;
        
        [self.view addSubview:view];
        
        [view registerNib:[UINib nibWithNibName:@"XKRWUserArticleTitleCell" bundle:nil] forCellReuseIdentifier:@"articleTitleCell"];
        [view registerClass:[XKRWArticleSectionCell class] forCellReuseIdentifier:@"articleSectionCell"];
        [view registerNib:[UINib nibWithNibName:@"XKRWUserArticleEndCell" bundle:nil] forCellReuseIdentifier:@"endCell"];
        
        [view registerClass:[XKRWFitCommentCell class] forCellReuseIdentifier:@"commetCell"];
        [view registerClass:[XKRWCommentEditCell class] forCellReuseIdentifier:@"editCommentCell"];
        [view registerClass:[XKRWMoreCommetCell class] forCellReuseIdentifier:@"moreCommetCell"];
        
        view;
    });
    
    _computeCell = ({
        XKRWArticleSectionView *view = [[XKRWArticleSectionView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
        view;
    });
    
    _likeView = ({
        XKRWLikeView *view = [[NSBundle mainBundle] loadNibNamed:@"XKRWLikeView" owner:nil options:nil].lastObject;
        view.frame = CGRectMake(0, 0, XKAppWidth, 120);
        view;
    });
    
    _userHead = ({
        XKRWIconAndLevelView *view =
        [[XKRWIconAndLevelView alloc] initWithFrame:CGRectMake(15, 17.5, 40, 40)
                                            IconUrl:self.articleEntity.user_avatar
                                        AndlevelUrl:self.articleEntity.user_level];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toUserInfoVC)];
        [view addGestureRecognizer:tap];
        view;
    });
    
    _inputBoxView = [[XKRWInputBoxView alloc] initWithPlaceholder:@"评论" style:original];
    _inputBoxView.delegate = self;
    [_inputBoxView showIn:self.view];
    
    if (self.articleEntity == nil) {
        [self initData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initData {
    if (self.aid && self.aid.length > 0 && [XKUtil isNetWorkAvailable]) {
        [self hiddenRequestArticleNetworkFailedWarningShow];
        if (self.showNaviBar) {
            [((XKRWNavigationController *)self.navigationController) navigationBarChangeFromBlackHalfTransNavigationBarToTransparencyNavigationBar];
            self.title = @"";
            self.showNaviBar = NO;
        }

        [XKRWCui showProgressHud:@"加载文章详情中"];
        
        [self downloadWithTaskID:@"downloadArticle" outputTask:^id{
            
            return [[XKRWUserArticleService shareService] getUserArticleDetailById:self.aid];
        }];
        
        [self downloadWithTaskID:@"reportReason" outputTask:^id{
            return [[XKRWUserArticleService shareService] getReportReasonByEnabled:1];
        }];
    } else {
        self.title = @"瘦身分享";
        self.showNaviBar = YES;
        [self showRequestArticleNetworkFailedWarningShow];
    }
 
}

- (UIView *)deletedView {
    
    if (_deletedView == nil) {
        _deletedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
        _deletedView.backgroundColor = XK_BACKGROUND_COLOR;
        [self.view addSubview:_deletedView];
        _deletedView.alpha = 0.0;
        UILabel *text = [[UILabel alloc]init];
        text.font = [UIFont systemFontOfSize:14];
        text.textColor = XK_TEXT_COLOR;
        text.textAlignment = NSTextAlignmentCenter;
        text.text = @"该文章已被删除";
        
        text.frame = CGRectMake(0, _deletedView.height / 2 - 60, XKAppWidth, 30);
        UIImage *image = [UIImage imageNamed:@"del_like"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((XKAppWidth-image.size.width)/2, text.top - 109  , image.size.width, image.size.height)];
        imageView.image = image;
        [_deletedView addSubview:imageView];
        
        if(_likeArticleDeleted){
            text.frame = CGRectMake(0, _deletedView.height / 2 - 60, XKAppWidth, 30);
            
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
            _deletedView.backgroundColor = [UIColor whiteColor];
        }
        [_deletedView addSubview:text];
        
    }
    return _deletedView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     XKRWNavigationController *ctrl = (XKRWNavigationController *)self.navigationController;
    if (!self.showNaviBar) {
        [ctrl navigationBarChangeFromBlackHalfTransNavigationBarToTransparencyNavigationBar];
    } else {
        [ctrl navigationBarChangeFromDefaultNavigationBarToBlackHarfTransNavigationBar];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self downloadComments];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        
    XKRWNavigationController *ctrl = (XKRWNavigationController *)self.navigationController;
    [ctrl navigationBarChangeFromTransparencyNavigationBarToDefaultNavigationBar];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reLoadDataFromNetwork:(UIButton *)button
{
    [self initData];
    [self downloadComments];
}

- (void)downloadComments {
    if (self.aid != nil && self.aid.length > 0 && !self.isPreview) {

    [self downloadWithTaskID:@"downloadComment" outputTask:^id{
        return [[XKRWManagementService5_0 sharedService] getCommentFromServerWithBlogId:self.aid Index:@(0) andRows:@(3) type:nil];
    }];
    }
}
#pragma mark - Actions

- (void)toUserInfoVC {
    
    XKRWUserInfoVC *vc = [[XKRWUserInfoVC alloc] initWithNibName:@"XKRWUserInfoVC" bundle:nil];
    vc.userNickname = self.articleEntity.user_nickname;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteArticle {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"确定删除这篇文章吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [view show];
}

- (BOOL)isSelfsArticle {
    if (!self.articleEntity) {
        return NO;
    }
    return [self.articleEntity.user_nickname isEqualToString:[[XKRWUserService sharedService] getUserNickName]];
}


- (void)cancelLikeArticle
{
    [self downloadWithTaskID:@"delArticleLike" outputTask:^id{
        return @([[XKRWUserArticleService shareService] delUserArticleLikeById:self.aid type:nil]);
    }];
}

#pragma mark - Networking


- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    
    [super handleDownloadProblem:problem withTaskID:taskID];
    
    [XKRWCui hideProgressHud];
    
    if ([taskID isEqualToString:@"downloadArticle"]) {
        [XKRWCui showInformationHudWithText:@"加载文章失败"];
        [self showRequestArticleNetworkFailedWarningShow];
    }
    else if ([taskID isEqualToString:@"deleteArticle"]) {
        [XKRWCui showInformationHudWithText:@"删除文章失败"];
    }
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    [super didDownloadWithResult:result taskID:taskID];
    
    if ([taskID isEqualToString:@"downloadArticle"]) {
        self.articleEntity = result;
        [self hiddenRequestArticleNetworkFailedWarningShow];
        [self.tableView reloadData];
        
        [XKRWCui hideProgressHud];
        _isLoaded = YES;

        if (self.articleEntity == nil) {
            [XKRWCui showInformationHudWithText:@"该文章不存在"];
        } else if (self.articleEntity.status == XKRWUserArticleStatusDeleteByAdmin||
                   self.articleEntity.status == XKRWUserArticleStatusDeleteByUser) {
            self.deletedView.alpha = 0.0;
            [UIView animateWithDuration:0.2 animations:^{
                self.deletedView.alpha = 1;
            }];
            [((XKRWNavigationController *)self.navigationController)navigationBarChangeFromDefaultNavigationBarToBlackHarfTransNavigationBar];
        } else {
            [self.tableView reloadData];
        }
        if (self.isSelfsArticle) {
            self.showDeleteButton = YES;
        } else {
            [_userHead setIconUrl:self.articleEntity.user_avatar
                      andLevelUrl:self.articleEntity.user_level];
        }
        
    } else if ([taskID isEqualToString:@"reportReason"]) {
        self.reportReasonArray = result;
        
    } else if ([taskID isEqualToString:@"deleteArticle"]) {
        
        [XKRWCui hideProgressHud];
        [XKRWCui showInformationHudWithText:@"删除成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }  else if ([taskID isEqualToString:@"commitComment"]) {

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
            [self downloadComments];
            
        } else {
            [XKRWCui showInformationHudWithText:@"评论失败"];
        }
        
    } else if ([taskID isEqualToString:@"addReport"]){
        if (result) {
            [XKRWCui showInformationHudWithText:@"举报成功"];
        } else {
            [XKRWCui showInformationHudWithText:@"举报失败"];
        }
        
    } else if ([taskID isEqualToString:@"downloadComment"]) {
        
        [self.commentMutArr removeAllObjects];
        [self.commentMutArr addObjectsFromArray:result[@"comment"]];
        
        self.commentCount = [result[@"commentNum"] integerValue];

        @try {
            
            [UIView performWithoutAnimation:^{
               [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
        }
        @catch (NSException *exception) {
            XKLog(@"%@",exception.description);
        }
        @finally {
            
        }
        
    } else if ([taskID isEqualToString:@"likeArticle"]) {
        if ([result boolValue]) {
            self.articleEntity.isLike = !self.articleEntity.isLike;
            self.articleEntity.likeNumber ++;
            [self.tableView reloadData];
        }
    }else if([taskID isEqualToString:@"delArticleLike"]){
        if ([result boolValue]) {
            self.articleEntity.isLike = !self.articleEntity.isLike;
            self.articleEntity.likeNumber --;
            [self.tableView reloadData];
        }
        if(_likeArticleDeleted){
            [XKRWCui showInformationHudWithText:@"取消成功"];
        }
    }
}

#pragma mark - UITableView's delegate and datasource
#pragma mark Header and Footer
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.aid != nil && self.aid.length > 0 && !self.isPreview) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= 0) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = nil;
    if (section >= 0) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
        footerView.backgroundColor = [UIColor clearColor];
    }
    return footerView;
}

#pragma mark Cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if (!self.isPreview) {
            return self.articleEntity.textContent.count + 2;
        }else{
            return self.articleEntity.textContent.count + 1;
        }
        
    } else if (section == 1) {
        return 1;
    } else if (section == 2 && (_commentCount > 3 || _commentCount == 0)) {
        return _commentMutArr.count + 2;
    } else if (section == 2 && (_commentCount <= 3 || _commentCount > 0)){
        return _commentMutArr.count + 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row ==  0) {
                return XKAppWidth * kCoverRatio;
            } else if (indexPath.row <= self.articleEntity.textContent.count) {

                NSArray *urls = self.articleEntity.imagePath.count > 0 && self.articleEntity.imagePath.count >= indexPath.row ? self.articleEntity.imagePath[indexPath.row - 1] : nil;
                NSArray *images = self.articleEntity.originalImages.count > 0 ? self.articleEntity.originalImages[indexPath.row - 1]: nil;
                
                return [_computeCell calculateSizeWithText:self.articleEntity.textContent[indexPath.row - 1]
                                                 imageURLs:urls
                                              ifHaveImages:images].size.height;
            } else {
                return 121;
            }
            break;
            
        case 1:
            if (!self.isSelfsArticle) {
                return 120;
            } else {
                return 44;
            }
            break;
            
        case 2:
            if (indexPath.row == 0 ) {
                return 25 + 30 + 10 ;
            } else if (indexPath.row == _commentMutArr.count + 1) {
                return 44;
            } else {
                XKRWCommentEtity *entity = _commentMutArr[(indexPath.row - 1)];
                
                static XKRWFitCommentCell *cell;
                if (!cell) {
                    cell = [[XKRWFitCommentCell alloc] init];
                }
                cell.replyImageView.hidden = YES;
                entity.sub_Array = nil;
                cell.entity = entity;
                
                return cell.line.bottom + 1;
            }
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row ==  0) {
                
                XKRWUserArticleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleTitleCell"];
                
               
                cell.title.text = self.articleEntity.articleTitle;
                
                if (self.isSelfsArticle) {
                    _userHead.hidden = YES;
                    cell.titleLeadingSpace.constant = 15;
                } else {
                    [cell.infoView addSubview:_userHead];
                    if (self.isPreview) {
                        _userHead.hidden = YES;
                        cell.titleLeadingSpace.constant = 15;
                    }else{
                        _userHead.hidden = NO;
                        cell.titleLeadingSpace.constant = 70;
                    }
                }
                
                if (self.articleEntity.mainPicture) {
                    [cell.coverImageView setImage:self.articleEntity.mainPicture];
                } else {
                    NSURL *url;
                    if ([XKRWUtil pathIsNative:self.articleEntity.mainPicturePath]) {
                        url = [[NSURL alloc] initFileURLWithPath:self.articleEntity.mainPicturePath];
                    } else {
                        url = [NSURL URLWithString:self.articleEntity.mainPicturePath];
                    }
                    [cell.coverImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"share_cover_placeholder"]];
                }
                return cell;
                
            } else if (indexPath.row <= self.articleEntity.textContent.count) {
                XKRWArticleSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleSectionCell"];
                cell.isEdit = NO;
                cell.indexPath = indexPath;
                
                NSArray *urls = self.articleEntity.imagePath.count > 0 && self.articleEntity.imagePath.count >= indexPath.row ? self.articleEntity.imagePath[indexPath.row - 1] : nil;
                NSArray *images = self.articleEntity.originalImages.count > 0 ? self.articleEntity.originalImages[indexPath.row - 1] : nil;
                
                [cell setContentWithText:self.articleEntity.textContent[indexPath.row - 1]
                               imageURLs:urls
                            ifHaveImages:images
                           sectionNumber:indexPath.row];
                
                __weak typeof(self) weakSelf = self;
                
                cell.imageClickHandler = ^(NSIndexPath *ip, NSInteger imageIndex) {
                    
                    XKRWPhotoBrowserVC *vc = [[XKRWPhotoBrowserVC alloc] init];
                    
                    vc.clickForBack = YES;
                    
                    if (weakSelf.articleEntity.originalImages.count) {
                        vc.images = weakSelf.articleEntity.originalImages[ip.row - 1];
                    } else {
                        vc.imageURLs = weakSelf.articleEntity.imagePath[ip.row - 1];
                    }
                    vc.currentIndex = imageIndex;
                    
                    vc.rightNavigationItemOption_oc = [[NSDictionary alloc] init];
                    
                    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                    [weakSelf presentViewController:vc animated:false completion:nil];
                };
                
                return cell;
            } else {
                if (!self.isPreview) {
                    XKRWUserArticleEndCell *cell = [tableView dequeueReusableCellWithIdentifier:@"endCell"];
                    cell.topicLabel.text = self.articleEntity.topic.name;
                    
                    __weak __typeof(self) weakSelf = self;
                    
                    cell.clickTopicAction = ^(){
                        XKRWTopicVC *vc = [[XKRWTopicVC alloc] init];
                        vc.topicStr = weakSelf.articleEntity.topic.name;
                        vc.topicId = @(weakSelf.articleEntity.topic.topicId);
                        
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    };
                    
                    return cell;
                }else{
                    return [UITableViewCell new];
                }
            }
            break;
        case 1: {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"likeCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"likeCell"];
                [cell.contentView addSubview:_likeView];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *likeCellTitle = [NSString stringWithFormat:@"已有%ld人喜欢这篇分享",(long)self.articleEntity.likeNumber];
            
            if (!self.isSelfsArticle) {
                if (_articleEntity.isLike) {
                    [_likeView setContentWithTitle:likeCellTitle ImageName:@"ylike_" ImageLabelText:@"已喜欢"];
                } else {
                    [_likeView setContentWithTitle:likeCellTitle ImageName:@"like_" ImageLabelText:@"喜欢"];
                }
                typeof(self) __weak weakSelf = self;
                _likeView.likeButtonClicked = ^(NSString *likeLabelText){
                  
                    if ([likeLabelText isEqualToString:@"喜欢"]) {
                        [weakSelf downloadWithTaskID:@"likeArticle" outputTask:^id{
                            return @([[XKRWUserArticleService shareService] addUserArticleLikeById:weakSelf.aid type:nil]);
                        }];
                    } else {
                        [weakSelf downloadWithTaskID:@"delArticleLike" outputTask:^id{
                            return @([[XKRWUserArticleService shareService] delUserArticleLikeById:weakSelf.aid type:nil]);
                        }];
                    }
                };
                
            } else {
                [_likeView hideLikePart];
                [_likeView setLikeTitle:likeCellTitle];
            }
            
            return cell;
        }
            break;
        case 2:
        {
            _editCell = [tableView dequeueReusableCellWithIdentifier:@"editCommentCell"];
//            _editCell.selectionStyle = UITableViewCellSelectionStyleGray;
            [_editCell.writeCommentBtn addTarget:self action:@selector(writeComment) forControlEvents:UIControlEventTouchUpInside];
            if (_commentCount == 0) { // 无评论
                if (indexPath.row == 0) {
                    _editCell.recentCommentLb.text = @"";
                    return _editCell;
                    
                } else {
                    XKRWMoreCommetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCommetCell"];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.haveComment = NO;
                    
                    return cell;
                }
                
            } else { // 有评论
                if (indexPath.row == 0) {
                    _editCell.recentCommentLb.text = @"最新评论";
                    return _editCell;
                    
                } else if (indexPath.row == _commentMutArr.count + 1) {
                    XKRWMoreCommetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCommetCell"];
                    if (cell == nil) {
                        cell = [[XKRWMoreCommetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCommetCell"];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.haveComment = YES;
                    cell.moreLabel.text = [NSString stringWithFormat:@"查看更多评论（%ld条）",(long)_commentCount];
                    return cell;
                    
                } else {
                    XKRWFitCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commetCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.timeLabel.hidden = YES;
                    cell.iconBtn.userInteractionEnabled = NO;
                    cell.replyImageView.hidden = YES;
                    __weak XKRWCommentEtity *entity = _commentMutArr[indexPath.row - 1];
                    entity.sub_Array = nil;
                    cell.selectIndexPath = indexPath;
                    cell.entity = entity;
                    cell.floorLabel.hidden = YES;
                    cell.articleReadingBtn.hidden = YES;
                    cell.commentLabel.userInteractionEnabled = NO;
                    cell.replyImageView.userInteractionEnabled = NO;
                    cell.replyView.userInteractionEnabled = NO;
                    __weak __typeof(self) weakSelf = self;
                    cell.openBlock = ^(NSIndexPath *ip , BOOL state) {
                        entity.isOpen = !state;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:
                         UITableViewRowAnimationNone];
                    };
                    
                    if (indexPath.row == _commentMutArr.count) {
                        cell.line.hidden = YES;
                    } else {
                        cell.line.hidden = NO;
                    }
                    return cell;
                }
            }
        }
            break;
        default:
            break;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && _commentCount > 0 && indexPath.row > 0) {
        
        [MobClick event:@"clk_MoreReview"];
        
        XKRWArticleCommentVC *vc = [[XKRWArticleCommentVC alloc] init];
        vc.blogId = _articleEntity.aid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Action

- (void)writeComment {
    [MobClick event:@"clk_WriteReview"];
    [self.inputBoxView beginEditWithPlaceholder:@"评论"];
}

- (void)moreOperationClick {
    XKRWActionSheet *actionSheet;
    if (self.isSelfsArticle) {
        actionSheet = [[XKRWActionSheet alloc] initShareHeaderSheetWithCancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitle:nil];
        actionSheet.tag = 2;
    } else {
        actionSheet = [[XKRWActionSheet alloc] initShareHeaderSheetWithCancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@"举报"];
        actionSheet.tag = 1;
    }
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

#pragma mark - XKRWInputBoxViewDelegate

- (void)inputBoxView:(XKRWInputBoxView *)inputBoxView sendMessage:(NSString *)message {
    if (message.length == 0) {
        [XKRWCui showInformationHudWithText:@"评论内容不能为空哦~"];
        
    } else {
        [self downloadWithTaskID:@"commitComment" outputTask:^id{
            return  [[XKRWManagementService5_0 sharedService] writeCommentWithMessage:message Blogid:self.articleEntity.aid sid:0 fid:0 type:0];
        }];
        
    }
}
//- (void)commitWithMsg:(NSString *)msg fid:(NSInteger)fid sid:(NSInteger)sid
//{
//    if (msg.length == 0 || msg == nil) {
//        [XKRWCui showInformationHudWithText:@"评论不能为空"];
//    } else {
//        [self downloadWithTaskID:@"commitComment" outputTask:^id{
//            return [[XKRWManagementService5_0 sharedService] writeCommentWithMessage:msg Blogid:self.aid sid:sid fid:fid type:0];
//        }];
//    }
//}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex != alertView.cancelButtonIndex) {
        
        [XKRWCui showProgressHud:@"删除文章中"];
        [self downloadWithTaskID:@"deleteArticle" outputTask:^id{
            return @([[XKRWUserArticleService shareService] deleteUserArticleById:self.articleEntity.aid]);
        }];
    }
}

#pragma mark - XKRWActionSheetDelegate

- (void)actionSheet:(XKRWActionSheet *)actionSheet clickedHeaderAtIndex:(NSInteger)buttonIndex {
    NSString *shareTitle = nil;
    
    shareTitle = [NSString stringWithFormat:@"%@ - %@\n - 分享自瘦瘦", _articleEntity.topic.name,_articleEntity.articleTitle];
    
    UIImage *icon = [UIImage imageWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.articleEntity.mainPicturePath, kNineThumb]]];
    
    if (buttonIndex == 1) {
        [MobClick event:@"clk_ShareWechat"];
        
        //微信分享
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = _articleEntity.articleURL;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession]
                                                           content:nil
                                                             image:icon
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
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _articleEntity.articleURL;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline]
                                                           content:nil
                                                             image:icon
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
        [UMSocialData defaultData].extConfig.qzoneData.url = _articleEntity.articleURL;
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone]
                                                           content:nil
                                                             image:icon
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
        NSString *shareText = [NSString stringWithFormat:@"%@ - %@ - %@\n - 分享自瘦瘦", _articleEntity.topic.name, _articleEntity.articleTitle, _articleEntity.articleURL];
        
        [[UMSocialControllerService defaultControllerService] setShareText:shareText
                                                                shareImage:icon
                                                          socialUIDelegate:(id)self];
        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    
  
}

- (void)actionSheet:(XKRWActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 1 && buttonIndex == 0) {
        [MobClick event:@"clk_report"];
        if ([XKUtil isNetWorkAvailable] == FALSE) {
            [XKRWCui showInformationHudWithText:@"没有网络，请检查网络设置"];
            return;
        }
        
        XKRWActionSheet *actionSheet = [[XKRWActionSheet alloc]initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:nil];
        actionSheet.delegate = self;
        actionSheet.tag = 10086;
        for (NSDictionary *temp in _reportReasonArray) {
            [actionSheet addButtonWithTitle:temp[@"name"]];
        }
        
        [actionSheet showInView:self.view];
        
    } else if (actionSheet.tag == 2 && buttonIndex == actionSheet.destructiveButtonIndex) {
        [self deleteArticle];
        
    } else if (actionSheet.tag == 10086) {
        
        [MobClick event:@"clk_report"];
        NSString *reason = [NSString stringWithFormat:@"%@",[_reportReasonArray[buttonIndex] objectForKey:@"id"]];
        [self downloadWithTaskID:@"addReport" outputTask:^id{
            
            return @( [[XKRWUserArticleService shareService] reportWithItem_id:_articleEntity.aid type:XKRWUserReportArticle blogId:@"" reason:reason]);
        }];
        
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > XKAppWidth * kCoverRatio - 64 && !self.showNaviBar) {
        [((XKRWNavigationController *)self.navigationController) navigationBarChangeFromDefaultNavigationBarToBlackHarfTransNavigationBar];
        self.title = self.articleEntity.articleTitle;
        self.showNaviBar = YES;
        
    } else if (scrollView.contentOffset.y < XKAppWidth * kCoverRatio - 64 && self.showNaviBar) {
        [((XKRWNavigationController *)self.navigationController) navigationBarChangeFromBlackHalfTransNavigationBarToTransparencyNavigationBar];
        self.title = @"";
        self.showNaviBar = NO;
    }
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
