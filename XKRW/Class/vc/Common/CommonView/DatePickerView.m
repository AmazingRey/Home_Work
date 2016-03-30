//
//  DatePickerView.m
//  XKRW
//
//  Created by XiKang on 14-11-4.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "DatePickerView.h"
#import "XKRWRecordCircumferenceEntity.h"
#import "XKRWCheckButtonView/XKRWCheckButtonView.h"

@interface DatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    NSMutableArray *_dataSource;
    NSMutableString *_selectedHour;
    NSMutableString *_selectedMinitus;
    UIButton *_button;
    id _currentDisplay;
}

@property (nonatomic, strong) XKRWCheckButtonView *checkView;

@end

@implementation DatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - initialize

- (void)initSubviewsWithStyle:(DatePickerStyle)style andObj:(id)obj
{
    _currentDisplay = obj;
    self.style = style;
    [self.confirmButton setTitleColor:XK_ASSIST_TEXT_COLOR forState:UIControlStateDisabled];
    
    self.width = XKAppWidth;
    [self initDataSource];
}

- (void)initSubviewsWithStyle:(DatePickerStyle)style andDatasource:(NSArray *)datasource andObj:(NSString *)obj {
    self.style = style;
    _currentDisplay = obj;
    
    _dataSource = [NSMutableArray arrayWithArray:@[datasource]];
    
    self.width = XKAppWidth;
    [self initDataSource];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)initDataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    if (self.style == DatePickerStyleGetUpTimePicker) {
        /**
         *  起床时间时的样式
         */
        _dataSource = [NSMutableArray arrayWithObjects:@[@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23",@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23",@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23"], nil];
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < 3 ; j++) {

        for (int i = 0; i < 60; i ++) {
            if (i < 10) {
                [array addObject:[NSString stringWithFormat:@"0%d", i]];
            } else {
                [array addObject:[NSString stringWithFormat:@"%2d", i]];
            }
        }
        }
        [_dataSource addObject:array];
        
        self.titleLabel.text = @"起床时间";
        
        int row_1 = 8;
        int row_2 = 0;
        if (_currentDisplay && [_currentDisplay isKindOfClass:[NSString class]]) {
            NSArray *sep = [(NSString *)_currentDisplay componentsSeparatedByString:@":"];
            row_1 = [sep[0] intValue];
            row_2 = [sep[1] intValue];
        }
        [self.timePicker selectRow:row_1+24 inComponent:0 animated:NO];
        [self.timePicker selectRow:row_2+60 inComponent:1 animated:NO];
        _selectedHour = [NSMutableString stringWithString:_dataSource[0][row_1+24]];
        _selectedMinitus = [NSMutableString stringWithString:_dataSource[1][row_2+60]];
        
    } else if (self.style == DatePickerStyleSleepTimePicker) {
        /**
         *  睡觉时长
         */
        _dataSource = [NSMutableArray arrayWithObjects:@[@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23"], @[@".0", @".5"], nil];
        
        int row_0 = 8;
        int row_1 = 0;
        if (_currentDisplay && [_currentDisplay isKindOfClass:[NSString class]]) {
            
            NSArray *separate = [_currentDisplay componentsSeparatedByString:@"."];
            if ([separate[0] intValue] > 0) {
                row_0 = [separate[0] intValue];
            }
            if ([separate[1] intValue] >= 5) {
                row_1 = 1;
            }
        }
        
        _selectedHour = [NSMutableString stringWithString:_dataSource[0][row_0]];
        _selectedMinitus = [NSMutableString stringWithString:_dataSource[1][row_1]];
        
        self.titleLabel.text = @"睡眠时长";
        
        [self.timePicker selectRow:row_0 inComponent:0 animated:NO];
        [self.timePicker selectRow:row_1 inComponent:1 animated:NO];
        
    } else if (self.style == DatePickerStyleWeightReocrd) {
        /**
         *  体重
         */
        NSMutableArray *array = [NSMutableArray array];
        int beginWeight = 40;
        if ([[XKRWUserService sharedService] getAge] < 18) {
            beginWeight = 20;
        }
        
        for (int i = beginWeight; i <= 199; i ++) {
            [array addObject:[NSString stringWithFormat:@"%d", i]];
        }
        [_dataSource addObject:array];
        
        array = [NSMutableArray array];
        for (int i = 0; i <= 9; i ++) {
            [array addObject:[NSString stringWithFormat:@".%d", i]];
        }
        [_dataSource addObject:array];
        int row_0 = 0;
        int row_1 = 0;
        if (_currentDisplay && [_currentDisplay isKindOfClass:[NSString class]]) {
            
            NSArray *separate = [_currentDisplay componentsSeparatedByString:@"."];
            if ([separate[0] intValue] >= beginWeight) {
                row_0 = [separate[0] intValue] - beginWeight;
            }
            row_1 = [separate[1] intValue];
        }
        
        _selectedHour = _dataSource[0][row_0];
        _selectedMinitus = _dataSource[1][row_1];
        
        self.titleLabel.text = @"体重";
        [self.timePicker selectRow:row_0 inComponent:0 animated:NO];
        [self.timePicker selectRow:row_1 inComponent:1 animated:NO];
        
    } else if (self.style == DatePickerStyleAlertType) {
        /**
         *  闹钟提醒项目
         */
        if ([_currentDisplay isKindOfClass:[NSArray class]]) {
            [_dataSource addObject:_currentDisplay];
        }
        self.titleLabel.text = @"提醒项目";
        _selectedHour = _dataSource[0][0];
        
        
    } else if (self.style == DatePickerStyleWeekdayPicker) {
        /**
         *  多选框
         */
        self.timePicker.delegate = nil;
        [self.timePicker removeFromSuperview];
        
        int weekdays = [_currentDisplay[@"Days_of_week"] intValue];
        
        self.checkView =
        [[XKRWCheckButtonView alloc] initWithFrame:CGRectMake(60.f, 15.f, 200.f, 1.f)
                                     andTitleArray:_currentDisplay[@"String_array"]
                          andCurrentSelectedButton:weekdays
                                          andStyle:XKRWCheckButtonViewStyleWeekdayPicker
                                      returnHeight:^(CGFloat height) {
                                          
                                      } clickButton:^(NSInteger index) {
                                          
                                      }];
        [self.contentView addSubview:self.checkView];
        
        self.selectedDate = [NSMutableString stringWithFormat:@"%d", weekdays];
        
    } else if (self.style == DatePickerStyleSchemeDifficulty) {
        /**
         *  设置页方案难度修改
         */
        self.timePicker.delegate = self;
        
    } else if (self.style == DatePickerStyleSinglePicker) {
        /**
         *  单列选择
         */
        NSInteger index = 0;
        BOOL flag = NO;
        for (NSString *str in _dataSource[0]) {
            if ([str isEqualToString:_currentDisplay]) {
                flag = YES;
                break;
            }
            index ++;
        }
        if (flag) {
            [self.timePicker selectRow:index inComponent:0 animated:NO];
            _selectedHour = _currentDisplay;
        } else {
            _selectedHour = _dataSource[0][0];
        }
        _selectedMinitus = [NSMutableString stringWithString:@""];
        
        [self setTitle:self.identifier];
        
    } else {
        /**
         *  围度
         */
        self.titleLabel.text = self.identifier;
        
        int row_0 = 0;
        int row_1 = 0;
        if (_currentDisplay && [_currentDisplay isKindOfClass:[XKRWRecordCircumferenceEntity class]]) {
            
            int temp = 0;
            
            if ([self.identifier isEqualToString:@"腰围"]) {
                
                [self createDatasourceWithRangeOfMax:150 min:40];
                temp = [(XKRWRecordCircumferenceEntity *)_currentDisplay waistline];
                
                if (temp > 0 && temp < 1500) {
                    row_0 = (int)temp / 10 - 40;
                    row_1 = temp % 10;
                }
            } else if ([self.identifier isEqualToString:@"胸围"]) {
                
                [self createDatasourceWithRangeOfMax:150 min:40];
                temp = [(XKRWRecordCircumferenceEntity *)_currentDisplay bust];
                if (temp > 0 && temp < 1500) {
                    row_0 = (int)temp / 10 - 40;
                    row_1 = temp % 10;
                }
            } else if ([self.identifier isEqualToString:@"臀围"]) {
                
                [self createDatasourceWithRangeOfMax:150 min:40];
                temp = [(XKRWRecordCircumferenceEntity *)_currentDisplay hipline];
                if (temp > 0 && temp < 1500) {
                    row_0 = (int)temp / 10 - 40;
                    row_1 = temp % 10;
                }
            } else if ([self.identifier isEqualToString:@"臂围"]) {
                
                [self createDatasourceWithRangeOfMax:50 min:10];
                temp = [(XKRWRecordCircumferenceEntity *)_currentDisplay arm];
                if (temp > 0 && temp < 500) {
                    row_0 = (int)temp / 10 - 10;
                    row_1 = temp % 10;
                }
            } else if ([self.identifier isEqualToString:@"大腿围"]) {
                
                [self createDatasourceWithRangeOfMax:80 min:20];
                temp = [(XKRWRecordCircumferenceEntity *)_currentDisplay thigh];
                if (temp > 0 && temp < 800) {
                    row_0 = (int)temp / 10 - 20;
                    row_1 = temp % 10;
                }
            } else if ([self.identifier isEqualToString:@"小腿围"]) {
                
                [self createDatasourceWithRangeOfMax:80 min:10];
                temp = [(XKRWRecordCircumferenceEntity *)_currentDisplay shank];
                if (temp > 0 && temp < 800) {
                    row_0 = (int)temp / 10 - 10;
                    row_1 = temp % 10;
                }
            }
        }
        _selectedHour = _dataSource[0][row_0];
        _selectedMinitus = _dataSource[1][row_1];
        
        [self.timePicker selectRow:row_0 inComponent:0 animated:NO];
        [self.timePicker selectRow:row_1 inComponent:1 animated:NO];
    }
    
    if (self.style == DatePickerstyleOrderPicker)
    {
//        self.titleLabel.text = @"订单";
    }
}

- (void)createDatasourceWithRangeOfMax:(int)max min:(int)min
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = min; i <= max - 1; i ++) {
        [array addObject:[NSString stringWithFormat:@"%d", i]];
    }
    [_dataSource addObject:array];
    
    array = [NSMutableArray array];
    for (int i = 0; i <= 9; i ++) {
        [array addObject:[NSString stringWithFormat:@".%d", i]];
    }
    [_dataSource addObject:array];
}

