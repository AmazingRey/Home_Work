//
//  XKAppInfoHelper.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-19.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>

enum XKAppInfoReleaseType {
    XKAppInfoReleaseTypeRelease = 0,
    XKAppInfoReleaseTypeReleasePreview,
    XKAppInfoReleaseTypeTest,
    XKAppInfoReleaseTypeDevelopment
};
typedef enum XKAppInfoReleaseType XKAppInfoReleaseType;

@interface XKAppInfoHelper : NSObject

+ (XKAppInfoReleaseType)releaseType;
+ (void)setReleaseType:(XKAppInfoReleaseType)releaseType;

+ (BOOL)isInformalReleaseType;

+ (XKAppInfoHelper *)instance;

@end
