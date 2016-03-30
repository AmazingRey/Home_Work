//
//  XKRWSchemeNotificationService.m
//  XKRW
//
//  Created by Shoushou on 16/2/3.
//  Copyright © 2016年 XiKang. All rights reserved.
//
#import "XKRWAlgolHelper.h"
#import "XKRWSchemeNotificationService.h"

@implementation XKRWSchemeNotificationService

static XKRWSchemeNotificationService *shareSchemeNotInstance;
/*
 let day = XKRWUserService.sharedService().getInsisted()
 self.title = String(format: "第%d天", day == 0 ? 1 : day)
 getResetTime
 */
+(instancetype)shareService {
   
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareSchemeNotInstance = [[self alloc] init];
    });
    return shareSchemeNotInstance;
}

- (NSMutableArray *)setNotificationArray:(NSInteger)schemeStartDay andSchemeDay:(NSInteger)schemeDay {
    NSMutableArray *mutArray = [NSMutableArray array];
    
    NSString *alertName = @"dayNotification";
    NSDate *date = [NSDate date];
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday ;
    
    comps = [calender components:unitFlags fromDate:date];
    [comps setHour:8];
    [comps setMinute:30];
    [comps setSecond:0];
    
    NSDate *temp = [calender dateFromComponents:comps];
    for (NSInteger i = schemeStartDay; i <= schemeDay; i++) {
        NSString *uid = [NSString stringWithFormat:@"%li",(long)[XKRWUserDefaultService getCurrentUserId]];
//        NSDate *fireDate = [temp offsetMinute:i-schemeStartDay];
        NSDate *fireDate = [temp offsetDay:i-schemeStartDay];
        NSString *alertBody = [NSString stringWithFormat:@"蜕变之旅第%ld天，要努力完成哦！",(long)i];
        NSDictionary *schemeNotificationDic = @{@"alertName":alertName,@"fireDate":fireDate,@"alertBody":alertBody,@"type":@(111),@"hour":@"8",@"minutes":@"30",@"uid":uid};
        [mutArray addObject:schemeNotificationDic];
    }
    return mutArray;
}


- (void)registerLocalNotification {
    [XKRWSchemeNotificationService cancelLocalNotification:@"alertName" value:@"dayNotification"];
    for (NSDictionary *dic in [self setNotificationArray:[XKRWAlgolHelper newSchemeStartDayToAchieveTarget] andSchemeDay:[[XKRWAlgolHelper expectDayOfAchieveTarget] integerValue]]) {
  
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [dic valueForKey:@"fireDate"];
        notification.timeZone = [NSTimeZone localTimeZone];
        notification.repeatInterval = NSCalendarUnitEra;
        notification.alertBody = [dic valueForKey:@"alertBody"];
        notification.soundName = @"message.wav";
        notification.applicationIconBadgeNumber = 0;
        notification.userInfo = dic;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


+ (void)cancelLocalNotification:(NSString *)key value:(NSString *)value {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        if (notification.userInfo && [[notification.userInfo valueForKey:key] isEqualToString:value]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

+ (void)cancelAllLocalNotificationExcept:(NSString *)key value:(NSString *)value {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        NSString *keyStr = [NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:key]];
        if (notification.userInfo && ![keyStr isEqualToString:value]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}
@end
