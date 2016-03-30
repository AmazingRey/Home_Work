//
//  XKRWAlarmVC.h
//  XKRW
//
//  Created by Shoushou on 15/8/31.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWAlarmEntity.h"

@interface XKRWAlarmVC : XKRWBaseVC

@property (strong, nonatomic) XKRWAlarmEntity *alarmEntity;
@property (assign,nonatomic) AlarmType type;

@end
