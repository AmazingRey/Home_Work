//
//  XKRWAlarmService5_1.h
//  XKRW
//
//  Created by Shoushou on 15/9/21.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWAlarmEntity.h"

@interface XKRWAlarmService5_1 : XKRWBaseService
+ (id)shareService;

- (BOOL)updateNotice:(NSArray *)entityArray;

- (void)defaultAlarmSetting;

//查询方法
- (XKRWAlarmEntity *)getAlarmWithType:(AlarmType)type;

// 是否有已激活的闹钟
- (BOOL)haveEnabledNotice;
- (BOOL)haveEnabledNotice:(AlarmType)type;
- (NSMutableArray *)getAllNotice;
- (void) cancelAllAlarm;

//判断闹钟时间与当前时间是否相等
- (BOOL) checkAlarmWithHour:(NSString *)h andMin:(NSString *)m;
@end
