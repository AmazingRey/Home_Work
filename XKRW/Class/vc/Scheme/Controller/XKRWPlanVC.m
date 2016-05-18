//
//  XKRWPlanVC.m
//  XKRW
//
//  Created by 忘、 on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanVC.h"
#import "XKRWRecordAndTargetView.h"
#import "XKRWUITableViewBase.h"
#import "XKRWUITableViewCellbase.h"
#import "KMSearchBar.h"
#import "KMSearchDisplayController.h"
#import "XKRWPlanEnergyView.h"
#import "XKRWWeightRecordPullView.h"
#import "XKRWWeightPopView.h"
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/iflyMSC.h>
#import "XKRWCui.h"
#import "XKRW-Swift.h"
#import "XKRWSearchResultCategoryCell.h"
#import "XKRWSportEntity.h"
#import "XKRWFoodEntity.h"
#import "XKRWMoreSearchResultVC.h"
#import "XKRWFoodDetailVC.h"
#import "XKRWSportDetailVC.h"
#import "XKRWThinBodyDayManage.h"
#import "XKRWUserService.h"
#import "XKRWRecordVC.h"
#import "XKRWSurroundDegreeVC_5_3.h"
#import "XKRWNavigationController.h"
#import "XKRWPlanTipsCell.h"
#import "XKRWPlanTipsEntity.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "XKRWPlanService.h"
#import "XKRWTipsManage.h"
#import "XKRWCalendarVC.h"
#import "XKRWRecordMore5_3View.h"
#import "XKRWRecordSingleMore5_3View.h"
#import "XKRWChangeMealPercentVC.h"
#import "XKRWHomePagePretreatmentManage.h"
#import "XKRWDailyAnalysizeVC.h"
#import "XKRWUtil.h"
#import "XKRWAlgolHelper.h"
#import "XKRWStatisticAnalysizeVC.h"

@interface XKRWPlanVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate, UISearchControllerDelegate,KMSearchDisplayControllerDelegate,XKRWWeightRecordPullViewDelegate,XKRWWeightPopViewDelegate,IFlyRecognizerViewDelegate,XKRWPlanEnergyViewDelegate,XKRWRecordFood5_3ViewDelegate,XKRWRecordMore5_3ViewDelegate,XKRWRecordSingleMore5_3ViewDelegate,UIAlertViewDelegate>
{
    XKRWUITableViewBase  *planTableView;
    KMSearchBar *foodAndSportSearchBar;
    KMSearchDisplayController *searchDisplayCtrl;
    IFlyRecognizerView *iFlyControl;
    NSString *searchKey;
    NSArray *foodsArray;
    NSArray *sportsArray;
    NSInteger foodsCount;
    NSInteger sportsCount;
    NSInteger mealGoalCarol;
    UILabel  *dayLabel;
    UIView *planHeaderView;
    UIView *recordBackView;
    
    NSArray *tipsArray;
    XKRWRecordEntity4_0 *recordEntity;
    NSArray  *recordScheme;
    // 摄入卡路里
    NSInteger intakeCalorie;
    // 消耗卡路里
    NSInteger expendCalorie;
    // 改正习惯
    NSInteger currentHabit;
    
    UIButton  *btnBackBounds;
    XKRWRecordMore5_3View *recordMoreView;
    XKRWRecordSingleMore5_3View *recordSingleMoreView;
    
    // 是不是今天的方案
    BOOL isTodaysPlan;
    
    UIView *backgroundView ;
    
    RevisionType revisionType ;
}

@property (nonatomic, strong) XKRWPlanEnergyView *planEnergyView;
@property (nonatomic, strong) XKRWRecordAndTargetView *recordAndTargetView;
@property (nonatomic, strong) XKRWWeightRecordPullView *pullView;
@property (nonatomic, strong) XKRWWeightPopView *popView;

@property (strong , nonatomic) NSArray *mealSchemeArray;
@property (strong , nonatomic) XKRWSchemeEntity_5_0 *sportSchemeEntity;
@property (strong , nonatomic) XKRWRecordView_5_3 *recordPopView;
@end

@implementation XKRWPlanVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[XKRWThinBodyDayManage shareInstance]viewWillApperShowFlower:self];
    if (recordBackView) {
        [[[UIApplication sharedApplication].delegate window] bringSubviewToFront:recordBackView];
        
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (recordBackView) {
        [[[UIApplication sharedApplication].delegate window] sendSubviewToBack:recordBackView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // judge for is today's record or history,is the history record can be changed.
    [self initData];
    [self initView];
    [self setPlanEnergyViewTitle];
    [self refreshEnergyCircleView:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshEnergyCircleView:) name:EnergyCircleDataNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTipsData) name:ReLoadTipsData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSchemeData:) name:RecordSchemeData object:nil];

}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addTouchWindowEvent{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPopView)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
}

#pragma mark - data

- (void)initData {
    
    NSDate *todayDate = [NSDate today];
    if (!self.recordDate || [_recordDate compare:todayDate] == NSOrderedSame ) {
        _recordDate = [NSDate today];
        isTodaysPlan = YES;
        revisionType = XKRWNotNeedRevision;
    } else {
        isTodaysPlan = NO;
        if ([_recordDate compare:[todayDate offsetDay:-1]] == NSOrderedSame || [_recordDate compare:[todayDate offsetDay:-2]] == NSOrderedSame) {
            revisionType = XKRWCanRevision;
        } else {
            revisionType = XKRWCanNotRevision;
        }
    }
    
//    [self syncTodaysData];

    [self getTipsData];
    [self getRecordAndMenuScheme];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTodayDataToUI) name:@"loginAgainSuccess" object:nil];
}

- (void)reloadSchemeData:(NSNotification *)notification
{
    if ([[notification object] isEqualToString:EffectFoodCircle]) {
        [self getMealScheme:@"reloadGetMealSchemeAndRecord"];
    }else{
        [self getSportScheme:@"reloadGetSportSchemeAndRecord"];
    }
}


- (void)getTipsData {
    tipsArray = [[XKRWTipsManage shareInstance ] TipsInfoWithUseSituationwithRecordDate:_recordDate];
    
    [planTableView reloadData];
}

- (void)setPlanEnergyViewTitle {
    NSString *title;
    if (isTodaysPlan) {
        title = [[XKRWThinBodyDayManage shareInstance] TipsTextWithDayAndWhetherOpen];
    } else {
        title = @"回到今天";
    }
    
    BOOL isflash;
    if ([title rangeOfString:@"点击“开启”，"].location != NSNotFound) {
        isflash = YES;
    } else if ([title rangeOfString:@"回到今天"].location != NSNotFound) {
        isflash = NO;
    } else {
        isflash = NO;
        title = [title stringByAppendingString:@" >"];
    }
    
    [_planEnergyView setTitle:title isflashing:isflash];
}


