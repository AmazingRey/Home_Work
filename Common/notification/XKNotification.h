//
//  XKNotification.h
//  XKCommon
//
//  Created by Rick Liao on 13-3-26.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKNotification : NSNotification

+ (id)notificationWithName:(NSString *)aName object:(id)anObject;
+ (id)notificationWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

- (id)initWithName:(NSString *)name object:(id)object;
- (id)initWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;

- (NSString *)name;
- (id)object;
- (NSDictionary *)userInfo;

- (id)userInfoValueForKey:(NSString *)key;

@end
