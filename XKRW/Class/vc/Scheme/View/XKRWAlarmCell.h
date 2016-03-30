//
//  XKRWAlarmCell.h
//  XKRW
//
//  Created by Jack on 15/7/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWCheckButtonView.h"
#import "XKRWAlarmEntity.h"
@interface XKRWAlarmCell : UITableViewCell
@property (nonatomic,strong)UILabel *mealLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIButton *editTimeBtn;
@property (nonatomic,strong)UISwitch *alarmSwitch;

@property (nonatomic, strong) XKRWCheckButtonView *checkView;
@property (nonatomic, strong) NSMutableString     *selectedDate;
@property (nonatomic, strong) NSArray *weekdayTitleArray;
@property (nonatomic) NSInteger weekDays;

@property (nonatomic, weak) XKRWAlarmEntity *entity;


@end
