//
//  XKRWAlarmVC.m
//  XKRW
//
//  Created by Shoushou on 15/8/31.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWAlarmVC.h"
#import "XKRWAlarmCell.h"
#import "DatePickerView.h"
#import "XKRWAlarmService5_1.h"
#import "XKRWCui.h"

@interface XKRWAlarmVC ()<UITableViewDataSource,UITableViewDelegate,DatePickerViewDelegate>
{
    UITableView *_tableView;
    BOOL  alarm1IsOpen;
    BOOL  alarm2IsOpen;
    BOOL  alarm3IsOpen;
   
}

//提醒时间
@property (nonatomic,strong) NSString *alarmStr;
//需要提醒的天 数组
@property (strong, nonatomic) NSArray  *weekdaysArray;

@property (strong, nonatomic) NSMutableArray *itemsLabelArray;
@property (strong, nonatomic) NSMutableArray *pickerTitleArray;

//天数标题 固定的
@property (nonatomic, strong) NSArray   *weekdayTitleArray;
// 存储daysofweek
@property (nonatomic, strong) NSMutableArray *alarmDaysArray;
//提醒实体
@property (nonatomic, strong) NSMutableArray *alarmEntityArray;

@property (nonatomic, assign) BOOL isUpdate;
@end

@implementation XKRWAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNaviBarBackButton];
    
    if (self.type == eAlarmExercise) {
        self.title = @"运动提醒";
    }else if (self.type == eAlarmBreakfast){
        self.title = @"食物提醒";
    }else{
        self.title = @"习惯提醒";
    }
    self.view.backgroundColor = XK_BACKGROUND_COLOR;
    
    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(popView)];
    
    [self loadData];
    [self initUI];
}
//界面即将消失的时候将记录数组存入数据库并返回保存结果
- (void)popView {
    
    // do custom
    
    if (self.isUpdate) {

        BOOL isSuccess = [[XKRWAlarmService5_1 shareService] updateNotice:_alarmEntityArray];
        if (isSuccess) {
            [XKRWCui showInformationHudWithText:@"保存成功"];
        }else{
            [XKRWCui showInformationHudWithText:@"保存失败"];
        }
        
    }

    // super
    [super popView];
}

- (void)loadData
{
    self.isUpdate = NO;
    _weekdayTitleArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    _alarmEntityArray = [[NSMutableArray alloc] init];
    _alarmDaysArray = [[NSMutableArray alloc] init];
    _itemsLabelArray = [NSMutableArray array];
    _pickerTitleArray = [NSMutableArray array];
    
    XKRWAlarmEntity *entity0;
    XKRWAlarmEntity *entity1;
    XKRWAlarmEntity *entity2;
    //   根据传过来的Type获取数据
    switch (self.type) {
        case eAlarmExercise:
            [_itemsLabelArray addObject:@"运动"];
            [_pickerTitleArray addObject:@"运动时间"];
            entity0 = [[XKRWAlarmService5_1 shareService] getAlarmWithType:eAlarmExercise];
            break;
        case eAlarmBreakfast:
            [_itemsLabelArray addObjectsFromArray:@[@"早餐",@"午餐",@"晚餐"]];
            [_pickerTitleArray addObjectsFromArray:@[@"早餐时间",@"午餐时间",@"晚餐时间"]];
            entity1 = [[XKRWAlarmService5_1 shareService] getAlarmWithType:eAlarmBreakfast];
            [_alarmEntityArray addObject:entity1];
            entity2 = [[XKRWAlarmService5_1 shareService] getAlarmWithType:eAlarmLunch];
            [_alarmEntityArray addObject:entity2];
            entity0 = [[XKRWAlarmService5_1 shareService] getAlarmWithType:eAlarmDinner];
            break;
        case eAlarmHabit:
            [_itemsLabelArray addObject:@"习惯"];
            [_pickerTitleArray addObject:@"习惯时间"];
            entity0 = [[XKRWAlarmService5_1 shareService] getAlarmWithType:eAlarmHabit];
            break;
        default:
            break;
            
    }
    
    //获取提醒
    [_alarmEntityArray addObject:entity0];
    
}
//初始化UI
- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:XKScreenBounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[XKRWAlarmCell class] forCellReuseIdentifier:@"alarmCell"];
    [self.view addSubview:_tableView];
}

