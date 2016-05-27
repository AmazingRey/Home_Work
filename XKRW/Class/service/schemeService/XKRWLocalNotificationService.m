//
//  XKRWLocalNotificationService.m
//  XKRW
//
//  Created by Shoushou on 16/4/11.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWLocalNotificationService.h"
#import "XKRWUserService.h"
#import "XKRWPlanService.h"
#import "XKRWRecordEntity4_0.h"
#import "XKRWCommHelper.h"
#import "XKRWAlgolHelper.h"
#import "XKRWAlarmEntity.h"


static XKRWLocalNotificationService *shareLocalNotificationService;
@implementation XKRWLocalNotificationService

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareLocalNotificationService = [[XKRWLocalNotificationService alloc] init];
    });
    return shareLocalNotificationService;
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

- (void)saveMetamorphosisTourAlarmsResetTime {
    NSDate *date = [NSDate today];
    NSString *key = [NSString stringWithFormat:@"MetamorphosisTourAlarmsResetTime_%ld",(long)[[XKRWUserService sharedService] getUserId]];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:key];
}

- (BOOL)isResetMetamorphosisTourAlarmsToday {
    NSString *key = [NSString stringWithFormat:@"MetamorphosisTourAlarmsResetTime_%ld",(long)[[XKRWUserService sharedService] getUserId]];
    NSDate *resetDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (resetDate) {
        NSDate *today = [NSDate date];
        if ([today compare:resetDate] == NSOrderedSame) {
            return YES;
        } else return NO;
    } else return NO;
}

#pragma mark - alarm
// 新用户默认闹钟设置v5.3以后改为默认关闭
- (void)defaultAlarmSetting {
    uint32_t uid = (int)[XKRWUserDefaultService getCurrentUserId];

    NSString *key = [NSString stringWithFormat:@"defaultAlarmSetting_%i",uid];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM alarm_4_0 WHERE uid = %i",uid];
    if (![self query:sql]) {
        NSMutableArray *alarmEntityArr = [NSMutableArray array];
        
        //生成运动、早餐、午餐、晚餐和习惯提醒的默认entity
        for (int i = 0; i < 5 ; i ++) {
            XKRWAlarmEntity *entity = [[XKRWAlarmEntity alloc] init];
            entity.uid = uid;
            entity.serverid = [[NSDate date] timeIntervalSince1970];
            entity.type = 2+i;
            entity.daysofweek = 31;
            entity.minutes = 0;
            entity.enabled = NO;
            switch (i) {
                case 0:
                    entity.hour = 8;
                    break;
                case 1:
                    entity.hour = 11;
                    break;
                case 2:
                    entity.hour = 18;
                    break;
                case 3:
                    entity.type = 6;
                    entity.hour = 20;
                    entity.enabled = NO;
                    break;
                case 4:
                    entity.type = 8;
                    entity.hour = 10;
                    break;
                default:
                    break;
            }
            [alarmEntityArr addObject:entity];
        }
        
        //判断用户是否有不良习惯，若没有，移除习惯初始提示
        XKRWRecordEntity4_0 *recordEntity = [[XKRWRecordEntity4_0 alloc] init];
        [recordEntity reloadHabitArray];
        if(recordEntity.habitArray == nil || recordEntity.habitArray.count == 0) {
            [alarmEntityArr removeLastObject];
        }
        
        [self updateNotice:alarmEntityArr];
    } else {
        [self deleteNoticeV5_0];
        [self resetAllAlarm];
        return;
    }
}

