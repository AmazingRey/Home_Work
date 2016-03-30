//
//  XKRWSurroundDegreeVC.m
//  XKRW
//
//  Created by 忘、 on 15/8/28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWSurroundDegreeVC.h"
#import "XKRWRecordService4_0.h"
#import "XKRWUserService.h"
#import "XKRWPickerSheet.h"
#import "XKRWRecordService4_0.h"
#import "XKRWAlgolHelper.h"
#import "XKRW-Swift.h"
#import "XKRWMoreView.h"
#import "XKRWDataCenterVC.h"

#define kDaySeconds 86400
#define HEIGHT    250
#define LABELHEIGHT  30
#define CELLWIDTH    64


@interface XKRWSurroundDegreeVC ()<UITableViewDataSource,UITableViewDelegate,PickerSheetViewDelegate,UIAlertViewDelegate>
{
    UILabel *initialLabel ;
    NSMutableArray  *initialDataArray;
    CGFloat  lineHighest;
    NSString *initialValue;   //初始值
    NSString *targetValue;    //目标值
    NSString *maxValue;     //最大值
    NSString *minValue;     //最小值
    
    NSMutableArray *decimalsArray;  //小数部分
    NSMutableArray *integerArray;   //整数部分
    
    
    NSDate *date;                //修改哪一天
    NSString  *recordValue;       //记录的值
    XKRWPickerSheet *pickerSheet;
    
    NSInteger row1Temp;
    NSInteger row2Temp;
    
    XKRWRecordType recordType;
    
    NSInteger changeRow;
    
    UITableView *surroundTableView ;
    
    NSArray * tempArray;
    UIBarButtonItem *backTodayItem;
    UISegmentedControl *segmentControl;
    
    NSInteger  maxRowValue;
    XKRWRecordEntity4_0 *entity;
}
@end

@implementation XKRWSurroundDegreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNaviBarBackButton];
    
    if (_dataType == eWeightType) {
        self.title = @"体重曲线";
    }else{
        self.title = @"围度曲线";
    }
    
    [XKRWCui showProgressHud];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initData];
    [self initUI];
    [self setPickerViewInitialValue];
    if (_dataType == eWeightType) {
        [self setinitialLabelLocation];
    }
    [XKRWCui hideProgressHud];
    
   
}

