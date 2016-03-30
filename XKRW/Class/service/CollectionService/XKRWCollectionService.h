//
//  XKRWCollectionService.h
//  XKRW
//
//  Created by Jack on 15/5/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWCollectionEntity.h"

#define SUCCESS @"success"
#define ERROR @"error"



@interface XKRWCollectionService : XKRWBaseService

+ (id)sharedService;

#pragma mark - DB Operation 数据库操作
#pragma mark -
/**
 *  保存收藏到数据库
 */
- (BOOL)collectToDB:(XKRWCollectionEntity *)entity;

/**
 *  从数据库删除收藏记录
 */
- (BOOL)deleteCollectionInDB:(XKRWCollectionEntity *)entity;

/**
 *  从数据库按照分类查询,收藏的类型type：0 文章，1 食物，2 运动
 */
- (NSMutableArray *)queryCollectionWithType:(NSInteger)type;

/**
 *  从数据库按照 CollectType分类和ID查询 （用于不能重复收藏）
 */
-(BOOL)queryCollectionWithCollectType:(NSInteger)type andNid:(NSInteger)nid;

/**
 *  返回 查询结果
 */
-(NSDictionary *)queryByCollectType:(NSInteger)type andNid:(NSInteger)nid;


#pragma mark - Save to remote  保存数据到服务器
#pragma mark - 
/**
 *  保存收藏消息到服务器
 *
 *  @param entity <#entity description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)saveCollectionToRemote:(XKRWCollectionEntity *)entity;

#pragma mark - Delete from remote
/**
 *  从服务器删除收藏数据
 *
 *  @param collectType 收藏类型
 *  @param date        日期
 *
 *  @return <#return value description#>
 */
- (BOOL)deleteFromRemoteWithCollecType:(NSInteger)collectType date:(NSDate *)date;

/**
 *  从服务器删除收藏数据
 *
 *  @param entity <#entity description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)deleteCollectionFromRemote:(XKRWCollectionEntity *)entity;



#pragma --mark 重写收藏的数据接口
/**
 *  从网络下载收藏数据
 *
 *  @param collectType 收藏类型
 *  @param date        日期
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)downloadFromRemoteType:(NSInteger)collectType date:(NSDate *)date;

/**
 *  获取收藏数据
 */
- (void)getCollectionRemoteData;

@end
