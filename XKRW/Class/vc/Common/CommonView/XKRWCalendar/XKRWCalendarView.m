//
//  XKRWCalendarView.m
//  XKRW
//
//  Created by XiKang on 14-11-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWCalendarView.h"
#import "XKRWCalendarItem.h"
#import "XKRWCalendarHelper.h"
#import "NSDate+XKRWCalendar.h"

@implementation XKRWCalendarView
{
    NSInteger _numberOfDayInMonth;
    NSInteger _weekday;

    NSInteger _numberOfLine;
    CGFloat _originalY;
    
    NSMutableArray *_itemArray;
    void (^_clickBlock)(NSDate *, BOOL outOfMonth);
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0.f, 0.f, XKAppWidth, 150.f);
        _originalY = 0.f;
        self.backgroundColor = [UIColor whiteColor];
        _itemArray = [NSMutableArray array];
        self.type = XKRWCalendarTypeMonth;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date
             recordDateArray:(NSArray *)dateArray
                returnHeight:(void (^)(CGFloat height))block
           calendarMonthType:(XKRWCalendarMonthType )monthType
              clickDateBlock:(void (^)(NSDate *date, BOOL outOfMonth))block2;
{
    self = [self init];
    self.recordDateArray = dateArray;
    self.monthType = monthType;
    [self initCalendarItemsWithDate:date clickDateBlock:block2];
     CGRect rect = self.frame;
    if(monthType == XKRWCalendarTypeStrongMonth){
        block(_numberOfLine * 70.f);
        rect.size.height = _numberOfLine * 70.f;
    }else{
        block(_numberOfLine * 30.f);
        rect.size.height = _numberOfLine * 30.f;
    }
    
   
    
    self.frame = rect;
    
    return self;
}
/**
 *  重置方法，仅在Type为Month时使用
 *
 *  @param date  重置之后的月份
 *  @param block 返回高度及相应相应方法
 */
- (void)resetWithDate:(NSDate *)date returnHeight:(void (^)(CGFloat height))block
{
//    [self removeAllItems];
//    [self initCalendarItemsWithDate:date clickDateBlock:nil];
    
    self.date = date;
    BOOL flag = NO;
    if ([self.date isMonthEqualToDate:[NSDate date]]) {
        flag = YES;
    }
    _numberOfDayInMonth = [date numberOfDaysInMonth];
    _numberOfLine = 1;
    _weekday = [date firstWeekDayInMonth];
    
    __block NSInteger day = 1;
    __block NSInteger offset = day - _weekday;
    
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        XKRWCalendarItem *item = (XKRWCalendarItem *)obj;
        BOOL isToday = NO;
        if (flag) {
            if (day == [NSDate date].day) {
                isToday = YES;
            }
        }
        if ((idx + 1) >= _weekday && day <= _numberOfDayInMonth) {
            NSDate *itemDate = [[date firstDayInMonth] offsetDay:day - 1];
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            item.tag = day;
            item.date = date;
            [item setDay:[NSString stringWithFormat:@"%d", (int)day]
              outOfMonth:NO
                 isToday:isToday
                isRecord:isRecord];
            
            day ++;
            if (item.hidden == YES) {
//                [item setHidden:NO withAnimation:YES];
            }
        } else {
            NSDate *itemDate = [[date firstDayInMonth] offsetDay:offset];
            if ([itemDate isDayEqualToDate:[NSDate date]]) {
                isToday = YES;
            }
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            item.tag = [[date firstDayInMonth] offsetDay:offset].day + 100;
            item.date = date;
            [item setDay:[NSString stringWithFormat:@"%ld", (long)[[date firstDayInMonth] offsetDay:offset].day]
              outOfMonth:YES
                 isToday:isToday
                isRecord:isRecord];
            
            
//            [item setHidden:YES withAnimation:YES];
        }
        offset ++;
        if (item.isSelected) {
            [item setSelected:NO];
        }
    }];
    
    if ((_numberOfDayInMonth - (8 - _weekday)) % 7) {
        _numberOfLine = (_numberOfDayInMonth - (8 - _weekday)) / 7 + 2;
    } else {
        _numberOfLine = (_numberOfDayInMonth - (8 - _weekday)) / 7 + 1;
    }
    
    if ([date isMonthEqualToDate:self.selectedDay]) {
        [self setDateSelected:self.selectedDay];
        self.currentLine = [self.selectedDay weekOfMonth];
    } else if ([self.selectedDay isWeekEqualToDate:[date firstDayInMonth]] ||
               [self.selectedDay isWeekEqualToDate:[date lastDayInMonth]]) {
        
        XKRWCalendarItem *item = (XKRWCalendarItem *)[self viewWithTag:100 + self.selectedDay.day];
        [item setSelected:YES];
    } else {
        self.currentLine = 1;
    }
    
    
    CGRect rect = self.frame;
    if(_monthType == XKRWCalendarTypeStrongMonth){
        if (block) {
            block(_numberOfLine * 70.f);
        }
        rect.size.height = _numberOfLine * 70.f;
    }else{
        if (block) {
            block(_numberOfLine * 30.f);
        }
        rect.size.height = _numberOfLine * 30.f;
    }
    self.frame = rect;
}
/**
 *  按月显示时初始化方法
 *
 *  @param date  显示月份
 *  @param block 点击item时触发响应事件
 */
