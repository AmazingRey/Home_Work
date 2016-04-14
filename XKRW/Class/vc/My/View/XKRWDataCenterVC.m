//
//  XKRWDataCenterVC.m
//  XKRW
//
//  Created by 忘、 on 15/7/10.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWDataCenterVC.h"
#import "XKRWSurroundCell.h"
#import "XKRWUserService.h"
#import "XKRWRecordService4_0.h"
#import "XKRWCourseWeightCell.h"
#import "XKRWCourseDietAndSportCell.h"
#import "XKRWHabitChangeCell.h"
#import "XKRWUserService.h"
#import "XKRWSurroundDegreeVC.h"
#import "MobClick.h"

@interface XKRWDataCenterVC ()<UITableViewDataSource,UITableViewDelegate,XKRWSurroundCellDelegate>
{
    UIImageView *remindImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XKRWDataCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviBarBackButton];
    self.title = @"数据中心";
  
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.segmentedControl addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    
    remindImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 48, XKAppWidth, XKAppHeight-112)];
    remindImageView.hidden = YES;
    [self.view addSubview:remindImageView];
    
    if (self.selectedIndex == 1) {
        _segmentedControl.selectedSegmentIndex = _selectedIndex;
        _tableView.backgroundColor = XKBGDefaultColor;
        [self showReminderImageView:sevenDay];
        
    } else {
        _segmentedControl.selectedSegmentIndex = 0;
    }
    
    [MobClick event:@"in_data"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (NSInteger)getSignIndays {
    NSString *createTime = [[XKRWUserService sharedService]getREGDate];
    NSTimeInterval createTimeInterval = [[NSDate dateFromString:createTime withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
    NSTimeInterval nowTimeInterval = [[NSDate date]timeIntervalSince1970];
    NSInteger signIndays = (nowTimeInterval - createTimeInterval)/(24*60*60);
    
    return signIndays;
}

- (void)showReminderImageView:(DateType) dateType
{
    NSInteger signIndays = [self getSignIndays];
    if (dateType == sevenDay) {
        if (XKAppHeight == 480) {
            remindImageView.image = [UIImage imageNamed:@"progress_7day_none_640x960"];
        }else if (XKAppHeight == 568)
        {
            remindImageView.image = [UIImage imageNamed:@"progress_7day_none_640x1136"];
        }else if (XKAppHeight == 667)
        {
            remindImageView.image = [UIImage imageNamed:@"progress_7day_none_750x1334"];
        }else{
            remindImageView.image = [UIImage imageNamed:@"progress_7day_none_1242x2208"];
        }
        
        if (signIndays < 7) {
            remindImageView.hidden = NO;
        }else{
            remindImageView.hidden = YES;
        }
    }else if(dateType == thirtyDay ){
        if (XKAppHeight == 480) {
            remindImageView.image = [UIImage imageNamed:@"progress_30day_none_640x960"];
        }else if (XKAppHeight == 568)
        {
            remindImageView.image = [UIImage imageNamed:@"progress_30day_none_640x1136"];
        }else if (XKAppHeight == 667)
        {
            remindImageView.image = [UIImage imageNamed:@"progress_30day_none_750x1334"];
        }else{
            remindImageView.image = [UIImage imageNamed:@"progress_30day_none_1242x2208"];
        }

        if (signIndays < 30) {
            remindImageView.hidden = NO;
        }else{
            remindImageView.hidden = YES;
        }
    }else{
        remindImageView.hidden = YES;
    }
    
}

#pragma --mark Action

- (void)segmentedAction:(UISegmentedControl *)segmentControl
{
    if (segmentControl.selectedSegmentIndex == 0) {
     
        _tableView.backgroundColor = [UIColor whiteColor];
        [self showReminderImageView:0];
    }else if (segmentControl.selectedSegmentIndex == 1)
    {
        [MobClick event:@"clk_7day"];
        
        _tableView.backgroundColor = XKBGDefaultColor;
        [self showReminderImageView:sevenDay];
    }else{
        
        [MobClick event:@"clk_30day"];
        _tableView.backgroundColor = XKBGDefaultColor;
        [self showReminderImageView:thirtyDay];
    }
    [_tableView reloadData];
}

- (void)setSurroundCellButton:(UIButton *)button withSurroundkey:(NSString *)key WithData:(NSDictionary *)dic
{
    NSDictionary *surroundDic = [dic objectForKey:key];
    
    NSArray *countArray = [surroundDic objectForKey:@"content"];
    
    if (countArray.count > 0) {
        [button setTitle:[NSString stringWithFormat:@"%.1fcm",[[[countArray lastObject] objectForKey:@"value"] floatValue]] forState:UIControlStateNormal];
        [button setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
        [button setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateHighlighted];
    }else{
        [button setTitle:@"未记录" forState:UIControlStateNormal];
        [button setTitleColor:XKWarningColor forState:UIControlStateNormal];
        [button setTitleColor:XKWarningColor forState:UIControlStateHighlighted];
    }
    
}

- (void)entrySurroundVCDelegate:(NSInteger)tag
{
    XKRWSurroundDegreeVC *surroundVC = [[XKRWSurroundDegreeVC alloc]init];
//    surroundVC.navigationController
    switch (tag) {
        case 1000:
            surroundVC.dataType = eBustType;
            break;
        case 1001:
            surroundVC.dataType = eArmType;
            break;
        case 1002:
            surroundVC.dataType = eWaistType;
            break;
        case 1003:
            surroundVC.dataType = eHipType;
            break;
        case 1004:
            surroundVC.dataType = eThighType;
            break;
        case 1005:
            surroundVC.dataType = ecalfType;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:surroundVC animated:YES];
    
    
}


#pragma --mark TableViewDelegate dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_segmentedControl.selectedSegmentIndex == 0){
        return 1;
    }else if (_segmentedControl.selectedSegmentIndex == 1){
        return 4;
    }else{
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return 1;
    }else if (_segmentedControl.selectedSegmentIndex == 1){
        return 1;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        
        XKRWSurroundCell *cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWSurroundCell");
        
        if([XKRWUserService sharedService].getSex == eSexMale){
            cell.sexImageView.image = [UIImage imageNamed:@"progress_male_640"];
        }else{
            cell.sexImageView.image = [UIImage imageNamed:@"progress_female_640"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.entrySurroundDelegate = self;
        NSDictionary *dic = [[XKRWRecordService4_0 sharedService] getAllCircumferenceAndWeightRecord];
        [self setSurroundCellButton:cell.armGirthButton withSurroundkey:@"arm" WithData:dic];
        [self setSurroundCellButton:cell.bustGirthButton withSurroundkey:@"bust" WithData:dic];
        [self setSurroundCellButton:cell.hiplineButton withSurroundkey:@"hipline" WithData:dic];
        [self setSurroundCellButton:cell.ThighlineButton withSurroundkey:@"thigh" WithData:dic];
        [self setSurroundCellButton:cell.waistlineButton withSurroundkey:@"waistline" WithData:dic];
        [self setSurroundCellButton:cell.calfGirthButton withSurroundkey:@"shank" WithData:dic];
        return cell;
    }else if(_segmentedControl.selectedSegmentIndex == 1)
    {
        if (indexPath.section == 0) {
            
            NSArray *weightArray =  [[XKRWRecordService4_0 sharedService]getWeightRecordNumberOfDays:7];
            XKRWCourseWeightCell *weightCell = LOAD_VIEW_FROM_BUNDLE(@"XKRWCourseWeightCell");
            weightCell.weightDescriptionLabel.text = [self userLoseWeightState];
            weightCell.selectionStyle = UITableViewCellSelectionStyleNone;
            weightCell.dataTypeImageView.image = [UIImage imageNamed:@"progress_weight_7day_640"];
            
            [self setEverydayExecuteState:weightArray DataType:sevenDay lifeStyle:weight inView:weightCell.pointView];
            
            return weightCell;
        }else if (indexPath.section == 1){
            
            NSArray *dietArrays = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:7 withType:RecordTypeBreakfirst];
            
            
            //完美执行
            NSInteger perfect = [self theNumberOfExecutionStatus:dietArrays andState:1 andLifeStyle:diet];
            NSInteger other = [self theNumberOfExecutionStatus:dietArrays andState:3 andLifeStyle:diet];
            NSInteger lazy  = [self theNumberOfExecutionStatus:dietArrays andState:2 andLifeStyle:diet];
            
            XKRWCourseDietAndSportCell *dietCell = LOAD_VIEW_FROM_BUNDLE(@"XKRWCourseDietAndSportCell");
            dietCell.dietAndSportImageView.image = [UIImage imageNamed:@"progress_diet_emblem_640"];
            dietCell.perfectExecutionLabel.text = [NSString stringWithFormat:@"%ld",(long)perfect];
            dietCell.lazyLabel.text = [NSString stringWithFormat:@"%ld",(long)lazy];
            dietCell.doOtherLabel.text = [NSString stringWithFormat:@"%ld",(long)other];
            dietCell.titleLabel.text = @"饮食摄入";
            dietCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [self setEverydayExecuteState:dietArrays DataType:sevenDay lifeStyle:diet inView:dietCell.dietAndSportDetailImageView];
            
            
            return dietCell;
        }else if (indexPath.section == 2){
            
            NSArray *sportArrays = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:7 withType:RecordTypeSport];
            
            NSInteger perfect = [self theNumberOfExecutionStatus:sportArrays andState:1 andLifeStyle:sport];
            NSInteger other = [self theNumberOfExecutionStatus:sportArrays andState:3 andLifeStyle:sport];
            NSInteger lazy  = [self theNumberOfExecutionStatus:sportArrays andState:2 andLifeStyle:sport];
            
            XKRWCourseDietAndSportCell *sportCell = LOAD_VIEW_FROM_BUNDLE(@"XKRWCourseDietAndSportCell");
            sportCell.titleLabel.text = @"运动消耗";
            sportCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sportCell.dietAndSportImageView.image = [UIImage imageNamed:@"progress_sport_emblem_640"];
            sportCell.perfectExecutionLabel.text = [NSString stringWithFormat:@"%ld",(long)perfect];
            sportCell.lazyLabel.text = [NSString stringWithFormat:@"%ld",(long)lazy];
            sportCell.doOtherLabel.text = [NSString stringWithFormat:@"%ld",(long)other];
            
            [self setEverydayExecuteState:sportArrays DataType:sevenDay lifeStyle:sport inView:sportCell.dietAndSportDetailImageView];
            
            
            return sportCell;
        }else {
            
            NSDictionary *resultDic =   [[XKRWRecordService4_0 sharedService]getHabitInfoWithDays:7];
            XKLog(@"%@",resultDic);
            
            NSArray *habitArrays = nil;
            if (resultDic != nil) {
                habitArrays = @[[resultDic objectForKey:@"content"],[resultDic objectForKey:@"count"]];
            }
            
            NSInteger  perfect =   [self theNumberOfExecutionStatus:[resultDic objectForKey:@"content"] andState:1 andLifeStyle:habit];
            NSInteger  oneStep =    [self theNumberOfExecutionStatus:[resultDic objectForKey:@"content"] andState:3 andLifeStyle:habit];
            NSInteger  noCorrect = [self theNumberOfExecutionStatus:[resultDic objectForKey:@"content"] andState:2 andLifeStyle:habit];
            
            XKRWHabitChangeCell *habitChangeCell = LOAD_VIEW_FROM_BUNDLE(@"XKRWHabitChangeCell");
            habitChangeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            habitChangeCell.perfectExecutionLabel.text = [NSString stringWithFormat:@"%ld",(long)perfect];
            habitChangeCell.doOtherLabel.text = [NSString stringWithFormat:@"%ld",(long)oneStep];
            habitChangeCell.lazyLabel.text = [NSString stringWithFormat:@"%ld",(long)noCorrect];
            
            [self setEverydayExecuteState:habitArrays DataType:sevenDay lifeStyle:habit inView:habitChangeCell.detailChangehabitView];
            
            return habitChangeCell;
        }
    }else{
        if (indexPath.section == 0) {
            NSArray *weightArray = [[XKRWRecordService4_0 sharedService]getWeightRecordNumberOfDays:30];
            
            static NSString *identifier = @"weightCell";
            
            XKRWCourseWeightCell *weightCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!weightNib) {
                weightNib = [UINib nibWithNibName:@"XKRWCourseWeightCell" bundle:nil];
                 [tableView registerNib:weightNib forCellReuseIdentifier:identifier];
                
                weightCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                weightCell.weightDescriptionLabel.text = [self userLoseWeightState];
                weightCell.dataTypeImageView.image = [UIImage imageNamed:@"progress_habit_30day_640"];
                [self setEverydayExecuteState:weightArray DataType:thirtyDay lifeStyle:weight inView:weightCell.pointView];
                weightCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return weightCell;
        }else if (indexPath.section == 1){
            
            static NSString *identifier = @"dietCell";
            
            XKRWCourseDietAndSportCell *dietCell =  [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!dietNib) {
                NSArray *dietArrays = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:30 withType:RecordTypeBreakfirst];
                NSInteger perfect = [self theNumberOfExecutionStatus:dietArrays andState:1 andLifeStyle:diet];
                NSInteger other = [self theNumberOfExecutionStatus:dietArrays andState:3 andLifeStyle:diet];
                NSInteger lazy  = [self theNumberOfExecutionStatus:dietArrays andState:2 andLifeStyle:diet];
                
                dietNib = [UINib nibWithNibName:@"XKRWCourseDietAndSportCell" bundle:nil];
                [tableView registerNib:dietNib forCellReuseIdentifier:identifier];
                
                dietCell =  [tableView dequeueReusableCellWithIdentifier:identifier];
                
                dietCell.titleLabel.text = @"饮食摄入";
                dietCell.dietAndSportImageView.image = [UIImage imageNamed:@"progress_diet_emblem_640"];
                dietCell.perfectExecutionLabel.text = [NSString stringWithFormat:@"%ld",(long)perfect];
                dietCell.lazyLabel.text = [NSString stringWithFormat:@"%ld",(long)lazy];
                dietCell.doOtherLabel.text = [NSString stringWithFormat:@"%ld",(long)other];
                dietCell.selectionStyle = UITableViewCellSelectionStyleNone;
                dietCell.dietAndSportDetailImageView.image = [UIImage imageNamed:@"progress_statistics_30day_640"];
                dietCell.dietAndSportDetailImageViewConstraint.constant = 110.5;
                
                [self setEverydayExecuteState:dietArrays DataType:thirtyDay lifeStyle:diet inView:dietCell. dietAndSportDetailImageView];
            }
            return dietCell;
        }else if (indexPath.section == 2){
            
            static NSString *identifier = @"sportCell";
            XKRWCourseDietAndSportCell *sportCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!sportNib) {
                NSArray *sportArrays = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:30 withType:RecordTypeSport];
                NSInteger perfect = [self theNumberOfExecutionStatus:sportArrays andState:1 andLifeStyle:sport];
                NSInteger other = [self theNumberOfExecutionStatus:sportArrays andState:3 andLifeStyle:sport];
                NSInteger lazy  = [self theNumberOfExecutionStatus:sportArrays andState:2 andLifeStyle:sport];
                sportNib = [UINib nibWithNibName:@"XKRWCourseDietAndSportCell" bundle:nil];
                [tableView registerNib:sportNib forCellReuseIdentifier:identifier];
                sportCell =  [tableView dequeueReusableCellWithIdentifier:identifier];
                
                sportCell.titleLabel.text = @"运动消耗";
                sportCell.dietAndSportImageView.image = [UIImage imageNamed:@"progress_sport_emblem_640"];
                sportCell.dietAndSportDetailImageView.image = [UIImage imageNamed:@"progress_statistics_30day_640"];
                sportCell.dietAndSportDetailImageViewConstraint.constant = 110.5;
                sportCell.selectionStyle = UITableViewCellSelectionStyleNone;
                sportCell.perfectExecutionLabel.text = [NSString stringWithFormat:@"%ld",(long)perfect];
                sportCell.lazyLabel.text = [NSString stringWithFormat:@"%ld",(long)lazy];
                sportCell.doOtherLabel.text = [NSString stringWithFormat:@"%ld",(long)other];
                
                [self setEverydayExecuteState:sportArrays DataType:thirtyDay lifeStyle:sport inView:sportCell.dietAndSportDetailImageView];
                
            }
            return sportCell;
        }else {
            
            static NSString *identifier = @"habitCell";
            XKRWHabitChangeCell *habitChangeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!habitNib) {
                
                NSDictionary *resultDic =   [[XKRWRecordService4_0 sharedService]getHabitInfoWithDays:30];
                NSArray *habitArrays = nil;
                
                if (resultDic != nil) {
                    habitArrays = @[[resultDic objectForKey:@"content"],[resultDic objectForKey:@"count"]];
                }
                
                NSInteger  perfect =   [self theNumberOfExecutionStatus:[resultDic objectForKey:@"content"] andState:1 andLifeStyle:habit];
                NSInteger  oneStep =    [self theNumberOfExecutionStatus:[resultDic objectForKey:@"content"] andState:3 andLifeStyle:habit];
                NSInteger  noCorrect = [self theNumberOfExecutionStatus:[resultDic objectForKey:@"content"] andState:2 andLifeStyle:habit];
                
                habitNib = [UINib nibWithNibName:@"XKRWHabitChangeCell" bundle:nil];
                [tableView registerNib:habitNib forCellReuseIdentifier:identifier];
                habitChangeCell =  [tableView dequeueReusableCellWithIdentifier:identifier];
                
                habitChangeCell.selectionStyle = UITableViewCellSelectionStyleNone;
                habitChangeCell.dateTypeImageView.image = [UIImage imageNamed:@"progress_habit_30day_640"];
                habitChangeCell.perfectExecutionLabel.text = [NSString stringWithFormat:@"%ld",(long)perfect];
                habitChangeCell.doOtherLabel.text = [NSString stringWithFormat:@"%ld",(long)oneStep];
                habitChangeCell.lazyLabel.text = [NSString stringWithFormat:@"%ld",(long)noCorrect];
                [self setEverydayExecuteState:habitArrays DataType:thirtyDay lifeStyle:habit inView:habitChangeCell.detailChangehabitView];
            }
            return habitChangeCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return XKAppHeight;
    }else if(_segmentedControl.selectedSegmentIndex == 1){
        if (indexPath.section == 0) {
            return 253;
        }else if (indexPath.section ==1)
        {
            return 235;
        }else if (indexPath.section ==2){
            return 235;
        }else{
            NSDictionary *resultDic =   [[XKRWRecordService4_0 sharedService]getHabitInfoWithDays:7];
            NSDictionary *countDic = [resultDic objectForKey:@"count"];
            if (countDic != nil) {
                return 280+35 * countDic.allKeys .count;
            }else{
                return 280;
            }
            
        }
        
    }else{
        if (indexPath.section == 0) {
            return 253;
        }else if (indexPath.section ==1)
        {
            return 290;
        }else if (indexPath.section ==2){
            return 290;
        }else{
            NSDictionary *resultDic =   [[XKRWRecordService4_0 sharedService]getHabitInfoWithDays:30];
            NSDictionary *countDic = [resultDic objectForKey:@"count"];
            if (countDic != nil) {
                return 280+35 * countDic.allKeys .count;
            }else{
                return 280;
            }
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(_segmentedControl.selectedSegmentIndex == 0)
    {
        return 0;
    }else{
        if (section == 3) {
            return 0;
        }
        return 10;
    }
}


- (void)setEverydayExecuteState:(NSArray *) stateArrays DataType:(DateType) datetype lifeStyle:(LifeStyleType)liftStyleType  inView:(UIView *)bgview
{
    XKLog(@"%lu",(unsigned long)stateArrays.count);
    
    if (datetype == sevenDay) {
        if (liftStyleType == diet || liftStyleType == sport) {
            for (int i = 0; i < stateArrays.count; i++) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5.5+38.5*i, 40, 32.5, 4)];
                
                switch ([[stateArrays objectAtIndex:i] integerValue]) {
                    case 0:
                        view.backgroundColor = colorSecondary_e0e0e0;
                        break;
                    case 1:
                        view.backgroundColor = XKMainToneColor_29ccb1;
                        break;
                    case 2:
                        view.backgroundColor = XKWarningColor;
                        break;
                    case 3:
                        view.backgroundColor = XKOrangeColor;
                        break;
                    default:
                        break;
                }
                
                [bgview addSubview:view];
            }
        }else if (liftStyleType == habit){
            [self showImproveHabitInHabitCell:bgview andhabitRecord:[stateArrays objectAtIndex:0] andNumOfImproveHabit:[stateArrays objectAtIndex:1] andDateType:sevenDay];
            
        }else{
            [self drawPointInview:bgview withWeightData:stateArrays withDateType:sevenDay];
        }
    }else if(datetype == thirtyDay){
        if (liftStyleType == diet || liftStyleType == sport) {
            for (int i = 0; i < 10; i++) {
                for (int j= 0; j <3; j++) {
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(4.5+27*i, 31+j*35.5, 23, 4)];
                    switch ([[stateArrays objectAtIndex:i+10*j] integerValue]) {
                        case 0:
                            view.backgroundColor = colorSecondary_e0e0e0;
                            break;
                        case 1:
                            view.backgroundColor = XKMainToneColor_29ccb1;
                            break;
                        case 2:
                            view.backgroundColor = XKWarningColor;
                            break;
                        case 3:
                            view.backgroundColor = XKOrangeColor;
                            break;
                        default:
                            break;
                    }
                    [bgview addSubview:view];
                }
            }
        }else if (liftStyleType == habit){
            [self showImproveHabitInHabitCell:bgview andhabitRecord:[stateArrays objectAtIndex:0] andNumOfImproveHabit:[stateArrays objectAtIndex:1] andDateType:thirtyDay];
        }else{
            [self drawPointInview:bgview withWeightData:stateArrays withDateType:thirtyDay];
            
        }
    }
}

