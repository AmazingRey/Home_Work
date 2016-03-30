//
//  XKRWsportAdvise.m
//  XKRW
//
//  Created by 忘、 on 15-2-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWsportAdviseModel.h"

@implementation XKRWsportAdviseModel

- (NSArray *)getAdviseArray {
    
    NSMutableArray *temp = [NSMutableArray array];
    if (_guide1 && _guide1.length) {
        [temp addObject:_guide1];
    }
    if (_guide2 && _guide2.length) {
        [temp addObject:_guide2];
    }
    if (_introduction && _introduction.length) {
        [temp addObject:_introduction];
    }
    if (_aerobics && _aerobics.length) {
        [temp addObject:_aerobics];
    }
    if (_strength && _strength.length) {
        [temp addObject:_strength];
    }
    return temp;
}
@end
