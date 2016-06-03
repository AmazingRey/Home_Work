//
//  XKRWDailyAnalysizeVC.m
//  XKRW
//
//  Created by ss on 16/4/28.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWDailyAnalysizeVC.h"
#import "XKRWAlgolHelper.h"
#import "XKRWUserService.h"
#import "Masonry.h"
#import "XKRWDailyAnalysizeView.h"
#import "XKRWRecordService4_0.h"
#import "XKRWStatisticAnalysizeVC.h"

@interface XKRWDailyAnalysizeVC ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *topImg;
@property (strong, nonatomic) UIImageView *ballImg;
@property (strong, nonatomic) UILabel *labToday;
@property (strong, nonatomic) UILabel *labTodayPredict;
@property (strong, nonatomic) XKRWDailyAnalysizeView *eatDecreaseView;
@property (strong, nonatomic) XKRWDailyAnalysizeView *sportDecreaseView;
@property (strong, nonatomic) UIImageView *noRecordView;
@property (strong, nonatomic) UILabel *labNorecord;
@property (assign, nonatomic) CGRect labPredictNorecordSize;
//每日正常饮食摄入
@property (assign, nonatomic) CGFloat dailyNormal;
//饮食消耗
@property (assign, nonatomic) CGFloat dailyFoodDecrease;
//运动消耗
@property (assign, nonatomic) CGFloat dailySportDecrease;
@end

@implementation XKRWDailyAnalysizeVC{
    BOOL hasRecord;
    NSArray *sportArray ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:@"pg_dailyana"];
    
    sportArray = [[XKRWRecordService4_0 sharedService] getSportRecordAndSportSchemeRecordWithDate:[NSDate date]];
    hasRecord = [[XKRWRecordService4_0 sharedService] getUserRecordStateWithDate:_recordDate];
    //每日正常饮食摄入
    _dailyNormal = [XKRWAlgolHelper dailyIntakEnergy];
    //饮食消耗
    _dailyFoodDecrease = [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:efoodCalories andDate:_recordDate];
    //运动消耗
    _dailySportDecrease = [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:eSportCalories andDate:_recordDate];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSInteger day = 1;
    if([XKRWAlgolHelper expectDayOfAchieveTarget] == nil){
        day = [[XKRWUserService sharedService] getInsisted];
    }else{
        day = [XKRWAlgolHelper newSchemeStartDayToAchieveTarget];
    }
    self.title = [NSString stringWithFormat:@"计划第%ld天", (long)(day == 0 ? 1 : day)];
    [self addNaviBarRightButtonWithText:@"统计分析" action:@selector(pressedRightAction)];
    [self addNaviBarBackButton];
    [self addMasonryView];
}

-(void)pressedRightAction{
    XKRWStatisticAnalysizeVC *vc =  [[XKRWStatisticAnalysizeVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.fromVC = DailyAnalysisVC;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark getter Method
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
-(UIImageView *)topImg{
    if (!_topImg) {
        _topImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 200)];
        _topImg.image = [UIImage imageNamed:@"dailyAnalyBack"];
        [self.scrollView addSubview:_topImg];
    }
    return _topImg;
}

-(UIImageView *)ballImg{
    if (!_ballImg) {
        _ballImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 108)];
        _ballImg.image = [UIImage imageNamed:@"dailyAnalyBall"];
        [_topImg addSubview:_ballImg];
    }
    return _ballImg;
}

-(UILabel *)labToday{
    if (!_labToday) {
        _labToday = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        _labToday.text = @"今日预计瘦";
        _labToday.textAlignment = NSTextAlignmentCenter;
        _labToday.textColor = colorSecondary_333333;
        _labToday.font = [UIFont systemFontOfSize:12];
        [_ballImg addSubview:_labToday];
    }
    return _labToday;
}