- (void) initUI
{
    surroundTableView = [[UITableView alloc]init];
    surroundTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    surroundTableView .delegate = self;
    surroundTableView.dataSource = self;
    surroundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    surroundTableView.showsHorizontalScrollIndicator = NO;
    surroundTableView.showsVerticalScrollIndicator = NO;
    surroundTableView.frame = CGRectMake(0, 0, XKAppWidth, HEIGHT);
    [self.view addSubview:surroundTableView];
    
    if (_dataType == eWeightType) {
        initialLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, LABELHEIGHT, 120, 20)];
        initialLabel.backgroundColor = [UIColor clearColor];
        initialLabel.textAlignment = NSTextAlignmentLeft;
        initialLabel.textColor = colorSecondary_666666;
        initialLabel.font = XKDefaultFontWithSize(14.f);
        initialLabel.text = [NSString stringWithFormat:@"初始体重%@kg",initialValue];
        [self.view addSubview:initialLabel];
        
        UILabel *targetLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (HEIGHT-LABELHEIGHT-20), 150, 20)];
        targetLabel.backgroundColor = [UIColor clearColor];
        targetLabel.textAlignment = NSTextAlignmentLeft;
        targetLabel.textColor = colorSecondary_666666;
        targetLabel.font = XKDefaultFontWithSize(14.f);
        targetLabel.text = [NSString stringWithFormat:@"目标体重%@kg",targetValue];
        [self.view addSubview:targetLabel];
        recordType = XKRWRecordTypeWeight;
        
        XKRWMoreView *dataCenterView = [[[NSBundle mainBundle] loadNibNamed:@"XKRWMoreView" owner:self options:nil] lastObject];
        dataCenterView.frame = CGRectMake(0, surroundTableView.bottom + 10, XKAppWidth, 44);
        dataCenterView.pushLabel.textColor = XK_TITLE_COLOR;
        dataCenterView.pushLabel.font = XKDefaultFontWithSize(14);
        dataCenterView.pushLabel.text = @"围度数据";
        dataCenterView.userInteractionEnabled = YES;
        
        __weak typeof(self) weakSelf = self;
        dataCenterView.viewClicked = ^(){
            [MobClick event:@"in_data3"];
            XKRWDataCenterVC *dataCenterVC =  [[XKRWDataCenterVC alloc]init];
            dataCenterVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:dataCenterVC animated:YES];
        };
        
        [self.view addSubview:dataCenterView];
        
    }else{
        NSArray *surroundArrays = @[@"胸围",@"臂围",@"腰围",@"臀围",@"大腿围",@"小腿围"];
        segmentControl = [[UISegmentedControl alloc]initWithItems:surroundArrays];
        segmentControl.frame = CGRectMake(15, 10, XKAppWidth-30, 30);
        [segmentControl addTarget:self action:@selector(surroundSegmentAction:) forControlEvents:UIControlEventValueChanged];
        segmentControl.tintColor = XKMainToneColor_29ccb1;
        [self.view addSubview:segmentControl];
        
        surroundTableView.frame = CGRectMake(0, segmentControl.bottom +10, XKAppWidth, HEIGHT);
        
        recordType = XKRWRecordTypeCircumference;
        
    }
    
    UIButton *backTodayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *title = @"回到今天";
    CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(XKAppWidth, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: XKDefaultFontWithSize(14)}
                                             context:nil].size.width;
    backTodayButton.frame = CGRectMake(0, 0, titleWidth, 20);
    [backTodayButton setTitle:title forState:UIControlStateNormal];
    [backTodayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backTodayButton.titleLabel.font = XKDefaultFontWithSize(14.f);
    [backTodayButton addTarget:self action:@selector(backTodayAction:) forControlEvents:UIControlEventTouchUpInside];
    
    backTodayItem =[[UIBarButtonItem alloc]initWithCustomView:backTodayButton];
    
    [self adjustUI];
}

//调整UI
- (void)adjustUI
{
    if (surroundTableView.contentOffset.y  < [initialDataArray count]*64 - XKAppWidth) {
        surroundTableView.contentOffset = CGPointMake(0, [initialDataArray count]*64 -XKAppWidth);
    }
    if (_dataType == eWeightType) {
        pickerSheet = [[XKRWPickerSheet alloc]initWithSheetTitle:@"设置体重" AndUnit:@"kg"];
    }else if (_dataType == eBustType){
        segmentControl.selectedSegmentIndex = 0;
        pickerSheet = [[XKRWPickerSheet alloc]initWithSheetTitle:@"设置胸围" AndUnit:@"cm"];
    }else if (_dataType == eArmType){
        segmentControl.selectedSegmentIndex = 1;
        pickerSheet = [[XKRWPickerSheet alloc]initWithSheetTitle:@"设置臂围" AndUnit:@"cm"];
    }else if (_dataType == eWaistType){
        segmentControl.selectedSegmentIndex = 2;
        pickerSheet = [[XKRWPickerSheet alloc]initWithSheetTitle:@"设置腰围" AndUnit:@"cm"];
    }else if (_dataType == eHipType){
        segmentControl.selectedSegmentIndex = 3;
        pickerSheet = [[XKRWPickerSheet alloc]initWithSheetTitle:@"设置臀围" AndUnit:@"cm"];
    }else if (_dataType == ecalfType){
        segmentControl.selectedSegmentIndex = 5;
        pickerSheet = [[XKRWPickerSheet alloc]initWithSheetTitle:@"设置小腿围" AndUnit:@"cm"];
    }else if (_dataType == eThighType)
    {
        segmentControl.selectedSegmentIndex = 4;
        pickerSheet = [[XKRWPickerSheet alloc]initWithSheetTitle:@"设置大腿围" AndUnit:@"cm"];
    }
    pickerSheet.pickerSheetDelegate = self;
}

