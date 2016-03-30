//
//  XKRWFatReasonEntity.m
//  XKRW
//
//  Created by yaowq on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWFatReasonEntity.h"

@implementation XKRWFatReasonEntity

/*
 @property (nonatomic) int32_t question;
 //答案id 或 个数
 @property (nonatomic) int32_t answer;
 //类型 1为多选  0为单选
 @property (nonatomic) int32_t type;
*/
-(NSString *)description{
    return [NSString stringWithFormat:@"%d_%d_%d",_question,_answer,_type];
}
@end