- (void)refreshTodayDataToUI {
    [self refreshEnergyCircleView:nil];
    _recordAndTargetView.currentWeightLabel.text =  [NSString stringWithFormat:@"%.1f",[[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]]];
}

- (void)refreshEnergyCircleView:(NSNotification *)notification {
    recordEntity = [[XKRWPlanService shareService] getAllRecordOfDay:_recordDate];

    recordScheme = [[XKRWRecordService4_0 sharedService]getSchemeRecordWithDate:_recordDate];
    _recordAndTargetView.currentWeightLabel.text =  [NSString stringWithFormat:@"%.1f",[[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]]];

    {
        intakeCalorie = 0;
        expendCalorie = 0;
        currentHabit = 0;
        
        // deal with scheme record
        
        for (XKRWRecordFoodEntity *foodEntity in recordEntity.FoodArray) {
            intakeCalorie += foodEntity.calorie;
        }
        
        for (XKRWRecordSportEntity *sportEntity in recordEntity.SportArray) {
            expendCalorie += sportEntity.calorie;
        }
        
        for (XKRWHabbitEntity *habitEntity in recordEntity.habitArray) {
            currentHabit += habitEntity.situation;
        }
        
        for (XKRWRecordSchemeEntity *schemeEntity in recordScheme) {
            if (schemeEntity.type == 0 || schemeEntity.type == 5) {
                expendCalorie += schemeEntity.calorie;
            }
            
            if (schemeEntity.type == 1 || schemeEntity.type == 2 || schemeEntity.type == 3|| schemeEntity.type == 4|| schemeEntity.type == 6) {
                intakeCalorie += schemeEntity.calorie;
            }
        }
    }
    
    if ([[notification object] isEqualToString:EffectHabit]) {
        [_planEnergyView runHabitEnergyCircleWithNewCurrentNumber:currentHabit];
        
    } else if ([[notification object] isEqualToString:EffectFoodCircle]) {
        [_planEnergyView runEatEnergyCircleWithNewCurrentNumber:intakeCalorie];
        
    } else if ([[notification object] isEqualToString:EffectSportCircle]) {
        [_planEnergyView runSportEnergyCircleWithNewCurrentNumber:expendCalorie];
        
    } else {
        [_planEnergyView setEatEnergyCircleGoalNumber:[XKRWAlgolHelper dailyIntakeRecomEnergyOfDate:_recordDate] currentNumber:intakeCalorie];
        [_planEnergyView setSportEnergyCircleGoalNumber:[XKRWAlgolHelper dailyConsumeSportEnergyOfDate:_recordDate] currentNumber:expendCalorie];
        [_planEnergyView setHabitEnergyCircleGoalNumber:recordEntity.habitArray.count currentNumber:currentHabit];
    }
    
}


#pragma -- mark UI

- (void)initView {
    
    backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:backgroundView];
    planTableView = [[XKRWUITableViewBase alloc]initWithFrame:CGRectMake(0, 120 + 171 * XKAppHeight / 480.0, XKAppWidth, XKAppHeight -(120 + 171 * XKAppHeight / 480.0) -49) style:UITableViewStylePlain];
    planTableView.delegate = self;
    planTableView.dataSource = self;
    planTableView.tag = 1000;
    planTableView.backgroundColor = XK_BACKGROUND_COLOR;
    planTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [planTableView registerClass:[XKRWPlanTipsCell class] forCellReuseIdentifier:XKRWPlanTipsCellIdentifier];
    [backgroundView addSubview:planTableView];
    
    iFlyControl = [[IFlyRecognizerView alloc]initWithCenter:CGPointMake(XKAppWidth/2, XKAppHeight/2)];
    [iFlyControl setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN] ];
    [iFlyControl setParameter:@"srview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH] ];
    [iFlyControl setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT] ];
    [iFlyControl setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE] ];
    [iFlyControl setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE] ];
    [iFlyControl setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT] ];
    [iFlyControl setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source" ];
    
    iFlyControl.delegate = self;
    iFlyControl.hidden = YES;
    [backgroundView addSubview:iFlyControl];
    
    [backgroundView addSubview:[self createPlanHeaderView]];
}