// v5.3设置未开起计划的提醒
- (void)setOpenPlanNotification {
    [XKRWLocalNotificationService cancelLocalNotification:@"alertName" value:@"openPlanNotification"];
    NSInteger remainPlanDays = [XKRWAlgolHelper remainDayToAchieveTarget];
    if (remainPlanDays <= 1) {
        return;
    }
    int offsetDay = 0;
    if ([[XKRWPlanService shareService] getEnergyCircleClickEvent:eFoodType] || [[XKRWPlanService shareService] getEnergyCircleClickEvent:eSportType] || [[XKRWPlanService shareService] getEnergyCircleClickEvent:eHabitType]) {
        offsetDay = 1;
    }
    NSMutableArray *mutArray = [NSMutableArray array];
   
    if (remainPlanDays >= (1 + offsetDay)) {
       [mutArray addObject:[self setNotificationDicWithAlertName:@"openPlanNotification" alertBody:@"昨天没有执行计划。现在补记还来得及哦！" hour:20 minute:0 second:0 offsetDay:(1 + offsetDay) type:@(eAlarmNoStartPlanOneDay) repeatInterval:NSCalendarUnitEra]];
    }
    if (remainPlanDays >= (2 + offsetDay)) {
       [mutArray addObject:[self setNotificationDicWithAlertName:@"openPlanNotification" alertBody:@"有3天没执行计划，不要偏离计划哦！" hour:20 minute:0 second:0 offsetDay:(2 + offsetDay) type:@(eAlarmNoStartPlanThreeDay) repeatInterval:NSCalendarUnitEra]];
    }
    if (remainPlanDays >= (6 + offsetDay)) {
       [mutArray addObject:[self setNotificationDicWithAlertName:@"openPlanNotification" alertBody:@"有7天没执行计划，建议重制新计划！" hour:20 minute:0 second:0 offsetDay:(6 + offsetDay) type:@(eAlarmNoStartPlanAWeek) repeatInterval:NSCalendarUnitEra]];
    }
    if (remainPlanDays >= (29 + offsetDay)) {
        [mutArray addObject:[self setNotificationDicWithAlertName:@"openPlanNotification" alertBody:[NSString stringWithFormat:@"还记得要瘦到%.1fkg吗？",[[XKRWUserService sharedService] getUserDestiWeight]/1000.f ] hour:20 minute:0 second:0 offsetDay:(29 + offsetDay) type:@(eAlarmNoStartPlanAMonth) repeatInterval:NSCalendarUnitEra]];
    }
    for (NSDictionary *dic in mutArray) {
        [self addAlarmWithFireDate:[dic valueForKey:@"fireDate"] repeatInterval:NSCalendarUnitEra alartBody:[dic valueForKey:@"alertBody"] andUserInfo:dic];
    }
}

/**
 *  v5.3连续7天未记录体重的提醒（12:00提醒）
 */
- (void)setRecordWeightNotification {
    [XKRWLocalNotificationService cancelLocalNotification:@"alertName" value:@"notRecordWeightAWeek"];
    NSInteger weight = [[XKRWRecordService4_0 sharedService] getWeightRecordOfDay:[NSDate today]];
    NSInteger offsetDay = 0;
    if (weight) {
        offsetDay = 1;
    }
     NSDictionary *dic = [self setNotificationDicWithAlertName:@"notRecordWeightAWeek" alertBody:@"已经一个周没记体重了！" hour:12 minute:0 second:0 offsetDay:(6 + offsetDay) type:@(eAlarmNoRecordWeightAWeek) repeatInterval:NSCalendarUnitEra];
    [self addAlarmWithFireDate:[dic valueForKey:@"fireDate"] repeatInterval:NSCalendarUnitEra alartBody:[dic valueForKey:@"alertBody"] andUserInfo:dic];
}

/**
 *  周分析提醒（18:00提醒)
 */
