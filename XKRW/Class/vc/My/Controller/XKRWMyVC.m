//
//  XKRWMoreVC.m
//  XKRW
//
//  Created by yaowq on 13-12-11.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWMyVC.h"
#import "XKRWCui.h"
#import "SDImageCache.h"
#import "NSTimer+XKDispatch.h"
#import "XKRWUserDefaultService.h"
#import "XKRWUserService.h"
#import "UIImageView+WebCache.h"
#import "XKRWNaviRightBar.h"
#import "XKRWCommHelper.h"
#import "UIButton+WebCache.h"
#import "XKRWRecordService4_0.h"
#import "XKRWChangeUserInfoVC.h"
#import "XKRWCollectVC.h"
#import "XKRWTableViewHeader.h"
#import "XKRW-Swift.h"
#import "XKRWDataCenterVC.h"
#import "XKRWLikeVC.h"
#import "RSKImageCropper.h"
#pragma mark - XKRWMyVC

@interface XKRWMyVC () <XKRWMyViewPraiseCellDelagate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>
{
    XKRWTableViewHeader *header;
    XKRWHeaderView *headerView;
    NSInteger    thumpUpNum;
    NSInteger    BePraisedNum;
    XKRWUserHonorEnity *honorEntity;
    
    BOOL  isShowAPPRecommend;
}

@end

@implementation XKRWMyVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBePraiseNoticeNum) name:BePraiseNoticeChanged object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    self.forbidAutoAddCloseButton = YES;
    [super viewDidLoad];
    [XKUtil executeCodeWhenSystemVersionAbove:7.0 blow:0 withBlock:^{
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    }];
    self.navigationController.delegate = self;
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick event:@"in_Wo"];
    
    if ([[XKRWServerPageService sharedService] needRequestStateOfSwitch]) {
        isShowAPPRecommend = NO;
        [self downloadWithTaskID:@"requestState" outputTask:^{
            return @([[XKRWServerPageService sharedService] isShowPurchaseEntry_uploadVersion]);
        }];
    } else {
        isShowAPPRecommend = YES;
    }
    
    
    XKRWNavigationController *nav = (XKRWNavigationController *)self.navigationController;
    [nav navigationBarChangeFromDefaultNavigationBarToTransparencyNavigationBar];
    
    headerView.nickNamelabel.text = [[XKRWUserService sharedService]getUserNickName].length==0?@"设置昵称":[[XKRWUserService sharedService]getUserNickName];
    headerView.menifestoLabel.text = [[XKRWUserService sharedService]getUserManifesto].length==0?@"设置宣言":[[XKRWUserService sharedService]getUserManifesto];
    headerView.sexImageView.image = [[XKRWUserService sharedService]getSex] ? [UIImage imageNamed:@"me_ic_female"] :[UIImage imageNamed:@"me_ic_male"];
    
    [_tableView reloadData];
    
    [self setNavifationItemWithLeftItemTitle:nil AndRightItemTitle:nil AndItemColor:[UIColor whiteColor] andShowLeftRedDot:NO AndShowRightRedDot:YES AndLeftRedDotShowNum:NO AndRightRedDotShowNum:NO AndLeftItemIcon:nil AndRightItemIcon:@"setting"];
    
   
    
    //获取用户点赞与被赞数据
    [self getUserPraiseNum];
    
    //获取用户荣誉数据
    [self getUserHonorData];
    [self checkMoreRed];
    
    [self hideNavigationLeftItemRedDot:YES andRightItemRedDotNeedHide:![XKRWUserDefaultService isShowMoreredDot]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    XKRWNavigationController *nav = (XKRWNavigationController *)self.navigationController;
    [nav navigationBarChangeFromTransparencyNavigationBarToDefaultNavigationBar];
}


- (void)initView{
    self.tableView = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    headerView = [XKRWHeaderView instance];
    
    NSString *urlString = [[XKRWUserService sharedService] getUserAvatar];
    if (urlString && ![urlString isKindOfClass:[NSNull class]]) {
        [headerView.headerButton setImageWithURL:[NSURL URLWithString:urlString]
                                        forState:UIControlStateNormal
         
                                placeholderImage:[UIImage imageNamed:@"lead_nor"]
                                         options:SDWebImageRetryFailed];
    } else {
        [headerView.headerButton setImage:[UIImage imageNamed:@"lead_nor"] forState:UIControlStateNormal];
    }
    
    headerView.nickNamelabel.text = [[XKRWUserService sharedService]getUserNickName].length==0?@"设置昵称":[[XKRWUserService sharedService]getUserNickName];
    headerView.menifestoLabel.text = [[XKRWUserService sharedService]getUserManifesto].length==0?@"设置宣言":[[XKRWUserService sharedService]getUserManifesto];
    
    headerView.sexImageView.image = [[XKRWUserService sharedService]getSex] ? [UIImage imageNamed:@"me_ic_female"] :[UIImage imageNamed:@"me_ic_male"];
    headerView.delegate = self;
    header = [XKRWTableViewHeader expandWithScrollView:_tableView expandView:headerView];
    
    [headerView.backgroundImageView setImageWithURL:[NSURL URLWithString:[[XKRWUserService sharedService] getUserBackgroundImage]]];
    
    headerView.insistLabel.text = [NSString stringWithFormat:@"已坚持了%ld天",(long)[[XKRWUserService sharedService ]getInsisted]];
    headerView.insistLabel.textColor = [UIColor whiteColor];
}


