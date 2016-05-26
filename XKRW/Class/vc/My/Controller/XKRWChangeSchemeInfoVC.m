//
//  XKRWChangeSchemeInfoVC.m
//  XKRW
//
//  Created by 忘、 on 15/7/8.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWChangeSchemeInfoVC.h"
#import "XKRWMoreCells.h"
#import "XKRWSchemeInfoCell.h"
#import "XKRWUserService.h"
#import "CityListViewController.h"
#import "XKRWRecordService4_0.h"

#import "XKRWFatReasonService.h"

#import "XKRW-Swift.h"
@interface XKRWChangeSchemeInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * schemeInfoTitleArray;
    NSMutableArray * schemeInfoDataArray;
    UITableView *schemeInfotableView;
    
    XKSex _originS;
}

@end

@implementation XKRWChangeSchemeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    
    [MobClick event:@"clk_revise"];
    _originS = [[XKRWUserService sharedService] getSex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
    [schemeInfotableView reloadData];
}

- (void)initView
{
    self.title = @"修改计划";
    [self addNaviBarBackButton];
    schemeInfotableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)];
    schemeInfotableView.delegate = self;
    schemeInfotableView.dataSource = self;
    schemeInfotableView.backgroundColor = XK_BACKGROUND_COLOR;
    schemeInfotableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    schemeInfotableView.separatorColor = XKClearColor;
    [self.view addSubview:schemeInfotableView];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 120)];
    footerView.backgroundColor = XK_BACKGROUND_COLOR;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(XKAppWidth / 2 - 125, 10, 250.f, 40.f);
    [btn addTarget:self action:@selector(footerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((XKAppWidth-280)/2, 10, 280, 60)];
    label.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [XKRWUtil createAttributeStringWithString:@"重新制定，仅会清空以上显示的方案数据。不会清空头像、昵称、宣言、天数、历程、记录等数据。" font:XKDefaultFontWithSize(14) color:XK_TEXT_COLOR lineSpacing:3.5 alignment:NSTextAlignmentCenter];
    label.attributedText =  attributedString;
    
    [footerView addSubview:label];
    
    schemeInfotableView.tableFooterView = footerView;
    
}

- (void)initData
{
    schemeInfoTitleArray = @[@[@"性别",@"出生日期",@"身高",@"初始体重",@"目标体重",@"日常活动水平",@"所在城市",@"肥胖原因"],@[@"重置瘦身方案"]];
    
    schemeInfoDataArray = [NSMutableArray arrayWithCapacity:8];
    XKSex sex =  [[XKRWUserService sharedService]getSex];
    
    if (sex == eSexMale) {
        [schemeInfoDataArray addObject:@"男"];
    }else{
        [schemeInfoDataArray addObject:@"女"];
    }
    
    NSString *birthday =  [[XKRWUserService sharedService]getBirthdayString];
    [schemeInfoDataArray addObject:birthday];
    
    NSInteger height = [[XKRWUserService sharedService]getUserHeight];
    [schemeInfoDataArray addObject:[NSString stringWithFormat:@"%ldcm",(long)height]];
    
    NSInteger origWeight =  [[XKRWUserService sharedService]getUserOrigWeight];
    [schemeInfoDataArray addObject:[NSString stringWithFormat:@"%.1fkg",origWeight/1000.0f]];
    
    NSInteger destiWeight = [[XKRWUserService sharedService]getUserDestiWeight];
    [schemeInfoDataArray addObject:[NSString stringWithFormat:@"%.1fkg",destiWeight/1000.0f]];
    
    XKPhysicalLabor labor = [[XKRWUserService sharedService]getUserLabor];
    
    if (labor == eLight) {
        [schemeInfoDataArray addObject:@"轻体力"];
    }else if (labor == eMiddle){
        [schemeInfoDataArray addObject:@"中体力"];
    }else{
        [schemeInfoDataArray addObject:@"重体力"];
    }
    
    NSString *userCity =  [[XKRWUserService sharedService]getUserCity];
    [schemeInfoDataArray addObject:userCity];
    
    [schemeInfoDataArray addObject:[NSString stringWithFormat: @"%ld个",(long)[XKRWFatReasonService.sharedService getBadHabitNum]]];
    
}

