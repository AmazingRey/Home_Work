//
//  XKRWFoodService.h
//  XKRW
//
//  Created by zhanaofan on 14-1-23.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWBaseService.h"
#import "XKRWFileManager.h"
#import "XKRWFoodEntity.h"
#import "NSDictionary+XKUtil.h"
#import "XKRWRecordEntity.h"


@interface XKRWFoodService : XKRWBaseService

+(id)shareService;
#pragma mark 网络任务


/*远程按分类获取食物列表*/
- (NSArray *) syncQueryFoodsWithCategory:(NSInteger) cateid page:(NSInteger)page pageSize:(NSInteger) pageSize order:(SchemeType)schemeType;
/*按关键词，远程获取食物列表*/
- (NSArray *) syncQueryFoodsWithKey:(NSString *)key page:(NSInteger)page pageSize:(NSInteger)  pageSize order:(SchemeType)schemeType;
/**
 *  根据id获取食物详情，4.0-5.0接口改变，需要更新方法。现接口已经合并运动和食物按id查询，以后如需改动，可整合接口
 *
 *  @param foodId 食物id
 *
 *  @return 食物实体对象
 */
- (XKRWFoodEntity*) syncQueryFoodWithId:(NSInteger)foodId;
/**
 *  通过ids批量获取食物实体对象数组
 *
 *  @param ids 食物id组成的字符串，以逗号隔开
 *
 *  @return 食物详情实体对象数组
 */
- (NSArray *)batchDownloadFoodWithIDs:(NSString *)ids;

/**
 *  解析食物字典，适配4.0到5.0的接口变化，之前旧接口字段全部改变、不能采用serProperty方法、删除字段及增加字段。
 *
 *  @param content    网络返回单条食物详情字典
 *  @param foodEntity 需要赋值的食物对象
 */
- (void)dealFoodDictionary:(NSDictionary *)content inFoodEntity:(XKRWFoodEntity *)foodEntity;


#pragma mark 本地任务
//获取本地缓存的食物信息
- (XKRWFoodEntity *) getFoodWithId:(NSInteger)foodId;
//保存食物到本地缓存
- (BOOL) saveFoodCache:(NSInteger) foodId withData:(NSData*)data;
//保存搜索历史列表
- (void) saveSearchKey:(NSString*)key keyType:(SchemeType)keyType;
//获取搜索历史列表
- (NSArray *) getSearchKey:(SchemeType)keyType;
/*清除所有的key*/
- (void) removeAllKeys:(SchemeType) keyType;
/*清除指定的key*/
- (void) removeSearchKey:(NSString *) key keyType:(SchemeType)keyTYpe;
/*获取分类*/
- (NSMutableArray *)fetchCategoryWithType:(NSInteger)type;

///*保存食物记录*/
//- (BOOL) saveRecord:(NSDictionary *)dict;
/*查询食物记录*/
- (NSArray*) getRecordWithDay:(NSString *) day;
- (XKRWRecordEntity*) getRecordWityId:(NSInteger)rid;
/*删除食物记录*/
- (BOOL) removeRecordWithId:(NSInteger) rid;

/**
 *  4.1新增
 */
/**
 *  保存食物详情
 *
 *  @param foodEntity 食物实例
 *
 *  @return 是否成功
 */
- (BOOL)saveFoodDetail:(XKRWFoodEntity *)foodEntity;
/**
 *  获取食物详情，根据食物id进行查询
 *
 *  @param foodId 食物id
 *
 *  @return 食物实例
 */
- (XKRWFoodEntity *)getFoodDetailByFoodId:(NSInteger)foodId;

/// 从数据库查询食物详情
- (XKRWFoodEntity *)getFoodDetailFromDBWithFoodId:(NSInteger)foodId;
/**
 *  获取营养元素key值数组
 */
- (NSArray *)getNutriArray;

#pragma mrak - 5.0 new
/**
 *  搜索食物
 *
 *  @param key      关键字
 *  @param page     页数
 *  @param pageSize 页大小
 *
 *  @return 食物实体对象数组
 */
- (NSArray *)searchFoodsWithKey:(NSString *)key page:(int)page pageSize:(int)pageSize;

@end
