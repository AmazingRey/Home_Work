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

@interface XKRWPlanVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate, UISearchControllerDelegate,KMSearchDisplayControllerDelegate,XKRWWeightRecordPullViewDelegate,XKRWWeightPopViewDelegate,IFlyRecognizerViewDelegate>
{
    XKRWUITableViewBase  *planTableView;
    KMSearchBar* foodAndSportSearchBar;
    KMSearchDisplayController * searchDisplayCtrl;
    IFlyRecognizerView *iFlyControl;
    NSString *searchKey;
   
    
    NSArray *foodsArray;
    NSArray *sportsArray;
    
    NSInteger foodsCount;
    NSInteger sportsCount;
    
    NSArray <XKRWSchemeEntity_5_0 *> *mealEntitys;
    NSInteger mealGoalCarol;
    
    UILabel  *dayLabel;
}
@property (nonatomic, strong) XKRWPlanEnergyView *planEnergyView;
@property (nonatomic, strong) XKRWRecordAndTargetView *recordAndTargetView;
@property (nonatomic, strong) XKRWWeightRecordPullView *pullView;
@property (nonatomic, strong) XKRWWeightPopView *popView;
@end

@implementation XKRWPlanVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [[XKRWThinBodyDayManage shareInstance]viewWillApperShowFlower:self];
   // dayLabel.text = [[XKRWThinBodyDayManage shareInstance] PlanDayText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshEnergyCircleView) name:@"energyCircleDataChanged" object:nil];
    //[self addTouchWindowEvent];
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
    
    mealEntitys = [[XKRWSchemeService_5_0 sharedService] getMealScheme];
    [_planEnergyView setHabitEnergyCircleGoalNumber:12 currentNumber:3];
    [self refreshEnergyCircleView];
}

- (void)refreshEnergyCircleView {
    [_planEnergyView setEatEnergyCircleGoalNumber:[XKRWAlgolHelper dailyIntakeRecomEnergy] currentNumber:0];
    [_planEnergyView setSportEnergyCircleGoalNumber:[XKRWAlgolHelper dailyConsumeSportEnergy] currentNumber:0];
}
#pragma --mark UI
- (void)initView {

    planTableView = [[XKRWUITableViewBase alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight) style:UITableViewStylePlain];
    planTableView.delegate = self;
    planTableView.dataSource = self;
    planTableView.tag = 1000;
    [self.view addSubview:planTableView];
    
    _planEnergyView = [[XKRWPlanEnergyView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 68 + (XKAppWidth - 66)/3.0)];
    
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
    [self.view addSubview:iFlyControl];

}