- (UIView *)createPlanHeaderView
{
    planHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 120 + 171 * XKAppHeight / 480.0)];
    planHeaderView.backgroundColor = [UIColor whiteColor];
    foodAndSportSearchBar = [[KMSearchBar alloc]initWithFrame:CGRectMake(0, 20, XKAppWidth, 44)];
    
    foodAndSportSearchBar.delegate = self;
    foodAndSportSearchBar.barTintColor = [UIColor whiteColor];
    [foodAndSportSearchBar setSearchBarTextFieldColor:XKBGDefaultColor];
    foodAndSportSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    foodAndSportSearchBar.showsBookmarkButton = true;
    foodAndSportSearchBar.showsScopeBar = true;
    
    [foodAndSportSearchBar setImage:[UIImage imageNamed:@"voice"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    foodAndSportSearchBar.placeholder = @"查询食物和运动";
    searchDisplayCtrl = [[KMSearchDisplayController alloc] initWithSearchBar:foodAndSportSearchBar contentsController:self];
    searchDisplayCtrl.delegate = self ;
    
    searchDisplayCtrl.searchResultDelegate = self ;
    searchDisplayCtrl.searchResultDataSource = self ;
    
    searchDisplayCtrl.searchResultTableView.tag = 201 ;
    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWSearchResultCell" bundle:nil] forCellReuseIdentifier:@"searchResultCell"];
    
    UILabel * searchText = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, XKAppWidth, 30)];
    searchText.text = @"查询";
    searchText.textColor = XK_ASSIST_TEXT_COLOR;
    searchText.font = [UIFont systemFontOfSize:24];
    searchText.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_ic_"]];
    iconImageView.center =  CGPointMake(XKAppWidth / 2, searchText.bottom + 10 + iconImageView.height / 2);
    
    [searchDisplayCtrl.backgroundContentView addSubview:searchText];
    [searchDisplayCtrl.backgroundContentView addSubview:iconImageView];
    
    
    UILabel *food = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.left, iconImageView.bottom + 5, 50, 30)];
    food.textAlignment = NSTextAlignmentLeft;
    food.text = @"食物";
    food.font = [UIFont systemFontOfSize:14];
    food.textColor = XK_ASSIST_TEXT_COLOR;
    
    UILabel *meal = [[UILabel alloc] initWithFrame:CGRectMake(XKAppWidth / 2 - 25, iconImageView.bottom + 5, 50, 30)];
    meal.textAlignment = NSTextAlignmentCenter;
    meal.text = @"菜肴";
    meal.font = [UIFont systemFontOfSize:14];
    meal.textColor = XK_ASSIST_TEXT_COLOR;
    
    UILabel *sport = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right - 54, iconImageView.bottom + 5, 50, 30)];
    sport.textAlignment = NSTextAlignmentRight;
    sport.text = @"运动";
    sport.font = [UIFont systemFontOfSize:14];
    sport.textColor = XK_ASSIST_TEXT_COLOR;
    
    [searchDisplayCtrl.backgroundContentView addSubview:food];
    [searchDisplayCtrl.backgroundContentView addSubview:meal];
    [searchDisplayCtrl.backgroundContentView addSubview:sport];
    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWSearchResultCategoryCell" bundle:nil] forCellReuseIdentifier:@"searchResultCategoryCell"];
    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWMoreSearchResultCell" bundle:nil] forCellReuseIdentifier:@"moreSearchResultCell"];
    searchDisplayCtrl.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [planHeaderView addSubview:foodAndSportSearchBar];
    
    _recordAndTargetView
    = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordAndTargetView");
    _recordAndTargetView.frame = CGRectMake(0, 64, planHeaderView.width, 59);
    _recordAndTargetView.backgroundColor = [UIColor whiteColor];
    _recordAndTargetView.dayLabel.layer.masksToBounds = YES;
    _recordAndTargetView.dayLabel.layer.cornerRadius = 16;
    _recordAndTargetView.dayLabel.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    _recordAndTargetView.dayLabel.layer.borderWidth = 1;
    _recordAndTargetView.currentWeightLabel.layer.masksToBounds = YES;
    _recordAndTargetView.currentWeightLabel.layer.cornerRadius = 16;
    _recordAndTargetView.currentWeightLabel.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    _recordAndTargetView.currentWeightLabel.layer.borderWidth = 1;
    _recordAndTargetView.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)_recordDate.day];
    _recordAndTargetView.monthLabel.text = [NSString stringWithFormat:@"%ld月",(long)_recordDate.month];
    [_recordAndTargetView.entryThinPlanButton addTarget:self action:@selector(entryTHinPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    if (isTodaysPlan) {
        _recordAndTargetView.targetWeightLabel.text = [NSString stringWithFormat:@"目标%.1fkg",[[XKRWUserService sharedService] getUserDestiWeight] /1000.f];
        _recordAndTargetView.planTimeLabel.text = [[XKRWThinBodyDayManage shareInstance] PlanDayText];
        _recordAndTargetView.currentWeightLabel.text =  [NSString stringWithFormat:@"%.1f",[[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]]];
        
    } else {
        _recordAndTargetView.targetWeightLabel.text = @"";
        _recordAndTargetView.planTimeLabel.text = @"";
        _recordAndTargetView.currentWeightLabel.text = [NSString stringWithFormat:@"%.1f",[[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]]];
    }
    
    [_recordAndTargetView.weightButton addTarget:self action:@selector(setUserDataAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *gesLongPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressRecognizer:)];
    gesLongPressed.minimumPressDuration = 1.0f;
    gesLongPressed.numberOfTouchesRequired=1;
    [_recordAndTargetView.weightButton addGestureRecognizer:gesLongPressed];
    
    [_recordAndTargetView.calendarButton addTarget:self action:@selector(entryCalendarAction:) forControlEvents:UIControlEventTouchUpInside];
    [planHeaderView addSubview:_recordAndTargetView];
    
    _planEnergyView = [[XKRWPlanEnergyView alloc] initWithFrame:CGRectMake(0, 120, XKAppWidth, 171 * XKAppHeight / 480.0)];
    [_planEnergyView.eatEnergyCircle setStyle:(([[XKRWPlanService shareService] getEnergyCircleClickEvent:eFoodType] || !isTodaysPlan) ? XKRWEnergyCircleStyleOpened : XKRWEnergyCircleStyleNotOpen)];
    [_planEnergyView.sportEnergyCircle setStyle:(([[XKRWPlanService shareService] getEnergyCircleClickEvent:eSportType] || !isTodaysPlan)? XKRWEnergyCircleStyleOpened : XKRWEnergyCircleStyleNotOpen)];
    [_planEnergyView.habitEnergyCircle setStyle:(([[XKRWPlanService shareService] getEnergyCircleClickEvent:eHabitType] || !isTodaysPlan) ? XKRWEnergyCircleStyleOpened : XKRWEnergyCircleStyleNotOpen)];
    _planEnergyView.delegate = self;
    [planHeaderView addSubview:_planEnergyView];
    planHeaderView.clipsToBounds = YES;
    return planHeaderView;
}


#pragma --mark Action
/**
 *  长按按钮1秒钟直接进入记录体重
 *
 */
- (void)handleLongPressRecognizer:(UIButton *)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        [self pressPullViewButtonWithType:0];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
}

- (void)setUserDataAction:(UIButton *)button {
    [self removeMenuView];
    [recordBackView removeFromSuperview];
    
    btnBackBounds = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBackBounds.frame = self.view.bounds;
    [btnBackBounds addTarget:self action:@selector(removeBtnBackBounds) forControlEvents:UIControlEventTouchDown];
    
    if (_pullView == nil) {
        CGFloat pullWidth = 138*XKAppWidth/375;
        CGFloat pullHeight = 143*pullWidth/138;
        
        _pullView = [[XKRWWeightRecordPullView alloc] initWithFrame:CGRectMake(0, 0, pullWidth, pullHeight)];
        CGPoint center = button.center;
        center.x = XKAppWidth - _pullView.frame.size.width/2 - 15;
        center.y = button.center.y + button.frame.size.height + _pullView.frame.size.height/2+foodAndSportSearchBar.frame.size.height;
        _pullView.center = center;
        [btnBackBounds addSubview:_pullView];
        _pullView.alpha = 0;
        _pullView.delegate = self;
        [self.view addSubview:btnBackBounds];
    }
    [self removePullView];
}

-(void)removeBtnBackBounds{
    if (_popView) {
        [self cancelPopView];
    }else{
        [self removePullView];
        [btnBackBounds removeFromSuperview];
        btnBackBounds = nil;
    }
}

-(void)removePullView{
    if (_pullView.alpha == 0) {
        [UIView animateWithDuration:.3 animations:^{
            _pullView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            _pullView.alpha = 0;
        }completion:^(BOOL finished) {
            [_pullView removeFromSuperview];
            _pullView = nil;
        }];
    }
}

- (void)entryCalendarAction:(UIButton *)button{
    if (self.navigationController.viewControllers.count >1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        XKRWCalendarVC *calendar = [[XKRWCalendarVC alloc] init];
        calendar.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:calendar animated:YES];
    }
}

