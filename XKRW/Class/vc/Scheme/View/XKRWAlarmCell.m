//
//  XKRWAlarmCell.m
//  XKRW
//
//  Created by Jack on 15/7/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWAlarmCell.h"
#define kButtonWidth (XKAppWidth-20)/7
@implementation XKRWAlarmCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _weekdayTitleArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        _selectedDate = [[NSMutableString alloc] init];
        [self initAlarmCell];
    }
    return self;
}

-(void)initAlarmCell{
    _mealLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 22)];
    _mealLabel.textColor = XKMainSchemeColor;
    _mealLabel.font = XKDefaultFontWithSize(17);
    [self.contentView addSubview:_mealLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, 80, 29)];
    _timeLabel.font = XKDefaultFontWithSize(29);
    _timeLabel.textColor = XK_ASSIST_TEXT_COLOR;
    [self.contentView addSubview:_timeLabel];
    
    _editTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editTimeBtn.frame = CGRectMake(_timeLabel.right, _timeLabel.top, 29, 29);
    [_editTimeBtn setImage:[UIImage imageNamed:@"alarm_btn_edit_640"] forState:UIControlStateNormal];
    [self.contentView addSubview:_editTimeBtn];
    
    _alarmSwitch = [[UISwitch alloc] init];
    _alarmSwitch.topRight = CGPointMake(XKAppWidth - 15.f, 7.f);
    [_alarmSwitch setOnTintColor:XKMainSchemeColor];
    [self.contentView addSubview:_alarmSwitch];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 114-0.5, XKAppWidth, 0.5)];
    line.backgroundColor = XK_ASSIST_LINE_COLOR;
    [self.contentView addSubview:line];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
