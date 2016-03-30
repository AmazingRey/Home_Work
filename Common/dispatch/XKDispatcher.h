//
//  XKDispatcher.h
//  XKCommon
//
//  Created by Rick Liao on 13-3-25.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^XKDispatcherTask)(void);
typedef void (^XKDispatcherInputTask)(id input);
typedef id (^XKDispatcherOutputTask)(void);

extern const NSTimeInterval kXKAsyncerUnlimitedTime;

@interface XKDispatcher : NSObject

+ (void)syncExecuteTask:(XKDispatcherTask)task;
+ (void)syncExecuteTask:(XKDispatcherTask)task afterSeconds:(float)seconds;

+ (void)asynExecuteTask:(XKDispatcherTask)targetTask;
+ (void)asynExecuteTask:(XKDispatcherTask)targetTask
             okCallback:(XKDispatcherTask)okTask;
+ (void)asynExecuteTask:(XKDispatcherTask)targetTask
             okCallback:(XKDispatcherTask)okTask
        timeoutCallback:(XKDispatcherTask)timeoutBlock
         maxExecuteTime:(NSTimeInterval)maxExecuteTime;
+ (void)asynExecuteTask:(XKDispatcherTask)targetTask
             okCallback:(XKDispatcherTask)okTask
             ngCallback:(XKDispatcherInputTask)ngTask
          finalCallback:(XKDispatcherTask)finalTask;
+ (void)asynExecuteTask:(XKDispatcherTask)targetTask
             okCallback:(XKDispatcherTask)okTask
             ngCallback:(XKDispatcherInputTask)ngTask
          finalCallback:(XKDispatcherTask)finalTask
        timeoutCallback:(XKDispatcherTask)timeoutTask
         maxExecuteTime:(NSTimeInterval)maxExecuteTime;

+ (void)asynExecuteOutputTask:(XKDispatcherOutputTask)targetTask
                   okCallback:(XKDispatcherInputTask)okTask;
+ (void)asynExecuteOutputTask:(XKDispatcherOutputTask)targetTask
                   okCallback:(XKDispatcherInputTask)okTask
              timeoutCallback:(XKDispatcherTask)timeoutBlock
               maxExecuteTime:(NSTimeInterval)maxExecuteTime;
+ (void)asynExecuteOutputTask:(XKDispatcherOutputTask)targetTask
                   okCallback:(XKDispatcherInputTask)okTask
                   ngCallback:(XKDispatcherInputTask)ngTask
                finalCallback:(XKDispatcherTask)finalTask;
+ (void)asynExecuteOutputTask:(XKDispatcherOutputTask)targetTask
                   okCallback:(XKDispatcherInputTask)okTask
                   ngCallback:(XKDispatcherInputTask)ngTask
                finalCallback:(XKDispatcherTask)finalTask
              timeoutCallback:(XKDispatcherTask)timeoutTask
               maxExecuteTime:(NSTimeInterval)maxExecuteTime;

@end
