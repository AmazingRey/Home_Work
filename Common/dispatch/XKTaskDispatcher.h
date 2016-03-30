//
//  XKTaskDispatcher.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-5.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKDispatcher.h"

@interface XKTaskDispatcher : NSObject

+ (void)downloadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task;
+ (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task;
+ (void)downloadWithTaskID:(NSString *)taskID outputTask:(XKDispatcherOutputTask)task;
+ (void)uploadWithTaskID:(NSString *)taskID outputTask:(XKDispatcherOutputTask)task;

@end