#pragma mark - Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.style == DatePickerStyleAlertType ||
        self.style == DatePickerStyleWeekdayPicker ||
        self.style == DatePickerStyleSinglePicker) {
        return 1;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ((NSArray *)_dataSource[component]).count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.style == DatePickerStyleGetUpTimePicker && component == 0 && (row == 11 || row == 59)) {
        [pickerView selectRow:38 inComponent:0 animated:NO];
        if (row == 59) {
            [pickerView selectRow:32 inComponent:0 animated:NO];
        }
    }
    
    if (self.style == DatePickerStyleGetUpTimePicker && component == 1 && (row == 26 || row == 152)) {
        [pickerView selectRow:89 inComponent:1 animated:NO];
    }
    
    return _dataSource[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (component == 0) {
        _selectedHour = [NSMutableString stringWithString:_dataSource[component][row]];
    } else if (component == 1) {
        _selectedMinitus = [NSMutableString stringWithString:_dataSource[component][row]];
    }

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 43.f;
    
}

#pragma mark - click actions

- (IBAction)clickClearButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickCancelButton:)]) {
        [self.delegate clickCancelButton:self];
    }
    [self removeTransparentButton:_button];
}

- (IBAction)clickConfirmButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickConfirmButton:postSelected:)]) {
        [self.delegate clickConfirmButton:self
                             postSelected:[self getSelectedDateString]];
    }
    [self removeTransparentButton:_button];
}