- (void)getUserPraiseNum
{
    [self downloadWithTaskID:@"thumpUpAndBeParised" outputTask:^id{
        return  [[XKRWUserService sharedService] getUserThumpUpAndBeParisedInfomation];
    }];
}

- (void)getUserHonorData{
    [self downloadWithTaskID:@"getHonorData" outputTask:^id{
        return [[XKRWUserService sharedService] getUserHonorData];
    }];
    
}

/**
 *  修改被赞消息条数
 */
- (void)changeBePraiseNoticeNum
{
    
    NSIndexPath *indexPatch = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPatch] withRowAnimation:UITableViewRowAnimationFade];
}


/**
 *  修改所有未读的消息条数
 */
- (void)changeAllUnreadNoticeNum
{
    
}

#pragma --mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        if(isShowAPPRecommend){
            return 4;
        }else{
            return 3;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        XKRWMyViewPraiseCell *praiseCell = [tableView dequeueReusableCellWithIdentifier:@"praiseCell"];
        if(praiseCell == nil){
            praiseCell = LOAD_VIEW_FROM_BUNDLE(@"XKRWMyViewPraiseCell");
            praiseCell.praiseCellDelegate = self;
            praiseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSInteger  unreadNum = [[XKRWNoticeService sharedService] getUnreadBePraisedNoticeNum];
        if (unreadNum > 0) {
            praiseCell.bePraisedRedImageView.hidden = NO;
            praiseCell.unreadBePraisedLable.text = [NSString stringWithFormat:@"%ld",(long)unreadNum];
        }else{
            praiseCell.bePraisedRedImageView.hidden = YES;
        }
        
        BePraisedNum = [[[NSUserDefaults standardUserDefaults] objectForKey:BEPRAISEDNUM]integerValue];
        thumpUpNum = [[[NSUserDefaults standardUserDefaults] objectForKey:THUMPUPNUM]integerValue];
        [praiseCell.bePraisedNumLabel setTitle:[NSString stringWithFormat:@"%ld",(long)BePraisedNum] forState:UIControlStateNormal];
        [praiseCell.thumpUpNumLabel setTitle:[NSString stringWithFormat:@"%ld",(long)thumpUpNum] forState:UIControlStateNormal];
        return praiseCell;
    }
    else if (indexPath.section == 1)
    {
        XKRWCommonCell  *collectCell = [tableView dequeueReusableCellWithIdentifier:@"collectCellIndentifer"];
        if (collectCell == nil)
        {
            collectCell = [[XKRWCommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectCellIndentifer"];
        }
        switch (indexPath.row) {
            case 0:
                collectCell.titleLabel.text = @"评估报告";
                collectCell.descriptionLabel.text = @"查看、修改和重置方案";
                [collectCell.upLineView setHidden:NO];
                [collectCell.headerBtn setBackgroundImage:[UIImage imageNamed:@"me_ic_evaluate"] forState:UIControlStateNormal];
                break;
            case 1:
            {
                collectCell.titleLabel.text = @"数据中心";
                collectCell.descriptionLabel.text = @"围度、统计数据";
                [collectCell.upLineView setHidden:YES];
                [collectCell.headerBtn setBackgroundImage:[UIImage imageNamed:@"me_ic_data"] forState:UIControlStateNormal];
            }
                break;
            case 2:
                collectCell.titleLabel.text = @"我的收藏";
                collectCell.descriptionLabel.text = @"文章、食物和运动";
                [collectCell.downLineView setHidden:NO];
                [collectCell.headerBtn setBackgroundImage:[UIImage imageNamed:@"me_ic_mark"] forState:UIControlStateNormal];
                break;
            case 3:
                collectCell.titleLabel.text = @"猜你喜欢";
                collectCell.descriptionLabel.text = @"发现更多有趣应用";
                [collectCell.downLineView setHidden:NO];
                [collectCell.headerBtn setBackgroundImage:[UIImage imageNamed:@"me_ic_apps"] forState:UIControlStateNormal];
                break;

            default:
                break;
        }
        
        return collectCell;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 64;
    }else{
        return 44;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
        [view setBackgroundColor:XKClearColor];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 0)
    {
        
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                [MobClick event:@"in_RptMyPlan"];
                XKRWThinBodyAssess_5_3VC *bodyAssesssVC = [[XKRWThinBodyAssess_5_3VC alloc]initWithNibName:@"XKRWThinBodyAssess_5_3VC" bundle:nil];
                bodyAssesssVC.hidesBottomBarWhenPushed = YES;
                [bodyAssesssVC setFromWhichVC:MyVC];
                [self.navigationController pushViewController:bodyAssesssVC animated:YES];
            }
                break;
            case 1:
            {
                XKRWDataCenterVC *dataCenterVC =  [[XKRWDataCenterVC alloc]init];
                dataCenterVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:dataCenterVC animated:YES];
            }
                break;
            case 2:
            {
                XKRWCollectVC *collectVC = [[XKRWCollectVC alloc]init];
                collectVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:collectVC animated:YES];
            }
                break;
            case 3:
            {
                XKRWAppRecommendVC *appRecommendVC = [[XKRWAppRecommendVC alloc]init];
                appRecommendVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:appRecommendVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
//    else if(indexPath.section == 2)  //购买记录页面
//    {
//        UIStoryboard *internalTest = [UIStoryboard storyboardWithName:@"InternalTestStoryBoard" bundle:nil];
//        ITMainVC *vc = [internalTest instantiateViewControllerWithIdentifier:@"ITMainVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }
    
}

#pragma --mark XKRWMyViewPraiseCellDelegate
- (void)entrybePraisedVC
{
    NSInteger  unreadNum = [[XKRWNoticeService sharedService] getUnreadBePraisedNoticeNum];
    
//    if(unreadNum == 0)
//    {
    XKRWBePraisedVC *praisedVC = [[XKRWBePraisedVC alloc]initWithNibName:@"XKRWBePraisedVC" bundle:nil];
    praisedVC.hidesBottomBarWhenPushed = YES;
    
    if(unreadNum > 0){
        praisedVC.dataType = bePraiseDataTypeFromDataBase;
    }
    
    [self.navigationController pushViewController:praisedVC animated:YES];
//    }else{
//        XKRWNoticeCenterVC *noticeVC = [[XKRWNoticeCenterVC alloc]initWithNibName:@"XKRWNoticeCenterVC" bundle:nil];
//        noticeVC.hidesBottomBarWhenPushed = YES;
//        noticeVC.noticeType = 3;
//        [self.navigationController pushViewController:noticeVC animated:YES];
//    }
    [MobClick event:@"clk_LikeMe"];
}

- (void)entrythumpUpVC
{
    XKRWLikeVC *likeVC = [[XKRWLikeVC alloc] init];
    likeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:likeVC animated:YES];
    
    [MobClick event:@"clk_MeLike"];
}

