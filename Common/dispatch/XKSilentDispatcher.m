//
//  XKSilentDispatcher.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-26.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "xkcm.h"
#import "XKAppInfoHelper.h"
#import "XKBusinessProblem.h"
#import "XKServerException.h"
#import "XKSilentDispatcher.h"

@implementation XKSilentDispatcher

+ (void)executeTask:(XKDispatcherTask)task {
    @try {
        task();
    } @catch (id e) {
        if ([XKAppInfoHelper isInformalReleaseType]) {
            if ([e conformsToProtocol:@protocol(XKBusinessProblem)]) {
                id<XKBusinessProblem> bp = e;
                XKLog(@"A problem occured in a silent process with class[%@], description[%@], type[%ld], brief[%@], detail[%@] and cause[%@].", bp.class, bp, (long)bp.type, bp.brief, bp.detail, bp.cause);
            } else {
                @throw e;
            }
        } // else NOP
    }
}

+ (void)executeRpcTask:(XKDispatcherTask)task {
    @try {
        task();
    } @catch (id e) {
        if ([XKAppInfoHelper isInformalReleaseType]) {
            if ([e isKindOfClass:BizException.class]) {
                XKLog(@"BizException occured in a silent process with class[%@], description[%@], code[%ld] and message[%@].", [e class], e, (long)[(BizException*)e code], [e message]);
            } else if ([e isKindOfClass:AuthException.class]) {
                XKLog(@"AuthException occured in a silent process with class[%@], description[%@], code[%ld] and message[%@].", [e class], e, (long)[(AuthException*)e code], [e message]);
            } else if ([e isKindOfClass:VersionException.class]) {
                XKLog(@"VersionException occured in a silent process with class[%@], description[%@], code[%ld] and message[%@].", [e class], e, (long)[(VersionException*)e code], [e message]);
            } else if ([e isKindOfClass:XKServerException.class]) {
                XKLog(@"XKServerException occured in a silent process with class[%@], description[%@] and detail[%@].", [e class], e, [(XKServerException*)e detail]);
            } else if ([e conformsToProtocol:@protocol(XKBusinessProblem)]) {
                id<XKBusinessProblem> bp = e;
                XKLog(@"A business problem occured in a silent process with class[%@], description[%@], type[%ld], brief[%@], detail[%@] and cause[%@].", bp.class, bp, (long)bp.type, bp.brief, bp.detail, bp.cause);
            } else {
                @throw e;
            }
        } // else NOP
    }
}

+ (void)syncExecuteTask:(XKDispatcherTask)task {
    [XKDispatcher syncExecuteTask:^{
        [self executeTask:task];
    }];
}

+ (void)syncExecuteRpcTask:(XKDispatcherTask)task {
    [XKDispatcher syncExecuteTask:^{
        [self executeRpcTask:task];
    }];
}

+ (void)asynExecuteTask:(XKDispatcherTask)task {
    [XKDispatcher asynExecuteTask:^{
        [self executeTask:task];
    }];
}

+ (void)asynExecuteRpcTask:(XKDispatcherTask)task {
    [XKDispatcher asynExecuteTask:^{
        [self executeRpcTask:task];
    }];
}

@end
