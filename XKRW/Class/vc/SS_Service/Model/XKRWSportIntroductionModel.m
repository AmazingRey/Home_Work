//
//  XKRWSportIntroductionModel.m
//  XKRW
//
//  Created by 忘、 on 15-2-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWSportIntroductionModel.h"

@implementation XKRWSportIntroductionModel

- (NSString *)getSportRecommendString {
    
    NSMutableString *result = [NSMutableString string];
    for (NSString *sportName in _catsArray) {
        
        if ([sportName isKindOfClass:[NSString class]]) {
            
            if (result.length) {
            
                [result appendFormat:@"  %@", sportName];
            } else {
                [result appendFormat:@"%@", sportName];
            }
        }
    }
    return result;
}
@end
