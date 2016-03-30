//
//  XKDefaultNotification.h
//  XKCommon
//
//  Created by Rick Liao on 13-3-27.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKNotification.h"

@interface XKDefaultNotification : XKNotification

+ (NSString *) notificationName;

+ (id)notificationWithDetailName:(NSString *)detailName
                          object:(id)object;
+ (id)notificationWithDetailName:(NSString *)detailName
                          object:(id)object
                   otherUserInfo:(NSDictionary *)otherUserInfo;

- (id)initWithDetailName:(NSString *)detailName
                  object:(id)object;
- (id)initWithDetailName:(NSString *)detailName
                  object:(id)object
           otherUserInfo:(NSDictionary *)otherUserInfo;

- (NSString *)detailName;
- (NSDictionary *)otherUserInfo;

@end
