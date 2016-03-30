//
//  XKRWHabitModel.m
//  XKRW
//
//  Created by 忘、 on 15-2-27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWHabitModel.h"

@implementation XKRWHabitModel


- (XKRWDescribeModel *)otherDescribeModel {
    if (!_otherDescribeModel) {
        _otherDescribeModel = [[XKRWDescribeModel alloc]init];
    
    }
    
    return _otherDescribeModel;
}
@end
