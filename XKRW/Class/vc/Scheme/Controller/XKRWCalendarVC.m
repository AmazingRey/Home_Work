//
//  XKRWCalendarVC.m
//  XKRW
//
//  Created by 忘、 on 16/4/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWCalendarVC.h"
#import "XKRWPlanCalendarView.h"
#import "XKRWCalendar.h"
#import "XKRWUserService.h"
#import "XKRWPlanVC.h"
#import "XKRWRecordService4_0.h"
#import "XKRWThinBodyDayManage.h"
#import "XKRWAlgolHelper.h"
#import "XKRW-Swift.h"

@interface XKRWCalendarVC ()<XKRWCalendarDelegate> {
    UIScrollView *calendarScrollView;
    XKRWCalendar *calendar;
    XKRWPlanCalendarView *headView;
    NSMutableArray *recordDates;
    NSDate *todayDate;
}

@end

@implementation XKRWCalendarVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController  setNavigationBarHidden:YES animated:YES];
    [calendar removeFromSuperview];
    recordDates = [[XKRWRecordService4_0 sharedService] getUserAllRecordDateFromDB];
    calendar =[[XKRWCalendar alloc] initWithOrigin:CGPointMake(0, 135) recordDateArray:recordDates headerType:XKRWCalendarHeaderTypeCustom andResizeBlock:^{
        
    } andMonthType:XKRWCalendarTypeStrongMonth];
    calendar.delegate = self;
    [calendar addBackToTodayButtonInFooterView];
    [calendar reloadCalendar];
    [calendarScrollView addSubview:calendar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

    // Do any additional setup after loading the view.
}

- (void)initView {
    self.view .backgroundColor = [UIColor whiteColor];
    calendarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
    calendarScrollView.contentSize = CGSizeMake(XKAppWidth, 700);
    [self.view addSubview:calendarScrollView];
    
    headView = [[NSBundle mainBundle] loadNibNamed:@"XKRWPlanCalendarView" owner:self options:nil][0];
    __weak typeof(self) weakSelf = self;
    headView.lookPlanBlock = ^(){
        [MobClick event:@"btn_cal_plan"];
        XKRWThinBodyAssess_5_3VC *bodyAssesssVC = [[XKRWThinBodyAssess_5_3VC alloc]initWithNibName:@"XKRWThinBodyAssess_5_3VC" bundle:nil];
        bodyAssesssVC.hidesBottomBarWhenPushed = YES;
        [bodyAssesssVC setFromWhichVC:MyVC];
        [weakSelf.navigationController pushViewController:bodyAssesssVC animated:YES];
    };
    headView.frame = CGRectMake(0, 0, XKAppWidth, 135);
    [calendarScrollView addSubview:headView];

    headView.progressLabel.attributedText = [[XKRWThinBodyDayManage shareInstance] calenderPlanDayText];
    headView.weightDescriptionLabel.text = [NSString stringWithFormat:@"从%.1fkg瘦到%.1fkg",[[XKRWUserService sharedService] getUserOrigWeight]/1000.0,[XKRWUserService sharedService].getUserDestiWeight/1000.0];
    
    if ([XKRWAlgolHelper remainDayToAchieveTarget] == -1) {
        headView.planFinishLabel.text = @"";
        
    } else {
        NSDate *planFinishDate = [[NSDate today] offsetDay:[XKRWAlgolHelper remainDayToAchieveTarget]];
        headView.planFinishLabel.text = [NSString stringWithFormat:@"预计将于%d年%d月%d日 完成",(int)[planFinishDate year],(int)[planFinishDate month],(int)[planFinishDate day]];
    }
   
    todayDate = [NSDate date];
    [self dealWithMonthLabel];
    [calendarScrollView addSubview:headView];
    
    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popButton.frame = CGRectMake(0, 0, 64, 64);
    UIImage *image = [UIImage imageNamed:@"navigationBarback"];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, image.size.width, image.size.height)];
    imageview.image = image;
    [popButton addSubview:imageview];
    [popButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popButton];
    
   
}

- (void)dealWithMonthLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSDate dateFormatString]];
    NSString *todayString = [formatter stringFromDate:todayDate];
    
    NSArray *dateArray = [todayString componentsSeparatedByString:@"-"];
    headView.monthLabel.text = [NSString stringWithFormat:@"%@年%@月",dateArray[0],dateArray[1]];
}

#pragma mark -XKRWCalendarDelegate
- (void)calendarSelectedDate:(NSDate *)date {
    [MobClick event:@"btn_cal"];
    NSDate *registerDate = [NSDate dateFromString:[[XKRWUserService sharedService] getREGDate]];
    NSDate *originOfDate = [NSDate dateWithTimeIntervalSince1970:[date originTimeOfADay]];
    NSComparisonResult result = [originOfDate compare:registerDate];
    if (result == NSOrderedAscending) {
        [XKRWCui showInformationHudWithText:@"注册日以前不能查看"];
        return;
        
    } else if ([[NSDate today] compare:originOfDate] == NSOrderedAscending) {
        [XKRWCui showInformationHudWithText:@"明天还没来，别着急哦~"];
        return;
        
    } else if ([[NSDate today] compare:originOfDate] == NSOrderedSame ) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
        
    } else {
        XKRWPlanVC *planVC = [[XKRWPlanVC alloc] init];
        planVC.recordDate = originOfDate;
        [self.navigationController pushViewController:planVC animated:YES];
    }
}

- (void)calendarScrollToPreMonth {
    todayDate = [todayDate offsetMonth:-1];
    [self dealWithMonthLabel];
}
- (void)calendarScrollToNextMonth {
    todayDate = [todayDate offsetMonth:1];
    [self dealWithMonthLabel];
}
#pragma --mark Action
- (void) popAction :(UIButton *) button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
