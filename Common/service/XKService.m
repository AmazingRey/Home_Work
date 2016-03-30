//
//  XKService.m
//  XKCommon
//
//  Created by Rick Liao on 13-3-28.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKDatabaseUtil.h"
#import "XKThriftClientFactory.h"
#import "XKDidPerformTaskNotification.h"
#import "XKUtil.h"
#import "XKService.h"

@implementation XKService

- (NSUserDefaults *)defaultUserDefaults {
    return [XKUtil defaultUserDefaults];
}

- (void)readDefaultDBWithTask:(void (^)(FMDatabase *db))task {
    [[XKDatabaseUtil defaultDB] inDatabase:task];
}

- (void)writeDefaultDBWithTask:(void (^)(FMDatabase *db, BOOL *rollback))task {
    [[XKDatabaseUtil defaultDB] inTransaction:task];
}

- (void)readDefaultReadonlyDBWithTask:(void (^)(FMDatabase *db))task {
    [[XKDatabaseUtil defaultReadonlyDB] inDatabase:task];
}

//- (void)downloadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task {
//    [XKDispatcher asynExecute:task
//                   okCallback:^ {
//                       [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification downloadOKNotificationWithTaskID:taskID]];
//                   }
//                   ngCallback:^(id problem) {
//                       [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification downloadNGNotificationWithTaskID:taskID problem:problem]];
//                   }
//                finalCallback:nil];
//}
//
//- (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task {
//    [XKDispatcher asynExecute:task
//                   okCallback:^ {
//                       [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification uploadOKNotificationWithTaskID:taskID]];
//                   }
//                   ngCallback:^(id problem) {
//                       [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification uploadNGNotificationWithTaskID:taskID problem:problem]];
//                   }
//                finalCallback:nil];
//}
//
//- (void)downloadWithTaskID:(NSString *)taskID outpuTask:(XKDispatcherOutputTask)task {
//    [XKDispatcher asynOutputExecute:task
//                         okCallback:^(id result) {
//                             [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification downloadOKNotificationWithTaskID:taskID result:result]];
//                         }
//                         ngCallback:^(id problem) {
//                             [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification downloadNGNotificationWithTaskID:taskID problem:problem]];
//                         }
//                      finalCallback:nil];
//}
//
//- (void)uploadWithTaskID:(NSString *)taskID outpuTask:(XKDispatcherOutputTask)task {
//    [XKDispatcher asynOutputExecute:task
//                         okCallback:^(id result) {
//                             [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification uploadOKNotificationWithTaskID:taskID result:result]];
//                         }
//                         ngCallback:^(id problem) {
//                             [[NSNotificationCenter defaultCenter] postNotification:[XKDidPerformTaskNotification uploadNGNotificationWithTaskID:taskID problem:problem]];
//                         }
//                      finalCallback:nil];
//}

- (id)rpcClientForClass:(Class)class {
    return [[XKThriftClientFactory sharedFactory] createClientInstanceByClass:class];
}

@end
