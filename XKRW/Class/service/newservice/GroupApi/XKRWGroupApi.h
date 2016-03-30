//
//  XKRWGroupApi.h
//  XKRW
//
//  Created by Seth Chen on 16/1/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "ServiceBase5_1_2.h"

@interface XKRWGroupApi : ServiceBase5_1_2



#pragma mark - 新版接口==========================================================================
/**
 *   获取小组列表  type 0 全部 1. 普通 2 活动
 *
 *  @param 
 */
- (void )getAllGroupBytype:(int)type;

/**
 *  获取所有的小组 -- 新增加  分权重排序 增加分页
 *
 *  @param type
 *  @param size
 *  @param joinGroupWithGroupId
 *  @param groupId
 */
- (void )getAllGroupBytype:(int)type size:(int)size rank:(NSString *)rank;

/**
 *  加入小组 没有回调 直接返回
 *
 *  @param groupId
 */
- (NSDictionary *)joinGroupWithGroupId:(NSString *)groupId;

/**
 *  加入小组 有回调
 *
 *  @param groupId
 */
- (void)joinTheGroupWithGroupId:(NSString *)groupId;

/**
 *  退出小组
 *
 *  @param groupId
 */
- (void)signOutGroupWithGroupId:(NSString *)groupId;

/**
 *  获取指定小组的帖子列表
 *
 *  @param groupId <#groupId description#>
 *  @param type    <#type description#>
 *  @param page    <#page description#>
 *  @param size    <#size description#>
 */
- (void)getPostlistWithGroupId:(NSString *)groupId
                          type:(NSString *)type
                          page:(int)page
                          size:(int)size;

#pragma mark - 老版版接口==========================================================================


@end
