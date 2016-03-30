//
//  XKRWFatReasonEntity.h
//  XKRW
//
//  Created by yaowq on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 *    #important
 *    当type = 0 时， question 的结果为个数 而非答案id
 */

@interface XKRWFatReasonEntity : NSObject
//问题id
@property (nonatomic) int32_t question;
//答案id 或 个数
@property (nonatomic) int32_t answer;
//类型 1为多选  0为单选
@property (nonatomic) int32_t type;

@property (nonatomic) NSInteger u_id;

@property (nonatomic) int32_t sync;

-(NSString *) description;

@end