- (void)entryTHinPlayButton:(UIButton *)button {
    XKRWThinBodyAssess_5_3VC *thinBodyVC = [[XKRWThinBodyAssess_5_3VC alloc] initWithNibName:@"XKRWThinBodyAssess_5_3VC" bundle:nil];
    thinBodyVC.hidesBottomBarWhenPushed = YES;
    [thinBodyVC setFromWhichVC:PlanVC];
    [self.navigationController pushViewController:thinBodyVC animated:YES];
}

- (void)dealTipsAction:(UIButton *)button {
    
    switch (button.tag) {
       
        case 1001:
        {
            [XKRWCui showProgressHud:@"重置用户减肥方案中..."];
            [[XKRWSchemeService_5_0 sharedService] resetUserScheme:self];
        }
            break;
        case 1002:
        {
            XKRWStatisticAnalysizeVC *vc =  [[XKRWStatisticAnalysizeVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1003:
        {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }

        }
            break;
            
        case 1004:
        {
            [self addschemeOrRecordView:1 andArrowX:_planEnergyView.eatEnergyCircle.center.x];
            _recordPopView.scrollView .contentOffset = CGPointMake(XKAppWidth, 0);
            if (XKAppWidth < 375) {
                [UIView animateWithDuration:0.25 animations:^{
                    CGRect backgroundFrame = backgroundView.frame;
                    backgroundFrame.origin.y -= 64;
                    backgroundView.frame = backgroundFrame;
                    CGRect popViewFrame =   recordBackView.frame;
                    popViewFrame.origin.y -= 64;
                    recordBackView.frame = popViewFrame;
                    
                }];
            }

        }
            break;
       
        
        default:
            break;
    }
    
}

#pragma mark - XKRWPlanEnergyViewDelegate

- (void)energyCircleViewBackgroundClicked {
    [self RecordFoodViewpressCancle];
}

- (void)energyCircleViewTitleClicked:(NSString *)title {
    
    if ([title rangeOfString:@"查看今日分析"].location != NSNotFound) {
        XKRWDailyAnalysizeVC *vc = [[XKRWDailyAnalysizeVC alloc] init];
        vc.recordDate = _recordDate;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [vc.navigationController setNavigationBarHidden:NO];
        
    } else if ([title rangeOfString:@"计划已结束"].location != NSNotFound) {
        [XKRWCui showConfirmWithMessage:@"确定要重置方案吗？" okButtonTitle:@"确定" cancelButtonTitle:@"取消" onOKBlock:^{
            [XKRWCui showProgressHud:@"重置用户减肥方案中..."];
            [[XKRWSchemeService_5_0 sharedService] resetUserScheme:self];
        }];
        
    } else if ([title rangeOfString:@"回到今天"].location != NSNotFound) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dealSystemTabbarShow" object:nil];
        
    }
}

- (void)energyCircleView:(XKRWPlanEnergyView *)energyCircleView clickedAtIndex:(NSInteger)index {
    CGFloat positionX ;
    if (index == 1) {
        [[XKRWPlanService shareService] saveEnergyCircleClickEvent:eFoodType];
        positionX = energyCircleView.eatEnergyCircle.center.x;
        
    } else if (index == 2) {
        [[XKRWPlanService shareService] saveEnergyCircleClickEvent:eSportType];
        positionX = energyCircleView.sportEnergyCircle.center.x;
        
    } else {
        [[XKRWPlanService shareService] saveEnergyCircleClickEvent:eHabitType];
        positionX = energyCircleView.habitEnergyCircle.center.x;
    }
    
    [self setPlanEnergyViewTitle];
    [self removePullView];
    [self removeMenuView];
    [self addschemeOrRecordView:index andArrowX:positionX];
    
    if (XKAppWidth < 375) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect backgroundFrame = backgroundView.frame;
            backgroundFrame.origin.y -= 64;
            backgroundView.frame = backgroundFrame;
            CGRect popViewFrame =   recordBackView.frame;
            popViewFrame.origin.y -= 64;
            recordBackView.frame = popViewFrame;
            
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ReLoadTipsData object:nil];
}


#pragma mark - XKRWRecordFood5_3View
-(void)addschemeOrRecordView:(NSInteger)index andArrowX:(CGFloat) postitonX {
    _recordPopView = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordView_5_3");
    
    if(XKAppWidth == 320){
        _recordPopView.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight - planHeaderView.height + 64);
    }else{
        _recordPopView.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight - planHeaderView.height);
    }

    _recordPopView.positionX = postitonX;
    _recordPopView.type = index;
    _recordPopView.vc = self;
    _recordPopView.revisionType = revisionType;

    if (_recordDate == nil) {
        _recordPopView.date = [NSDate today];
    }else{
        _recordPopView.date = _recordDate;
    }
 
  
    if (index == 1) {
        _recordPopView.schemeArray = _mealSchemeArray;
    }else if(index == 2){
        if([XKRWAlgolHelper dailyConsumeSportEnergyOfDate:_recordDate] > 0){
            _recordPopView.schemeArray = [NSArray arrayWithObject:_sportSchemeEntity];
        }else{
            _recordPopView.schemeArray = nil;
        }
    }
    
    [_recordPopView initSubViews];
    [_recordPopView setsubViewUI];
   
    
    CGRect recordFrame = _recordPopView.frame;
    recordFrame.origin.y -= recordFrame.size.height;
    _recordPopView.frame = recordFrame;
    [_recordPopView layoutIfNeeded];
    
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:.1 options:0 animations:^{
        if (!recordBackView){
            CGRect recFrame = CGRectMake(0, planHeaderView.frame.size.height, XKAppWidth, _recordPopView.height);
            recordBackView = [[UIView alloc] initWithFrame:recFrame];
            recordBackView.backgroundColor = [UIColor whiteColor];
            recordBackView.clipsToBounds = YES;
        }
        [recordBackView addSubview:_recordPopView];
        CGRect frame = _recordPopView.frame;
        frame.origin.y = 0;
        _recordPopView.frame = frame;
        _recordPopView.delegate = self;
        [[[UIApplication sharedApplication].delegate window] addSubview:recordBackView];
    } completion:nil];
}

-(void)removeMenuView{
    if (_recordPopView) {
        XKRWRecordView_5_3 *popView = _recordPopView;
        _recordPopView = nil;
        
        [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:1 options:0 animations:^{
            CGRect frame = popView.frame;
            frame.origin.y -= frame.size.height;
            popView.frame = frame;
            if (XKAppWidth < 375) {
                CGRect backgroundFrame = backgroundView.frame;
                backgroundFrame.origin.y += 64;
                backgroundView.frame = backgroundFrame;
                
                CGRect popViewFrame = recordBackView.frame;
                popViewFrame.origin.y += 64;
                recordBackView.frame = popViewFrame;
            }
        }completion:^(BOOL finished) {
            [popView removeFromSuperview];
            popView.delegate = nil;
        }];
    }
}

