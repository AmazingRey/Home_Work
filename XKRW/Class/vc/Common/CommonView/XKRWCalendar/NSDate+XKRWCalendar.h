//
//  NSDate+XKRWCalendar.h
//  XKRW
//
//  Created by XiKang on 14-11-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XKRWCalendar)

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;

- (NSDate *)offsetMonth:(NSInteger)offset;
- (NSDate *)offsetWeekOfYear:(NSInteger)offset;
- (NSDate *)offsetDay:(NSInteger)offset; 
- (NSDate *)offsetMinute:(NSInteger)offset;
- (int)returnWeekday;
- (int)weekOfMonth;

- (NSString *)formatInXKRWCalendar;

- (NSInteger)numberOfDaysInMonth;
- (NSInteger)firstWeekDayInMonth;

- (BOOL)isMonthEqualToDate:(NSDate *)date;
- (BOOL)isDayEqualToDate:(NSDate *)date;
- (BOOL)isWeekEqualToDate:(NSDate *)date;

- (NSDate *)firstDayInMonth;
- (NSDate *)lastDayInMonth;

- (NSDate *)firstDayInWeek;
- (NSDate *)lastDayInWeek;

- (NSTimeInterval)originTimeOfADay;

@end
