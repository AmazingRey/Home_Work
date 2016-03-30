//
//  XKConfigException.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-24.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKConfigException.h"

@implementation XKConfigException

+ (id)exceptionForMissedConfigWithConfigKey:(NSString *)configKey {
    return [[self alloc] initForMissedConfigWithConfigKey:configKey];
}

+ (id)exceptionForIllegalConfigWithConfigKey:(NSString *)configKey {
    return [[self alloc] initForIllegalConfigWithConfigKey:configKey];
}

+ (id)exceptionWithConfigKey:(NSString *)configKey
                      detail:(NSString *)detail  {
    return [[self alloc] initWithConfigKey:configKey detail:detail];
}

+ (id)exceptionWithConfigKey:(NSString *)configKey {
    return [[self alloc] initWithConfigKey:configKey];
}

- (id)initForMissedConfigWithConfigKey:(NSString *)configKey {
    return [self initWithConfigKey:configKey detail:[NSString stringWithFormat:@"The config is missed for the key [%@]", configKey]];
}

- (id)initForIllegalConfigWithConfigKey:(NSString *)configKey {
    return [self initWithConfigKey:configKey detail:[NSString stringWithFormat:@"The config is illegal for the key [%@]", configKey]];
}

- (id)initWithConfigKey:(NSString *)configKey
                 detail:(NSString *)detail {
    self = [self initWithDetail:detail];
    
    if (self) {
        self.configKey = configKey;
    }
    
    return self;
}

- (id)initWithConfigKey:(NSString *)configKey {
    return [self initWithConfigKey:configKey detail:[NSString stringWithFormat:@"Config problem occured for the key [%@].", configKey]];
}

@end
