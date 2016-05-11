//
//  XKRWTabbarVC.m
//  XKRWTabbarVC
//
//  Created by Jiang Rui on 13-12-10.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWTabbarVC.h"
#import "XKRWCui.h"
#import "XKRWUserService.h"
#import "LRatingRemaindTool.h"

#import "XKRWCityControlService.h"
#import "XKCuiUtil.h"
#import "XKRWCommHelper.h"
#import "XKRWShareVC.h"
#import "XKRWRecordService4_0.h"
#import "XKRWVersionService.h"
#import "XKRWNeedLoginAgain.h"
#import "XKRWAccountService.h"
#import "XKRWMyVC.h"
#import "XKRWNavigationController.h"
#import "XKRW-Swift.h"
#import "XKRWDBControlService.h"
#import "Reachability.h"
#import "XKRWPlanVC.h"

@interface XKRWTabbarVC () <XKRWShareVCDelegate, UIAlertViewDelegate,XKRWCheckMoreRedDotDelegate>
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) XKRWDiscover_5_2 *discoverVC;
@end

@implementation XKRWTabbarVC
{
    BOOL _isShowRedDot;
    UIImageView *redDotView;
    UIImageView *moreRedDotView;
    UIImageView *numImageView;
    UILabel     *numLabel;
    
    UIImageView *articleNumImageView;
    UILabel     *articleLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createCustomTabBar
{
    tabbarBG = [[UIImageView alloc] init];
    tabbarBG.backgroundColor = [UIColor whiteColor];
    tabbarBG.userInteractionEnabled = YES;
    
    tabbarBG.frame = CGRectMake(0,0, XKAppWidth, self.tabBar.height);
    [self.tabBar addSubview:tabbarBG];
    self.tabBar.barStyle = UIBarStyleBlackOpaque;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, .5)];
    line.backgroundColor = XKSepDefaultColor;
    [tabbarBG addSubview:line];
    
    personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.tag = 0;
   
    if (XKAppWidth == 320) {
        [personBtn setBackgroundImage:[UIImage imageNamed:@"ic_home"] forState:UIControlStateNormal];
        [personBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_p"] forState:UIControlStateSelected];
        [personBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_p"] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"ic_home"];
         personBtn.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    }else{
        [personBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_six_"] forState:UIControlStateNormal];
        [personBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_p_six_"] forState:UIControlStateSelected];
        [personBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_p_six_"] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"ic_home_six_"];
        personBtn.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    }
    
    [personBtn addTarget:self action:@selector(personBtn_Click:) forControlEvents:UIControlEventTouchDown];
    personBtn.selected = YES;
    [tabbarBG addSubview:personBtn];
    
    schemeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    schemeBtn.tag = 1;
    if (XKAppWidth == 320) {
        [schemeBtn setBackgroundImage:[UIImage imageNamed:@"ic_discover"] forState:UIControlStateNormal];
        [schemeBtn setBackgroundImage:[UIImage imageNamed:@"ic_discover_p"] forState:UIControlStateSelected];
        [schemeBtn setBackgroundImage:[UIImage imageNamed:@"ic_discover_p"] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"ic_discover"];
        schemeBtn.frame = CGRectMake(XKAppWidth/4*1, 0.0, image.size.width, image.size.height);
    }else{
        [schemeBtn setBackgroundImage:[UIImage imageNamed:@"ic_discover_six_"] forState:UIControlStateNormal];
        [schemeBtn setBackgroundImage:[UIImage imageNamed:@"ic_discover_p_six_"] forState:UIControlStateSelected];
        [schemeBtn setBackgroundImage:[UIImage imageNamed:@"ic_discover_p_six_"] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"ic_discover_six_"];
        schemeBtn.frame = CGRectMake(XKAppWidth/4*1,0.0, image.size.width, image.size.height);
        XKLog(@"%f,%f",image.size.width,image.size.height);
    }

    [schemeBtn addTarget:self action:@selector(schemeBtn_Click:) forControlEvents:UIControlEventTouchDown];
    [tabbarBG addSubview:schemeBtn];
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.tag = 2;
    if (XKAppWidth == 320) {
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_service"] forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_service_p"] forState:UIControlStateSelected];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_service_p"] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"ic_service"];
        shareBtn.frame = CGRectMake(XKAppWidth/4*2, 0.0, image.size.width, image.size.height);
    }else{
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_service_six_"] forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_service_p_six_"] forState:UIControlStateSelected];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_service_p_six_"] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"ic_service_six_"];
        shareBtn.frame = CGRectMake(XKAppWidth/4*2, 0.0, image.size.width, image.size.height);
    }

    [shareBtn addTarget: self action:@selector(shareBtn_Click:) forControlEvents:UIControlEventTouchDown];
    
    _isShowRedDot = NO;

    [tabbarBG addSubview:shareBtn];
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.tag = 3;
    if (XKAppWidth == 320) {
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"ic_me"] forState:UIControlStateNormal];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"ic_me_p"] forState:UIControlStateSelected];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"ic_me_p"] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"ic_me"];
        moreBtn.frame = CGRectMake(XKAppWidth/4*3, 0.0, image.size.width, image.size.height);
    }else{
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"ic_me_six_"] forState:UIControlStateNormal];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"ic_me_p_six_"] forState:UIControlStateSelected];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"ic_me_p_six_"] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"ic_me_six_"];
        moreBtn.frame = CGRectMake(XKAppWidth/4*3, 0.0, image.size.width, image.size.height);
    }
   
    [moreBtn addTarget: self action:@selector(moreBtn_Click:) forControlEvents:UIControlEventTouchDown];
    [tabbarBG addSubview:moreBtn];
    
    if ([XKRWUserDefaultService isShowMoreredDot] ) {
        UIImage *redDot = [UIImage imageNamed:@"unread_red_dot"];
        moreRedDotView = [[UIImageView alloc] initWithImage:redDot];
        CGRect rect = moreRedDotView.frame;
        if (XKAppWidth == 320) {
            rect.origin = CGPointMake(53.f, 6.f);
        }else if (XKAppWidth == 375 ){
            rect.origin = CGPointMake(60.f, 6.f);
        }else{
            rect.origin = CGPointMake(65.f, 6.f);
        }
        moreRedDotView.frame = rect;
        [moreBtn addSubview:moreRedDotView];
    }
    
    UIImage *numImage = [UIImage imageNamed:@"notice_l"];
    numImageView = [[UIImageView alloc] initWithImage:numImage];
    CGRect rect = CGRectMake(0, 0, 16, 16);
    if (XKAppWidth == 320) {
        rect.origin = CGPointMake(48.f, 1.f);
    }else if (XKAppWidth == 375 ){
        rect.origin = CGPointMake(55.f, 1.f);
    }else{
        rect.origin = CGPointMake(60.f, 1.f);
    }
    numImageView.frame = rect;
    numImageView.hidden = YES;
    [moreBtn addSubview:numImageView];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    numLabel.text = @"99";
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = XKDefaultFontWithSize(12);
    [numImageView addSubview:numLabel];
    
    if([[XKRWNoticeService sharedService] getUnreadBePraisedNoticeNum] > 0){
        numImageView.hidden = NO;
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)[[XKRWNoticeService sharedService] getUnreadBePraisedNoticeNum]];
    }
    
 
    articleNumImageView = [[UIImageView alloc] initWithImage:numImage];

    articleNumImageView.frame = rect;
    articleNumImageView.hidden = YES;
    [schemeBtn addSubview:articleNumImageView];
    
    articleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    articleLabel.text = @"99";
    articleLabel.textAlignment = NSTextAlignmentCenter;
    articleLabel.textColor = [UIColor whiteColor];
    articleLabel.font = XKDefaultFontWithSize(12);
    [articleNumImageView addSubview:articleLabel];
    
    if([[XKRWNoticeService sharedService] getUnreadCommentOrSystemNoticeNum] > 0){
        articleNumImageView.hidden = NO;
        articleLabel.text = [NSString stringWithFormat:@"%ld",(long)[[XKRWNoticeService sharedService] getUnreadCommentOrSystemNoticeNum]];
    }
}