- (void) initData
{
    row1Temp = 0;
    row2Temp = 0;
    
    lineHighest = HEIGHT - LABELHEIGHT -2*20 ;
    
    targetValue =[NSString stringWithFormat:@"%.1f",[[XKRWUserService sharedService] getUserDestiWeight]/1000.0];

    decimalsArray = [NSMutableArray arrayWithArray:@[@".0",@".1",@".2",@".3",@".4",@".5",@".6",@".7",@".8",@".9"]];
    
    initialDataArray = [[NSMutableArray alloc]init];

    [self refreahData];
}

- (void)refreahData
{
    if (_dataType == eWeightType) {
        initialValue = [NSString stringWithFormat:@"%.1f",[[XKRWUserService sharedService] getUserOrigWeight]/1000.0];
    }else if (_dataType == eBustType){
        if ([[XKRWUserService sharedService] getSex] == eSexFemale) {
            initialValue  = @"100";
        }else{
            initialValue  = @"100";
        }
    }else if (_dataType == eArmType){
        if ([[XKRWUserService sharedService] getSex] == eSexFemale) {
            initialValue  = @"25";
        }else{
            initialValue  = @"30";
        }
        
    }else if (_dataType == eWaistType){
        if ([[XKRWUserService sharedService] getSex] == eSexFemale) {
            initialValue  = @"75";
        }else{
            initialValue  = @"85";
        }
        
    }else if (_dataType == eHipType){
        if ([[XKRWUserService sharedService] getSex] == eSexFemale) {
            initialValue  = @"90";
        }else{
            initialValue  = @"100";
        }
        
    }else if (_dataType == eThighType){
        if ([[XKRWUserService sharedService] getSex] == eSexFemale) {
            initialValue  = @"50";
        }else{
            initialValue  = @"60";
        }
        
    }else if (_dataType == ecalfType){
        if ([[XKRWUserService sharedService] getSex] == eSexFemale) {
            initialValue  = @"30";
        }else{
            initialValue  = @"40";
        }
        
    }

    if (integerArray == nil) {
        integerArray = [NSMutableArray array];
    }else{
        [integerArray removeAllObjects];
    }
    if (_dataType == eWeightType) {
        for (NSInteger i = (NSInteger)[[XKRWUserService sharedService] getUserDestiWeight]/1000; i <200; i++) {
            [integerArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
            maxRowValue = 200;
        }
    }else if(_dataType == eBustType ||_dataType ==eWaistType||_dataType ==eHipType){
        for (int i = 50; i < 150 ; i++) {
            [integerArray addObject:[NSString stringWithFormat:@"%d",i]];
            maxRowValue = 150;
        }
    }else if (_dataType == eArmType){
        for (int i = 15; i < 100 ; i++) {
            [integerArray addObject:[NSString stringWithFormat:@"%d",i]];
            maxRowValue = 100;
        }
    }else if (_dataType == eThighType){
        for (int i = 30; i < 150 ; i++) {
            [integerArray addObject:[NSString stringWithFormat:@"%d",i]];
            maxRowValue = 150;
        }
    }else{
        for (int i = 15; i < 100 ; i++) {
            [integerArray addObject:[NSString stringWithFormat:@"%d",i]];
            maxRowValue = 100;
        }
    }
   
    
    NSDictionary *dic = [[XKRWRecordService4_0 sharedService] getAllCircumferenceAndWeightRecord];

    if (_dataType == eWeightType) {
        tempArray = [[dic objectForKey:@"weight"] objectForKey:@"content"];
    }else if(_dataType == eBustType ){
       tempArray = [[dic objectForKey:@"bust"] objectForKey:@"content"];
    }else if (_dataType == eArmType){
       tempArray = [[dic objectForKey:@"arm"] objectForKey:@"content"];
    }else if (_dataType == eThighType){
       tempArray = [[dic objectForKey:@"thigh"] objectForKey:@"content"];
    }else if(_dataType ==eWaistType ){
       tempArray = [[dic objectForKey:@"waistline"] objectForKey:@"content"];
    }else if (_dataType ==eHipType){
       tempArray = [[dic objectForKey:@"hipline"] objectForKey:@"content"];
    }else{
       tempArray = [[dic objectForKey:@"shank"] objectForKey:@"content"];
    }

    [self handleDataWithTempMutArray:tempArray];
    
    if ([tempArray count] == 0) {
        maxValue = minValue = initialValue;
    }else{
        NSArray * orderlyArray = [self dateSortFromMinToMax:[NSMutableArray arrayWithArray:tempArray]];
        maxValue = [[orderlyArray lastObject] objectForKey:@"value"];
        minValue = [[orderlyArray firstObject] objectForKey:@"value"];
        if ([initialValue floatValue] > [maxValue floatValue]) {
             initialValue = maxValue;
        }
        if ([initialValue floatValue] < [minValue floatValue]) {
             initialValue = minValue;
        }
    }
}


#pragma --mark Action

-(void)backTodayAction:(UIButton *)button
{
    surroundTableView.contentOffset = CGPointMake(0, [initialDataArray count]*64 -XKAppWidth);
}


- (void)surroundSegmentAction:(UISegmentedControl *) segmentedControl
{
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            _dataType = eBustType;
            break;
        case 1:
             _dataType = eArmType;
            break;
        case 2:
             _dataType = eWaistType;
            break;
        case 3:
             _dataType = eHipType;
            break;
        case 4:
             _dataType = eThighType;
            break;
        case 5:
             _dataType = ecalfType;
            break;
        default:
            break;
    }
    row1Temp = 0;
    row2Temp = 0;
    changeRow = 0;
    [self adjustUI];
    [self refreahData];
    [surroundTableView reloadData];
    
}