-(UILabel *)labTodayPredict {
    if (!_labTodayPredict) {
        _labTodayPredict = [[UILabel alloc] init];
        CGFloat predictValue = 0.0;
        if (_dailyFoodDecrease + _dailySportDecrease != 0 && hasRecord) {
            predictValue = (_dailyNormal - _dailyFoodDecrease + _dailySportDecrease)/7.7 >=0 ? (_dailyNormal - _dailyFoodDecrease + _dailySportDecrease)/7.7 : 0 ;
        }
        
        NSString *predictValueStr ;
        if (!hasRecord) {
            predictValueStr = [NSString stringWithFormat:@"***\n克"];
        }
        else{
            predictValueStr = [NSString stringWithFormat:@"%.0f\n克",predictValue];
        }
         NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:predictValueStr];
     
        NSRange range = NSMakeRange(0, predictValueStr.length - 2);
        NSRange range1 = NSMakeRange( predictValueStr.length - 1,1);
        [string addAttributes:@{NSFontAttributeName:XKDefaultFontWithSize(27),NSForegroundColorAttributeName:colorSecondary_333333} range:range];
        [string addAttributes:@{NSFontAttributeName:XKDefaultFontWithSize(12),NSForegroundColorAttributeName:colorSecondary_333333} range:range1];
        
        _labTodayPredict.attributedText = string;

        _labTodayPredict.textAlignment = NSTextAlignmentCenter;
        _labTodayPredict.numberOfLines = 0;
        [_ballImg addSubview:_labTodayPredict];
    }
    return _labTodayPredict;
}

-(XKRWDailyAnalysizeView *)eatDecreaseView{
    if (!_eatDecreaseView) {
        _eatDecreaseView = [[XKRWDailyAnalysizeView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, AnalysizeViewHeight) type:analysizeEat andSportArray:sportArray];
        [self.scrollView addSubview:_eatDecreaseView];
    }
    return _eatDecreaseView;
}

-(XKRWDailyAnalysizeView *)sportDecreaseView{
    if (!_sportDecreaseView) {
        _sportDecreaseView = [[XKRWDailyAnalysizeView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, AnalysizeViewHeight) type:analysizeSport andSportArray:sportArray];
       
        [self.scrollView addSubview:_sportDecreaseView ];
    }
    return _sportDecreaseView;
}

-(UIImageView *)noRecordView{
    if (!_noRecordView ) {
        _noRecordView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 408)];
        _noRecordView.image = [UIImage imageNamed:@"dailyNoRecord"];
        [self.scrollView addSubview:_noRecordView];
    }
    return _noRecordView;
}

-(UILabel *)labNorecord{
    if (!_labNorecord) {
        _labNorecord = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth-30, 30)];
        _labNorecord.center = _noRecordView.center;
        _labNorecord.text = @"记录之后，才能查看分析哦~";
        _labNorecord.textAlignment = NSTextAlignmentCenter;
        _labNorecord.textColor = colorSecondary_333333;
        _labNorecord.font = [UIFont systemFontOfSize:15];
        [_noRecordView addSubview:_labNorecord];
    }
    return _labNorecord;
}

#pragma mark Masonry Method
-(void)addMasonryView{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(XKAppHeight-64);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    [self.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(200);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.mas_equalTo(self.scrollView.mas_top);
    }];
    [self.ballImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@108);
        make.height.equalTo(@108);
        make.centerX.mas_equalTo(_topImg.mas_centerX);
        make.centerY.mas_equalTo(_topImg.mas_centerY);
    }];
    [self.labToday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@30);
        make.centerX.mas_equalTo(_ballImg.mas_centerX);
        make.centerY.mas_equalTo(_ballImg.mas_centerY).offset(-15);
    }];
    [self.labTodayPredict mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labToday.mas_bottom).offset(-15);
        make.height.equalTo(@70);
        make.width.equalTo(@100);
        make.centerX.mas_equalTo(_ballImg.mas_centerX);
    }];
    
    if (hasRecord) {
        [self.eatDecreaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(XKAppWidth);
            make.height.mas_equalTo(AnalysizeViewHeight);
            make.top.mas_equalTo(_topImg.mas_bottom).offset(10);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        [self.sportDecreaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(XKAppWidth);
            make.height.mas_equalTo(AnalysizeViewHeight + 33 *sportArray.count);
            make.top.mas_equalTo(_eatDecreaseView.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.scrollView.mas_bottom);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
    }else{
        [self.noRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(XKAppWidth);
            make.top.mas_equalTo(self.topImg.mas_bottom);
            make.bottom.mas_equalTo(self.scrollView.mas_bottom);
            make.left.mas_equalTo(self.scrollView.mas_left);
        }];
        [self.labNorecord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.noRecordView.mas_centerX);
            make.centerY.mas_equalTo(self.noRecordView.mas_centerY);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end