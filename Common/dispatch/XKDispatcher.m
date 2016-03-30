//
//  XKDispatcher.m
//  XKCommon
//
//  Created by Rick Liao on 13-3-25.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "NSTimer+XKDispatch.h"
#import "XKDispatcher.h"

const NSTimeInterval kXKAsyncerUnlimitedTime = -1;

@implementation XKDispatcher

+ (void)syncExecuteTask:(XKDispatcherTask)task {
    dispatch_async(dispatch_get_main_queue(), task);
}

+ (void)syncExecuteTask:(XKDispatcherTask)task afterSeconds:(float)seconds{
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), task);
}

+ (void)asynExecuteTask:(XKDispatcherTask)targetTask {
    [XKDispatcher asynExecuteTask:targetTask
                       okCallback:nil
                       ngCallback:nil
                    finalCallback:nil
                  timeoutCallback:nil
                   maxExecuteTime:kXKAsyncerUnlimitedTime];
}

+ (void)asynExecuteTask:(XKDispatcherTask)targetTask
             okCallback:(XKDispatcherTask)okTask {
    [XKDispatcher asynExecuteTask:targetTask
                       okCallback:okTask
                       ngCallback:nil
                    finalCallback:nil
                  timeoutCallback:nil
                   maxExecuteTime:kXKAsyncerUnlimitedTime];
}

+ (void)asynExecuteTask:(XKDispatcherTask)targetTask
             okCallback:(XKDispatcherTask)okTask
        timeoutCallback:(XKDispatcherTask)timeoutBlock
         maxExecuteTime:(NSTimeInterval)maxExecuteTime {
    [XKDispatcher asynExecuteTask:targetTask
                       okCallback:okTask
                       ngCallback:nil
                    finalCallback:nil
                  timeoutCallback:timeoutBlock
                   maxExecuteTime:maxExecuteTime];
}

+ (void)asynExecuteTask:(XKDispatcherTask)targetTask
             okCallback:(XKDispatcherTask)okTask
             ngCallback:(XKDispatcherInputTask)ngTask
          finalCallback:(XKDispatcherTask)finalTask {
    [XKDispatcher asynExecuteTask:targetTask
                       okCallback:okTask
                       ngCallback:ngTask
                    finalCallback:finalTask
                  timeoutCallback:nil
                   maxExecuteTime:kXKAsyncerUnlimitedTime];
}

+ (void)asynExecuteTask:(XKDispatcherTask)targetTask
             okCallback:(XKDispatcherTask)okTask
             ngCallback:(XKDispatcherInputTask)ngTask
          finalCallback:(XKDispatcherTask)finalTask
        timeoutCallback:(XKDispatcherTask)timeoutTask
         maxExecuteTime:(NSTimeInterval)maxExecuteTime {
    __block BOOL timeout = NO;
    __block BOOL dispatchOver = NO;
    
    if (timeoutTask && maxExecuteTime >= 0) {
        [NSTimer scheduledTimerWithTimeInterval:maxExecuteTime
                                        repeats:NO
                                           task:^ {
                                               if (!dispatchOver) {
                                                   timeout = YES;
                                                   timeoutTask();
                                               } // else NOP
                                           }];
    } // else NOP
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (ngTask || finalTask) {
            @try {
                targetTask();
                dispatchOver = YES;
                
                if (!timeout && okTask) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        okTask();
                    });
                } // else NOP
            } @catch (id e) {
                if (!timeout) {
                    if(ngTask) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            ngTask(e);
                        });
                    } else {
                        @throw e;
                    }
                } // else NOP
            } @finally {
                if (finalTask) {
                    dispatch_async(dispatch_get_main_queue(), finalTask);
                } // else NOP
            }
        }else {
            targetTask();
            dispatchOver = YES;
            
            if (!timeout && okTask) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    okTask();
                });
            } // else NOP
        }
    });
}

+ (void)asynExecuteOutputTask:(XKDispatcherOutputTask)targetTask
                   okCallback:(XKDispatcherInputTask)okTask {
    [XKDispatcher asynExecuteOutputTask:targetTask
                             okCallback:okTask
                             ngCallback:nil
                          finalCallback:nil
                        timeoutCallback:nil
                         maxExecuteTime:kXKAsyncerUnlimitedTime];
}

+ (void)asynExecuteOutputTask:(XKDispatcherOutputTask)targetTask
                   okCallback:(XKDispatcherInputTask)okTask
              timeoutCallback:(XKDispatcherTask)timeoutBlock
               maxExecuteTime:(NSTimeInterval)maxExecuteTime {
    [XKDispatcher asynExecuteOutputTask:targetTask
                             okCallback:okTask
                             ngCallback:nil
                          finalCallback:nil
                        timeoutCallback:timeoutBlock
                         maxExecuteTime:maxExecuteTime];
}

+ (void)asynExecuteOutputTask:(XKDispatcherOutputTask)targetTask
                   okCallback:(XKDispatcherInputTask)okTask
                   ngCallback:(XKDispatcherInputTask)ngTask
                finalCallback:(XKDispatcherTask)finalTask {
    [XKDispatcher asynExecuteOutputTask:targetTask
                             okCallback:okTask
                             ngCallback:ngTask
                          finalCallback:finalTask
                        timeoutCallback:nil
                         maxExecuteTime:kXKAsyncerUnlimitedTime];
}

+ (void)asynExecuteOutputTask:(XKDispatcherOutputTask)targetTask
                   okCallback:(XKDispatcherInputTask)okTask
                   ngCallback:(XKDispatcherInputTask)ngTask
                finalCallback:(XKDispatcherTask)finalTask
              timeoutCallback:(XKDispatcherTask)timeoutTask
               maxExecuteTime:(NSTimeInterval)maxExecuteTime {
    __block BOOL timeout = NO;
    __block BOOL dispatchOver = NO;
    
    if (timeoutTask && maxExecuteTime >= 0) {
        [NSTimer scheduledTimerWithTimeInterval:maxExecuteTime
                                        repeats:NO
                                           task:^ {
                                               if (!dispatchOver) {
                                                   timeout = YES;
                                                   timeoutTask();
                                               } // else NOP
                                           }];
    } // else NOP
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id result = nil;
        
        if (ngTask || finalTask) {
            @try {
                result = targetTask();
                dispatchOver = YES;
                
                if (!timeout && okTask) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        okTask(result);
                    });
                } // else NOP
            } @catch (id e) {
                if (!timeout) {
                    if(ngTask) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            ngTask(e);
                        });
                    } else {
                        @throw e;
                    }
                } // else NOP
            } @finally {
                if (finalTask) {
                    dispatch_async(dispatch_get_main_queue(), finalTask);
                } // else NOP
            }
        }else {
            result = targetTask();
            dispatchOver = YES;
            
            if (!timeout && okTask) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    okTask(result);
                });
            } // else NOP
        }
    });
}

@end
