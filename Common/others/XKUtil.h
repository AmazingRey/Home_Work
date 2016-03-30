//
//  XKUtil.h
//  calorie
//
//  Created by Jiang Rui on 12-11-13.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^code)();

@interface XKUtil : NSObject

// 取得缺省的userDefaults
+ (NSUserDefaults *)defaultUserDefaults;

// 判断指定的字符串是否全字符串匹配指定的正则表达式
+ (BOOL)wholeString:(NSString *)string matchRegex:(NSString *)regex;

//判断网络状态
+(BOOL)isNetWorkAvailable;

+ (void)handleUnexpectedProblem:(id)problem;

// 在浏览器中打开指定URL
+ (void)openUrlInBrowser:(NSString *)url;

// 打开App Store中当前应用的介绍页面
+ (void)openCurrentIntroInAppStore;
// 打开App Store中当前应用的评分页面
+ (void)openCurrentGradeInAppStore;

// 打开App Store中指定ID的应用的介绍页面
+ (void)openIntroInAppStoreWithAppleIDForITC:(NSString *)appleIDForITC;
// 打开App Store中指定ID的应用的评分页面
+ (void)openGradeInAppStoreWithAppleIDForITC:(NSString *)appleIDForITC;

//根据系统版本选择执行代码
+(void)executeCodeWhenSystemVersionAbove:(float)floor blow:(float)limit withBlock:(code)block;

//发送小组变更的通知
+ (void)postRefreshGroupTeamInDiscover;

@end
