//
//  XKRWNoticeEntity.m
//  XKRW
//
//  Created by zhanaofan on 14-1-16.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWAlarmEntity.h"
#import "NSDate+Helper.h"
#import "NSString+XKUtil.h"

@implementation XKRWAlarmEntity
- (id) init
{
    self = [super init];
    if (self) {
        _uid = UID;
        _hour = 0;
        _minutes = 0;
        _type = -1;
        _daysofweek = 128;
        _alarmtime = 0;
        _enabled = 0;
        _vibrate = 0;
        _label = @"";
        _message = @"";
        _alert  = @"";
        _serverid = 0;
    }
    return self;
}

- (void) setType:(int32_t)alarmType
{
    _type = alarmType;
    
//    NSArray *noticeName = NoticeTitles ;
//    if (alarmType > 0) {
//        NSString *title = [noticeName objectAtIndex:(alarmType - 1)];
//        if (title) {
//            _label = title;
//        }
//    }
}
- (NSString *)description{
    return [NSString stringWithFormat:@"闹钟打印 -----------闹钟名 : %@  时间 : %d:%d 铃声 : %@ -----------------\n内容  :-: %@ ",_label,_hour,_minutes,_alert,_message];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    XKRWAlarmEntity *copy = [[XKRWAlarmEntity allocWithZone:zone] init];
    copy.uid = self.uid;
    copy.hour = self.hour;
    copy.minutes = self.minutes;
    copy.type = self.type;
    copy.daysofweek = self.daysofweek;
    copy.alarmtime = self.alarmtime;
    copy.vibrate = self.vibrate;
    copy.label = [self.label mutableCopy];
    copy.message = [self.message mutableCopy];
    copy.alert = [self.alert mutableCopy];
    copy.serverid = self.serverid;
    copy.sync = self.sync;
    
    return copy;
}
@end
