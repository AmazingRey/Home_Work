//
//  XKRWRecordFoodEntity.h
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWFoodEntity.h"

@interface XKRWRecordFoodEntity : XKRWFoodEntity
/**
 *  记录id
 */
@property (nonatomic,assign) NSInteger rid;
/**
 *  记录用户的id
 */
@property (nonatomic,assign) NSInteger uid;
/**
 *  记录类型, 1:早餐 2:午餐 3:晚餐 4:加餐
 */
@property (nonatomic,assign) RecordType recordType;
/**
 *  记录卡路里数
 */
@property (nonatomic,assign) NSInteger calorie;
/**
 *  记录重量  克为单位
 */
@property (nonatomic,assign) NSInteger number;
/**
 *  服务器数据ID，添加时serverid:0 修改时带上serverid:参数 __deprecated
 *
 *  5.0 new: 由于服务器不再返回serverid，存储格式改为纯json，serverid由客户端自定义，为10位时间戳。
 */
@property (nonatomic,assign) NSInteger serverid;
/**
 *  计量单位
 */
@property (nonatomic,assign) NSInteger unit;
/**
 *  记录时间
 */
@property (nonatomic,strong) NSDate *date;
/**
 *  是否同步到服务器，是为1，否为0
 */
@property (nonatomic) NSInteger sync;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryInRecordTable;

- (NSString *)description;


#pragma mark - 5.0 new 
/**
 *  用5.0新单位记录时，存储的单位
 */
@property (nonatomic, strong) NSString *unit_new;
/**
 *  5.0 新单位记录时，记录的数量，上传时需转换成一份旧记录的单位：xxxg（暂用克）和旧number（通过卡路里计算）
 */
@property (nonatomic) NSInteger number_new;

@end
