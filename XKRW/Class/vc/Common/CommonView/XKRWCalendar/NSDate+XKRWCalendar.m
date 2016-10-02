//
//  NSDate+XKRWCalendar.m
//  XKRW
//
//  Created by XiKang on 14-11-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "NSDate+XKRWCalendar.h"

@implementation NSDate (XKRWCalendar)

@dynamic year, day, month;

- (NSInteger)year
{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:self];
    return comps.year;
}

- (NSInteger)day
{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:self];
    return comps.day;
}

- (NSInteger)month
{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:self];
    return comps.month;
}

- (NSInteger)hour
{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitHour fromDate:self];
    return comps.hour;
}

- (int)returnWeekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    return (int)[calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:self];
}

- (int)weekOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekOfMonth fromDate:self];
    return (int32_t)comps.weekOfMonth;
}

- (NSDate *)offsetMonth:(NSInteger)offset
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:offset];
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)offsetWeekOfYear:(NSInteger)offset
{
    if (offset == 0) {
        return self;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setWeekOfYear:offset];
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)offsetDay:(NSInteger)offset
{
    if (offset == 0) {
        return self;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:offset];
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)offsetMinute:(NSInteger)offset
{
    if (offset == 0) {
        return self;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMinute:offset];
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}


- (NSString *)formatInXKRWCalendar
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    formatter.dateFormat = @"yyyy年MM月";
    return [formatter stringFromDate:self];
}

- (NSInteger)numberOfDaysInMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

- (NSInteger)firstWeekDayInMonth
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                           fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];
    
    return [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:newDate];
}

- (BOOL)isMonthEqualToDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
    if (selfComps.year == dateComps.year && selfComps.month == dateComps.month) {
        return YES;
    }
    return NO;
}

- (BOOL)isDayEqualToDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                         fromDate:self];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                         fromDate:date];
    if (selfComps.year == dateComps.year && selfComps.month == dateComps.month && selfComps.day == dateComps.day) {
        return YES;
    }
    return NO;
}

- (BOOL)isWeekEqualToDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComps = [cal components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitYear
                                         fromDate:self];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitYear
                                         fromDate:date];
    if (selfComps.weekOfYear == dateComps.weekOfYear && dateComps.yearForWeekOfYear == selfComps.yearForWeekOfYear) {
        return YES;
    }
    return NO;
}

- (NSDate *)firstDayInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                          fromDate:self];
    [comps setHour:12];
    [comps setDay:1];
    
    return [calendar dateFromComponents:comps];
}

- (NSDate *)lastDayInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                          fromDate:self];
    [comps setHour:12];
    [comps setDay:[self numberOfDaysInMonth]];
    
    return [calendar dateFromComponents:comps];
}

- (NSDate *)firstDayInWeek {
    int offsetDay;
    if ([self returnWeekday] == 1) {
        offsetDay = -7;
    } else {
        offsetDay = - [self returnWeekday] + 1;
    }
    return [self offsetDay:(offsetDay + 1)];
}

- (NSDate *)lastDayInWeek {
    int offsetDay;
    if ([self returnWeekday] == 1) {
        offsetDay = 0;
    } else {
        offsetDay = 7 - [self returnWeekday] + 1;
    }
    return [self offsetDay:offsetDay];
}

- (NSTimeInterval)originTimeOfADay {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    return [[calendar dateFromComponents:comps] timeIntervalSince1970];
}




@end
