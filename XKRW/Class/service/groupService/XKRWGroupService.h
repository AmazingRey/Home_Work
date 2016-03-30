//
//  XKRWGroupService.h
//  XKRW
//
//  Created by Seth Chen on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWPostEntity.h"
#import "XKRWGroupItem.h"

@interface XKRWGroupService : XKRWBaseService

+(instancetype )shareInstance;


/**
 *  获取指定小组的帖子列表
 *
 *  @param groupId <#groupId description#>
 *  @param type    <#type description#>
 *  @param page    <#page description#>
 *  @param size    <#size description#>
 */
- (NSMutableArray *)getPostlistWithGroupId:(NSString *)groupId
                          type:(NSString *)type
                          page:(NSInteger)page
                          size:(NSInteger)size;

/**
 *  获取最新的活跃小组
 *
 *  @param  ctime   以时间戳辨别当前时间
 *  @return XKRWGroupWithtServerTimeItem
 */
- (XKRWGroupWithtServerTimeItem *)getActivitiesGroupsWithCtime:(NSString *)ctime;

/**
 *  获取小组详情
 *
 *  @return XKRWGroupItem
 */
- (XKRWGroupItem *)getGroupDetailWithGroupId:(NSString *)groupId;

/**
 *  小组鉴权
 *
 *  @param groupId
 *
 *  @return
 */
- (NSDictionary *)checkGroupIdentifyWithGroupId:(NSString *)groupId;

/**
 *  我的发布的帖子
 *
 *  @param nickName 不传是查看自己发布的帖子
 *  @param postId   当前翻页的最小帖子 id（如果是第一页则不 传或者传 0
 *  @param size     size
 *
 *  @return
 */
- (NSMutableArray *)getMyReportPostWithNickName:(NSString *)nickName postId:(NSString *)postId size:(NSString *)size;

/**
 *  我的回复的帖子
 *
 *  @return
 */
- (NSMutableArray *)getMyReplyPostWithTime:(NSString *)ctime andSize:(NSString *)size;

/**
 *   检验用户是否已经加入小组
 *
 *  @param groupId
 *
 *  @return
 */
- (NSMutableArray *)getGroupHasrecord;

/**
 *  批量加入小组
 *
 *  @param groupids
 */
- (NSString *)addMutilGroupbyGroupIds:(NSArray *)groupids;


@end
