//
//  XKSilentDispatcher.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-26.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKDispatcher.h"

@interface XKSilentDispatcher : NSObject

+ (void)executeTask:(XKDispatcherTask)task;
+ (void)executeRpcTask:(XKDispatcherTask)task;

+ (void)syncExecuteTask:(XKDispatcherTask)task;
+ (void)syncExecuteRpcTask:(XKDispatcherTask)task;

+ (void)asynExecuteTask:(XKDispatcherTask)task;
+ (void)asynExecuteRpcTask:(XKDispatcherTask)task;

@end
