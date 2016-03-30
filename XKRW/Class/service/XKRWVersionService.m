//
//  XKRWVersionService.m
//  XKRW
//
//  Created by yaowq on 14-3-28.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWVersionService.h"
#import "XKRWBusinessException.h"
#import "ASIHTTPRequest.h"

#import "JSONKit.h"

#define LOCAL_VERSION_KEY @"LOCAL_VERSION_KEY"

static XKRWVersionService *shareInstance;

@implementation XKRWVersionService

+ (id)shareService
{
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        shareInstance = [[XKRWVersionService alloc] init];
    });
    return shareInstance;
}

- (void)checkVersion:(BOOL (^)(NSString *currentVersion, BOOL isNewUpdate, BOOL isNewSetUp))block
      needUpdateMark:(BOOL)mark {
    
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_VERSION_KEY];
    
    BOOL isNewUpdate = NO;
    BOOL isNewSetUp = NO;
    
    if (!oldVersion) {
        isNewSetUp = YES;
        isNewUpdate = YES;
        
    } else if (![oldVersion isEqualToString:versionString]) {
        isNewSetUp = NO;
        isNewUpdate = YES;
    }
    
    if (block) {
        if (block(versionString, isNewUpdate, isNewSetUp)) {
            
            if (mark) {
                [[NSUserDefaults standardUserDefaults] setObject:versionString forKey:LOCAL_VERSION_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}

- (void)doSomeFixWithInfo:(BOOL (^)(NSString *currentVersion, BOOL currentUserNeedExecute))block {
    
    int uid = (int)[XKRWUserDefaultService getCurrentUserId];
    
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSNumber *needExe = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%d_UPDATE_FIX_KEY", versionString, uid]];
    if (!needExe) {
        needExe = [NSNumber numberWithBool:YES];
    } else {
        if (!needExe.boolValue) {
            return;
        }
    }
    
    if (block && versionString.length) {
        if (block(versionString, needExe.boolValue)) {
            [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:[NSString stringWithFormat:@"%@_%d_UPDATE_FIX_KEY", versionString, uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)checkVersionToShowRedDot:(void (^)(BOOL isShowRedDot))block
{
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_VERSION_KEY];
    
    BOOL isShowRedDot = NO;
    
    if (![oldVersion isEqualToString:versionString]) {
        isShowRedDot = YES;
    }
    if (block) {
        block(isShowRedDot);
    }
}

@end
