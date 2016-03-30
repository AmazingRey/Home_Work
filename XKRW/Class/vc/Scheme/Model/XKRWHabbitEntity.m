//
//  XKRWHabbitEntity.m
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWHabbitEntity.h"

@implementation XKRWHabbitEntity

- (instancetype)initWithHid:(NSInteger)hid andName:(NSString *)name andSituation:(NSInteger)situation
{
    if (self = [super init]) {
        _hid = hid;
        _name = name;
        _situation = situation;
    }
    return self;
}

- (NSArray *)getButtonImages {
    
    if (_hid == 6 || _hid == 4 || _hid == 5) {
        return @[@"habit_ic_4", @"habit_ic_4_p"];
    }
    
    return @[[NSString stringWithFormat:@"habit_ic_%d", (int)_hid],
             [NSString stringWithFormat:@"habit_ic_%d_p", (int)_hid]];
}
@end
