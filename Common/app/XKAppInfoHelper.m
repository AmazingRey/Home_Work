//
//  XKAppInfoHelper.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-19.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKUnsupportedMethodException.h"
#import "XKAppInfoHelper.h"

static XKAppInfoHelper *_instance = nil;

@interface XKAppInfoHelper ()

@property XKAppInfoReleaseType releaseType;

@end

@implementation XKAppInfoHelper

+ (XKAppInfoReleaseType)releaseType {
    return [self instance].releaseType;
}

+ (void)setReleaseType:(XKAppInfoReleaseType)releaseType {
    [self instance].releaseType = releaseType;
}

+ (BOOL)isInformalReleaseType {
    XKAppInfoReleaseType releaseType = [self releaseType];
    return (releaseType == XKAppInfoReleaseTypeDevelopment || releaseType == XKAppInfoReleaseTypeTest);
}

+ (XKAppInfoHelper *)instance {
    @synchronized (self) {
        if (!_instance) {
            _instance = [self new];
        }
    }
    
    return _instance;
}

- (id)init {
    @synchronized (self.class) {
        if (_instance) {
            XK_THROW_UNSUPPORTED_INSTANCE_METHOD_EXCEPTION_FOR_SINGLETON_PATTERN;
        } else {
            self = [super init];
            
            if (self) {
                _releaseType = XKAppInfoReleaseTypeRelease;
                _instance = self;
            }
        }
    }
    
    return self;
}

@end