- (void)setWeekAnalyzeNotification {
    [XKRWLocalNotificationService cancelLocalNotification:@"alertName" value:@"seeWeeklyAnalyze"];
    NSInteger offsetDay = 7 - [XKRWAlgolHelper newSchemeStartDayToAchieveTarget]%7;
    NSInteger remainDays = [XKRWAlgolHelper remainDayToAchieveTarget];
    if (remainDays == -1 ||offsetDay > remainDays) {
        return;
    }
    NSMutableArray *mutArr = [NSMutableArray array];
    NSInteger times = (remainDays - offsetDay)/7 + 1;
    NSInteger timesOffset = (remainDays - offsetDay)%7 ? 1 : 0;
    for (int i = 0; i< times + timesOffset; i++) {
        [mutArr addObject:[self setNotificationDicWithAlertName:@"seeWeeklyAnalyze" alertBody:@"上周的分析已准备好啦，过来看看吧！" hour:18 minute:0 second:0 offsetDay:(1 +offsetDay + i * 7) type:@(eAlarmSeeWeeklyAnalyze) repeatInterval:NSCalendarUnitEra]];
        
    }
    for (NSDictionary *dic in mutArr) {
        [self addAlarmWithFireDate:[dic valueForKey:@"fireDate"] repeatInterval:NSCalendarUnitEra alartBody:[dic valueForKey:@"alertBody"] andUserInfo:dic];
    }


}
/**
 *  更新所有闹钟
 *
 *  @param entityArray <#entityArray description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)updateNotice:(NSArray *)entityArray
{
    BOOL isSuccess = NO;
    NSMutableString *insertMutableSql = [NSMutableString stringWithString:@"INSERT INTO alarm_4_0 (uid,type,hour,minutes,daysofweek,enabled,vibrate,label,message,alert,sync,serverid) VALUES "];
    for (XKRWAlarmEntity *entity in entityArray) {
        
        if ((!entity.label) || ([entity.label isEqualToString:@""]) || !entity.message|| ([entity.message isEqualToString:@""]) || !entity.alert) {
            
            NSString *title  = [XKRWCommHelper getAlarmTitleWithType:entity.type];
            
            entity.label = title;
            
            entity.message = [XKRWCommHelper getAlarmMsgWithType:entity.type];
            
            entity.alert = @"默认铃声";
            
        }
        
        // 相同uid下只能存在一种type
        [self executeSql:[NSString stringWithFormat:@"DELETE FROM alarm_4_0 WHERE uid = %d AND type = %d", entity.uid,entity.type]];
        
        NSMutableString *append = [NSMutableString stringWithFormat:@"(%d, %d, %d, %d, %d, %d, %d, '%@', '%@', '%@', %d, %d),", entity.uid, entity.type, entity.hour, entity.minutes, entity.daysofweek, entity.enabled, entity.vibrate, entity.label, entity.message, entity.alert, entity.sync, entity.serverid];
        
        [insertMutableSql appendString:append];
    }
    [insertMutableSql deleteCharactersInRange:NSMakeRange(insertMutableSql.length - 1, 1)];
    
    if ([self executeSql:insertMutableSql]) {
        [self resetAllAlarm];
        
        isSuccess = YES;
    }
    
    return isSuccess;
}
/**
 *  监测删除5.0版本没有的提醒
 */
- (void)deleteNoticeV5_0 {
    
    NSString *sql = [NSString stringWithFormat: @"delete from alarm_4_0 where uid = %li and type not in (2,3,4,6,8)",(long)[XKRWUserDefaultService getCurrentUserId] ];
    
    [self executeSql:sql];
    
}