- (void)fixHabitAt:(NSInteger)index isCurrect:(BOOL)abool {
    
    [recordEntity.habitArray[index] setSituation:abool];
    
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
        return;
        
    } else {
        [self downloadWithTaskID:@"saveHabit" task:^{
            [[XKRWPlanService shareService] saveRecord:recordEntity ofType:XKRWRecordTypeHabit];
        }];
        
        return;
        
    }
    
}

-(void)getRecordAndMenuScheme{
    [self getMealScheme:nil];
    [self getSportScheme:nil];
}

-(void)getMealScheme:(NSString *)taskID{
    if (taskID == nil) {
        [self downloadWithTaskID:@"getMealSchemeAndRecord" outputTask:^id{
            return   [[XKRWSchemeService_5_0 sharedService] getMealScheme];
            
        }];
    }else{
        [self downloadWithTaskID:taskID outputTask:^id{
            return   [[XKRWSchemeService_5_0 sharedService] getMealScheme];
            
        }];
    }
    
}

-(void)getSportScheme:(NSString *)taskID{
    if (taskID == nil) {
        [self downloadWithTaskID:@"getSportSchemeAndRecord" outputTask:^id{
            NSInteger i =[[XKRWRecordService4_0 sharedService]getMenstruationSituation]?1:0;
            return [[XKRWSchemeService_5_0 sharedService] getSportScheme:i];
        }];
    }else{
        [self downloadWithTaskID:taskID outputTask:^id{
            NSInteger i =[[XKRWRecordService4_0 sharedService]getMenstruationSituation]?1:0;
            return [[XKRWSchemeService_5_0 sharedService] getSportScheme:i];
        }];
    }
    
}

-(void)RecordFoodViewpressCancle{
    [_planEnergyView noneSelectedCircleStyle];
    [self removeMenuView];
    [recordBackView removeFromSuperview];
}

- (void)saveSchemeRecord:(id )entity andType:(XKRWRecordType)recordtype andEntryType:(energyType)entryRype
{
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
        return;
    }
    if (entryRype == energyTypeEat) {
        [self downloadWithTaskID:@"saveFoodScheme" outputTask:^id{
            return [NSNumber numberWithBool:[[XKRWPlanService shareService] saveRecord:entity ofType:recordtype]];
        }];
    }else if(entryRype == energyTypeSport){
        [self downloadWithTaskID:@"saveSportScheme" outputTask:^id{
            return [NSNumber numberWithBool:[[XKRWPlanService shareService] saveRecord:entity ofType:recordtype]];
        }];
    }
    
}

- (void) deleteSchemeRecord:(id )entity andType:(XKRWRecordType)recordtype andEntryType:(energyType)entryRype
{
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
        return;
    }
    if (entryRype == energyTypeEat && recordtype == XKRWRecordTypeScheme) {
        [self downloadWithTaskID:@"deleteFoodScheme" outputTask:^{
            BOOL isDelete = [[XKRWRecordService4_0 sharedService] deleteRecord:entity];
            if (isDelete) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectFoodCircle];
                });
            }
            return [NSNumber numberWithBool:isDelete];
        }];
    }else if(entryRype == energyTypeSport && recordtype == XKRWRecordTypeScheme){
        [self downloadWithTaskID:@"deleteSportScheme" outputTask:^{
             BOOL isDelete = [[XKRWRecordService4_0 sharedService] deleteRecord:entity];
            if (isDelete) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectSportCircle];
                });
                
            }
            return [NSNumber numberWithBool:isDelete];
        }];
    }else if (recordtype == XKRWRecordTypeFood){
        [self downloadWithTaskID:@"deleteRecordFood" outputTask:^{
            return [NSNumber numberWithBool:[[XKRWRecordService4_0 sharedService] deleteRecord:entity]];
        }];
    }else if (recordtype == XKRWRecordTypeSport){
        [self downloadWithTaskID:@"deleteRecordSport" outputTask:^{
            return [NSNumber numberWithBool:[[XKRWRecordService4_0 sharedService] deleteRecord:entity]];
        }];
    }
}

- (void)menstruationIsOn:(BOOL)on {
    if (on) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"大姨妈来了" message:@"适量运动有助调节情绪，缓解生理期不适，瘦瘦为你准备了适合姨妈期的运动方案，快去看看吧！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去换方案", nil];
        alertView.tag = 10010;
        
        [alertView show];
        [MobClick event:@"tips_mc_on"];

    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"大姨妈走了！" message:@"适恭喜你进入减肥黄金周，新陈代谢加速，减肥事半功倍，开启燃脂模式，努力运动吧 ！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        alertView.tag = 10010;
        
        [alertView show];
        
        [MobClick event:@"tips_mc_off"];
    }
}

#pragma --mark UIalertViewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10010){
        if (buttonIndex == alertView.cancelButtonIndex) {
            [MobClick event:@"tips_mc_on_ok"];
        }
        else {
            [MobClick event:@"tips_mc_on_reload"];
            XKRWSchemeDetailVC *schemeDetailVC = [[XKRWSchemeDetailVC alloc] init];
            schemeDetailVC.schemeEntity = _sportSchemeEntity;
//            schemeDetailVC.recordDate = _recordDate;
            schemeDetailVC.is_m = 1;
            schemeDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:schemeDetailVC animated:YES];
        }
    }
}

#pragma mark XKRWRecordMore5_3View & XKRWRecordMore5_3ViewDelegate
- (void)entryRecordVCWith:(SchemeType)schemeType {
    XKRWRecordVC *recordvc = [[XKRWRecordVC alloc] init];
    recordvc.recordDate = _recordDate;
    recordvc.schemeType = schemeType;
    recordvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordvc animated:YES];
}

-(void)addMoreView{
    if (!recordMoreView && !recordSingleMoreView) {
        CGRect frame = CGRectMake(recordBackView.frame.size.width - 140, _recordPopView.moreButton.frame.origin.y + _recordPopView.moreButton.frame.size.height+15, 138, 105);
        if (_recordPopView.type == 2) {
            frame.size.height = 59;
            
            recordSingleMoreView = [[XKRWRecordSingleMore5_3View alloc] initWithFrame:frame];
            [_recordPopView addSubview:recordSingleMoreView];
            recordSingleMoreView.type = _recordPopView.type;
            recordSingleMoreView.delegate = self;
        }else{
            recordMoreView = [[XKRWRecordMore5_3View alloc] initWithFrame:frame];
            [_recordPopView addSubview:recordMoreView];
            recordMoreView.type = _recordPopView.type;
            recordMoreView.delegate = self;
        }
    }else if (recordSingleMoreView || recordMoreView){
        [self removeMoreView];
    }
}

