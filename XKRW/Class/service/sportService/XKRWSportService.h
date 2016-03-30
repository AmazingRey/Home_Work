//
//  XKRWSportService.h
//  XKRW
//
//  Created by zhanaofan on 14-3-4.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWBaseService.h"
#import "XKRWSportEntity.h"

@interface XKRWSportService : XKRWBaseService

+(id)shareService;
/**
 *  通过运动id数组获取运动详情
 *
 *  @param ids 运动id数组
 *
 *  @return 运动实体对象数组
 */
- (NSArray *)getSportDetailByIds:(NSArray *)ids;
/**
 *  通过id在本地获取运动详情
 *
 *  @param sportId 运动id
 *
 *  @return 运动实体对象
 */
- (XKRWSportEntity *)sportDetailWithId:(uint32_t)sportId;
- (XKRWSportEntity *)sportDetailWithId:(uint32_t)sportId andSportName:(NSString * )name;
/**
  * 通过运动id远程获取涌动详情
 */
- (XKRWSportEntity *) syncQuerySportWithId:(uint32_t)sportId;
/**
 *  批量下载运动详情
 *
 *  @param ids 运动id组合的字符串，以','隔开
 *
 *  @return 运动实体对象数组
 */
- (NSArray *)batchDownloadSportWithIDs:(NSString *)ids;

- (void)silenceBatchDownloadSportWithIDs:(NSString *)ids;

/*获取运动的分类*/
- (NSMutableArray*) sportCateList;
/*根据分类，获取运动列表*/
- (NSArray *) syncQuerySportWithCategory:(uint32_t) cateId;
/*根据搜索关键词，获取运动列表*/
- (NSArray *) syncQuerySportWithKey:(NSString*) key page:(uint32_t)page pageSize:(uint32_t) pageSize ;
///*随机获取运动*/
//- (XKRWSchemeEntity *)randomSportSchem:(uint32_t)sid;

#pragma mark - 5.0 new

- (NSArray *)searchSportWithKey:(NSString *)key page:(int)page pageSize:(int)pageSize;

- (void)dealSportDataWithDictionary:(NSDictionary *)value inEntity:(XKRWSportEntity *)sportEntity;

@end
