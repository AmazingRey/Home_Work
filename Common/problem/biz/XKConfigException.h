//
//  XKConfigException.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-24.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKRuntimeException.h"

@interface XKConfigException : XKRuntimeException

@property NSString *configKey;

+ (id)exceptionForMissedConfigWithConfigKey:(NSString *)configKey;
+ (id)exceptionForIllegalConfigWithConfigKey:(NSString *)configKey;

+ (id)exceptionWithConfigKey:(NSString *)configKey
                      detail:(NSString *)detail;
+ (id)exceptionWithConfigKey:(NSString *)configKey;

- (id)initForMissedConfigWithConfigKey:(NSString *)configKey;
- (id)initForIllegalConfigWithConfigKey:(NSString *)configKey;

- (id)initWithConfigKey:(NSString *)configKey
                 detail:(NSString *)detail;
- (id)initWithConfigKey:(NSString *)configKey;

@end