- (void)initCalendarItemsWithDate:(NSDate *)date clickDateBlock:(void (^)(NSDate *date, BOOL outOfMonth))block
{
    self.date = date;
    BOOL flag = NO;
    if ([self.date isMonthEqualToDate:[NSDate date]]) {
        flag = YES;
    }
    
    if (!_clickBlock) {
        _clickBlock = block;
    }

    CGFloat _xPoint = 15.f, _yPoint = 0.f;
    
    if (_monthType == XKRWCalendarTypeStrongMonth) {
        UIView  *lineView  =[[UIView alloc]initWithFrame:CGRectMake(0, 69, XKAppWidth, 1)];
        lineView.backgroundColor = XK_ASSIST_LINE_COLOR;
        [self addSubview:lineView];
    }
    
    _numberOfDayInMonth = [date numberOfDaysInMonth];
    _numberOfLine = 1;
    _weekday = [date firstWeekDayInMonth];
    
    NSInteger day = 1;
    NSInteger offset = day - _weekday;

    for (int i = 1; i <= 42; i ++) {
        if (_xPoint > XKAppWidth - 15.f - ITEM_WIDTH / 2) {
            _xPoint = 15.f;
            if(_monthType == XKRWCalendarTypeStrongMonth){
                _yPoint += 70.f;
                UIView  *lineView  = [[UIView alloc] init];
                lineView.backgroundColor = XK_ASSIST_LINE_COLOR;
                lineView.frame = CGRectMake(0, 69 + _yPoint, XKAppWidth, 1);
                [self addSubview:lineView];
            }else{
                _yPoint += 30.f;
            }
            if (day <= _numberOfDayInMonth) {
                _numberOfLine ++;
            }
        }
        BOOL isToday = NO;
        if (flag) {
            if (day == [NSDate date].day) {
                isToday = YES;
            }
        }
        
        XKRWCalendarItem *item =
        [[XKRWCalendarItem alloc] initWithOrigin:CGPointMake(_xPoint, _yPoint)
                                       withTitle:@"-"
                                          record:NO
                                      isSelected:NO
                                      outOfMonth:NO
                                         isToday:NO
                               calendarMonthType:_monthType
                                    onClickBlock:^(XKRWCalendarItem *item) {
                                        if (item.isSelected == NO) {
                                            [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                XKRWCalendarItem *it = (XKRWCalendarItem *)obj;
                                                if (it.tag != item.tag && it.isSelected == YES) {
                                                    [it setSelected:NO];
                                                }
                                            }];
                                            
                                            NSCalendar *cal = [NSCalendar currentCalendar];
                                            NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone fromDate:self.date];
                                            
                                            if (item.outOfMonth) {
                                                [comps setDay:item.tag - 100];
                                                if (comps.day < 8) {
                                                    [comps setMonth:comps.month + 1];
                                                } else {
                                                    [comps setMonth:comps.month - 1];
                                                }
                                                
                                            } else {
                                                [comps setDay:item.tag];
                                            }
                                            [comps setHour:12];
                                            NSDate *clickedDate = [cal dateFromComponents:comps];
                                            _clickBlock(clickedDate, item.outOfMonth);
                                            
                                            self.selectedLine = [clickedDate weekOfMonth];
                                            self.currentLine = self.selectedLine;
                                      
                                        } else {
                                            return;
                                        }
                                    }];
        if (i >= _weekday && day <= _numberOfDayInMonth) {
            NSDate *itemDate = [[date firstDayInMonth] offsetDay:day - 1];
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            item.tag = day;
            item.date = itemDate;
            [item setDay:[NSString stringWithFormat:@"%d", (int)day]
              outOfMonth:NO
                 isToday:isToday
                isRecord:isRecord];
            
            day ++;
        } else {
            NSDate *itemDate = [[date firstDayInMonth] offsetDay:offset];
            if ([itemDate isDayEqualToDate:[NSDate date]]) {
                isToday = YES;
            }
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            item.date = itemDate;
            item.tag = [[date firstDayInMonth] offsetDay:offset].day + 100;
            [item setDay:[NSString stringWithFormat:@"%ld", (long)[[date firstDayInMonth] offsetDay:offset].day]
              outOfMonth:YES
                 isToday:isToday
                isRecord:isRecord];
            
            
            
//            [item setHidden:YES withAnimation:NO];
        }
        offset ++;
        
        [_itemArray addObject:item];
        [self addSubview:item];
        
        _xPoint += ITEM_WIDTH;
    }
}
/**
 *  设置选中的日期
 *
 *  @param date 选中日期
 */
