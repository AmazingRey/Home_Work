//
//  XKTaskDispatcher.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-5.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKDidPerformTaskNotification.h"
#import "XKTaskDispatcher.h"

@implementation XKTaskDispatcher

+ (void)downloadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task {
    [XKDispatcher asynExecuteTask:task
                       okCallback:^ {
                           [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification downloadOKNotificationWithTaskID:taskID]];
                       }
                       ngCallback:^(id problem) {
                           [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification downloadNGNotificationWithTaskID:taskID problem:problem]];
                       }
                    finalCallback:nil];
}

+ (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task {
    [XKDispatcher asynExecuteTask:task
                       okCallback:^ {
                           [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification uploadOKNotificationWithTaskID:taskID]];
                       }
                       ngCallback:^(id problem) {
                           [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification uploadNGNotificationWithTaskID:taskID problem:problem]];
                       }
                    finalCallback:nil];
}

+ (void)downloadWithTaskID:(NSString *)taskID outputTask:(XKDispatcherOutputTask)task {
    [XKDispatcher asynExecuteOutputTask:task
                             okCallback:^(id result) {
                                 [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification downloadOKNotificationWithTaskID:taskID result:result]];
                             }
                             ngCallback:^(id problem) {
                                 [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification downloadNGNotificationWithTaskID:taskID problem:problem]];
                             }
                          finalCallback:nil];
}

+ (void)uploadWithTaskID:(NSString *)taskID outputTask:(XKDispatcherOutputTask)task {
    [XKDispatcher asynExecuteOutputTask:task
                             okCallback:^(id result) {
                                 [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification uploadOKNotificationWithTaskID:taskID result:result]];
                             }
                             ngCallback:^(id problem) {
                                 [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification uploadNGNotificationWithTaskID:taskID problem:problem]];
                             }
                          finalCallback:nil];
}

@end
