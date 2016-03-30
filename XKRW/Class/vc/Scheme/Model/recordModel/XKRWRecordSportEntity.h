//
//  XKRWRecordSportEntity.h
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSportEntity.h"

@interface XKRWRecordSportEntity : XKRWSportEntity
/**
 *  记录id
 */
@property (nonatomic) uint32_t rid;
/**
 *  记录用户的id
 */
@property (nonatomic) uint32_t uid;
/**
 *  记录类型，运动:0
 */
@property (nonatomic) RecordType recordType;
/**
 *  记录卡路里数
 */
@property (nonatomic) NSInteger calorie;
/**
 *  运动时长
 */
@property (nonatomic) NSInteger number;
/**
 *  计量单位
 */
@property (nonatomic) uint32_t unit;
/**
 *  添加时serverid:0 修改时带上serverid:参数
 */
@property (nonatomic) uint32_t serverid;
/**
 *  运动图片URL
 */
@property (nonatomic ,strong) NSString *imageURL;
/**
 *  记录时间
 */
@property (nonatomic, strong) NSDate *date;
/**
 *  是否同步到服务器，是为1，否为0
 */
@property (nonatomic) int sync;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryInRecordTable;

@end
