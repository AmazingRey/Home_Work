//
//  XKRWCalendarHelper.h
//  XKRW
//
//  Created by XiKang on 14-11-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CALENDAR_NORMAL_HEIGHT
#define CALENDAR_CLOSE_HEIGHT

typedef NS_ENUM(NSInteger, XKRWCalendarType) {
    XKRWCalendarTypeWeek,
    XKRWCalendarTypeMonth,
    
};

typedef NS_ENUM(NSInteger,XKRWCalendarMonthType) {
    XKRWCalendarDefault,
    XKRWCalendarTypeStrongMonth    //月份显示增强版
};

typedef NS_ENUM(NSInteger, XKRWCalendarHeaderType) {
    XKRWCalendarHeaderTypeDefault = 0,
    XKRWCalendarHeaderTypeCustom,
    XKRWCalendarHeaderTypeSimple
};

@interface XKRWCalendarHelper : NSObject

+ (NSDate *)getPreviousMonth:(NSDate *)date;
+ (NSDate *)getNextMonth:(NSDate *)date;

+ (BOOL)checkSameDay:(NSDate *)date1 another:(NSDate *)date2;

+ (NSDate *)getNextDate:(NSDate *)date;

@end