//设置初始体重Label 的位置
- (void)setinitialLabelLocation
{
    CGFloat initialLabelY;
    if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
        initialLabelY = (lineHighest +LABELHEIGHT) /2 ;
    }else{
        initialLabelY =  lineHighest +20 +LABELHEIGHT/2 -((initialValue.floatValue - minValue.floatValue) *lineHighest /(maxValue.floatValue - minValue.floatValue));
        if (initialLabelY > HEIGHT- 50) {
            initialLabelY = HEIGHT-60;
        }
    }
    initialLabel.frame = CGRectMake(0, initialLabelY-20/2, 120, 20);
}

/*** 用户达到目标体重*/
- (void)userReachTargetWeight{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"已达成目标体重" message:@"已达成目标体重，是否重新制定方案？" delegate:self cancelButtonTitle:nil  otherButtonTitles:@"是的，去重置方案",@"没有，记录错了", nil];

    alertView.tag = 10001;
    [alertView show];
}


#pragma --mark UITableViewDelegate And UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return initialDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"check";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 64, 20)];
        dateLabel.tag = 100;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = XKDefaultFontWithSize(14.f);
        dateLabel.textColor = colorSecondary_666666;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        [cell.contentView addSubview:dateLabel];
        
        UILabel * dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-LABELHEIGHT, 64, LABELHEIGHT)];
        dataLabel.tag = 101;
        dataLabel.textAlignment = NSTextAlignmentCenter;
        dataLabel.font = XKDefaultFontWithSize(14.f);
        dataLabel.textColor = XKMainToneColor_29ccb1;
        dataLabel.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:dataLabel];
    }
    
    UILabel *dateLabel  = (UILabel *)[cell viewWithTag:100];
    NSRange range = {5,5};
    NSString *showDate = [[[initialDataArray objectAtIndex:indexPath.row] objectForKey:@"date"] substringWithRange:range];
    dateLabel.text = [NSString stringWithFormat:@"%@",showDate];
    
    UILabel *dataLabel = (UILabel *)[cell viewWithTag:101];
    
    if(indexPath.row == 373)
    {
        XKLog(@"%@",[[initialDataArray objectAtIndex:indexPath.row] objectForKey:@"value"]);
    }
    if ([[[initialDataArray objectAtIndex:indexPath.row] objectForKey:@"value"] floatValue] > 0) {
        if (_dataType == eWeightType) {
             dataLabel.text = [NSString stringWithFormat:@"%.1fkg",[[[initialDataArray objectAtIndex:indexPath.row] objectForKey:@"value"] floatValue]];
        }else{
             dataLabel.text = [NSString stringWithFormat:@"%.1fcm",[[[initialDataArray objectAtIndex:indexPath.row] objectForKey:@"value"] floatValue]];
        }
       
    }
    
    NSString *currentValue = [[initialDataArray objectAtIndex:indexPath.row] objectForKey:@"value"];
    
    [self drawImageViewInCell:currentValue And:indexPath andCell:cell];

    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorFromHexString:@"#F9F9F9"];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLWIDTH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [pickerSheet showInView:self.view];
    NSDictionary *selectDic = [initialDataArray objectAtIndex:indexPath.row];
    date = [NSDate dateFromString:[selectDic objectForKey:@"date"] withFormat:@"yyyy/MM/dd"];
    changeRow = indexPath.row;
    [self setPickerViewInitialValue];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (surroundTableView.contentOffset.y  >= [initialDataArray count]*64 - XKAppWidth) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = backTodayItem;
    }
}

