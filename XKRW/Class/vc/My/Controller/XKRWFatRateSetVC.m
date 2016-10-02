//
//  XKRWFatRateSetVC.m
//  XKRW
//
//  Created by Shoushou on 16/8/25.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWFatRateSetVC.h"
#import "XKRWUtil.h"
#import "XKRWUserService.h"
#import "XKRWRecordService4_0.h"
#import "XKRWSchemeInfoCell.h"
#import "XKRWAlgolHelper.h"
#import "XKRWPickerSheet.h"

@interface XKRWFatRateSetVC ()<UITableViewDelegate,UITableViewDataSource,PickerSheetViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, strong) XKRWPickerSheet *pickerSheet;
@property (nonatomic, assign) CGFloat waist;
@property (nonatomic, strong) NSMutableArray *decimalsArray;
@property (nonatomic, strong) NSMutableArray *integerArray;
@property (nonatomic, assign) NSInteger maxRowValue;
@property (nonatomic, assign) NSInteger row1Temp;
@property (nonatomic, assign) NSInteger row2Temp;
@property (nonatomic, strong) NSString  *recordValue;
@property (nonatomic, strong) XKRWRecordEntity4_0 *entity;
@end

@implementation XKRWFatRateSetVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"体脂率自动填写";
    
    _titlesArray = @[@"关闭",@"开启",@"   腰围"];
    
    _integerArray = [NSMutableArray array];
    for (int i = 50; i < 150 ; i++) {
        [_integerArray addObject:[NSString stringWithFormat:@"%d",i]];
        _maxRowValue = 150;
    }
    _decimalsArray = [NSMutableArray arrayWithArray:@[@".0",@".1",@".2",@".3",@".4",@".5",@".6",@".7",@".8",@".9"]];
    _pickerSheet = [[XKRWPickerSheet alloc]initWithSheetTitle:@"设置腰围" AndUnit:@"cm"];
    _pickerSheet.pickerSheetDelegate = self;
    [self initData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = XKClearColor;
    _tableView.scrollEnabled = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"XKRWSchemeInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"onOrOffCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    

}

- (void)initData {
    _waist = [[XKRWRecordService4_0 sharedService] queryRecentWaist];
    if (_waist <= 50) {
        _row1Temp = 50;
        _row2Temp = 0;
    } else {
        _row2Temp = (int)(_waist * 10) % 10;
        _row1Temp = (NSInteger)(_waist - _row2Temp / 10) - 50;
    }
    _isOn = [XKRWAlgolHelper isSetFatRateWriteAuto];
    [self setPickerSheetState];
}

- (void)setPickerSheetState {
    [_pickerSheet pickerSelectRow:_row1Temp inCol:0];
    [_pickerSheet pickerSelectRow:_row2Temp inCol:1];
}

#pragma mark - NetWorking

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
   if ([taskID isEqualToString:@"record"]) {
       [XKRWCui hideProgressHud];
       [XKRWCui showInformationHudWithText:@"保存失败，请重试"];
   }
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    if ([taskID isEqualToString:@"record"]) {
        [_pickerSheet removeFromView];
        [XKRWCui hideProgressHud];
        [XKRWAlgolHelper setFatRateWriteAuto:YES];
        [self initData];
        [_tableView reloadData];
        return;
    }
}

#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isOn) {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKRWSchemeInfoCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"onOrOffCell"];
    tableViewCell.schemeInfotitleLabel.text = _titlesArray[indexPath.row];
    tableViewCell.arrowCell.image = [UIImage imageNamed:@"perfect"];
    if (indexPath.row == 0) {
        _isOn? (tableViewCell.arrowCell.hidden = YES):(tableViewCell.arrowCell.hidden = NO);
    } else if (indexPath.row == 1) {
        _isOn? (tableViewCell.arrowCell.hidden = NO):(tableViewCell.arrowCell.hidden = YES);
    } else if (indexPath.row == 2) {
        tableViewCell.arrowCell.image = [UIImage imageNamed:@"arrow_right5_3"];
        tableViewCell.schmeInfoDataLabel.text = [NSString stringWithFormat:@"%.1fcm",_waist];
        
    }
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && _isOn) {
        [XKRWAlgolHelper setFatRateWriteAuto:NO];
        _isOn = [XKRWAlgolHelper isSetFatRateWriteAuto];
        [tableView reloadData];

    } else if (indexPath.row == 1 && !_isOn) {
        if (!_waist) {
            [_pickerSheet showInView:self.view];
            
        } else {
            [XKRWAlgolHelper setFatRateWriteAuto:YES];
            _isOn = [XKRWAlgolHelper isSetFatRateWriteAuto];
            [tableView reloadData];
        }
        
    } else if (indexPath.row == 2) {
        [_pickerSheet showInView:self.view];
        
    } else {
        return;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *noticeView;
    if (noticeView == nil) {
        noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 150)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, XKAppWidth - 30, 44)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.attributedText = [XKRWUtil createAttributeStringWithString:@"- 若选择“关闭”，每次记录体脂率时，不自动填写系统计算的体脂率数值；\n- 若选择“开启”，每次记录体脂率时，会自动填写系统计算的体脂率数值，但你可以进行修改并记录；\n- 如果你有体脂称设备，推荐关闭；如果没有，推荐开启。\n- 开启自动填写，需要腰围数据；" font:XKDefaultFontWithSize(14.f) color:XK_ASSIST_TEXT_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
        [label sizeToFit];
        [noticeView addSubview:label];
    }
    
    return noticeView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header;
    if (header == nil) {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
        header.backgroundColor = XKClearColor;
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma  --mark pickerSheetDelegate And pickerSheetDataSource

- (NSInteger)pickerSheetNumberOfColumns
{
    return 2;
}

- (NSInteger)pickerSheetNumberOfRowsInColumn:(NSInteger) column
{
    if (column == 0) {
        return [_integerArray count];
    }else{
        return [_decimalsArray count];
    }
}

- (NSString *)pickerSheetTitleInRow:(NSInteger)row andColum:(NSInteger)colum
{
    if (colum == 0) {
        return [_integerArray objectAtIndex:row];
    }else{
        return [_decimalsArray objectAtIndex:row];
    }
}

- (void)pickerSheet:(XKRWPickerControlView *)picker DidSelectRowAtRow:(NSInteger)row AndCloum:(NSInteger)colum
{
    if (colum == 0) {
        _row1Temp = row;
    }else if (colum ==1)
    {
        _row2Temp = row;
    }
}

//顶部按钮回调
- (void) pickerSheetCancelBackUserBtn:(BOOL)status
{
    
}


//点击确定 记录围度数据
- (void)pickerSheetDoneBack:(DidDoneCallback)caback
{
    _entity = [[XKRWRecordService4_0 sharedService] getOtherInfoOfDay:[NSDate today]];
    if(!_entity){
        _entity = [[XKRWRecordEntity4_0 alloc] init];
    }
    _entity.circumference.uid = (int)[XKRWUserDefaultService getCurrentUserId];
    _recordValue = [NSString stringWithFormat:@"%@%@",[_integerArray objectAtIndex:_row1Temp],[_decimalsArray objectAtIndex:_row2Temp]];
    
    _entity.circumference.waistline = [_recordValue floatValue];//腰围 waistline
    _entity.date = [NSDate today];
    
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"网络未连接，请稍后再试"];
        return;
    }
    
    [XKRWCui showProgressHud:@"保存中..."];
    [self downloadWithTaskID:@"record" outputTask:^id{
        return @([[XKRWRecordService4_0 sharedService] saveRecord:_entity ofType:XKRWRecordTypeCircumference]);
    }];
    
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
