//
//  XKService.h
//  XKCommon
//
//  Created by Rick Liao on 13-3-28.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "XKDispatcher.h"

@interface XKService : NSObject

- (NSUserDefaults *)defaultUserDefaults;

- (void)readDefaultDBWithTask:(void (^)(FMDatabase *db))task;
- (void)writeDefaultDBWithTask:(void (^)(FMDatabase *db, BOOL *rollback))task;
- (void)readDefaultReadonlyDBWithTask:(void (^)(FMDatabase *db))task;

//- (void)downloadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task;
//- (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task;
//- (void)downloadWithTaskID:(NSString *)taskID outpuTask:(XKDispatcherOutputTask)task;
//- (void)uploadWithTaskID:(NSString *)taskID outpuTask:(XKDispatcherOutputTask)task;

- (id)rpcClientForClass:(Class)classes;

@end
