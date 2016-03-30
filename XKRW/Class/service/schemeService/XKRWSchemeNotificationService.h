//
//  XKRWSchemeNotificationService.h
//  XKRW
//
//  Created by Shoushou on 16/2/3.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWSchemeNotificationService : NSObject
+(instancetype)shareService;

+(void)cancelLocalNotification:(NSString *)key value:(NSString *)value;
+ (void)cancelAllLocalNotificationExcept:(NSString *)key value:(NSString *)value;
- (NSMutableArray *)setNotificationArray:(NSInteger)schemeStartDay andSchemeDay:(NSInteger)schemeDay;
- (void)registerLocalNotification;
@end
