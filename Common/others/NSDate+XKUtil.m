//
//  NSDate+XKUtil.m
//  calorie
//
//  Created by Jiang Rui on 12-11-15.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "NSDate+XKUtil.h"

@implementation NSDate (XKUtil)

+(NSString *)getCurrentDateStringWithFormat:(NSString *)format
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    formater.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:format];//这里设置日期的字符串格式
    NSString * curTime = [formater stringFromDate:curDate];
    return curTime;
}

+(NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    dateFormat.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

//+(NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)formate
//{
//    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
//    [dateFormat setDateFormat:formate];//设定时间格式,这里可以设置成自己需要的格式
//    NSDate *date =[dateFormat dateFromString:string];
//    return date;
//}

//时间格式转换 yyyyMMddHHmmss -> yyyy-MM-dd HH:mm:ss
+(NSString *)localToNet:(NSString *)time
{
    NSString *str1 = [time substringWithRange:NSMakeRange(0, 4)];
    NSString *str2 = [time substringWithRange:NSMakeRange(5, 2)];
    NSString *str3 = [time substringWithRange:NSMakeRange(8, 2)];
    NSString *str4 = [time substringWithRange:NSMakeRange(11, 2)];
    NSString *str5 = [time substringWithRange:NSMakeRange(14, 2)];
    NSString *str6 = [time substringWithRange:NSMakeRange(17, 2)];
    NSString *newTimeString = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,str2,str3,str4,str5,str6];
    return newTimeString;

}

//时间格式转换 yyyy-MM-dd HH-mm-ss -> yyyyMMddHHmmss
+(NSString *)netTolocal:(NSString *)time
{
    
    NSString *str1 = [time substringWithRange:NSMakeRange(0, 4)];
    NSString *str2 = [time substringWithRange:NSMakeRange(4, 2)];
    NSString *str3 = [time substringWithRange:NSMakeRange(6, 2)];
    NSString *str4 = [time substringWithRange:NSMakeRange(8, 2)];
    NSString *str5 = [time substringWithRange:NSMakeRange(10, 2)];
    NSString *str6 = [time substringWithRange:NSMakeRange(12, 2)];
    NSString *newTimeString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",str1,str2,str3,str4,str5,str6];
    return newTimeString;
}

+(NSDate *)nextMonth:(NSDate *)date
{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setDateFormat:@"yyyyMM"];
    int month = [formatter stringFromDate:date].intValue;
    if (month % 100 == 12) {
        month += 89;
    }
    else
    {
        month += 1;
    }
    NSString *str = [NSString stringWithFormat:@"%i",month];
    NSDate *nextDate = [formatter dateFromString:str];
    return nextDate;
    
}

+(NSDate *)previousMonth:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setDateFormat:@"yyyyMM"];
    int month = [formatter stringFromDate:date].intValue;
    if (month % 100 == 1) {
        month -= 89;
    }
    else
    {
        month -= 1;
    }
    NSString *str = [NSString stringWithFormat:@"%i",month];
    NSDate *previousDate = [formatter dateFromString:str];
    return previousDate;
}

+ (NSDate*)today {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:[NSDate date]];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [calendar dateFromComponents:components];
}

-(NSString *)convertToStringWithFormat:(NSString *)format
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    formater.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formater setDateFormat:format];//这里设置日期的字符串格式
    NSString *time = [formater stringFromDate:self];
    return time;
}

- (NSDate*)addDay:(NSInteger)offset {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *offsetComponents = [NSDateComponents new];
    [offsetComponents setDay:offset];
    
    return [calendar dateByAddingComponents:offsetComponents toDate:self options:0];
}

@end
