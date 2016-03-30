//
//  XKRWSportResultModel.m
//  XKRW
//
//  Created by 忘、 on 15-2-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWSportResultModel.h"

@implementation XKRWSportResultModel

- (NSArray *)getDescriptionInTitle {
    
    NSString *hl = [_heart_lung substringFromIndex:2];
    NSString *power = [_power substringFromIndex:2];
    NSString *status = [_status substringToIndex:_status.length - 2];
    NSString *fp = [_fp substringFromIndex:2];
    
    return @[power, status, hl, fp];
}
@end
