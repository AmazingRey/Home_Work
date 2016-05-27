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
    
    switch (_hid) {
        case 1:
            return @[@"habit_ic_oily_",@"habit_ic_oily_p_"];
            break;
        case 2:
            return @[@"habit_ic_snacks_",@"habit_ic_snacks_p_"];
            break;
        case 3:
            return @[@"habit_ic_drink_",@"habit_ic_drink_p_"];
            break;
        case 7:
            return @[@"habit_ic_fat_",@"habit_ic_fat_p_"];
            break;
        case 8:
            return @[@"habit_ic_nut_",@"habit_ic_nut_p_"];
            break;
        case 9:
            return @[@"habit_ic_nightsnack_",@"habit_ic_nightsnack_p_"];
            break;
        case 10:
            return @[@"habit_ic_late_",@"habit_ic_late_p_"];
            break;
        case 11:
            return @[@"habit_ic_fast_",@"habit_ic_fast_p_"];
            break;
        case 12:
            return @[@"habit_ic_inordinate_",@"habit_ic_inordinate_p_"];
            break;
        case 13:
            return @[@"habit_ic_hypomotility_",@"habit_ic_hypomotility_p_"];
            break;
        case 14:
            return @[@"habit_ic_littlepractice_",@"habit_ic_littlepractice_p_"];
            break;
        default:
            return @[@"habit_ic_alcohol_", @"habit_ic_alcohol_p_"];
            break;
    }
    
    if (_hid == 6 || _hid == 4 || _hid == 5) {
        
    }
    
    return @[[NSString stringWithFormat:@"habit_ic_%d", (int)_hid],
             [NSString stringWithFormat:@"habit_ic_%d_p", (int)_hid]];
}
@end