- (XKRWUITableViewCellbase *)setSearchAndRecordCell:(UITableView *)tableView {
    XKRWUITableViewCellbase *cell = [tableView dequeueReusableCellWithIdentifier:@"searchAndRecord"];
    if(cell == nil){
        cell = [[XKRWUITableViewCellbase alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchAndRecord"];
        cell.frame = CGRectMake(0, 0, XKAppWidth, 120);
    }
    if (foodAndSportSearchBar == nil) {
        foodAndSportSearchBar = [[KMSearchBar alloc]initWithFrame:CGRectMake(0, 20, XKAppWidth, 44)];
        
        foodAndSportSearchBar.delegate = self;
        foodAndSportSearchBar.barTintColor = [UIColor whiteColor];
        [foodAndSportSearchBar setSearchBarTextFieldColor:XKBGDefaultColor];
        foodAndSportSearchBar.searchBarStyle = UISearchBarStyleMinimal;
        foodAndSportSearchBar.showsBookmarkButton = true;
        foodAndSportSearchBar.showsScopeBar = true;
        
        [foodAndSportSearchBar setImage:[UIImage imageNamed:@"voice"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
        foodAndSportSearchBar.placeholder = @"查询食物和运动" ;
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
        [cell.contentView addSubview:foodAndSportSearchBar];
    }
    
    if(_recordAndTargetView == nil){
        _recordAndTargetView
        = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordAndTargetView");
        _recordAndTargetView.frame = CGRectMake(0, 64, cell.contentView.width, 30);
        _recordAndTargetView.dayLabel.layer.masksToBounds = YES;
        _recordAndTargetView.dayLabel.layer.cornerRadius = 16;
        _recordAndTargetView.dayLabel.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
        _recordAndTargetView.dayLabel.layer.borderWidth = 1;
        XKLog(@"%@",[[XKRWThinBodyDayManage shareInstance] PlanDayText]);
        _recordAndTargetView.planTimeLabel.text = [[XKRWThinBodyDayManage shareInstance] PlanDayText];
        _recordAndTargetView.currentWeightLabel.layer.masksToBounds = YES;
        _recordAndTargetView.currentWeightLabel.layer.cornerRadius = 16;
        _recordAndTargetView.currentWeightLabel.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
        _recordAndTargetView.currentWeightLabel.layer.borderWidth = 1;
        _recordAndTargetView.currentWeightLabel.text =  [NSString stringWithFormat:@"%.1f",[[XKRWUserService sharedService] getCurrentWeight]/1000.f];
        _recordAndTargetView.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)[NSDate date].day];
        _recordAndTargetView.monthLabel.text = [NSString stringWithFormat:@"%ld月",(long)[NSDate date].month];
        _recordAndTargetView.targetWeightLabel.text = [NSString stringWithFormat:@"目标%.1fkg",[[XKRWUserService sharedService] getUserDestiWeight] /1000.f];
        [_recordAndTargetView.weightButton addTarget:self action:@selector(setUserDataAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *gesLongPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressRecognizer:)];
        gesLongPressed.minimumPressDuration = 1.0f;
        gesLongPressed.numberOfTouchesRequired=1;
        [_recordAndTargetView.weightButton addGestureRecognizer:gesLongPressed];
        
        [_recordAndTargetView.calendarButton addTarget:self action:@selector(entryCalendarAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_recordAndTargetView];

    }
    return cell;
}

#pragma --mark Action
/**
 *  长按按钮1秒钟直接进入记录体重
 *
 */
- (void)handleLongPressRecognizer:(UIButton *)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        [self pressWeight];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
}

- (void)setUserDataAction:(UIButton *)button {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.view.bounds;
    [btn addTarget:self action:@selector(removePullView:) forControlEvents:UIControlEventTouchDown];
    if (_pullView == nil) {
        
        _pullView = [[XKRWWeightRecordPullView alloc] initWithFrame:CGRectMake(0, 0, 80, 90)];
        CGPoint center = button.center;
        center.x = XKAppWidth - _pullView.frame.size.width/2 - 15;
        center.y = button.center.y + button.frame.size.height + _pullView.frame.size.height/2+foodAndSportSearchBar.frame.size.height;
        _pullView.center = center;
        [btn addSubview:_pullView];
        _pullView.alpha = 0;
        _pullView.delegate = self;
        
        [self.view addSubview:btn];
    }
    [self removePullView:btn];
}

-(void)removePullView:(UIButton *)button{
    if (_pullView.alpha == 0) {
        [UIView animateWithDuration:.3 animations:^{
            _pullView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            _pullView.alpha = 0;
        }completion:^(BOOL finished) {
            [button removeFromSuperview];
            [_pullView removeFromSuperview];
            _pullView = nil;
        }];
    }
}

- (void)entryCalendarAction:(UIButton *)button{
    XKRWRecordVC *recordVC = [[XKRWRecordVC alloc] init];
    recordVC.hidesBottomBarWhenPushed = YES;
   
    [self.navigationController pushViewController:recordVC animated:YES];
     [recordVC.navigationController setNavigationBarHidden:NO];
    
//    XKRWSurroundDegreeVC_5_3 *vc = [[XKRWSurroundDegreeVC_5_3 alloc] init];
//    vc.dataType = eWeightType;
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
}


#pragma XKRWWeightRecordPullViewDelegate method

/**
 *  记录体重
 */
-(void)pressWeight{
    [self popViewAppear:0];
}

/**
 *  记录围度
 */
-(void)pressContain{
    [self popViewAppear:1];
}

/**
 *  查看曲线
 */
-(void)pressGraph{
//    [self popViewAppear:2];
    XKRWSurroundDegreeVC_5_3 *vc = [[XKRWSurroundDegreeVC_5_3 alloc]init];
    vc.dataType = 1;
    [self presentViewController:vc animated:YES completion:nil];
}

/**
 *  点击不同的按钮类型不同
 *
 *  @param type 0:记录体重 
 *              1:记录围度
 *              2:查看曲线
 */
-(void)popViewAppear:(NSInteger)type{
    _popView = [[XKRWWeightPopView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _popView.delegate = self;
    CGPoint center = self.view.center;
    center.y -= 100;
    _popView.center = center;
    _popView.alpha = 0;
    [UIView animateWithDuration:.3 delay:.1 options:0 animations:^{
        [_popView.textField becomeFirstResponder];
        [[UIApplication sharedApplication].keyWindow addSubview:_popView];
        _popView.center = self.view.center;
        _pullView.alpha = 0;
        self.view.alpha = .5;
        _popView.alpha = 1;
        self.view.userInteractionEnabled = NO;
        self.tabBarController.tabBar.hidden = YES;
    } completion:nil];
}

-(void)cancelPopView{
    if (_popView) {
        CGPoint center = _popView.center;
        center.y -= 100;
        [_popView.textField resignFirstResponder];
        [UIView animateWithDuration:.5 delay:0 options:0 animations:^{
            _popView.center = center;
            _popView.alpha = 0;
            self.view.alpha = 1;
        } completion:^(BOOL finished) {
            [_popView removeFromSuperview];
            _popView = nil;
            self.view.userInteractionEnabled = YES;
            self.tabBarController.tabBar.hidden = NO;
        }];
    }else{
        [self setUserDataAction:nil];
    }
}

#pragma XKRWWeightPopViewDelegate 
-(void)pressPopViewSure:(NSDictionary *)dic{
    [self cancelPopView];
}

-(void)pressPopViewCancle{
    [self cancelPopView];
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
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [super handleDownloadProblem:problem withTaskID:taskID];
    
    if ([taskID isEqualToString:@"restSchene"]) {
        [XKRWCui showInformationHudWithText:@"重置方案失败，请稍后尝试"];
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
        if (indexPath.section == 0) {
            XKRWUITableViewCellbase *cell  = [tableView dequeueReusableCellWithIdentifier:@"searchAndRecord"];
            if(cell == nil){
                cell = [self setSearchAndRecordCell:tableView];
            }
            
            return cell;
        } else if (indexPath.section == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"energyCircle"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"energyCircle"];
                cell.contentView.size = CGSizeMake(XKAppWidth, 68 + (XKAppWidth - 88)/3.0);
                [cell addSubview:_planEnergyView];
            }
            return cell;
        }
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
        return 3;
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
        return 1;
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
        if (indexPath.section == 2) {
            return 68 + (XKAppWidth - 88)/3.0;
        }
        return 120;
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchDisplayCtrl showSearchResultView];

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
