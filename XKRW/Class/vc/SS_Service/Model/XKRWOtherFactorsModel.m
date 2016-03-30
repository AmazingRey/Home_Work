//
//  XKRWOtherFactorsModel.m
//  XKRW
//
//  Created by 忘、 on 15-2-27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWOtherFactorsModel.h"

@implementation XKRWOtherFactorsModel

- (NSDictionary *)getTitleStrings {
    
    NSMutableDictionary *titles = [NSMutableDictionary dictionary];
    
    [titles setObject:_characterModel.result forKey:@"character"];
    
    NSMutableString *mutableString = [NSMutableString string];
    
    for (XKRWDescribeModel *model in _mindArray) {
        if (mutableString.length) {
            [mutableString appendFormat:@"\n%@", model.result];
        } else {
            [mutableString appendString:model.result];
        }
    }
    [titles setObject:mutableString forKey:@"mind"];
    
    mutableString = [NSMutableString string];
    for (XKRWDescribeModel *model in _reasonArray) {
        if (mutableString.length) {
            [mutableString appendFormat:@"\n%@", model.result];
        } else {
            [mutableString appendString:model.result];
        }
    }
    [titles setObject:mutableString forKey:@"main"];
    
    return titles;
}
@end
