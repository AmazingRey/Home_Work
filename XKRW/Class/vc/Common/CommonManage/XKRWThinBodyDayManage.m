//
//  XKRWThinBodyDayManage.m
//  XKRW
//
//  Created by 忘、 on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//  瘦身天数管理

#import "XKRWThinBodyDayManage.h"
#import "XKRWAlgolHelper.h"
#import "XKRWUserService.h"

static  XKRWThinBodyDayManage *shareInstance;

@implementation XKRWThinBodyDayManage

+ (instancetype) shareDayManage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[XKRWThinBodyDayManage alloc] init];
    });
    return shareInstance;
}

/** 达成目标需要的天数*/
- (NSInteger)dayOfAchieveTarget {
    return [XKRWAlgolHelper dayOfAchieveTarget];
}

/*达成目标体重的新方案开始了多少天*/
- (NSInteger ) newSchemeStartDayToAchieveTarget {
    return [XKRWAlgolHelper newSchemeStartDayToAchieveTarget];
}

/*5.2版本之前 方案未更新坚持天数开始了多少天*/
- (NSInteger) oldSchemeInsistDay{
    return [[XKRWUserService sharedService] getInsisted];
}



@end
