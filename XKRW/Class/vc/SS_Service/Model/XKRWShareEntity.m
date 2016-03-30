//
//  XKRWShareEntity.m
//  XKRW
//
//  Created by zhanaofan on 13-12-18.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWShareEntity.h"

@implementation XKRWShareEntity
@synthesize uid,nickName,avator,gender,totalDays,reduceWeights,content,images,shareTime,favNum,commentNum,shareType;
- (id) init
{
    if (self = [super init]) {
        totalDays = 0;
        gender = 1;
        totalDays = 1;
        reduceWeights = 0.f;
        favNum = 0.f;
        commentNum = 0.f;
        shareType = shareTypeOfCustom;
    }
    return self;
}

@end
