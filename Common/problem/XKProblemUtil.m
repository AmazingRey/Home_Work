//
//  XKProblemUtil.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-19.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKAppInfoHelper.h"
#import "UncaughtExceptionHandler.h"
#import "XKProblemUtil.h"

@implementation XKProblemUtil

+ (void)installDefaultUnexpectedProblemHandler {
    [self installDefaultUnexpectedProblemHandlerWithFinalTask:nil];
}

+ (void)installDefaultUnexpectedProblemHandlerWithFinalTask:(void (^)(void))finalTask {
    XK_UncaughtExceptionHandlerShouldPopupDebugInfo = [XKAppInfoHelper isInformalReleaseType];
    XK_UncaughtExceptionHandlerFinalTask = finalTask;
    
    XK_InstallUncaughtExceptionHandler();
}

@end