- (void)initTabbarViewControllers
{
    XKRWPlanVC *planVC = [[XKRWPlanVC alloc] init];
  //  XKRWSchemeVC_5_0 *schemeVC = [[XKRWSchemeVC_5_0 alloc] initWithNibName:@"XKRWSchemeVC_5_0" bundle:nil];
    self.discoverVC = [[XKRWDiscover_5_2 alloc] initWithNibName:@"XKRWDiscover_5_2" bundle:nil];
    XKRWShareVC *shareVC = [[XKRWShareVC alloc]init];
    XKRWMyVC *moreVC = [[XKRWMyVC alloc]init];
    moreVC.delegate = self;
    
    NSArray *vcArray = @[planVC,self.discoverVC,shareVC,moreVC];

    NSMutableArray  *navArray = [NSMutableArray arrayWithCapacity:[vcArray count]];
    XKRWNavigationController *nav;
    for (int i = 0; i < [vcArray count]; i++) {
        if (i == 3) {
            nav = [[XKRWNavigationController alloc]initWithRootViewController:[vcArray objectAtIndex:i ] withNavigationBarType:NavigationBarTypeTransparency];
            
        }else{
            nav = [[XKRWNavigationController alloc]initWithRootViewController:[vcArray objectAtIndex:i ] withNavigationBarType:NavigationBarTypeDefault];
        }
        [navArray addObject:nav];
    }
    
    self.viewControllers = navArray;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createCustomTabBar];
    [self initTabbarViewControllers];
    
    __block XKRWTabbarVC * weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(exitTheAccount) name:@"Exit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(hideTabbar) name:@"hideTabbar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(showTabbar) name:@"showTabbar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(dealWithSystemTabbarShow) name:@"dealSystemTabbarShow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBePraiseNoticeNum) name:BePraiseNoticeChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCommentAndSystemNoticeNum) name:CommentAndSystemNoticeChanged object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    //获取已坚持
    [self downloadWithTaskID:@"getSignInDays" task:^{
        [[XKRWUserService sharedService] getSignInDays];
        // 获取吃了大餐的文案
        [[XKRWRecordService4_0 sharedService] getEatALotText];
    }];
    [self dealWithSystemTabbarShow];
}

