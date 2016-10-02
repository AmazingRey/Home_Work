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
@interface XKRWChangeSchemeInfoVC ()<UITableViewDataSource,UITableViewDelegate,PickerSheetViewDelegate>
{
    NSArray * schemeInfoTitleArray;
    NSMutableArray * schemeInfoDataArray;
    UITableView *schemeInfotableView;
    
    XKRWPickerSheet *waistPickerSheet;
    
    NSMutableArray *decimalsArray;
    NSMutableArray *integerArray;
    NSInteger maxRowValue;
    NSInteger waistRow1Temp;
    NSInteger waistRow2Temp;
    CGFloat waist;
    NSString  *recordValue;
    XKRWRecordEntity4_0 *waistRecordEntity;
}

@end

@implementation XKRWChangeSchemeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    
    [MobClick event:@"clk_revise"];
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
    
    waistPickerSheet = [[XKRWPickerSheet alloc]initWithSheetTitle:@"设置腰围" AndUnit:@"cm"];
    waistPickerSheet.pickerSheetDelegate = self;
    waistPickerSheet.tag = 10005;
    
}

- (void)initData
{
    schemeInfoTitleArray = @[@[@"性别",@"出生日期",@"身高",@"初始体重",@"目标体重",@"日常活动水平",@"腰围",@"所在城市",@"肥胖原因"],@[@"重置瘦身方案"]];
    
    schemeInfoDataArray = [NSMutableArray array];
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
    
    waist = [[XKRWRecordService4_0 sharedService] queryRecentWaist];
    if (waist) {
        [schemeInfoDataArray addObject:[NSString stringWithFormat:@"%.1fcm",waist]];
    } else {
       [schemeInfoDataArray addObject:@"未填写"];
    }
    
    integerArray = [NSMutableArray array];
    for (int i = 50; i < 150 ; i++) {
        [integerArray addObject:[NSString stringWithFormat:@"%d",i]];
        maxRowValue = 150;
    }
    decimalsArray = [NSMutableArray arrayWithArray:@[@".0",@".1",@".2",@".3",@".4",@".5",@".6",@".7",@".8",@".9"]];
    
    NSString *userCity =  [[XKRWUserService sharedService]getUserCity];
    [schemeInfoDataArray addObject:userCity];
    
    [schemeInfoDataArray addObject:[NSString stringWithFormat: @"%ld个",(long)[XKRWFatReasonService.sharedService getBadHabitNum]]];
    
    [self setPickerSheetState];
    
}

- (void)setPickerSheetState {
    
    if (waist <= 50) {
        waistRow1Temp = 50;
        waistRow2Temp = 0;
    } else {
        waistRow2Temp = (NSInteger)(waist * 10) % 10;
        waistRow1Temp = (NSInteger)(waist - waistRow2Temp / 10) - 50;
    }
    [waistPickerSheet pickerSelectRow:waistRow1Temp inCol:0];
    [waistPickerSheet pickerSelectRow:waistRow2Temp inCol:1];
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

- (NSString *)pickerSheetTitleInRow:(NSInteger)row andColum:(NSInteger)colum
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
        waistRow1Temp = row;
    }else if (colum ==1)
    {
        waistRow2Temp = row;
    }
}

//顶部按钮回调
- (void) pickerSheetCancelBackUserBtn:(BOOL)status
{
    
}


//点击确定 记录围度数据
- (void)pickerSheetDoneBack:(DidDoneCallback)caback
{
    waistRecordEntity = [[XKRWRecordService4_0 sharedService] getOtherInfoOfDay:[NSDate today]];
    if(!waistRecordEntity){
        waistRecordEntity = [[XKRWRecordEntity4_0 alloc] init];
    }
    waistRecordEntity.circumference.uid = (int)[XKRWUserDefaultService getCurrentUserId];
    recordValue = [NSString stringWithFormat:@"%@%@",[integerArray objectAtIndex:waistRow1Temp],[decimalsArray objectAtIndex:waistRow2Temp]];
    
    waistRecordEntity.circumference.waistline = [recordValue floatValue];//腰围 waistline
    waistRecordEntity.date = [NSDate today];
    
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"网络未连接，请稍后再试"];
        return;
    }
    
    [XKRWCui showProgressHud:@"保存中..."];
    [self downloadWithTaskID:@"record" outputTask:^id{
        return @([[XKRWRecordService4_0 sharedService] saveRecord:waistRecordEntity ofType:XKRWRecordTypeCircumference]);
    }];
    
}

#pragma --mark AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)  //确定
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"needResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
        
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"lateToResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [XKRWCui showProgressHud:@"数据重置中，请稍后..."];
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
    
    if ([taskID isEqualToString:@"record"]) {
        [waistPickerSheet removeFromView];
        waist = [[XKRWRecordService4_0 sharedService] queryRecentWaist];
        [schemeInfoDataArray replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%.1fcm",waist]];
        [self setPickerSheetState];
        [schemeInfotableView reloadData];
    }
    if ([taskID isEqualToString:@"restSchene"]) {
        if (result != nil) {
            if ([[result objectForKey:@"success"] integerValue] == 1){
                
                NSDate *date = [NSDate dateFromString:[result objectForKey:@"data"] withFormat:@"yyyy-MM-dd hh:mm:ss"];
                [[XKRWUserService sharedService] setResetTime:[NSNumber numberWithLong:[date timeIntervalSince1970]]];
                
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
                [XKRWCui showInformationHudWithText:@"重置计划失败，请稍后尝试"];
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
    [XKRWCui showInformationHudWithText:@"重置计划失败，请稍后尝试"];
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
                [waistPickerSheet showInView:self.view];
            }
                break;
            case 7:
            {
                CityListViewController * vc = [[CityListViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 8:
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
    
    if (indexPath.section == 0) {
        
        if (indexPath.row < 6){
            
            cell.schmeInfoDataLabel.textColor =  colorSecondary_999999;
            cell.arrowCell.hidden = YES;
        }
        
    }else{
        
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