#pragma --mark Action
- (void)checkMoreRed
{
    if ( ![XKRWUserDefaultService isShowMoreredDot] ) {
        if ([self.delegate respondsToSelector:@selector(clearRedDotFromMore)]) {
            [self.delegate clearRedDotFromMore];
        }
    }
}



- (void)rightItemAction:(UIButton *)button
{
    XKRWSetVC *setVC = [[XKRWSetVC alloc]initWithNibName:@"XKRWSetVC" bundle:nil];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}


#pragma --mark XKRWHeaderView


- (void)changeBackgroundImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册上传图片",nil];
    actionSheet.tag = 10011;
    [actionSheet showInView:self.view];
    
    [MobClick event:@"clk_background"];
}

//修改用户头像
- (void)changeUserInfoHeadImage
{
    [MobClick event:@"clk_head"];
    if ([XKUtil isNetWorkAvailable] == FALSE) {
        [XKRWCui showInformationHudWithText:@"没有网络，请检查网络设置"];
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选取照片",@"拍照",nil];
    actionSheet.tag = 10010;
    [actionSheet showInView:self.view];
}

- (void)entryUserInfo
{
    XKRWChangeUserInfoVC *personInfoVC = [[XKRWChangeUserInfoVC alloc] init];
    personInfoVC.entity =  honorEntity;
    personInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personInfoVC animated:YES];
}