///  自动联网时，同步数据。
- (void)reachabilityChanged:(NSNotification *)notification {
    
    Reachability *reachability = notification.object;
    
    if (reachability.currentReachabilityStatus != NotReachable) {
        [self downloadWithTaskID:@"syncData" task:^{
            [XKRWCommHelper syncDataToRemote];
        }];
    }
}


- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    if ([taskID isEqualToString:@"syncData"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SCHEME_RELOAD" object:nil];
    }
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideAdImage];
    [super handleDownloadProblem:problem withTaskID:taskID];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IsNeedCheckUpdate"] boolValue]) {
        
        NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"familyCare_version"];
        if (![version isEqualToString:bundleVersion])
        {
            [[NSUserDefaults standardUserDefaults] setObject:bundleVersion forKey:@"familyCare_version"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        /**
         *  只有当刚开应用才检查
         */
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"IsNeedCheckUpdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hideTabbar {
    self.tabBar.alpha = 0.001;
    self.tabBar.hidden = YES;
}

- (void)showTabbar {
    self.tabBar.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.tabBar.alpha = 1;
    }];
}

- (void)entryAction
{
    [self schemeBtn_Click:nil];
}

- (void)exitTheAccount {
    NSString *passWord = [XKRWUserDefaultService getPrivacyPassword];
    if (passWord == nil || [passWord isEqualToString:@""]) {
        XKRWRootVC *rootVC = [[XKRWRootVC alloc]init];
        if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
            XKRWNavigationController *nav = [[XKRWNavigationController alloc] initWithRootViewController:rootVC withNavigationBarType:NavigationBarTypeDefault];
            [self presentViewController:nav animated:NO completion:nil];
        } else {
            [self.navigationController pushViewController:rootVC animated:NO];
        }
    } else {
        [self dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToRootVC" object:nil];
        }];
    }
    [[XKRWUserService sharedService] logout];
}

- (void)personBtn_Click:(UIButton *)button
{
    [self selectPerson];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

}

#pragma mark 闹钟处理