#pragma mark - other functions

- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect = self.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.frame = rect;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) {
            [super removeFromSuperview];
        }
    }];
}

- (void)addToWindow
{
    __block CGRect rect = self.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.frame = rect;
    self.alpha = 0.f;
    
    [self addTransparentButton];
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
    UIWindow *keywWindow = [UIApplication sharedApplication].keyWindow;
    if (keywWindow && self) {
        [keywWindow addSubview:self];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        rect = self.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height - rect.size.height;
        self.frame = rect;
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (NSString *)getSelectedDateString
{
    if (self.style == DatePickerStyleWeekdayPicker) {
      
        self.selectedDate = [NSMutableString stringWithFormat:@"%d", [self.checkView getAllButtonState]];
        
    } else if (self.style == DatePickerStyleGetUpTimePicker) {
        self.selectedDate = [NSMutableString stringWithFormat:@"%@:%@", _selectedHour, _selectedMinitus];
        
    } else if (self.style == DatePickerStyleAlertType) {
        
        return _selectedHour;
    } else {
        self.selectedDate = [NSMutableString stringWithFormat:@"%@%@", _selectedHour, _selectedMinitus];
    }
    return self.selectedDate;
}

- (void)addTransparentButton
{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _button.backgroundColor = [UIColor blackColor];
        [_button addTarget:self action:@selector(removeTransparentButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    _button.alpha = 0.f;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_button];
    
    [UIView animateWithDuration:0.3 animations:^{
        _button.alpha = 0.3f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeTransparentButton:(UIButton *)button
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _button.alpha = 0.f;
                     }
                     completion:^(BOOL finished) {
                         [button removeFromSuperview];
                     }];
    [self removeFromSuperview];
}

@end