#pragma --mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 10010) {
        if (buttonIndex == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.view.tag = actionSheet.tag;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        else if (buttonIndex == 1){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.view.tag = actionSheet.tag;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else if(actionSheet.tag ==  10011)
    {
        if (buttonIndex == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.view.tag = actionSheet.tag;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            //            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

#pragma  --mark  UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [MobClick event:@"set_face pic"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if ([XKUtil isNetWorkAvailable] == FALSE) {
            [XKRWCui showInformationHudWithText:@"没有网络，请检查网络设置"];
            return;
        }
        if (picker.view.tag == 10010){
            [self uploadWithTaskID:@"changeHeadImage" task:^{
                [XKRWCui showProgressHud:@"提交中..."];
                [[XKRWUserService sharedService] setUserAvatar:[info objectForKey:UIImagePickerControllerEditedImage]];
            }];
        }
        else if (picker.view.tag == 10011){
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            
            RSKImageCropViewController *vc = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCustom];
            vc.delegate = self;
            vc.dataSource = self;
            vc.avoidEmptySpaceAroundImage = YES;
            vc.rotationEnabled = NO;
            
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
}

#pragma mark - RSKImageCropViewController's delegate

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller {
    
    CGSize maskSize = CGSizeMake(XKAppWidth, XKAppWidth * 21 / 32);
    
    return CGRectMake(0, (controller.view.height - maskSize.height) * 0.5, maskSize.width, maskSize.height);
}

- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller {
    
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path closePath];
    
    return path;
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    
    [controller dismissViewControllerAnimated:YES completion:^{
        
        [self uploadWithTaskID:@"changeBackgroundImage" task:^{
            [[XKRWUserService sharedService] setUserBackgroundImageView:croppedImage];
        }];
    }];
}

#pragma --mark dealNetWork

- (void)didUploadWithResult:(id)result taskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"changeHeadImage"]) {
        
        [[XKRWUserService sharedService] saveUserInfo];
        NSString *urlString = [[XKRWUserService sharedService]getUserAvatar];
        if (urlString && ![urlString isKindOfClass:[NSNull class]]) {
            [headerView.headerButton setImageWithURL:[NSURL URLWithString:urlString]
                                            forState:UIControlStateNormal
                                    placeholderImage:[UIImage imageNamed:@"lead_nor"]
                                             options:SDWebImageRetryFailed];
        } else {
            [headerView.headerButton setImage:[UIImage imageNamed:@"lead_nor"] forState:UIControlStateNormal];
        }
        [_tableView reloadData];
    }
    
    if ([taskID isEqualToString:@"changeBackgroundImage"]) {
        
        NSString *urlString = [[XKRWUserService sharedService] getUserBackgroundImage];
        
        if (urlString && ![urlString isKindOfClass:[NSNull class]]) {
            [headerView.backgroundImageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageRetryFailed];
        }
    }
}

- (void)handleUploadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"changeHeadImage"]) {
        [XKRWCui showInformationHudWithText:@"头像设置失败"];
    }
    
    if ([taskID isEqualToString:@"changeBackgroundImage"]){
        [XKRWCui showInformationHudWithText:@"设置背景图失败"];
    }
    
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
//    XKLog(@"%@",result);
    if ([taskID isEqualToString:@"thumpUpAndBeParised"]){
        thumpUpNum = [[[result objectForKey:@"data"]objectForKey:@"send"] integerValue] + [[[result objectForKey:@"data"]objectForKey:@"post_send"] integerValue] ;
        BePraisedNum = [[[result objectForKey:@"data"]objectForKey:@"recv"] integerValue] + [[[result objectForKey:@"data"]objectForKey:@"post_recv"] integerValue] ;
        [_tableView reloadData];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:thumpUpNum] forKey:THUMPUPNUM];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:BePraisedNum] forKey:BEPRAISEDNUM];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }else if ([taskID isEqualToString:@"getHonorData"]){
        
        honorEntity = [[XKRWUserHonorEnity alloc]init];
        
        NSDictionary *data = [result objectForKey:@"data"];
        
        honorEntity.nowDegree = [data objectForKey:@"now"];
        honorEntity.nextDegree = [data objectForKey:@"next"];
        honorEntity.nowDegreeProgress = [[data objectForKey:@"rank"] integerValue];
        honorEntity.nowExperience = [[data objectForKey:@"score"] integerValue];
        honorEntity.nextDegreeExperience = [[data objectForKey:@"up"] integerValue];
        
        [headerView.degreeImageView setImageWithURL:[NSURL URLWithString:honorEntity.nowDegree] placeholderImage:[UIImage imageNamed:@"level_image"] options:SDWebImageRetryFailed];
    }
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [super handleDownloadProblem:problem withTaskID:taskID];
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication {
    return YES;
}



#pragma --mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    XKRWNavigationController *nav = (XKRWNavigationController *)self.navigationController;
    [nav changeImageViewAlpha:0-scrollView.contentOffset.y andHeaderViewHeight:120 AndViewController:self andnavigationBarTitle:@"我"];
}

#pragma --mark NavigationControllerDelegate
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
