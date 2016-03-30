//
//  XKRWCustomBaseEntity.h
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWCustomBaseEntity : NSObject
/**
 *  自定义食物或运动名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  自定义食物或运动的单位
 */
@property (nonatomic, strong) NSString *unit;
/**
 *  自定义食物或运动的id
 */
@property (nonatomic) uint32_t custom_id;


@end