#pragma --mark initPickerView
//设置pickerView 默认显示的值
- (void) setPickerViewInitialValue
{
     NSString *showValue = [[initialDataArray objectAtIndex:changeRow] objectForKey:@"value"];
    if (showValue.floatValue == 0) {
        showValue = [self findNextDataFromArray:[initialDataArray subarrayWithRange:NSMakeRange(0, changeRow)]];
    }
    
    NSInteger integer = showValue.intValue;
    
    NSInteger decimals = ceilf((showValue.floatValue - integer)*10);
    row1Temp = integer - [[integerArray objectAtIndex:0] integerValue];
    
    if (row1Temp < 0) {
        row1Temp = 0;
    }

    if (row1Temp > maxRowValue  - [[integerArray objectAtIndex:0] integerValue]-1) {
        row1Temp = maxRowValue - [[integerArray objectAtIndex:0] integerValue]-1;
    }
    
    row2Temp = decimals;
    if (row2Temp < 0 || row2Temp ==10) {
        row2Temp = 0;
    }
    [pickerSheet pickerSelectRow:row1Temp inCol:0];
    [pickerSheet pickerSelectRow:row2Temp inCol:1];
}

#pragma --mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10001){
        if (buttonIndex == 0) {
            [MobClick event:@"clk_YesRest"];
            [self downloadWithTaskID:@"record" outputTask:^id{
                return @([[XKRWRecordService4_0 sharedService] saveRecord:entity ofType:recordType]);
            }];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"ShowWindowFlower_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self popView];
        }else{
            [MobClick event:@"clk_NoRest"];
        }
    }

}


#pragma  --mark pickerSheetDelegate And pickerSheetDataSource

- (NSInteger)pickerSheetNumberOfColumns
{
    return 2;
}

- (NSInteger)pickerSheetNumberOfRowsInColumn:(NSInteger) column
{
    if (column == 0) {
        return [integerArray count];
    }else{
        return [decimalsArray count];
    }
}

- (NSString *)  pickerSheetTitleInRow:(NSInteger) row andColum:(NSInteger)colum
{
    if (colum == 0) {
        return [integerArray objectAtIndex:row];
    }else{
        return [decimalsArray objectAtIndex:row];
    }
}

