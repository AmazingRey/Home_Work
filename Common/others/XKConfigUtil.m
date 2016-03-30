//
//  XKConfigUtil.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-11.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKAppInfoHelper.h"
#import "XKConfigUtil.h"

static NSMutableDictionary *_dataDict = nil;

@implementation XKConfigUtil

+ (void)initialize {
    if(self == XKConfigUtil.class) {
        _dataDict = [NSMutableDictionary dictionary];

        XKAppInfoReleaseType releaseType = [XKAppInfoHelper releaseType];
        
        if (releaseType == XKAppInfoReleaseTypeDevelopment) {
            [_dataDict setObject:@"10.10.18.195:9080/base" forKey:@"XKBaseHost"];
        } else if (releaseType == XKAppInfoReleaseTypeTest) {
            [_dataDict setObject:@"ti2.xikang.com/base" forKey:@"XKBaseHost"];
        } else if (releaseType == XKAppInfoReleaseTypeReleasePreview) {
            [_dataDict setObject:@"dli.xikang.com/base" forKey:@"XKBaseHost"];
        } else if (releaseType == XKAppInfoReleaseTypeRelease) {
            [_dataDict setObject:@"i.xikang.com/base" forKey:@"XKBaseHost"];
        }
        
        [_dataDict setObject:@"XKBaseHost" forKey:@"HostForAccountServiceClient"];
        [_dataDict setObject:@"XKBaseHost" forKey:@"HostForUserServiceClient"];
        [_dataDict setObject:@"XKBaseHost" forKey:@"HostForAppServiceClient"];
        [_dataDict setObject:@"XKBaseHost" forKey:@"HostForAuthServiceClient"];
        [_dataDict setObject:@"XKBaseHost" forKey:@"HostForFamilyServiceClient"];
    } // else NOP
}

+ (NSString *)stringForKey:(NSString *)key {
    return [_dataDict objectForKey:key];
}

+ (BOOL)boolForKey:(NSString *)key {
    return [[_dataDict objectForKey:key] boolValue];
}

+ (void)setString:(NSString *)value forKey:(NSString *)key {
    [_dataDict setValue:value forKey:key];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key {
    [_dataDict setValue:[NSNumber numberWithBool:value] forKey:key];
}

+ (NSURL *)urlForRootKey:(NSString *)rootKey subKey:(NSString *)subKey {
    NSString *rootUrl = [self stringForKey:rootKey];
    NSString *subUrl = [self stringForKey:subKey];
    NSString *url = [rootUrl stringByAppendingPathComponent:subUrl];
    
    NSURL *result = [NSURL URLWithString:url];
    return result;
}

@end
