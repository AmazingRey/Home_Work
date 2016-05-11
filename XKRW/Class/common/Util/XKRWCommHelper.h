//
//  XKRWCommHelper.h
//  XKRW
//
//  Created by zhanaofan on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+XKUtil.h"
#import "XKSilentDispatcher.h"

@interface XKRWCommHelper : NSObject

//判断3.0版本是不是第一次打开
+ (BOOL) isFirstOpenThisApp;

+ (BOOL) isFirstOpenThisAppWithUserId:(NSInteger ) userId;
/*判断是否是今天第一次打开app*/
+ (BOOL) isFirstOpenToday;
//动画效果是否执行
+ (BOOL) isLoginOpenToday;
+ (void)setLoginOpenToday;

+ (BOOL) isUpdateFromV2;
/*当天第一次打开app时，需要处理的任务*/
+ (void) firstOpenHandler;

//版本升级的时候，需要执行的数据库升级任务
+ (void) updateHandelFromV2;
/*将远程数据同步到本地*/
+ (BOOL) syncRemoteData;
/*将今天远程数据同步到本地*/
+ (BOOL) syncTodayRemoteData;
/*同步本地数据到服务器上*/
+ (BOOL) syncDataToRemote;
//
+ (NSDictionary *) getAlarmsData;
/*获取提醒内容*/
+ (NSString *) getAlarmMsgWithType:(AlarmType)alrmType;
/**
 *  @brief  获得提醒标题
 */
+ (NSString *)getAlarmTitleWithType:(AlarmType)alarmType;
/*获取重量示意图数据*/
+ (NSArray *) getWeightHints;

//更新肥胖原因
+ (void) getQAWithUID:(NSInteger) u_id;

//判断某文件路径是否存在
+ (BOOL) fileExists:(NSString *)fileName;
/*清理缓存*/
+ (void) cleanCache;
@end