- (void)resetAllAlarm
{
    //取消所有闹钟提醒
    for (UILocalNotification *notification in [UIApplication sharedApplication].scheduledLocalNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (!userInfo || ![(NSString *)[userInfo objectForKey:@"alertName"] length]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    //获取数据库有效提醒列表
    uint32_t currentUid = (int)[XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM alarm_4_0 WHERE uid = %i AND daysofweek != 0 AND enabled = 1 AND sync != -1",currentUid];
    
    NSMutableArray *alarmMutableDics = [self query:sql];
    
    if (alarmMutableDics.count && alarmMutableDics) {
        
        for (NSDictionary *dic in alarmMutableDics) {
            [self addAlarmWithEntity:dic];
        }
    }
}


// 取消所有提醒
- (void)cancelAllAlarm{
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}


- (void)addAlarmWithEntity:(NSDictionary *)dic
{
    // 循环周期
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekOfYear;
    
    // 开始时间
    NSDate *date = [NSDate date];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday ;
    
    comps = [calender components:unitFlags fromDate:date];
    [comps setHour:[[dic valueForKey:@"hour"] integerValue]];
    [comps setMinute:[[dic valueForKey:@"minutes"] integerValue]];
    [comps setSecond:0];
    
    NSDate *temp = [calender dateFromComponents:comps];
    
    NSInteger todayOfWeek = [comps weekday];
    NSInteger offset = 1;
    NSInteger daysofweek = [[dic valueForKey:@"daysofweek"] integerValue];
    
    while (daysofweek) {
        offset++;
        if (offset > 7) {
            offset = 1;
        }
        if (daysofweek%2) {
            
            NSDate *fireDate = [temp offsetDay:offset >= todayOfWeek ?(offset - todayOfWeek):(7-todayOfWeek+offset)];
            
            // 设置随机文案
            AlarmType type ;
            switch ([[dic valueForKey:@"type"] integerValue]) {
                case 2:
                    type = eAlarmBreakfast;
                    break;
                case 3:
                    type = eAlarmLunch;
                    break;
                case 4:
                    type = eAlarmDinner;
                    break;
                case 6:
                    type = eAlarmExercise;
                    break;
                case 8:
                    type = eAlarmHabit;
                    break;
                default:
                    type = eAlarmRecord;
                    break;
            }
            
            NSString *message = [XKRWCommHelper getAlarmMsgWithType:type];
            [dic setValue:message forKey:@"message"];
            
            //单个添加闹钟
            [self addAlarmWithFireDate:fireDate repeatInterval:calendarUnit alartBody:[dic valueForKey:@"message"] andUserInfo:dic];
            
        }
        daysofweek /= 2;
    }
}
/**
 *  设置alarm.userInfo
 *
 *  @param alertName      <#alertName description#>
 *  @param alertBody      <#alertBody description#>
 *  @param hour           <#hour description#>
 *  @param minute         <#minute description#>
 *  @param second         <#second description#>
 *  @param offsetDay      <#offsetDay description#>
 *  @param type           <#type description#>
 *  @param repeatInterval <#repeatInterval description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)setNotificationDicWithAlertName:(NSString *)alertName alertBody:(NSString *)alertBody hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second offsetDay:(NSInteger)offsetDay type:(NSNumber*)type repeatInterval:(NSCalendarUnit)repeatInterval {
    NSDate *date = [NSDate date];
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday ;
    
    comps = [calender components:unitFlags fromDate:date];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    NSDate *temp = [calender dateFromComponents:comps];
    
    NSString *uid = [NSString stringWithFormat:@"%li",(long)[XKRWUserDefaultService getCurrentUserId]];
    NSDate *fireDate = [temp offsetDay:offsetDay];
    NSDictionary *dic = @{@"alertName":alertName,@"fireDate":fireDate,@"alertBody":alertBody,@"type":type,@"hour":[NSString stringWithFormat:@"%ld",(long)hour],@"minutes":[NSString stringWithFormat:@"%ld",(long)minute],@"uid":uid};
    return dic;
}
//添加单个闹钟
- (void)addAlarmWithFireDate:(NSDate *)fireDate repeatInterval:(NSCalendarUnit)repeatInterval alartBody:(NSString *)alartBody andUserInfo:(NSDictionary *)userInfoDic
{
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    alarm.fireDate = fireDate;
    alarm.timeZone = [NSTimeZone localTimeZone];
    alarm.repeatInterval = repeatInterval;
    
    alarm.soundName = @"message.wav";
    
    alarm.alertAction = @"打开";
    alarm.alertBody = alartBody;
    alarm.userInfo = userInfoDic;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
}

//获取提醒对象  从数据库获取相应的闹钟  如果没有就从plist文件中读取默认的闹钟     （该方法后面需要添加 一个 取值参数 限制范围）
- (XKRWAlarmEntity*) getAlarmWithType:(AlarmType)type
{
    if (type < 1 || type > 9) {
        return nil;
    }
    uint32_t uid = (int)[XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM alarm_4_0 WHERE uid = %i AND type = %i ORDER BY serverid DESC LIMIT 0,1 ",uid,type];
    //LIMIT 0,1     0表示第一个  如果是自定义个数的话 需要从n个开始  n为表格中第n个提醒
    NSDictionary *rst = [self fetchRow:sql];
    
    XKRWAlarmEntity *entity = [[XKRWAlarmEntity alloc] init];
    if (rst != nil) {
        [rst setPropertiesToObject:entity];
        entity.type = type;
        return entity;
    }
    entity.label = [XKRWCommHelper getAlarmTitleWithType:type];
    entity.message = [XKRWCommHelper getAlarmMsgWithType:type];
    
    entity.type = type;
    
    entity.alert = @"默认铃声";
    
    return entity;
}


- (NSMutableArray *)getAllNotice
{
    NSMutableArray *array = [NSMutableArray array];
    
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        uint32_t uid = (int)[XKRWUserDefaultService getCurrentUserId];
        NSString *sql = [NSString stringWithFormat: @"SELECT * FROM alarm_4_0 WHERE uid = %i AND sync != -1",uid];
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            XKRWAlarmEntity *entity = [[XKRWAlarmEntity alloc] init];
            [set setResultIgnoreAbsentPropertiesToObject:entity];
            [array addObject:entity];
        }
    }];
    return array;
}

- (NSMutableArray *)setNotificationArray:(NSInteger)schemeStartDay andSchemeDay:(NSInteger)schemeDay {
    NSMutableArray *mutArray = [NSMutableArray array];
    
    NSString *alertName = @"dayNotification";
   
    for (NSInteger i = schemeStartDay; i <= schemeDay; i++) {
        NSString *alertBody = [NSString stringWithFormat:@"蜕变之旅第%ld天，要努力完成哦！",(long)i];
         [mutArray addObject:[self setNotificationDicWithAlertName:alertName alertBody:alertBody hour:8 minute:30 second:0 offsetDay:(i - schemeStartDay) type:@(111) repeatInterval:NSCalendarUnitEra]];
    }
    return mutArray;
}


- (void)registerMetamorphosisTourAlarms {
    
    [XKRWLocalNotificationService cancelLocalNotification:@"alertName" value:@"dayNotification"];
    if ([XKRWAlgolHelper remainDayToAchieveTarget] == -1) {
        return;
    }
    NSInteger schemeStartDay = [XKRWAlgolHelper newSchemeStartDayToAchieveTarget];
    NSInteger achieveTargetDay = [[XKRWAlgolHelper expectDayOfAchieveTarget] integerValue];
    
    if (achieveTargetDay - schemeStartDay + 1 > 15) {
        achieveTargetDay = schemeStartDay + 14;
    }
    
    for (NSDictionary *dic in [self setNotificationArray:schemeStartDay andSchemeDay:achieveTargetDay]) {
        [self addAlarmWithFireDate:[dic valueForKey:@"fireDate"] repeatInterval:NSCalendarUnitEra alartBody:[dic valueForKey:@"alertBody"] andUserInfo:dic];
    }
    [self saveMetamorphosisTourAlarmsResetTime];
}

#pragma mark -- Judgements

- (BOOL)haveEnabledNotice
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS num FROM alarm_4_0 WHERE uid = %ld AND enabled = 1", (long)UID];
    
    NSDictionary *result = [self query:sql][0];
    if (result && [result[@"num"] intValue]) {
        return YES;
    }
    
    return NO;
}


- (BOOL)haveEnabledNotice:(AlarmType)type{
    uint32_t uid = (int)[XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM alarm_4_0 WHERE uid = %i AND type = %i ORDER BY serverid DESC LIMIT 0,1 ",uid,type];
    
    NSDictionary *rst = [self fetchRow:sql];
    
    XKRWAlarmEntity *entity = [[XKRWAlarmEntity alloc] init];
    if (rst != nil) {
        [rst setPropertiesToObject:entity];
        if(!entity.enabled){
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

//判断闹钟时间与当前时间是否相等
- (BOOL) checkAlarmWithHour:(NSString *)h andMin:(NSString *)m{
    BOOL alarm = NO;
    // HH:mm
    NSString * nowTime = [NSDate stringFromDate:[NSDate date] withFormat:@"HHmmss"];
    int  hour = [[nowTime substringToIndex:2] intValue];
    int  min = [[nowTime substringWithRange:NSMakeRange(2, 2)] intValue];
    NSString * second =[nowTime substringWithRange:NSMakeRange(4, 2)];
    
    if (hour == [h integerValue]) {
        if (min ==[m integerValue]) {
            if ([second isEqualToString:@"00"]) {
                alarm = YES;
            }
        }
    }
    
    return alarm;
    
}

@end