#pragma mark picker 协议方法及回调
-(void) showBottomPicker:(int)index{
    self.showType = index;
    NSString * str = nil;
    switch (_showType) {
        case 101:
        {//性别
            str = @"性别";
        }
            break;
        case 102:
        {//生日
            
            str = @"生日";
        }
            break;
        case 103:
        {//身高
            str = @"身高";
        }
            break;
        case 201:
        {//目标体重
            str = @"目标体重";
        }
            break;
        case 202:
        {//减重部位
            str = @"减重部位";
        }
            break;
        case 203:
        {//方案难度
            str = @"方案难度";
        }
            break;
        case 204:
        {//日常活动水平
            str = @"日常活动水平";
        }
            break;
        case 205:
        {//人群
            str = @"人群";
        }
            break;
        case 206:
        {//疾病史
            str = @"疾病史";
        }
            break;
        default:
            break;
    }
    if ([str isEqualToString:@"疾病史"]){
        
        otherPicker = [[XKRWPickerViewVC alloc] initWithSheetTitle:str];
        otherPicker.isIllnessView=YES;
        otherPicker.PickerViewVCDelegate = self;
        [otherPicker showInView:self.view];
    }else if ([str isEqualToString:@"减重部位"]) {
        initpicker = [[XKRWSlimPartView alloc] initWithSheetTitle:str];
        initpicker.XKRWSlimPartViewDelegate = self;
        [initpicker showInView:self.view];
    }else{
        myPicker = [[XKRWPickerSheet alloc] initWithSheetTitle:str AndUnit:@"kg"];
        myPicker.pickerSheetDelegate = self;
        [self initSelectPicker:myPicker];
        [myPicker showInView:self.view];
    }
}

#pragma mark picker 初始选中状态
- (void) initSelectPicker:(XKRWPickerSheet *) picker{
    [picker setPointHidden:YES];
    switch (_showType) {
        case 101:
        {//性别
            
            int sex = [[XKRWUserService sharedService] getSex];
            
            [picker pickerSelectRow:sex inCol:0];
            _row1Temp = sex;
            
            
        }
            break;
        case 102:
        {//生日
            NSDate *nowDate = [NSDate date];
            self.addOneDay = [self addOneDate:nowDate];
            
            int nowYear = [self getContentFromDate:nowDate fomat:@"yyyy"];
            int oneYear = [self getContentFromDate:_addOneDay fomat:@"yyyy"];
            
            self.endYear = nowYear - 7;
            self.startYear = oneYear-70-1;
            
            
            NSInteger birthTime =   [[XKRWUserService sharedService] getBirthday];
            NSDate  *currentDate = [[NSDate alloc] initWithTimeIntervalSince1970:birthTime];
            
            int currentY = [self getContentFromDate:currentDate fomat:@"yyyy"];
            int currentM = [self getContentFromDate:currentDate fomat:@"MM"];
            int currentD = [self getContentFromDate:currentDate fomat:@"dd"];
            _currentYearIndex = currentY - _startYear;
            _currentMonthIndex = currentM - 1;
            _currentDayIndex = currentD - 1;
            
            _isLeapYear = [self isMyLeapYearWith:_currentYearIndex];
            self.dataArray = [self birthdayWith:_currentYearIndex month:_currentMonthIndex  isLeapYear:_isLeapYear];
            
            
            [picker pickerSelectRow:_currentYearIndex inCol:0];
            [picker pickerSelectRow:_currentMonthIndex inCol:1];
            [picker pickerSelectRow:_currentDayIndex inCol:2];
            
        }
            break;
        case 103:
        {//身高
            
            int temp = 140;
            if ([[XKRWUserService sharedService] getAge] < 18) {
                temp = 110;
            }
            _row1Temp = [(XKRWUserService *)[XKRWUserService sharedService] getUserHeight];
            [picker pickerSelectRow:_row1Temp-temp  inCol:0];
        }
            break;
            
        case 201:
        {
            NSInteger weight = [(XKRWUserService *)[XKRWUserService sharedService] getUserDestiWeight];
            if (weight<([[XKRWUserService sharedService]getAge]< 18 ? 20*1000 : 40*1000)) {
                weight= [[  XKRWUserService sharedService]getAge] <18  ? 20*1000 : 40*1000;
            }
            
            NSInteger row1 = weight/1000;
            NSInteger row2 = weight/100%10;
            
            
            if ([[XKRWUserService sharedService] getAge] < 18)
            {
                row1 -= 20;
            }
            else
            {
                
                row1 -= 40;
            }
            
            [picker pickerSelectRow:row1 inCol:0];
            [picker pickerSelectRow:row2 inCol:1];
            [picker setPointHidden:NO];
            _row1Temp = row1;
            _row2Temp = row2;
            
            
        }
            break;
        case 202:
        {//减重部位
            //            str = @"减重部位";
        }
            break;
        case 203:
        {//方案难度
            int row = [[XKRWUserService sharedService] getUserPlanDifficulty];
            [picker pickerSelectRow:row - 1 inCol:0];
        }
            break;
        case 204:
        {//日常活动水平
            int row = [[XKRWUserService sharedService] getUserLabor];
            _row1Temp = row - 1;
            [picker pickerSelectRow:_row1Temp inCol:0];
        }
            break;
        case 205:
        {
            int row = [[XKRWUserService sharedService] getUserGroup];
            int sex = [[XKRWUserService sharedService] getSex];
            if (row == 0) {
                if (sex) {
                    row = 6;
                }else
                    row = 5;
            }
            [picker pickerSelectRow:row-1 inCol:0];
        }
            break;
        case 206:
        {//疾病史
            //            str = @"疾病史";
        }
            break;
            
        default:
            break;
    }
}