//对体重进行一个排序
- (NSMutableArray *)weightDateSort:(NSMutableArray *)array
{
    for (int i =0; i < array.count-1; i++) {
        for (int j =i+1; j< array.count; j++) {
            if([[array objectAtIndex:i] floatValue] > [[array objectAtIndex:j] floatValue])
            {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}


- (void )drawPointInview:(UIView *)view withWeightData:(NSArray *)weightArray withDateType:(DateType) dateType
{
    NSMutableArray *sortArray = [self weightDateSort:[NSMutableArray arrayWithArray:weightArray]];
    
    CGFloat maxWeight = [[sortArray lastObject]floatValue];
    CGFloat minWeight = [[sortArray firstObject]floatValue];
    
    NSMutableArray *pointArrays = [NSMutableArray array];
    CGPoint point;
    CGFloat  y;
    CGFloat  x;
    for (int i = 0; i <[weightArray count]; i++) {
        if (dateType == sevenDay) {
            x =   22 + 37.5*i;
        }else{
            x =  22 + 7.5*i;
        }
        if (maxWeight != minWeight) {
            y =  100/(maxWeight - minWeight)*(maxWeight - [weightArray[i]floatValue] );
        }else{
            y =   100/2;
        }
        
        point = CGPointMake(x, y);
        [pointArrays addObject:[NSValue valueWithCGPoint:point]];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint p0 = [pointArrays[0] CGPointValue];
    [path moveToPoint:CGPointMake(p0.x, p0.y)];
    
    for(int i=0;i<pointArrays.count;i++) {
        CGPoint p = [[pointArrays objectAtIndex:i] CGPointValue];
        [path addLineToPoint:p];
    }
    CGPoint lastP = [[pointArrays lastObject] CGPointValue];
    [path addLineToPoint:CGPointMake(lastP.x, lastP.y)];
    
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = view.bounds;
    pathLayer.bounds = view.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = XKMainSchemeColor.CGColor;//粗线的颜色
    pathLayer.fillColor = nil;
    if (dateType == sevenDay) {
        pathLayer.lineWidth = 2;
    }else{
        pathLayer.lineWidth = 1;
    }
    pathLayer.lineJoin = kCALineJoinRound;
    [view.layer addSublayer:pathLayer];
    
    //添加圆图标
    for(int i=0;i<pointArrays.count;i++){
        
        CGPoint point = [[pointArrays objectAtIndex:i] CGPointValue];
        
        if (i == 0 ) {
            [self showWeightAndLine:[weightArray objectAtIndex:i] andPoint:point inView:view andShowlineUp:YES andDateType:dateType];
        }else if ( i == pointArrays.count-1){
            [self showWeightAndLine:[weightArray objectAtIndex:i] andPoint:point inView:view andShowlineUp:NO andDateType:dateType];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (dateType == sevenDay) {
            btn.frame = CGRectMake(0, 0, 12, 12) ;
            [btn setImage:[UIImage imageNamed:@"girth_btn_point_mark_640"] forState:UIControlStateNormal];
        }else{
            btn.frame = CGRectMake(0, 0, 4, 4) ;
            [btn setBackgroundImage:[UIImage imageNamed:@"progress_weight_point_30day_640"] forState:UIControlStateNormal];
        }
        btn.center = point;
        [view addSubview:btn];
    }
}

- (void)showWeightAndLine:(NSString *)weight andPoint:(CGPoint)point inView:(UIView *)view andShowlineUp:(BOOL) up andDateType:(DateType )datatype
{   UILabel *label =[[UILabel alloc]init];
    if (up) {
        if (datatype == sevenDay) {
            label.frame = CGRectMake(point.x-20, point.y-22, 50, 20);
        }else{
            label.frame = CGRectMake(point.x-20, point.y-18, 50, 20);
        }
    }else{
        if (datatype == sevenDay) {
            label.frame = CGRectMake(point.x-20, point.y+4, 50, 20);
        }else{
            label.frame = CGRectMake(point.x-20, point.y, 50, 20);
        }
    }
    label.text = [NSString stringWithFormat:@"%@kg",weight];
    label.textColor = XK_ASSIST_TEXT_COLOR;
    label.font = XKDefaultFontWithSize(12.f);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, point.y, view.width, 1)];
    lineImageView.image = [UIImage imageNamed:@"progress_line_640"];
    [view addSubview:lineImageView];
}

- (NSInteger)theNumberOfExecutionStatus:(NSArray *)array andState:(NSInteger) state andLifeStyle:(LifeStyleType) lifeStyleType
{
    NSInteger num = 0;
    
    if (lifeStyleType != habit) {
        for (int i = 0; i < [array count]; i++) {
            if ([[array objectAtIndex:i]integerValue] == state) {
                num ++;
            }
        }
    }else{
        
        for (int i = 0; i <[array count]; i++) {
            if (state == 2) {
                if ([[[array objectAtIndex:i] objectForKey:@"amended"] integerValue] == 0 &&[[[array objectAtIndex:i] objectForKey:@"all"] integerValue] != 0) {
                    num ++;
                }
            }else if (state == 3)
            {
                if ([[[array objectAtIndex:i] objectForKey:@"amended"] integerValue] != 0 && [[[array objectAtIndex:i] objectForKey:@"amended"] integerValue] != [[[array objectAtIndex:i] objectForKey:@"all"] integerValue]) {
                    num ++;
                }
            }else{
                if ([[[array objectAtIndex:i] objectForKey:@"amended"] integerValue] == [[[array objectAtIndex:i] objectForKey:@"all"] integerValue]) {
                    num++;
                }
            }
        }
    }
    
    return num;
}

- (NSString *)userLoseWeightState
{
    //当前体重
    NSInteger  currentWeight = [[XKRWUserService sharedService]getCurrentWeight];
    //初始体重
    NSInteger  origWeight   = [[XKRWUserService sharedService]getUserOrigWeight];
    //目标体重
    NSInteger  destiWeight   = [[XKRWUserService sharedService] getUserDestiWeight];
    
    NSInteger  haveLoseWeight = origWeight - currentWeight;
    
    NSInteger  targetLoseWeight = origWeight - destiWeight;
    
    return [NSString stringWithFormat:@"减重 %@ kg,完成任务的%@%%",[NSString stringWithFormat:@"%.1f",haveLoseWeight/1000.f],[NSString stringWithFormat:@"%d",(int)(100*(haveLoseWeight/(CGFloat)targetLoseWeight))]];
}

- (void)showImproveHabitInHabitCell:(UIView *)bgview andhabitRecord:(NSArray *)habitArrays andNumOfImproveHabit:(NSDictionary *) numDic andDateType:(DateType) dateType{
    
    UIView *view;
    for (int i = 0; i <habitArrays.count; i++) {
        NSDictionary *dic = [habitArrays objectAtIndex:i];
        CGFloat all = [[dic objectForKey:@"all"] floatValue];
        CGFloat amended =[[dic objectForKey:@"amended"] floatValue];
        
        if (amended != 0 && all != 0) {
            if (dateType == sevenDay) {
                view = [[UIView alloc]initWithFrame:CGRectMake(14.5+38*i, (110-(int)110*(amended/all)), 18, (int)110*(amended/all))];
            }else{
                view = [[UIView alloc]initWithFrame:CGRectMake(12+8.5*i, (110-(int)110*(amended/all)), 7, (int)110*(amended/all))];
            }
            
            
            if (amended == all) {
                view.backgroundColor = XKMainToneColor_29ccb1;
            }else{
                view.backgroundColor = XKOrangeColor;
            }
            
        }else if (amended == 0 && all == 0)
        {
            if (dateType == sevenDay) {
                view = [[UIView alloc]initWithFrame:CGRectMake(14.5+38*i, 0, 18, 110)];
            }else{
                view = [[UIView alloc]initWithFrame:CGRectMake(12+8.5*i, 0, 7, 110)];
            }
            view.backgroundColor = XKMainToneColor_29ccb1;

        }
        else{
            if (dateType == sevenDay) {
                view = [[UIView alloc]initWithFrame:CGRectMake(14.5+38*i, (110-5), 18, 5)];
            }else{
                view = [[UIView alloc]initWithFrame:CGRectMake(12+8.5*i, (110-5), 7, 5)];
            }
            view.backgroundColor = XKWarningColor;
        }
        
        [bgview addSubview:view];
    }
    
    
    
    
    if ([numDic.allKeys count] != 0) {
        
        int  current = 0;
        UIView *showView;
        for ( NSNumber *key  in numDic.allKeys) {
            NSString *name = nil;
            NSInteger times = 0;
            switch ([key intValue]) {
                case 1:
                    name = @"饮食油腻";
                    break;
                case 2:
                    name = @"吃零食";
                    break;
                case 3:
                    name = @"喝饮料";
                    break;
                case 4:
                    name = @"饮酒";
                    break;
                case 5:
                    name = @"饮酒";
                    break;
                case 6:
                    name = @"饮酒";
                    break;
                case 7:
                    name = @"吃肥肉";
                    break;
                case 8:
                    name = @"吃坚果";
                    break;
                case 9:
                    name = @"吃宵夜";
                    break;
                case 10:
                    name = @"吃饭晚";
                    break;
                case 11:
                    name = @"吃饭快";
                    break;
                case 12:
                    name = @"饮食不规律";
                    break;
                case 13:
                    name = @"活动量小";
                    break;
                case 14:
                    name = @"缺乏锻炼";
                    break;
                default:
                    break;
            }
            
            times = [[numDic objectForKey:key] integerValue];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 250+33*current, 100, 26)];
            nameLabel.text = name;
            nameLabel.textColor = colorSecondary_666666;
            nameLabel.font = XKDefaultFontWithSize(13.f);
            
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake((XKAppWidth-100-35), 250+33*current, 100, 26)];
            timeLabel.text = [NSString stringWithFormat:@"%ld次",(long)times];
            timeLabel.textAlignment = NSTextAlignmentRight;
            timeLabel.textColor = colorSecondary_666666;
            timeLabel.font = XKDefaultFontWithSize(13.f);
            
            UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(35, nameLabel.bottom, XKAppWidth-70, 7)];
            grayView.backgroundColor = colorSecondary_e0e0e0;
            
            if (dateType == sevenDay) {
                showView = [[UIView alloc]initWithFrame:CGRectMake(35, nameLabel.bottom, (XKAppWidth-70)*(times/7.0), 7)];
            }else{
                showView = [[UIView alloc]initWithFrame:CGRectMake(35, nameLabel.bottom, (XKAppWidth-70)*(times/30.0), 7)];
            }
            
            showView.backgroundColor = XKMainToneColor_29ccb1;
            
            [bgview.superview addSubview:nameLabel];
            [bgview.superview addSubview:timeLabel];
            [bgview.superview addSubview:grayView];
            [bgview.superview addSubview:showView];
            current++;
        }
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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
