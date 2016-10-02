//
//  NSDate+Util.h
//  calorie
//
//  Created by Jiang Rui on 12-11-15.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XKUtil)

//根据格式得到当前时间的字符串
+(NSString *)getCurrentDateStringWithFormat:(NSString *)format;

//从字符串中取得时间 必须是 yyyy-MM-DD HH:MM:SS格式
+(NSDate *)dateFromString:(NSString *)string;

//时间格式转换 yyyy-MM-dd HH:mm:ss -> yyyyMMddHHmmss
+(NSString *)localToNet:(NSString *)time;

//时间格式转换 yyyyMMddHHmmss -> yyyy-MM-dd HH:mm:ss
+(NSString *)netTolocal:(NSString *)time;

//后一个月一号
+(NSDate *)nextMonth:(NSDate *)date;

//前一个月一号
+(NSDate *)previousMonth:(NSDate *)date;

+ (NSDate*)today;

+ (NSDate *)tomorrow ;

+ (NSDate *)tomorrowEnding;

+ (NSDate *)twoDaysAgo;


//把NSDate转换为字符串
- (NSString *)convertToStringWithFormat:(NSString *)format;

- (NSDate*)addDay:(NSInteger)offset;


+ (BOOL) compareDateIsToday:(NSDate *)date ;

//+(NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)formate;

@end