#pragma mark picker 代理方法
//被选中的行列
-(void)pickerSheet:(XKRWPickerControlView *)picker DidSelectRowAtRow:(NSInteger)row AndCloum:(NSInteger)colum{
    
    if (colum == 0)
    {
        _row1Temp = row;
    }
    else if(colum == 1)
    {
        _row2Temp = row;
    }
    else{
        
        _row3Temp = row;
    }
    
    switch (_showType) {
        case 101:
        {//性别
            
            [[XKRWUserService sharedService] setSex:(int)row];
            
        }
            break;
        case 102:
        {//生日
            BOOL isYear = NO;
            if (colum == 0)
            {
                _currentYearIndex = row;
                isYear = [self isMyLeapYearWith:row];
                
                _isLeapYear = isYear;
                
                self.dataArray = [self birthdayWith:_currentYearIndex month:_currentMonthIndex  isLeapYear:_isLeapYear];
                [picker reloadData:1];
                [picker reloadData:2];
            }
            
            if (colum == 1)
            {
                _currentMonthIndex = row;
                self.dataArray = [self birthdayWith:_currentYearIndex month:_currentMonthIndex  isLeapYear:_isLeapYear];
                [picker reloadData:2];
                
            }
            if (colum == 2)
            {
                _currentDayIndex = row;
            }
            
            
            NSInteger selectYear = 1988;
            NSInteger selectMonth = 1;
            NSInteger selectDay = 1;
            
            
            selectYear = _startYear + _currentYearIndex;
            selectMonth = _currentMonthIndex + 1;
            selectDay = _currentDayIndex + 1;
            
            
            NSDate *selectDate = [self createDateWithYear:selectYear month:selectMonth day:selectDay];
            
            [[XKRWUserService sharedService] setBirthday:(int32_t)[selectDate timeIntervalSince1970]];
            
        }
            break;
        case 103:
        {//身高
            //140
            NSInteger age =  [[XKRWUserService sharedService] getAge];
            
            if (age<18) {
                [[XKRWUserService sharedService] setUserHeight:(int)row + 110];
            }
            
            [[XKRWUserService sharedService] setUserHeight:(int)row + 140];
            
        }
            break;
            
        case 201:
        {//目标体重
            //            str = @"目标体重";
            /**
             *  目标体重
             */
            int32_t a = 40;
            
            if ([[XKRWUserService sharedService] getAge] < 18)
            {
                a = 20;
            }
            
            int32_t weight = ((int32_t)(_row1Temp + a) * 1000) + ((int32_t)_row2Temp * 100);
            //            [[XKRWUserService sharedService]setUserDestiWeight:weight];
            NSInteger result  = [self checkTarget:weight];
            /**
             *  0 满足条件
             1 目标体重过小
             2 目标体重大于记录的最小值
             3 目标体重大于当前体重
             4 目标体重大于初始值
             */
            switch (result) {
                case 0:
                    [[XKRWUserService sharedService] setUserDestiWeight:weight];
                    break;
                case 1:
                    //                    self.tempWeight=weight;
                    [XKRWCui showInformationHudWithText:@"再瘦就不健康了哦！"];
                    break;
                case 2:
                case 3:
                case 4:
                default:
                    [XKRWCui showInformationHudWithText:@"不能增肥哦！"];
                    break;
            }
            
            
            
        }
            break;
        case 202:
        {//减重部位
            //            str = @"减重部位";
        }
            break;
        case 203:
        {//方案难度
            [[XKRWUserService sharedService] setUserPlanDifficulty:(int)row+1];
            //            str = @"方案难度";
        }
            break;
        case 204:
        {//日常活动水平
            [[XKRWUserService sharedService] setUserLabor:(int)row +1];
        }
            break;
        case 205:
        {//人群
            /*
             eGroupDay = 2,
             eGroupStudent = 1,
             eGroupNight = 3,
             eGroupFreelance = 4,
             eGroupPuerperium = 5,
             eGroupOther = 0,
             */
            int sex = [[XKRWUserService sharedService] getSex];
            //当为女性有产后选项
            if (sex) {
                if (row == 5) {
                    row = -1;
                }
            }else
                if (row == 4) {
                    row = -1;
                }
            
            [[XKRWUserService sharedService ] setUserGroup:(int)row+1];
        }
            break;
        case 206:
        {//疾病史
            //            str = @"疾病史";
        }
            break;
        default:
            break;
    }
}