-(void)removeMoreView{
    [recordMoreView removeFromSuperview];
    recordMoreView = nil;
    
    [recordSingleMoreView removeFromSuperview];
    recordSingleMoreView = nil;
}

//调整四餐比例
-(void)pressTip_1WithIndex:(NSInteger)index{
    [self removeMoreView];
    if (index == 1) {
        XKRWChangeMealPercentVC *changeMealVC = [[XKRWChangeMealPercentVC alloc] init];
        changeMealVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changeMealVC animated:YES];
        [changeMealVC.navigationController setNavigationBarHidden:NO];
        
    } else {
        XKRWFoundFatReasonVC *fatReasonVC = [[XKRWFoundFatReasonVC alloc]initWithNibName:@"XKRWFoundFatReasonVC" bundle:nil];
        [fatReasonVC setFromWhichVC:SchemeInfoChangeVC];
        [self.navigationController pushViewController:fatReasonVC animated:YES];
        [fatReasonVC.navigationController setNavigationBarHidden:NO];
    }
   
}

//设置饮食提醒
-(void)pressSetNotifyWithIndex:(NSInteger)index{
    
    [self removeMoreView];
    XKRWAlarmVC *vc = [[XKRWAlarmVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    switch (index) {
        case 1:
            vc.type = eAlarmBreakfast;
            break;
        case 3:
            vc.type = eAlarmHabit;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
    [vc.navigationController setNavigationBarHidden:NO];
}

-(void)pressSetSportNotify{
    
    [self removeMoreView];
    XKRWAlarmVC *vc = [[XKRWAlarmVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = eAlarmExercise;
    [self.navigationController pushViewController:vc animated:YES];
    [vc.navigationController setNavigationBarHidden:NO];
}
#pragma mark XKRWWeightRecordPullViewDelegate method
/**
 *  点击不同的按钮类型不同
 *
 *  @param type 0:记录体重
 *              1:记录围度
 *              2:查看曲线
 */
-(void)pressPullViewButtonWithType:(PullViewBtnType)type{
    if (type == 2) {
        [self removeBtnBackBounds];
        XKRWSurroundDegreeVC_5_3 *vc = [[XKRWSurroundDegreeVC_5_3 alloc]init];
        vc.dataType = 1;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self removePullView];
        _popView = [[XKRWWeightPopView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth - 100, 240) withType:type];
        _popView.alpha = 0;
        
        _popView.delegate = self;
        if (!btnBackBounds) {
            btnBackBounds = [UIButton buttonWithType:UIButtonTypeCustom];
            btnBackBounds.frame = self.view.bounds;
            [btnBackBounds addTarget:self action:@selector(removeBtnBackBounds) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:btnBackBounds];
        }
        _popView.center = btnBackBounds.center;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasHidden:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        
        [UIView animateWithDuration:.35 delay:.1 options:0 animations:^{
            [_popView.textField becomeFirstResponder];
            [btnBackBounds addSubview:_popView];
            btnBackBounds.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
            _popView.alpha = 1;
//            self.view.userInteractionEnabled = NO;
          //  self.tabBarController.tabBar.hidden = YES;

        } completion:nil];
    }
}

#pragma mark keyboard Method
- (void)keyboardWasShown:(NSNotification *)notification
{
    if (_popView) {
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGFloat height = MIN(keyboardSize.height,keyboardSize.width);
        //    CGFloat width = MAX(keyboardSize.height,keyboardSize.width);
        
        CGPoint cen = CGPointMake(self.view.center.x, (CGFloat)(XKAppHeight - height)/2);
        [UIView animateWithDuration:.2 animations:^{
            _popView.center = cen;
        }];
    }
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
    if (_popView && !_popView.isCalendarShown) {
        _popView.center = self.view.center;
    }
}

-(void)cancelPopView{
    [_popView.textField resignFirstResponder];
    [UIView animateWithDuration:.6 delay:0 options:0 animations:^{
        _popView.alpha = 0;
        btnBackBounds.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
    } completion:^(BOOL finished) {
        [_popView removeFromSuperview];
        _popView = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        [btnBackBounds removeFromSuperview];
        btnBackBounds = nil;
    }];
}

#pragma mark XKRWWeightPopViewDelegate
-(void)pressPopViewSure:(NSDictionary *)dic{
    [self removeBtnBackBounds];
}

-(void)pressPopViewCancle{
    [self removeBtnBackBounds];
}

-(void)resetWeightPlan{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"needResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
    
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"lateToResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [XKRWCui showProgressHud:@"重置方案中..."];
    [self downloadWithTaskID:@"restSchene" outputTask:^id{
        return  [[XKRWUserService sharedService] resetUserAllDataByToken];
    }];
}

/**
 *  方案网络请求失败后 处理数据
 *
 *  @param problem
 *  @param taskID
 */
- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    [super handleDownloadProblem:problem withTaskID:taskID];
    if ([taskID isEqualToString:@"restSchene"]) {
        [XKRWCui showInformationHudWithText:@"重置方案失败，请稍后尝试"];
        return;
    }
}


- (void)saveSurroundDegreeOrWeightDataToServer:(XKRWRecordType)recordType andEntity:(XKRWRecordEntity4_0 *)entity
{
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
        return;
    }
    [XKRWCui showProgressHud];
    [self downloadWithTaskID:@"recordWeightAndDegree" outputTask:^id{
        return @([[XKRWRecordService4_0 sharedService] saveRecord:entity ofType:XKRWRecordTypeWeightAndCircumference]);
    }];
}

#pragma --mark Network
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    if ([taskID isEqualToString:@"search"]){
        [XKRWCui hideProgressHud];
        foodsArray = [result objectForKey:@"food"];
        sportsArray = [result objectForKey:@"sport"];
        foodsCount = foodsArray.count > 3 ? 3 : foodsArray.count;
        sportsCount = sportsArray.count > 3 ? 3 : sportsArray.count;
        if (!searchDisplayCtrl.isShowSearchResultTableView ){
            [searchDisplayCtrl showSearchResultTableView];
        }
        [searchDisplayCtrl reloadSearchResultTableView];
        
        return ;
    }
    
    if ([taskID isEqualToString:@"restSchene"]) {
        [XKRWCui hideProgressHud];
        if (result != nil) {
            if ([[result objectForKey:@"success"] integerValue] == 1){
                [[XKRWSchemeService_5_0 sharedService] dealResetUserScheme:self];
                XKRWFoundFatReasonVC *fatReasonVC = [[XKRWFoundFatReasonVC alloc] initWithNibName:@"XKRWFoundFatReasonVC" bundle:nil];
                fatReasonVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fatReasonVC animated:YES];
                [fatReasonVC.navigationController setNavigationBarHidden:NO];
            }
        }else {
            [XKRWCui showInformationHudWithText:@"重置方案失败，请稍后尝试"];
        }
        return;
    }
    
    if ([taskID isEqualToString:@"getMealSchemeAndRecord"]) {
        [XKRWCui hideProgressHud];
        if (result != nil) {
            _mealSchemeArray = (NSArray *)result;
        }else {
            [XKRWCui showInformationHudWithText:@"获取推荐食谱失败"];
        }
        return;
    }
    
    if ([taskID isEqualToString:@"getSportSchemeAndRecord"]) {
        [XKRWCui hideProgressHud];
        if (result != nil) {
            _sportSchemeEntity = result;
        } else {
            [XKRWCui showInformationHudWithText:@"获取推荐运动失败"];
        }
        return;
    }
    
    if ([taskID isEqualToString:@"reloadGetMealSchemeAndRecord"]) {
        [XKRWCui hideProgressHud];
        if (result != nil) {
            _mealSchemeArray = (NSArray *)result;
            
            _recordPopView.schemeArray = _mealSchemeArray;
            [_recordPopView.recommendedTableView reloadData];
        }else {
            [XKRWCui showInformationHudWithText:@"获取推荐食谱失败"];
        }
        return;
    }
    
    
    if ([taskID isEqualToString:@"reloadGetSportSchemeAndRecord"]) {
        [XKRWCui hideProgressHud];
        if (result != nil) {
            _sportSchemeEntity = result;
            _recordPopView.schemeArray = [NSArray arrayWithObject:_sportSchemeEntity];
            [_recordPopView.recommendedTableView reloadData];
        } else {
            [XKRWCui showInformationHudWithText:@"获取推荐运动失败"];
        }
        return;
    }

    
    
    
    
    if ([taskID isEqualToString:@"saveFoodScheme"]) {
        [XKRWCui showInformationHudWithText:@"保存成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectFoodCircle];
        return;
    }
    
    if ([taskID isEqualToString:@"saveSportScheme"]) {
        [XKRWCui showInformationHudWithText:@"保存成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectSportCircle];
        return;
    }
    
    if ([taskID isEqualToString:@"deleteFoodScheme"]) {
        [XKRWCui showInformationHudWithText:@"取消执行"];
        return;
    }
    
    if ([taskID isEqualToString:@"deleteSportScheme"]) {
        [XKRWCui showInformationHudWithText:@"取消执行"];
        return;
    }
    
    if ([taskID isEqualToString:@"saveHabit"]) {
        [XKRWCui showInformationHudWithText:@"保存成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectHabit];
        return;
        
    }
    
    if ([taskID isEqualToString:@"deleteRecordFood"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectFoodCircle];
        [_recordPopView setsubViewUI];
        return;
    }
    
    if ([taskID isEqualToString:@"deleteRecordSport"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectSportCircle];
        [_recordPopView setsubViewUI];
        return;
    }
    
    //保存体重围度成功
    if ([taskID isEqualToString:@"recordWeightAndDegree"]) {
        [XKRWCui hideProgressHud];
        [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectFoodAndSportCircle];
        CGFloat weight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]];
        _recordAndTargetView.currentWeightLabel.text = [NSString stringWithFormat:@"%.1f",weight];
        [_recordAndTargetView updateConstraints];
        [_recordAndTargetView.currentWeightLabel setNeedsDisplay];
        return;
    }
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication {
    return YES;
}

#pragma --mark Delegate
#pragma --mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1000){
        XKRWPlanTipsCell *tipCell = [tableView dequeueReusableCellWithIdentifier:XKRWPlanTipsCellIdentifier];
        tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            tipCell.TipLabelColor = colorSecondary_333333;
            tipCell.imageName = @"point_n";
        }else {
            tipCell.TipLabelColor = colorSecondary_999999;
            tipCell.imageName = @"point_p";
        }
        
        XKRWPlanTipsEntity *entity = [tipsArray objectAtIndex:indexPath.row];
        [tipCell  updateHeightCell:entity];
        [tipCell.actionButton addTarget:self action:@selector(dealTipsAction:) forControlEvents:UIControlEventTouchUpInside];
        return tipCell;
    }else if (tableView.tag == 201){
        
        if(indexPath.section == 0){
            
            if(foodsArray.count > 0){
                
                if (indexPath.row == 0){
                    XKRWSearchResultCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCategoryCell"];
                    cell.title.text = @"食物";
                    return cell;
                    
                }else if (indexPath.row == foodsCount +1){
                    XKRWMoreSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreSearchResultCell"];
                    cell.title.text = @"查看更多食物";
                    return cell;
                }else{
                    XKRWSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
                    XKRWFoodEntity *foodEntity =[foodsArray objectAtIndex:indexPath.row - 1];
                    cell.title.text = foodEntity.foodName;
                    cell.subtitle.text = [NSString stringWithFormat:@"%ldkcal/100g",(long)foodEntity.foodEnergy];
                    [cell.logoImageView setImageWithURL:[NSURL URLWithString:foodEntity.foodLogo] placeholderImage:[UIImage imageNamed:@"food_default"] options:SDWebImageRetryFailed];
                    return cell;
                }
            }else {
                if (indexPath.row == 0) {
                    XKRWSearchResultCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCategoryCell"];
                    cell.title.text = @"运动";
                    return cell;
                }else if (indexPath.row == foodsCount +1){
                    XKRWMoreSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreSearchResultCell"];
                    cell.title.text = @"查看更多运动";
                    return cell;
                }else{
                    XKRWSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
                    
                    XKRWSportEntity *sportEntity =[sportsArray objectAtIndex:indexPath.row - 1];
                    cell.title.text = sportEntity.sportName;
                    cell.subtitle.text = [NSString stringWithFormat:@"%fkcal/60分钟",sportEntity.sportMets];
                    [cell.logoImageView setImageWithURL:[NSURL URLWithString:sportEntity.sportActionPic] placeholderImage:[UIImage imageNamed:@"food_default"] options:SDWebImageRetryFailed];
                    return cell;
                }
            }
            
        } else {
            if (indexPath.row == 0) {
                XKRWSearchResultCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCategoryCell"];
                cell.title.text = @"运动";
                return cell;
            }else if (indexPath.row == foodsCount +1){
                XKRWMoreSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreSearchResultCell"];
                cell.title.text = @"查看更多运动";
                return cell;
            }else{
                XKRWSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
                
                XKRWSportEntity *sportEntity =[sportsArray objectAtIndex:indexPath.row - 1];
                cell.title.text = sportEntity.sportName;
                cell.subtitle.text = [NSString stringWithFormat:@"%fkcal/60分钟",sportEntity.sportMets];
                [cell.logoImageView setImageWithURL:[NSURL URLWithString:sportEntity.sportActionPic] placeholderImage:[UIImage imageNamed:@"food_default"] options:SDWebImageRetryFailed];
                return cell;
            }
        }
    }
    return [UITableViewCell new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag == 1000){
        return 1;
    }else if (tableView.tag == 201){
        NSInteger section = 0;
        if(foodsArray.count > 0){
            section++;
        }
        
        if(sportsArray.count > 0){
            section++;
        }
        
        return section;
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1000){
        return tipsArray.count;
    }else if (tableView.tag == 201){
        if(section == 0){
            if(foodsArray.count > 0){
                if(foodsArray.count > 3){
                    return 5;
                }else {
                    return foodsArray.count + 1;
                }
            }else {
                if(sportsArray.count > 3){
                    return 5;
                }else {
                    return sportsArray.count + 1;
                }
            }
        }
        if (section == 1){
            if(sportsArray.count > 3){
                return 5;
            }else {
                return sportsArray.count + 1;
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1000){
        CGFloat height = [tableView fd_heightForCellWithIdentifier:XKRWPlanTipsCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            XKRWPlanTipsEntity *entity = [tipsArray objectAtIndex:indexPath.row];
            [cell  updateHeightCell:entity];
        }];
        return height > 44 ? height :44  ;
        
    }else if (tableView.tag == 201){
        if(indexPath.section == 0 ){
            if ([foodsArray count] > 0){
                if (indexPath.row == 0){
                    return 38 ;
                }else if (indexPath.row == foodsCount + 1){
                    return 44;
                }else {
                    return 88;
                }
            }else {
                if (indexPath.row == 0){
                    return 38 ;
                }else if (indexPath.row == sportsCount + 1){
                    return 44;
                }else {
                    return 88;
                }
            }
        }else{
            if (indexPath.row == 0){
                return 38 ;
            }else if (indexPath.row == sportsCount + 1){
                return 44;
            }else {
                return 88;
            }
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 201) {
        if (indexPath.section == 0){
            if (foodsArray.count > 0) {
                if (indexPath.row == 0){
                    
                }else if (indexPath.row == foodsCount + 1) {
                    XKRWMoreSearchResultVC *moreSearchVC = [[XKRWMoreSearchResultVC alloc] init];
                    moreSearchVC.dataArray = foodsArray;
                    moreSearchVC.searchKey = searchKey;
                    moreSearchVC.searchType = 1;
                    [self.navigationController pushViewController:moreSearchVC animated:YES];
                    [moreSearchVC.navigationController setNavigationBarHidden:NO];
                }else {
                    XKRWFoodDetailVC *foodDetailVC = [[XKRWFoodDetailVC alloc] init];
                    foodDetailVC.foodId = ((XKRWFoodEntity *)[foodsArray objectAtIndex:indexPath.row - 1]).foodId;
                    [self.navigationController pushViewController:foodDetailVC animated:YES];
                    [foodDetailVC.navigationController setNavigationBarHidden:NO];
                }
            }else {
                if (indexPath.row == 0){
                    
                }else if (indexPath.row == sportsCount + 1){
                    XKRWMoreSearchResultVC *moreSearchVC = [[XKRWMoreSearchResultVC alloc] init];
                    moreSearchVC.dataArray = sportsArray;
                    moreSearchVC.searchKey = searchKey;
                    moreSearchVC.searchType = 0;
                    [self.navigationController pushViewController:moreSearchVC animated:YES];
                    [moreSearchVC.navigationController setNavigationBarHidden:NO];
                }else {
                    XKRWSportDetailVC *sportDetailVC = [[XKRWSportDetailVC alloc] init];
                    sportDetailVC.sportID = ((XKRWSportEntity *)[sportsArray objectAtIndex:indexPath.row - 1]).sportId;
                    sportDetailVC.sportName = ((XKRWSportEntity *)[sportsArray objectAtIndex:indexPath.row - 1]).sportName;
                    [self.navigationController pushViewController:sportDetailVC animated:YES];
                    [sportDetailVC.navigationController setNavigationBarHidden:NO];
                }
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0){
                
            }else if (indexPath.row == sportsCount + 1){
                XKRWMoreSearchResultVC *moreSearchVC = [[XKRWMoreSearchResultVC alloc] init];
                moreSearchVC.dataArray = sportsArray;
                moreSearchVC.searchKey = searchKey;
                moreSearchVC.searchType = 0;
                [self.navigationController pushViewController:moreSearchVC animated:YES];
                [moreSearchVC.navigationController setNavigationBarHidden:NO];
            }else {
                XKRWSportDetailVC *sportDetailVC = [[XKRWSportDetailVC alloc] init];
                sportDetailVC.sportID = ((XKRWSportEntity *)[sportsArray objectAtIndex:indexPath.row - 1]).sportId;
                sportDetailVC.sportName = ((XKRWSportEntity *)[sportsArray objectAtIndex:indexPath.row - 1]).sportName;
                [self.navigationController pushViewController:sportDetailVC animated:YES];
                [sportDetailVC.navigationController setNavigationBarHidden:NO];
            }
            
        }
    }
}


#pragma --mark UISearchBar Delegate

- (void)KMSearchDisplayHideSearchResult {
    [self RecordFoodViewpressCancle];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchDisplayCtrl showSearchResultView];
    [self removeMenuView];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:NO];
    [searchDisplayCtrl hideSearchResultView];
}



- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text.length > 0){
        searchKey = searchBar.text;
        [self downloadWithTaskID:@"search" outputTask:^id{
            
            return [[XKRWSearchService sharedService] searchWithKey:searchKey type:XKRWSearchTypeAll page:1 pageSize:30];
        }];
        
        if([searchBar resignFirstResponder])
        {
            [foodAndSportSearchBar setCancelButtonEnable:YES];
        }
    }
}



- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    [MobClick event:@"clk_VoiceSerch"];
    [searchDisplayCtrl showSearchResultView];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    if (iFlyControl.hidden){
        iFlyControl.hidden = NO;
        [iFlyControl start];
    }else{
        iFlyControl.hidden = YES;
        [iFlyControl cancel];
        
    }
}

#pragma --mark IFlyDelegate
// MARK: - iFly's delegate

- (void)onError:(IFlySpeechError *)error {
    if ([error errorCode] != 0){
        [XKRWCui  showInformationHudWithText:@"搜索失败"];
    }
}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
    if (resultArray != nil && resultArray.count > 0 ){
        
        NSLog(@"%@\n%@",resultArray,[[resultArray lastObject] allKeys].lastObject);
        foodAndSportSearchBar.text = [[[resultArray lastObject] allKeys] lastObject];
        [self searchBarSearchButtonClicked:foodAndSportSearchBar];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