- (void)pickerSheet:(XKRWPickerControlView *)picker DidSelectRowAtRow:(NSInteger)row AndCloum:(NSInteger)colum
{
    if (colum == 0) {
        row1Temp = row;
    }else if (colum ==1)
    {
        row2Temp = row;
    }
}

//顶部按钮回调
- (void) pickerSheetCancelBackUserBtn:(BOOL)status
{

}


//点击确定 记录围度数据
- (void) pickerSheetDoneBack:(DidDoneCallback) caback
{
//    XKRWRecordEntity4_0 *entity = nil;
    entity = [[XKRWRecordService4_0 sharedService] getOtherInfoOfDay:date];
    if(!entity){
        entity = [[XKRWRecordEntity4_0 alloc] init];
    }
    entity.circumference.uid = (int)[XKRWUserDefaultService getCurrentUserId];
    recordValue = [NSString stringWithFormat:@"%@%@",[integerArray objectAtIndex:row1Temp],[decimalsArray objectAtIndex:row2Temp]];
    
    switch (_dataType) {
        case eBustType:
            entity.circumference.bust = [recordValue floatValue];//胸围  bust
            [MobClick event:@"clk_bust"];
            break;
        case eArmType:
            entity.circumference.arm = [recordValue floatValue];//臂围  arm
            [MobClick event:@"clk_arm"];
            break;
        case eWaistType:
            entity.circumference.waistline = [recordValue floatValue];//腰围 waistline
            [MobClick event:@"clk_waist"];
            break;
        case eHipType:
            entity.circumference.hipline = [recordValue floatValue];//臀围 hipline
            [MobClick event:@"clk_hip"];
            break;
        case eThighType:
            entity.circumference.thigh = [recordValue floatValue];//大腿围 thigh
            [MobClick event:@"clk_thigh"];
            break;
        case ecalfType:
            entity.circumference.shank = [recordValue floatValue];//小腿围 shank
            [MobClick event:@"clk_calf"];
            break;
        case eWeightType:
            [MobClick event:@"clk_WeightRevise"];
            if ([recordValue floatValue] < [targetValue floatValue] ) {
                [XKRWCui showInformationHudWithText:@"不能低于目标体重哦"];
                return;
            }
            entity.weight = [recordValue floatValue]; //体重 weight
            break;
        default:
            break;
    }
    entity.date = date;
    if([recordValue floatValue] == [targetValue floatValue]){
        
         [self userReachTargetWeight];
        
    }else{
        [XKRWCui showProgressHud:@"保存中..."];
        [self downloadWithTaskID:@"record" outputTask:^id{
            return @([[XKRWRecordService4_0 sharedService] saveRecord:entity ofType:recordType]);
        }];
    }
    
    
}


#pragma --mark NetworkDeal
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    
    if ([taskID isEqualToString:@"record"]) {
        [pickerSheet removeFromView];
        [self refreahData];
        [surroundTableView reloadData];
        if (_dataType == eWeightType) {
            [self setinitialLabelLocation];
            
            if (changeRow == [initialDataArray count] -1) {
                CGFloat dailyIntake =  [[[NSUserDefaults standardUserDefaults ] objectForKey:@"DailyIntakeSize"]
                                        floatValue];
                CGFloat nowDailyIntake = [XKRWAlgolHelper dailyIntakeRecomEnergy];
                BOOL answer =   [[XKRWUserService sharedService] isNeedChangeScheme:dailyIntake AndNowDailyIntake:nowDailyIntake];
                if(answer){
                    UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"您已进入新的减重阶段，可获取新方案" message:@"请到“方案”页面的食谱和运动方案中，点击“换一组”获取新方案" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    alertView.tag = 10000;
                    [alertView show];
                }
            }
            
        }
    }
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    [super handleDownloadProblem:problem withTaskID:taskID];
    if ([taskID isEqualToString:@"record"]) {
        [pickerSheet removeFromView];
    }
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}


#pragma --mark drawAction