#pragma mark picker 数据源
-(NSInteger)pickerSheetNumberOfColumns{
    return [self getNumberOfColum];
}
-(NSInteger)pickerSheetNumberOfRowsInColumn:(NSInteger)column{
    return [self getRowsInColum:column];
}
-(NSString *)pickerSheetTitleInRow:(NSInteger)row andColum:(NSInteger)colum{
    return [self gettitle:row andClom:colum];
}

#pragma mark 本地获取数据
- (NSString *) gettitle:(NSInteger)row andClom:(NSInteger)clom{
    
    NSString * title = [NSString stringWithFormat:@"%ld - %ld",(long)row,(long)clom];//@"";
    NSInteger age =  [[XKRWUserService sharedService] getAge];
    switch (_showType) {
        case 101:
        {//性别
            if (row) {
                title = @"女";
            }else{
                title = @"男";
            }
            
        }
            break;
        case 102:
        {//生日
            
            if (clom == 0)
            {
                NSArray *array1 = [_dataArray objectAtIndex:0];
                NSString *str = [array1 objectAtIndex:row];
                title = str;
            }
            else if (clom == 1)
            {
                NSArray *array2 = [_dataArray objectAtIndex:1];
                NSString *str = [array2 objectAtIndex:row];
                title = str;
                
            }
            else
            {
                NSArray *array3 = [_dataArray objectAtIndex:2];
                NSString *str = [array3 objectAtIndex:row];
                title = str;
            }
            
            
        }
            break;
        case 103:
        {//身高
            
            if (age < 18)
            {
                title  =[NSString stringWithFormat:@"%licm",(long)row+110];
            }
            
            else
            {
                title = [NSString stringWithFormat:@"%licm",(long)row+140];
            }
        }
            break;
        case 201:
        {//目标体重
            //            str = @"目标体重";
            if (clom == 0) {
                
                if (age < 18)
                {
                    return [NSString stringWithFormat:@"%li",(long)row+20];
                }
                else
                {
                    
                    return [NSString stringWithFormat:@"%li",(long)row+40];
                }
                
            }
            else {
                return [NSString stringWithFormat:@".%li",(long)row];
            }
        }
            break;
        case 202:
        {//减重部位
            //            str = @"减重部位";
        }
            break;
        case 203:
        {//方案难度
            
            [[XKRWUserService sharedService] setUserPlanDifficulty:(int)row+1];
            
            XKDifficulty  difficulty =[[XKRWUserService sharedService]getUserPlanDifficulty];
            NSString *difficultyStr;
            if (difficulty == eEasy) {
                difficultyStr = @"容易(可吃八分饱，饭后散散步就好)";
            }else if (difficulty == eNormal){
                difficultyStr = @"一般(需吃八分饱，三天两头跑一跑）";
            }else if (difficulty == eHard){
                difficultyStr = @"困难(只吃五分饱，运动天天不能少）";
            }else if (difficulty == eVeryHard ){
                difficultyStr = @"艰巨(只吃五分饱，天天运动强度高）";
            }
            
            return difficultyStr;
            
            
        }
            break;
        case 204:
        {//日常活动水平
            switch (row) {
                case 0:
                    if (K_iOS_System_Version_Gt_7) {
                        title = @"轻体力(久坐时间比较多)";
                        
                    }else{
                        title = @"轻体力";
                    }
                    
                    break;
                case 1:
                    if (K_iOS_System_Version_Gt_7) {
                        title = @"中体力(偶尔站立活动)";
                    }else{
                        title = @"中体力";
                    }
                    break;
                case 2:
                    if (K_iOS_System_Version_Gt_7) {
                        title = @"重体力(常做体力活动)";
                    }else{
                        title = @"重体力";
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        case 205:
        {//人群
            int sex = [[XKRWUserService sharedService] getSex];
            switch (row) {
                case 0:
                    title =@"学生";
                    break;
                case 1:
                    title =@"白班族";
                    break;
                    
                case 2:
                    title =@"夜班族";
                    break;
                case 3:
                    title =@"自由职业";
                    break;
                case 4:
                    title =@"产后女性";
                    if (!sex) {
                        title = @"其他";
                    }
                    
                    break;
                case 5:
                    title =@"其他";
                    break;
                default:
                    break;
            }
            
            return title;
            
        }
            break;
        case 206:
        {//疾病史
            //            str = @"疾病史";
        }
            break;
        default:
            break;
    }
    
    return title;
}

- (NSInteger) getNumberOfColum{
    
    NSInteger colums = 0;
    switch (_showType) {
        case 101:
        {//性别
            colums = 1;
        }
            break;
        case 102:
        {//生日
            colums = 3;
        }
            break;
        case 103:
        {//身高
            colums = 1;
        }
            break;
        case 201:
        {//目标体重
            colums = 2;
        }
            break;
        case 202:
        {//减重部位
            //            str = @"减重部位";
        }
            break;
        case 203:
        {//方案难度
            colums=1;
            //            str = @"方案难度";
        }
            break;
        case 204:
        {//日常活动水平
            colums = 1;
        }
            break;
        case 205:
        {//人群
            colums = 1;
        }
            break;
        case 206:
        {//疾病史
            //            str = @"疾病史";
        }
            break;
        default:
            break;
    }
    
    return colums;
}
- (NSInteger) getRowsInColum:(NSInteger) colum{
    
    NSInteger age =  [[XKRWUserService sharedService] getAge];
    NSInteger rows = 0;
    switch (_showType) {
        case 101:
        {//性别
            rows = 2;
        }
            break;
        case 102:
        {//生日
            if (colum == 0)
            {
                NSArray *array1 = [_dataArray objectAtIndex:0];
                return array1.count;
            }
            else if (colum == 1)
            {
                NSArray *array2 = [_dataArray objectAtIndex:1];
                return array2.count;
                
            }
            else
            {
                NSArray *array3 = [_dataArray objectAtIndex:2];
                return array3.count;
            }
        }
            break;
        case 103:
        {//身高
            
            if (age < 18) {
                rows = 121;
            }else
                rows = 81;
        }
            break;
            
        case 201:
        {//目标体重
            if (colum == 0)
            {
                if (age < 18){
                    rows = 181;
                }else{
                    rows = 161;
                }
            }
            else{
                rows = 10;
            }
        }
            break;
        case 202:
        {//减重部位
        }
            break;
        case 203:
        {//方案难度
            rows= [[XKRWUserService sharedService]getDiffCount];
        }
            break;
        case 204:
        {//日常活动水平
            rows = 3;
        }
            break;
        case 205:
        {//人群
            int sex = [[XKRWUserService sharedService] getSex];
            rows = 5;
            if (sex) {
                rows = 6;
            }
        }
            break;
        case 206:
        {//疾病史
        }
            break;
        default:
            break;
    }
    return rows;
}


//根据年份判断是否为闰年
- (BOOL)isMyLeapYearWith:(NSInteger)cell
{
    NSMutableArray *arrAnswers_ = [self birthdayWith:_currentYearIndex month:_currentMonthIndex  isLeapYear:_isLeapYear];
    
    if (arrAnswers_ > 0)
    {
        NSArray *yearArray = [arrAnswers_ objectAtIndex:0];
        if (yearArray.count >= cell)
        {
            NSString *selectedYearStr = [yearArray objectAtIndex:cell];
            NSString *selectedYear = [selectedYearStr substringToIndex:selectedYearStr.length-1];
            int year = [selectedYear intValue];
            if(year%400==0||(year%4==0 && year%100!=0)){
                return  YES;
            }
        }
    }
    return NO;
    
}




//根据月份，是否为闰年，最小年龄，最大年龄 算出这个范围内的所有年月日
- (NSMutableArray *)birthdayWith:(NSInteger)year month:(NSInteger)month isLeapYear:(BOOL)isLeapYear
{
    NSMutableArray *yearArray = [NSMutableArray array];
    NSMutableArray *monthArray = [NSMutableArray array];
    NSMutableArray *dayArray = [NSMutableArray array];
    
    //年
    for(NSInteger i = _startYear; i <= _endYear ;i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%li年", (long)i]];
    }
    
    //月,日
    int days = 0;
    if (month == 0 || month == 2 || month == 4|| month == 6 || month == 7|| month == 9 || month == 11)
    {
        days = 31;
    }
    
    else if (month == 3 || month == 5 || month == 8|| month == 10 )
    {
        days = 30;
    }
    else if (month == 1)
    {
        if (isLeapYear)
        {
            days = 29;
        }
        else
        {
            days = 28;
        }
    }
    
    int monthBegin = 1;
    int dayBegin = 1;
    
    int monthEnd = 12;
    int dayEnd = days;
    
    if (year+_startYear == _startYear)
    {
        int addMonth = [self getContentFromDate:_addOneDay fomat:@"MM"];
        int addDay = [self getContentFromDate:_addOneDay fomat:@"dd"];
        monthBegin = addMonth;
        
        if (month == 0){
            dayBegin = addDay;
        }
        
    }
    
    else if (year+_startYear == _endYear)
    {
        
        NSDate *nowDate = [NSDate date];
        int nowMonth = [self getContentFromDate:nowDate fomat:@"MM"];
        int nowDay = [self getContentFromDate:nowDate fomat:@"dd"];
        
        monthEnd = nowMonth;
        
        if (month+1 == nowMonth)
        {
            dayEnd = nowDay;
        }
        
    }
    for(int j = monthBegin; j <= monthEnd;j++)
    {
        NSString *monthStr = nil;
        monthStr = [NSString stringWithFormat:@"%i月",j];
        
        [monthArray addObject:monthStr];
    }
    
    for (int i = dayBegin; i <= dayEnd; i++)
    {
        NSString *dayStr = nil;
        
        dayStr = [NSString stringWithFormat:@"%i日",i];
        
        [dayArray addObject:dayStr];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:yearArray,monthArray,dayArray, nil];
    return array;
}

//根据NSDate 和 fomatter 获取对应的年月日
- (int)getContentFromDate:(NSDate *)date fomat:(NSString *)fomat
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    fomatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [fomatter setDateFormat:fomat];
    int currentY = [[fomatter stringFromDate:date] intValue];
    return currentY;
}

//根据年月日创建 NSDate
- (NSDate *)createDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *cal = [[NSCalendar alloc]
                       initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[[NSTimeZone alloc] initWithName:[[NSTimeZone knownTimeZoneNames] objectAtIndex:1]]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    NSDate *dd = [cal dateFromComponents:comps];
    return dd;
}

- (NSDate *)addOneDate:(NSDate *)date
{
    NSCalendar *cal = [[NSCalendar alloc]
                       initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    NSDate *nextDate = [cal dateByAddingComponents:comps toDate:date  options:0];
    return nextDate;
}

//根据date获取周岁
-(int32_t)getAgeFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setDateFormat:@"yyyy"];
    NSTimeInterval birthday = [date timeIntervalSince1970];
    int32_t age = [formatter stringFromDate:[NSDate date]].intValue - [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:birthday]].intValue - 1;
    [formatter setDateFormat:@"MMdd"];
    BOOL isPassBirthday = [formatter stringFromDate:[NSDate date]].intValue > [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:birthday]].intValue;
    if (isPassBirthday) {
        age += 1;
    }
    return age;
}

