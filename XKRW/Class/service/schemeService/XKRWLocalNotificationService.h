//
//  XKRWLocalNotificationService.h
//  XKRW
//
//  Created by Shoushou on 16/4/11.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
@class XKRWAlarmEntity;

@interface XKRWLocalNotificationService : XKRWBaseService
+ (instancetype)shareInstance;
+(void)cancelLocalNotification:(NSString *)key value:(NSString *)value;
+ (void)cancelAllLocalNotificationExcept:(NSString *)key value:(NSString *)value;
/**
 *  今天是否重设过蜕变之旅的本地推送
 *
 *  @return <#return value description#>
 */
- (BOOL)isResetMetamorphosisTourAlarmsToday;
/**
 *  设置默认闹钟
 */
- (void)defaultAlarmSetting;

/**
 *  注册蜕变之旅本地提醒
 */
- (void)registerMetamorphosisTourAlarms;
/**
 *  v5.3七天未记录体重提醒
 */
- (void)setRecordWeightNotification;
// v5.3设置未开起计划的提醒
- (void)setOpenPlanNotification;
/**
 *  周分析提醒（18:00提醒)
 */
- (void)setWeekAnalyzeNotification;
/**
 *  批量设置闹钟
 *
 *  @param entityArray NSArray <XKRWAlarmEntity *> *
 *
 *  @return success:YES fault:NO
 */
- (BOOL)updateNotice:(NSArray *)entityArray;


//查询方法
- (XKRWAlarmEntity *)getAlarmWithType:(AlarmType)type;

// 是否有已激活的闹钟
- (BOOL)haveEnabledNotice;
- (BOOL)haveEnabledNotice:(AlarmType)type;

/**
 *  getAllAlarms
 *
 *  @return NSMutableArray <XKRWAlarmEntity *> *
 */
- (NSMutableArray *)getAllNotice;
- (void) cancelAllAlarm;

//判断闹钟时间与当前时间是否相等
- (BOOL) checkAlarmWithHour:(NSString *)h andMin:(NSString *)m;
@end
