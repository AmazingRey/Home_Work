//
//  XKDefaultNotification.m
//  XKCommon
//
//  Created by Rick Liao on 13-3-27.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKDefine.h"
#import "XKDefaultNotification.h"

@implementation XKDefaultNotification

+ (NSString *) notificationName {
    return kXKDefaultNotification;
}

+ (id)notificationWithDetailName:(NSString *)detailName
                          object:(id)object {
    return [[XKDefaultNotification alloc] initWithDetailName:detailName
                                                      object:object];
}

+ (id)notificationWithDetailName:(NSString *)detailName
                          object:(id)object
                   otherUserInfo:(NSDictionary *)otherUserInfo {
    return [[XKDefaultNotification alloc] initWithDetailName:detailName
                                                      object:object
                                               otherUserInfo:otherUserInfo];
}

- (id)initWithDetailName:(NSString *)detailName
                  object:(id)object {
    return [self initWithDetailName:detailName object:object otherUserInfo:nil];
}

- (id)initWithDetailName:(NSString *)detailName
                  object:(id)object
           otherUserInfo:(NSDictionary *)otherUserInfo {
    NSMutableDictionary *userInfo = nil;
    if (otherUserInfo) {
        userInfo = [NSMutableDictionary dictionaryWithDictionary:otherUserInfo];
    } else {
        userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    if (detailName) {
        userInfo[@"XKUserInfoDetailName"] = detailName;
    }
    
    return [self initWithName:[XKDefaultNotification notificationName]
                       object:object
                     userInfo:userInfo];
}

- (NSString *)detailName {
    return [self userInfoValueForKey:@"XKUserInfoDetailName"];
}

- (NSDictionary *)otherUserInfo {
    NSMutableDictionary *otherUserInfo = [NSMutableDictionary dictionaryWithDictionary:self.userInfo];
    
    [otherUserInfo removeObjectForKey:@"XKUserInfoDetailName"];
    
    return otherUserInfo;
}

@end