-(void)saveIllnessArray {
    NSMutableArray * arrayTemp = [NSMutableArray array];
    if (otherPicker.illnessResultSet.count) {
        for (NSString * str in otherPicker.illnessResultSet){
            [arrayTemp addObject:str];
        }
    }
    if (otherPicker) {
        [[XKRWUserService sharedService] setUserDisease:arrayTemp];
    }
}

-(void)savePersonSlimParts
{
    [self.view endEditing:YES];
    NSMutableArray * arrayTemp = [NSMutableArray array];
    if (initpicker.slimPartsSet.count) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"(),[]{}"];
        for (NSString * str in initpicker.slimPartsSet){
            if ([str rangeOfCharacterFromSet:set].location == NSNotFound) {
                
                [arrayTemp addObject:str];
            }
        }
    }
    if (initpicker) {
        [[XKRWUserService sharedService] setUserSlimPartsWithStringArray:arrayTemp];
    }
}

- (NSInteger) checkTarget:(int32_t) weight{
    NSInteger index = 0;
    NSInteger compare = 0;
    XKSex sex = [[XKRWUserService sharedService] getSex];
    NSInteger stature = [[XKRWUserService sharedService] getStature];
    NSInteger age = [[XKRWUserService sharedService] getAge];
    XKRWBMIEntity* entity = [XKRWAlgolHelper calcBMIInfoWithSex:sex age:age andHeight:stature];
    compare =  entity.healthyWeight;
    /**
     *  健康BMI范围的最小值对应的体重，最大值取自”记录“”当前“”初始“三个值中的最小值
     */
    if (weight < compare) {
        self.tempWeight=weight;
        index = 1;
    }else{
        NSInteger cur = [[XKRWUserService sharedService] getUserOrigWeight];
        if (weight <= cur) {
            self.tempWeight=weight;
            index = 0;
        }else{
            self.tempWeight=weight;
            index = 3;
        }
    }
    return index;
}