- (void)drawImageViewInCell:(NSString *)currentValue And:(NSIndexPath *) indexPath andCell:(UITableViewCell *)cell
{
    CGPoint prevPoint;
    CGPoint currentPoint;
    CGPoint nextPoint;
    NSString *nextValue;
    NSString *prevValue;
    UIImageView *imageView = [[UIImageView alloc]init];
    
    if (currentValue.floatValue == 0) {
        currentValue = [self findNextDataFromArray:[initialDataArray subarrayWithRange:NSMakeRange(0, indexPath.row)]];
        imageView.image = [UIImage imageNamed:@"girth_btn_point_640"];
    }else{
        imageView.image = [UIImage imageNamed:@"girth_btn_point_mark_640"];
    }
    
    
    if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
        currentPoint = CGPointMake((CELLWIDTH)/2, (lineHighest +20) /2 );
    }else{
        currentPoint = CGPointMake((CELLWIDTH)/2, lineHighest +20 +LABELHEIGHT/2 -( (currentValue.floatValue - minValue.floatValue) *lineHighest /(maxValue.floatValue - minValue.floatValue)));
    }
    
    imageView.frame = CGRectMake(currentPoint.x-12/2, currentPoint.y-12/2, 12, 12);
    
    if (indexPath.row != 0) {
        prevValue = [[initialDataArray objectAtIndex:indexPath.row -1] objectForKey:@"value"];
        if (prevValue.floatValue == 0) {
            prevValue = [self findNextDataFromArray:[initialDataArray subarrayWithRange:NSMakeRange(0, indexPath.row-1)]];
        }
        if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
            prevPoint = CGPointMake(0, (lineHighest +20) /2 );
        }else{
            prevPoint = CGPointMake(0, lineHighest +20 +LABELHEIGHT/2 -( (prevValue.floatValue +(currentValue.floatValue -prevValue.floatValue)/2  - minValue.floatValue) *lineHighest /(maxValue.floatValue - minValue.floatValue)));
        }
        [self drawLineInView:cell.contentView fromPoint:prevPoint toTargetPoint:currentPoint];
    }
    
    if (initialDataArray.count > indexPath.row +1) {
        nextValue = [[initialDataArray objectAtIndex:indexPath.row+1] objectForKey:@"value"];
        if (nextValue.floatValue == 0) {
            nextValue = [self findNextDataFromArray:[initialDataArray subarrayWithRange:NSMakeRange(0, indexPath.row+1)]];
        }
        if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
            nextPoint = CGPointMake(CELLWIDTH, (lineHighest +20) /2 );
        }else{
            nextPoint = CGPointMake(CELLWIDTH, lineHighest +20 +LABELHEIGHT/2 -( (nextValue.floatValue +(currentValue.floatValue -nextValue.floatValue)/2  - minValue.floatValue) *lineHighest /(maxValue.floatValue - minValue.floatValue)));
        }
        [self drawLineInView:cell.contentView fromPoint:currentPoint toTargetPoint:nextPoint];
    }
    
    [cell.contentView addSubview:imageView];
}


- (void)drawLineInView:(UIView *)view fromPoint:(CGPoint) currentPoint toTargetPoint:(CGPoint) targetPoint
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(currentPoint.x, currentPoint.y)];
    [path addLineToPoint:CGPointMake(targetPoint.x, targetPoint.y)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = view.bounds;
    pathLayer.bounds = view.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = XKMainToneColor_29ccb1.CGColor;//粗线的颜色
    
    
    pathLayer.lineWidth = 1;
    
    pathLayer.lineJoin = kCALineJoinRound;
    [view.layer addSublayer:pathLayer];
    
    UIBezierPath* fill = [UIBezierPath bezierPath];
    
    [fill moveToPoint:CGPointMake(currentPoint.x, HEIGHT-LABELHEIGHT)];
    [fill addLineToPoint:CGPointMake(currentPoint.x, currentPoint.y)];
    [fill addLineToPoint:CGPointMake(targetPoint.x, targetPoint.y)];
    [fill addLineToPoint:CGPointMake(targetPoint.x, HEIGHT-LABELHEIGHT)];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.frame = view.bounds;
    fillLayer.bounds = view.bounds;
    fillLayer.path = fill.CGPath;
    fillLayer.strokeColor = nil;
    fillLayer.fillColor = [XKMainSchemeColor colorWithAlphaComponent:0.3].CGColor;//线下面的颜色
    fillLayer.lineWidth = 0;
    fillLayer.lineJoin = kCALineJoinRound;
    [view.layer addSublayer:fillLayer];
    
}

