//
//  XKConfigUtil.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-11.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKConfigUtil : NSObject

// 取得配置string
+ (NSString *)stringForKey:(NSString *)key;
// 取得配置bool
+ (BOOL)boolForKey:(NSString *)key;

// 存入配置string
+ (void)setString:(NSString *)value forKey:(NSString *)key;
// 存入配置bool
+ (void)setBool:(BOOL)value forKey:(NSString *)key;

// 根据前后部分的key取得url
+ (NSURL *)urlForRootKey:(NSString *)rootKey subKey:(NSString *)subKey;

@end