//发送请求，结束后调用回调
-(void)pickerSheetDoneBack:(DidDoneCallback)caback{
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"没有网络无法修改资料哦"];
        return;
    }
    [self savePersonSlimParts];  //减肥部位
    [self saveIllnessArray];   //疾病史
    // 如果用户的目标体重大于用的的初始体重，那么不能减肥和保存数据；如果用户的目标体重小于用户的健康体重,同样不能保存数据；
    NSInteger compare = 0;
    XKSex sex = [[XKRWUserService sharedService] getSex];
    NSInteger stature = [[XKRWUserService sharedService] getStature];
    NSInteger age = [[XKRWUserService sharedService] getAge];
    
    XKRWBMIEntity* entity = [XKRWAlgolHelper calcBMIInfoWithSex:sex age:age andHeight:stature];
    compare =  entity.healthyWeight;
    
    int cur_weight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]] * 1000;
    
    if ((self.tempWeight==0?cur_weight:self.tempWeight) < compare  ) {
        [XKRWCui showInformationHudWithText:@"目标体重不能低于健康体重"];
        return;
    }
    
    if ((self.tempWeight==0?cur_weight:self.tempWeight) > cur_weight) {
        [XKRWCui showInformationHudWithText:@"目标体重不能大于当前体重"];
        return;
    }
    
    //设置保存用户信息的参数
    //地址
    NSString *address = [XKRWUserService sharedService].getCityAreaString;
    //生日
    NSString * birthday = [XKRWUserService sharedService].getBirthdayString;
    //体力劳动水平
    XKPhysicalLabor labor =  [XKRWUserService sharedService].getUserLabor;
    //目标体重
    NSInteger destiWeight =   [XKRWUserService sharedService].getUserDestiWeight;
    CGFloat  targetWeight = destiWeight/1000.0f;
    
    XKDifficulty degree = [[XKRWUserService sharedService ]getUserPlanDifficulty];
    
    NSDictionary *slim_Plan = @{@"meal_ratio":[[XKRWUserService sharedService] getMealRatio],
                                @"target_weight":[NSNumber numberWithFloat:targetWeight],
                                @"part":@"1,2,3,4,5,6",
                                @"degree":[NSNumber numberWithInt:degree]
                                };
    NSDictionary *data = @{@"address":address,
                           @"birthday":birthday,
                           @"slim_plan":slim_Plan,
                           @"labor_level":[NSNumber numberWithInt:labor],
                           @"gender":[NSNumber numberWithInt:sex],
                           };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"data":jsonString};
    
    //用户修改身高后，如果用户的修改身高后的体重BMI小于用户目标体重的BMI，那么无法修改体重
    [self uploadWithTask:^{
        [[XKRWUserService sharedService] saveUserInfoToRemoteServer:params];
    }];
    self.saveBack = caback;
}

