//
//  XKNotification.m
//  XKCommon
//
//  Created by Rick Liao on 13-3-26.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKNotification.h"

@interface XKNotification ()

@property NSString *name;
@property id object;
@property NSDictionary *userInfo;

@end

@implementation XKNotification

@synthesize name = _name, object = _object, userInfo = _userInfo;

+ (id)notificationWithName:(NSString *)name object:(id)object {
    return [[XKNotification alloc] initWithName:name object:object];
}

+ (id)notificationWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    return [[XKNotification alloc] initWithName:name object:object userInfo:userInfo];
}

- (id)initWithName:(NSString *)name object:(id)object {
    return [self initWithName:name object:object userInfo:nil];
}

- (id)initWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    _name = name;
    _object = object;
    _userInfo = userInfo;
    
    return self;
}

- (id)userInfoValueForKey:(NSString *)key {
    return self.userInfo[key];
}

@end