#pragma mark - tableViewDelegate&&dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XKRWAlarmEntity *entity = _alarmEntityArray[indexPath.section];
    
    XKRWAlarmCell *alarmCell = [tableView dequeueReusableCellWithIdentifier:@"alarmCell"];
    [alarmCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (alarmCell == nil) {
        alarmCell = [[XKRWAlarmCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"alarmCell"];
        alarmCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    self.alarmStr = [self alarmStrWithEntity:entity];
    
    [self.alarmDaysArray addObject:[NSMutableString stringWithFormat:@"%d", entity.daysofweek]];
    if (entity.serverid == 0) {
        entity.serverid = [[NSDate date] timeIntervalSince1970];
        
    }
    
    if(!entity.enabled){
        [alarmCell.alarmSwitch setOn:NO animated:YES];
    }else{
        [alarmCell.alarmSwitch setOn:YES animated:YES];
    }
    
    if (indexPath.section == 0) {
        alarm1IsOpen = alarmCell.alarmSwitch.isOn;
    }else if (indexPath.section == 1){
        alarm2IsOpen = alarmCell.alarmSwitch.isOn;}else{
            alarm3IsOpen = alarmCell.alarmSwitch.isOn;}
    
    alarmCell.mealLabel.text = _itemsLabelArray[indexPath.section];
    alarmCell.timeLabel.text = self.alarmStr;
    alarmCell.editTimeBtn.tag = indexPath.section;
    [alarmCell.editTimeBtn addTarget:self action:@selector(editTime:) forControlEvents:UIControlEventTouchUpInside];
    alarmCell.alarmSwitch.tag = indexPath.section;
    [alarmCell.alarmSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
    //    [self addWeekDaysViewOnCell:alarmCell andTag:(int)indexPath.section];
    
    __block XKRWCheckButtonView *view = [[XKRWCheckButtonView alloc] initWithFrame:CGRectMake(15, 73+12, XKAppWidth - 30, 35.f)
                                                                     andTitleArray:(NSMutableArray *)_weekdayTitleArray
                                                                   andSpacingWidth:(XKAppWidth - 30 - 35 * 7) / 6
                                                          andCurrentSelectedButton:[self.alarmDaysArray[indexPath.section] intValue]
                                                                          andStyle:XKRWCheckButtonViewStyleWeekdayPicker
                                                                      returnHeight:^(CGFloat height) {
                                                                          
                                                                      } clickButton:^(NSInteger index) {
                                                                          XKLog(@"%d",(int)index);
                                                                          self.isUpdate = YES;
                                                                          _alarmDaysArray[indexPath.section] = [NSMutableString stringWithFormat:@"%d",[view getAllButtonState]];
                                                                          [self saveAlarmWithType:indexPath.section];
                                                                      }];
    
    [alarmCell.contentView addSubview:view];
    
    return alarmCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        return 15;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _alarmEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 15)];
    view.backgroundColor = XK_BACKGROUND_COLOR;
    return view;
}



#pragma mark - 触发事件

//点击开关
- (void)clickSwitch:(UISwitch *)editSwitch
{
    self.isUpdate = YES;
    if(editSwitch.tag == 0){
        alarm1IsOpen =  editSwitch.isOn;
        [self saveAlarmWithType: 0];
        
    }else if (editSwitch.tag == 1){
        alarm2IsOpen =  editSwitch.isOn;
        [self saveAlarmWithType: 1];
        
    }else if (editSwitch.tag == 2){
        alarm3IsOpen =  editSwitch.isOn;
        [self saveAlarmWithType:2];
        
    }
}

//点击时间编辑按钮事件
-(void)editTime:(UIButton *)btn
{
    DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
    
    [picker initSubviewsWithStyle:DatePickerStyleGetUpTimePicker
                           andObj:[self alarmStrWithEntity:_alarmEntityArray[btn.tag]]];
    picker.identifier = [NSString stringWithFormat:@"%zd",btn.tag];
    [picker setTitle:_pickerTitleArray[btn.tag]];
    
    
    picker.delegate = self;
    [picker addToWindow];
}


#pragma mark - delegate of DatePickerView

- (void)clickCancelButton:(DatePickerView *)picker
{
    
}

- (void)clickConfirmButton:(DatePickerView *)picker postSelected:(NSString *)string
{
    if (![self.alarmStr isEqualToString:string]) {
        self.isUpdate = YES;
    }
    self.alarmStr = string;
    NSArray *sep = [string componentsSeparatedByString:@":"];
    
    XKRWAlarmEntity *entity = _alarmEntityArray[[picker.identifier intValue]];
    
    
    entity.hour = [sep[0] intValue];
    entity.minutes = [sep[1] intValue];
    [_tableView reloadData];
    [self saveAlarmWithType:[picker.identifier intValue]];
    
}

#pragma mark - 数据处理
//将更改的提醒记录保存在数组
- (void)saveAlarmWithType:(NSInteger) type
{
    XKRWAlarmEntity *entity = _alarmEntityArray[type];
    if (type == 0) {
        entity.enabled = alarm1IsOpen;
    }else if (type == 1){
        entity.enabled = alarm2IsOpen;
    }else{
        entity.enabled = alarm3IsOpen;}
    entity.daysofweek = [_alarmDaysArray[type] intValue];
    _alarmEntityArray[type] = entity;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回alarmStr:提醒提醒时间Label显示str
- (NSString *)alarmStrWithEntity:(XKRWAlarmEntity *)entity
{
    
    NSString *hourStr = @"";
    NSString *minuteStr = @"";
    if(entity.hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%i",entity.hour];
    } else {
        hourStr = [NSString stringWithFormat:@"%i",entity.hour];
    }
    
    if(entity.minutes < 10) {
        minuteStr = [NSString stringWithFormat:@"0%i",entity.minutes];
    } else {
        minuteStr = [NSString stringWithFormat:@"%i",entity.minutes];
    }
    _alarmStr= [NSString stringWithFormat:@"%@:%@",hourStr,minuteStr];
    return _alarmStr;
}
//根据早餐、午餐、晚餐的类型分别返回0、1、2
- (NSInteger)mealSelectWithAlarmType:(AlarmType)alarmType
{
    NSInteger selectInteger;
    switch (alarmType) {
        case eAlarmBreakfast:
            selectInteger = 0;
            break;
        case eAlarmLunch:
            selectInteger = 1;
            break;
        default:
            selectInteger = 2;
            break;
    }
    return selectInteger;
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