-(void)receiveAlarmWithNotification:(NSNotification *) notification{
    
    /*
     1 方案
     2 记录
     3 体重记录
     */
    NSNumber * indexTemp =notification.object;
    NSInteger index = [indexTemp integerValue];
    //当前所在的队列 pop到底
    
    id con = self.selectedViewController;
    if (con) {
        if ([con isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)con) popToRootViewControllerAnimated:NO];
        }
    }
    /*
     eAlarmWeight    =1,       //体重记录提醒
     eAlarmHabit,              //习惯改变提醒
     eAlarmExercise,           //有氧运动提醒
     eAlarmWalkNoon,           //午餐后散步提醒
     eAlarmWalkEvening,        //晚餐后散步提醒
     eAlarmBreakfast ,         //早餐
     eAlarmLunch,              //午餐
     eAlarmDinner,             //晚餐
     eAlarmRecord,             //记录
     */
    switch (index) {
        case eAlarmRecord:
        {
//            [self toRecord];
        }
            break;
        case eAlarmBreakfast:
        case eAlarmLunch:
        case eAlarmDinner:
        {
            [self selectSecheme];
            
        }
            break;
            
        default:
            break;
    }
    
}


-(void) selectPerson{
    personBtn.selected = YES;
    schemeBtn.selected = NO;
    shareBtn.selected = NO;
    moreBtn.selected = NO;
    personBtn.userInteractionEnabled = NO;
    schemeBtn.userInteractionEnabled = YES;
    shareBtn.userInteractionEnabled = YES;
    moreBtn.userInteractionEnabled = YES;
    self.selectedIndex = 0;
    
}
- (void)schemeBtn_Click:(UIButton *)button
{
    [self selectSecheme];
    /**
     *  友盟点击事件
     */
    
    [MobClick event:@"in_Note"];
}

-(void) selectSecheme{
    self.selectedIndex = 1;
    personBtn.selected = NO;
    schemeBtn.selected = YES;
    shareBtn.selected = NO;
    moreBtn.selected = NO;
    personBtn.userInteractionEnabled = YES;
    schemeBtn.userInteractionEnabled = NO;
    shareBtn.userInteractionEnabled = YES;
    moreBtn.userInteractionEnabled = YES;
}

- (void)shareBtn_Click:(UIButton *)button
{
    personBtn.selected = NO;
    schemeBtn.selected = NO;
    shareBtn.selected = YES;
    moreBtn.selected = NO;
    personBtn.userInteractionEnabled = YES;
    schemeBtn.userInteractionEnabled = YES;
    shareBtn.userInteractionEnabled = NO;
    moreBtn.userInteractionEnabled = YES;
    self.selectedIndex = button.tag;
    
    UINavigationController *nav = (UINavigationController *)self.selectedViewController;
    XKRWShareVC *vc = nav.viewControllers[0];
    vc.delegate = self;
}

- (void)clearShareVCRedDot
{
    [redDotView removeFromSuperview];
}

- (void)clearRedDotFromMore
{
    [moreRedDotView removeFromSuperview];
}

- (void)moreBtn_Click:(UIButton *)button
{
    personBtn.selected = NO;
    schemeBtn.selected = NO;
    shareBtn.selected = NO;
    moreBtn.selected = YES;
    personBtn.userInteractionEnabled = YES;
    schemeBtn.userInteractionEnabled = YES;
    shareBtn.userInteractionEnabled = YES;
    moreBtn.userInteractionEnabled = NO;
    self.selectedIndex = button.tag;
}



- (void)changeBePraiseNoticeNum
{
    if([[XKRWNoticeService sharedService] getUnreadBePraisedNoticeNum] > 0){
        if(numImageView.hidden == YES){
            numImageView.hidden = NO;
        }
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)[[XKRWNoticeService sharedService] getUnreadBePraisedNoticeNum]];
    }else{
        if(numImageView.hidden == NO){
            numImageView.hidden = YES;
        }
    }
}

- (void)changeCommentAndSystemNoticeNum
{
    if([[XKRWNoticeService sharedService] getUnreadCommentOrSystemNoticeNum] > 0){
        if(articleNumImageView.hidden == YES){
            articleNumImageView.hidden = NO;
        }
        articleLabel.text = [NSString stringWithFormat:@"%ld",(long)[[XKRWNoticeService sharedService] getUnreadCommentOrSystemNoticeNum]];
    }else{
        if(articleNumImageView.hidden == NO){
            articleNumImageView.hidden = YES;
        }
    }
}

//处理系统的tabbar 显示
- (void)dealWithSystemTabbarShow
{
    for (int i =0 ; i < [self.tabBar.items count]; i++) {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        [item setTitlePositionAdjustment:UIOffsetMake(0, 49)];
    }
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
