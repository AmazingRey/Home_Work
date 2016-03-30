//
//  XKRWRecordCustomEntity.h
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWCustomBaseEntity.h"

@interface XKRWRecordCustomEntity : NSObject
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
/**
 *  记录id
 */
@property (nonatomic) uint32_t rid;
/**
 *  记录用户的id
 */
@property (nonatomic) uint32_t uid;
/**
 *  记录的数量
 */
@property (nonatomic) NSInteger number;
/**
 *  记录的卡路里
 */
@property (nonatomic) NSInteger calorie;
/**
 *  记录的类型, 0:运动 1:早餐 2:午餐 3:晚餐 4:加餐
 */
@property (nonatomic) RecordType recordType;
/**
 *  服务器数据id, 添加时serverid:0 修改时带上serverid:参数
 */
@property (nonatomic) uint32_t serverid;
/**
 *  记录时间
 */
@property (nonatomic, strong) NSDate *date;
/**
 *  是否同步到服务器，是为1，否为0
 */
@property (nonatomic) int sync;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)dictionaryInRecordTable;

@end
