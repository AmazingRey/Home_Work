//
//  XKRWRecordSchemeEntity.m
//  XKRW
//
//  Created by Klein Mioke on 15/7/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWRecordSchemeEntity.h"

@implementation XKRWRecordSchemeEntity

- (NSDate *)date {
    if (!_date) {
        
        if (_create_time != 0) {
            _date = [NSDate dateWithTimeIntervalSince1970:_create_time];
        } else {
            _date = [NSDate date];
        }
    }
    return _date;
}

@end