- (void)setDateSelected:(NSDate *)date
{
    self.selectedDay = date;
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XKRWCalendarItem *item = (XKRWCalendarItem *)obj;
        if (item.isSelected) {
            [item setSelected:NO];
        }
    }];
    if (self.type == XKRWCalendarTypeMonth) {
        
        if (![date isMonthEqualToDate:self.date]) {
            self.currentLine = 1;
            return;
        }
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:date];
        XKRWCalendarItem *item = (XKRWCalendarItem *)[self viewWithTag:comps.day];
        
        self.selectedLine = (int)(item.frame.origin.y / 30 + 1);
        self.currentLine = self.selectedLine;
        [item setSelected:YES];
        
    } else {
        
        if (![self.selectedDay isWeekEqualToDate:self.date]) {
            return;
        }
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:date];
        XKRWCalendarItem *item;
        if ([self.selectedDay isMonthEqualToDate:self.date]) {
            item = (XKRWCalendarItem *)[self viewWithTag:comps.day];
            
        } else {
            item = (XKRWCalendarItem *)[self viewWithTag:comps.day + 100];
        }
        self.selectedLine = (int)(item.frame.origin.y / 30 + 1);
        [item setSelected:YES];
    }
}

- (void)removeAllItems
{
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XKRWCalendarItem *item = (XKRWCalendarItem *)obj;
        [item removeFromSuperview];
    }];
    [_itemArray removeAllObjects];
}

#pragma mark - type of week 

- (void)setTypeToWeek
{
    [self resetWeekStyleWithDate:self.selectedDay];
}
/**
 *  scrollview中间视图主要显示的日历
 *
 *  @param date    将要显示的周的日期
 *  @param yesOrNo 是否有动画
 */
- (void)resetWeekStyleAsPrimaryView:(NSDate *)date animation:(BOOL)yesOrNo returnHeight:(void (^)(CGFloat height))block
{
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XKRWCalendarItem *item = (XKRWCalendarItem *)obj;
        if (item.isHidden) {
//            [item setHidden:NO withAnimation:YES];
        }
    }];
    
    if (![date isMonthEqualToDate:self.date]) {
        [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            XKRWCalendarItem *item = (XKRWCalendarItem *)obj;
            if (item.isSelected) {
                [item setSelected:NO];
            }
        }];
        [self resetWithDate:date returnHeight:^(CGFloat height) {
            block(height);
        }];
    }
    self.currentLine = [date weekOfMonth];
    CGFloat offset = [self offsetOfDate:date];
    if (yesOrNo) {
        [UIView animateWithDuration:0.2f animations:^{
            [self offsetYPoint:offset];
        }];
    } else {
        [self offsetYPoint:offset];
    }
}
/**
 *  次视图上显示的日历
 *
 *  @param date 将要显示的周的日期
 */
- (void)resetWeekStyleWithDate:(NSDate *)date
{
    self.type = XKRWCalendarTypeWeek;
    
    self.date = date;
    BOOL flag = NO;
    if ([self.date isMonthEqualToDate:[NSDate date]]) {
        flag = YES;
    }
    
    int offset = 0 - [self.date returnWeekday];
    
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XKRWCalendarItem *item = (XKRWCalendarItem *)obj;
        BOOL isToday = NO;
        
        if (idx < 7) {
            NSDate *itemDate = [self.date offsetDay:offset + idx + 1];
            if ([itemDate isDayEqualToDate:[NSDate date]]) {
                isToday = YES;
            }
            BOOL outOfMonth = ![itemDate isMonthEqualToDate:self.date];
            if (outOfMonth) {
                item.tag = itemDate.day + 100;
                
            } else {
                item.tag = itemDate.day;
            }
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            [item setDay:[NSString stringWithFormat:@"%ld", (long)itemDate.day]
              outOfMonth:outOfMonth
                 isToday:isToday
                isRecord:isRecord];
            if (item.isHidden) {
//                [item setHidden:NO withAnimation:YES];
            }
        } else {
            item.tag = 0;
        }
    }];
    [self setDateSelected:self.selectedDay];
}

- (CGFloat)animationEndTopLine
{
    return (self.currentLine - 1) * 30.f;
}

- (CGFloat)animationEndBottomLine
{
    return self.currentLine * 30.f;
}

- (CGFloat)offsetOfDate:(NSDate *)date
{
    CGFloat offset = -1.f;
    if (![date isMonthEqualToDate:self.date]) {
        return offset;
    }
    offset = ([date weekOfMonth] - 1) * 30.f;
    return - offset;
}

- (void)offsetYPoint:(CGFloat)offset
{
    CGRect rect = self.frame;
    rect.origin.y = _originalY + offset;
    self.frame = rect;
}

- (void)clickDayOutOfMonth:(void (^)(int))block
{
    
}
@end