//数组进行排序  找出最大以及最小值
- (NSMutableArray *)dateSortFromMinToMax:(NSMutableArray *)array
{
//     XKLog(@"数组排序的开始时间%@",[self getTimeNow]);
    for (int i =0; i < array.count-1; i++) {
        for (int j =i+1; j< array.count; j++) {
            if([[[array objectAtIndex:i] objectForKey:@"value"] floatValue] > [[[array objectAtIndex:j] objectForKey:@"value"] floatValue])
            {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
//    XKLog(@"数组排序的结束时间%@",[self getTimeNow]);
    return array;
}


-(NSString*)getDateStringFromDate:(NSDate*)showDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    df.dateFormat = @"yyyy/MM/dd";
    NSString *str = [df stringFromDate:showDate];
    return str;
}

-(void)handleDataWithTempMutArray:(NSArray *)tempDataArray{
    
//    XKLog(@"补全数组的开始时间%@",[self getTimeNow]);
    
    [initialDataArray removeAllObjects];

    NSString *registerDateStr = [[XKRWUserService sharedService] getREGDate];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc ]init];
    formatter1.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    formatter1.dateFormat = @"yyyy-MM-dd";
    NSDate *registerDate  = [formatter1 dateFromString:registerDateStr];
    
    NSInteger count = (int)((int)[[NSDate date] timeIntervalSince1970]- [registerDate timeIntervalSince1970])/kDaySeconds +1;
    
    NSInteger index = 0;
    
    for(int i=0;i<count;i++){
        NSDate *showDate = [NSDate dateWithTimeIntervalSince1970:([registerDate timeIntervalSince1970]+i*kDaySeconds)];
        //注册那天  到今天
        NSString *everyDate = [NSDate stringFromDate:showDate withFormat:@"yyyy-MM-dd"];
        NSMutableDictionary *tempDic= [[NSMutableDictionary alloc] init];
        

        if(![[XKRWRecordService4_0 sharedService] recordTableHavaDataWithDate:everyDate AndType:_dataType]){
            NSString *dayString = [self getDateStringFromDate:showDate];
            [tempDic setObject:dayString forKey:@"date"];
            [tempDic setObject:@"0" forKey:@"value"];
        }else{
            NSString *dayStr = [self getDateStringFromDate:tempDataArray[index][@"date"]];
            [tempDic setObject:dayStr forKey:@"date"];
            [tempDic setObject:[NSString stringWithFormat:@"%@",tempDataArray[index][@"value"]] forKey:@"value"];
            index ++;
        }
        [initialDataArray addObject:tempDic];
    }
//    XKLog(@"补全数组的结束时间%@",[self getTimeNow]);
}



//找到数组中最后边的不为空的值
- (NSString *)findNextDataFromArray:(NSArray *)array
{
//    XKLog(@"数组不为空的开始时间%@",[self getTimeNow]);
    NSArray *reverseArray =   [[array reverseObjectEnumerator]allObjects];
    
    for (int i = 0; i <reverseArray.count; i++) {
        NSString *value = [[reverseArray objectAtIndex:i]objectForKey:@"value"];
        if (value.floatValue != 0) {
            return value;
        }
    }
//    XKLog(@"数组不为空的结束时间%@",[self getTimeNow]);
    return initialValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