//取消点击，
-(void)pickerSheetCancelBackUserBtn:(BOOL)status{
    [[XKRWUserService sharedService] getUserInfoByUserAccount:[[XKRWUserService sharedService]getUserAccountName]];
    [schemeInfotableView reloadData];
    self.tempWeight = 0 ;
}

#pragma --mark AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)  //确定
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"needResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
        
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"lateToResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [XKRWCui showProgressHud:@"重置方案中..."];
        [self downloadWithTaskID:@"restSchene" outputTask:^id{
            return  [[XKRWUserService sharedService] resetUserAllDataByToken];
        }];
    }
}

//重置 减肥 方案
-(void)footerBtnClicked
{
    if(![XKUtil isNetWorkAvailable])
    {
        [XKRWCui showInformationHudWithText:@"网络未连接,请检查网络"];
        
        return;
    }
    [MobClick event:@"clk_reset"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定要重新制定吗？" message:nil delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma --mark  NetWork

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    [XKRWCui hideProgressHud];
    
    if ([taskID isEqualToString:@"restSchene"]) {
        if (result != nil) {
            if ([[result objectForKey:@"success"] integerValue] == 1){
                
                
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"DailyIntakeSize"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[XKRWUserService sharedService] deleteDBDataByUser];
                
                // reset user records, includes today's habit records
                [self downloadWithTask:^{
                    [[XKRWRecordService4_0 sharedService] resetUserRecords];
                }];
                
                [XKRWCui hideProgressHud];
                
                XKRWFoundFatReasonVC *fatReasonVC = [[XKRWFoundFatReasonVC alloc]initWithNibName:@"XKRWFoundFatReasonVC" bundle:nil];
                [self.navigationController pushViewController:fatReasonVC animated:YES];
            }
            else
            {
                [XKRWCui hideProgressHud];
                [XKRWCui showInformationHudWithText:@"重置方案失败，请稍后尝试"];
            }
        }
    }
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
    [XKRWCui showInformationHudWithText:@"重置方案失败，请稍后尝试"];
}


- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}


- (void)didUpload {
    //刷新当前页
    [[XKRWUserService sharedService] saveUserInfo];
    [self initData];
    [schemeInfotableView reloadData];
    if (self.saveBack) {
        self.saveBack();
        self.saveBack = nil;
    }
    
    /*
     *  如果改变性别，则通知方案界面重载cell
     */
    if (_originS != [[XKRWUserService sharedService] getSex]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SCHEME_RELOAD_NOTICE" object:nil];
    }
}

- (void)handleUploadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [schemeInfotableView reloadData];
}

#pragma --mark  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 20;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section== 0){
        
        switch (indexPath.row) {
                
            case 6:
            {
                CityListViewController * vc = [[CityListViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 7:
            {
                XKRWFoundFatReasonVC *fatReasonVC = [[XKRWFoundFatReasonVC alloc]initWithNibName:@"XKRWFoundFatReasonVC" bundle:nil];
                [fatReasonVC setFromWhichVC:SchemeInfoChangeVC];
                [self.navigationController pushViewController:fatReasonVC animated:YES];
            }
                break;
            default:
            {
                [XKRWCui showInformationHudWithText:@"不能修改哦，如需调整请重新制定~"];
                return;
            }
                break;
        }
    }else if (indexPath.section == 1){
        [self footerBtnClicked];
    }
}


#pragma  --mark  UItableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return schemeInfoTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = schemeInfoTitleArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"schemeInfoCell";
    XKRWSchemeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWSchemeInfoCell");
    }
    [XKRWUtil addViewUpLineAndDownLine:cell andUpLineHidden:YES DownLineHidden:NO];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row < 6){
            
            cell.schmeInfoDataLabel.textColor =  colorSecondary_999999;
            cell.arrowCell.hidden = YES;
        }
        
    }else{
        
        [XKRWUtil addViewUpLineAndDownLine:cell andUpLineHidden:NO DownLineHidden:NO];
        cell.schemeInfotitleLabel.hidden = YES;
        cell.arrowCell.hidden = YES;
        cell.schmeInfoDataLabel.hidden = YES;
        
        UILabel * tittleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, cell.height)];
        tittleLable.textAlignment = NSTextAlignmentCenter;
        tittleLable.textColor = [UIColor redColor];
        tittleLable.font = cell.schemeInfotitleLabel.font;
        tittleLable.text = @"重新制定计划";
        [cell addSubview:tittleLable];
    }
    
    
    NSArray * schemeInfotitleData = schemeInfoTitleArray[indexPath.section];
    cell.schemeInfotitleLabel.text = [schemeInfotitleData objectAtIndex:indexPath.row];
    cell.schmeInfoDataLabel.text = [schemeInfoDataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
