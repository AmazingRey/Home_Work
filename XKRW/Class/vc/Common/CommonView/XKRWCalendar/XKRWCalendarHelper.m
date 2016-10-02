//
//  XKRWCalendarHelper.m
//  XKRW
//
//  Created by XiKang on 14-11-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWCalendarHelper.h"

@implementation XKRWCalendarHelper

+ (NSDate *)getPreviousMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    [components setDay:1];
    [components setHour:12];
    [components setMonth:components.month - 1];
    
    return [calendar dateFromComponents:components];
}

+ (NSDate *)getNextMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar]; 
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    [components setDay:1];
    [components setHour:12];
    [components setMonth:components.month + 1];
    
    return [calendar dateFromComponents:components];
}

+ (BOOL)checkSameDay:(NSDate *)date1 another:(NSDate *)date2
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    formatter.dateFormat = @"yyyy-MM-DD";
    NSString *string1 = [formatter stringFromDate:date1];
    NSString *string2 = [formatter stringFromDate:date2];
    
    return [string1 isEqualToString:string2];
}


+ (NSDate *)getNextDate:(NSDate *)date{
    NSDate *tomorrow = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:date];
    return tomorrow;
    
}

@end
