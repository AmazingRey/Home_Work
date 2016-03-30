//
//  XKRWNoticeEntity.h
//  XKRW
//
//  Created by zhanaofan on 14-1-16.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWAlarmEntity : NSObject <NSMutableCopying>

@property (nonatomic) int aid;
//用户uid
@property (nonatomic, assign) int32_t               uid;
//提醒类型
@property (nonatomic, assign) int32_t               type;
//提醒小时
@property (nonatomic, assign) int32_t               hour;
//提醒分钟
@property (nonatomic, assign) int32_t               minutes;

/* 提醒频率
 1<<0  周一 1<<1 周二 1<<2 周三   1<<3 周四  1<<4 周五  1<<5 周六  1<<6 周日
 1+2   表示周一和周二
 */
@property (nonatomic, assign) int32_t              daysofweek;
//下次提醒时间点
@property (nonatomic, assign) int32_t              alarmtime;
//提醒状态
@property (nonatomic, assign) int32_t               enabled;
//是否震动提醒
@property (nonatomic, assign) int32_t               vibrate;
//提醒标题
@property (nonatomic, strong) NSString              *label;
//提醒内容
@property (nonatomic, strong) NSString              *message;
//提醒铃声
@property (nonatomic, strong) NSString              *alert;

@property (nonatomic, assign) int32_t               sync;
//serverid 当create_time用 ----5.0
@property (nonatomic) int serverid;



- (void) setType:(int32_t)alarmType;
-(NSString *)description;


@end
