//
//  XKUtil.m
//  calorie
//
//  Created by Jiang Rui on 12-11-13.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "Reachability.h"
#import "XKConfigUtil.h"
#import "XKProblem.h"
#import "XKError.h"
#import "XKException.h"
#import "XKUtil.h"

@implementation XKUtil

+ (NSUserDefaults *)defaultUserDefaults {
    return [NSUserDefaults standardUserDefaults];
}

+ (BOOL)wholeString:(NSString *)string matchRegex:(NSString *)regex {
    NSError *error = NULL;
    NSRegularExpression *regexObj = [NSRegularExpression regularExpressionWithPattern:regex
                                                                              options:NSRegularExpressionAnchorsMatchLines
                                                                                error:&error];
    NSUInteger matchCount = [regexObj numberOfMatchesInString:string
                                                      options:0
                                                        range:NSMakeRange(0, string.length)];
    return (matchCount == 1);
}

+(BOOL)isNetWorkAvailable
{
    BOOL isExistenceNetWork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable://无网络
            isExistenceNetWork = FALSE;
            break;
        case ReachableViaWWAN://使用3G或RPRS
            isExistenceNetWork = TRUE;
            break;
        case ReachableViaWiFi://使用WiFi
            isExistenceNetWork = TRUE;
            break;
    }
    return isExistenceNetWork;
}

+ (void)handleUnexpectedProblem:(id)problem {
    if ([problem isKindOfClass:XKError.class]) {
        XKError *e = problem;
        XKLog(@"XKProblem -- 发生预想外问题：class[%@] description[%@] type[%ld] brief[%@] detail[%@] cause[%@]", [e class], e, (long)e.type, e.brief, e.detail, e.cause);
    } else if ([problem isKindOfClass:XKException.class]) {
        XKException *e = problem;
        XKLog(@"XKProblem -- 发生预想外问题：class[%@] description[%@] type[%ld] brief[%@] detail[%@] cause[%@] callStackSymbols[%@]", [e class], e, (long)e.type, e.brief, e.detail, e.cause, e.callStackSymbols);
    } else if ([problem conformsToProtocol:@protocol(XKProblem)]) {
            id<XKProblem> e = problem;
            XKLog(@"XKProblem -- 发生预想外问题：class[%@] description[%@] type[%ld] brief[%@] detail[%@] cause[%@]", [e class], e, (long)e.type, e.brief, e.detail, e.cause);
    } else if ([problem isKindOfClass:NSError.class]) {
        NSError *e = problem;
        XKLog(@"XKProblem -- 发生预想外问题：class[%@] description[%@] domain[%@] code[%ld] userInfo[%@]", [e class], e, e.domain, (long)e.code, e.userInfo);
    } else if ([problem isKindOfClass:NSException.class]) {
        NSException *e = problem;
        XKLog(@"XKProblem -- 发生预想外问题：class[%@] description[%@] name[%@] reason[%@] userInfo[%@] callStackSymbols[%@]", [e class], e, e.name, e.reason, e.userInfo, e.callStackSymbols);
    } else if ([problem conformsToProtocol:@protocol(NSObject)]) {
        XKLog(@"XKProblem -- 发生预想外问题：class[%@] description[%@]", [problem class], [problem description]);
    } else {
        XKLog(@"XKProblem -- 发生预想外问题：pointer[%p]", problem);
    }
    
#ifdef DEBUG
    @throw problem;
#endif
}

+ (void)openUrlInBrowser:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openCurrentIntroInAppStore {
    [self openIntroInAppStoreWithAppleIDForITC:[XKConfigUtil stringForKey:@"AppleIDForITC"]];
}

+ (void)openCurrentGradeInAppStore {
    [self openGradeInAppStoreWithAppleIDForITC:[XKConfigUtil stringForKey:@"AppleIDForITC"]];
}

+ (void)openIntroInAppStoreWithAppleIDForITC:(NSString *)appleIDForITC {
    NSString *url = [NSString stringWithFormat:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@", appleIDForITC];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openGradeInAppStoreWithAppleIDForITC:(NSString *)appleIDForITC {
    NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appleIDForITC];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+(void)executeCodeWhenSystemVersionAbove:(float)floor blow:(float)limit withBlock:(code)block {
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    float limitVersion = 0.f;
    if (limit < 1) {
        limitVersion = 100;
    }
    else {
        limitVersion = limit;
    }
    if ((systemVersion >= floor) && (systemVersion < limitVersion)) {
        block();
    }
}

+ (void)postRefreshGroupTeamInDiscover{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFLASHTEAMDATA" object:nil];
}

@end
