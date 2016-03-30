//
//  XKReceiveAPNNotification.m
//  XKCommon
//
//  Created by Liao Rick on 13-7-2.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKReceiveAPNNotification.h"

NSString * const kXKReceiveAPNNotificationName = @"XKReceiveAPNNotification";

@implementation XKReceiveAPNNotification

+ (id)notificationWithUserInfo:(NSDictionary *)userInfo {
    return [[XKReceiveAPNNotification alloc] initWithUserInfo:userInfo];
}

- (id)initWithUserInfo:(NSDictionary *)userInfo {
    return [self initWithName:kXKReceiveAPNNotificationName object:nil userInfo:userInfo];
}

@end
