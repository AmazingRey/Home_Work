//
//  XKReceiveAPNNotification.h
//  XKCommon
//
//  Created by Liao Rick on 13-7-2.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKNotification.h"

OBJC_EXTERN NSString * const kXKReceiveAPNNotificationName;

@interface XKReceiveAPNNotification : XKNotification

+ (id)notificationWithUserInfo:(NSDictionary *)userInfo;

- (id)initWithUserInfo:(NSDictionary *)userInfo;

@end
