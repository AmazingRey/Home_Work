//
//  XKRWGroupApi.m
//  XKRW
//
//  Created by Seth Chen on 16/1/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWGroupApi.h"
#import "XKRWGroupItem.h"
#import "XKRWBaseService.h"
#import "XKRWPostEntity.h"

@implementation XKRWGroupApi



#pragma mark - 新版接口==========================================================================
//获取所有的小组
- (void )getAllGroupBytype:(int)type
{
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?type=%d",kNewServer,XKRWAllGroup,type];
    
//    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil,nil];
    [self startAsynchronizedPostMethodwithCompleteUrl:groupUrl andParamer:nil andResponseMethod:@selector(getAllGroupRes:)];
}

- (NSMutableArray *)getAllGroupRes:(NSDictionary *)data
{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString * statu = data[@"success"];
    if (statu.intValue != 1) {
        return nil;
    }
    for (NSDictionary *temp in data[@"data"]) {
        
        XKRWGroupItem *item = [XKRWGroupItem new];
        item.groupName = temp[@"name"];
        item.grouptype = temp[@"type"];
        item.groupIcon = temp[@"icon"];
        item.groupDescription = temp[@"description"];
        item.groupId = temp[@"id"];
        item.groupCTime = temp[@"ctime"];
        item.groupNum = temp[@"member_nums"];
        item.rank = XKSTR(@"%@",temp[@"rank"]);
        [mutArray addObject:item];
    }
    return mutArray;
}


//获取所有的小组 -- 新增加  分权重排序 增加分页
- (void )getAllGroupBytype:(int)type size:(int)size rank:(NSString *)rank
{
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?type=%d&size=%d&rank=%@",kNewServer,XKRWAllCGroup,type, size, rank];
    //    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil,nil];
    [self startAsynchronizedPostMethodwithCompleteUrl:groupUrl andParamer:nil andResponseMethod:@selector(getAllGroupRes:)];
}


//加入小组
- (NSDictionary * )joinGroupWithGroupId:(NSString *)groupId
{
    __block NSDictionary * dic;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSString *groupUrl = [NSString stringWithFormat:@"%@%@?gid=%@",kNewServer, XKRWGroupAdd, groupId];
        dic = [self startSynchronizedPostMethodwithCompleteUrl:groupUrl andParamer:nil];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    return dic;
}

//加入小组
- (void)joinTheGroupWithGroupId:(NSString *)groupId
{
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?gid=%@",kNewServer, XKRWGroupAdd, groupId];
    [self startAsynchronizedPostMethodwithCompleteUrl:groupUrl andParamer:nil andResponseMethod:@selector(getJoinGroupRes:)];
}

- (NSDictionary *)getJoinGroupRes:(NSDictionary *)data
{
    return data;
}


//退出小组
- (void)signOutGroupWithGroupId:(NSString *)groupId
{
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?gid=%@",kNewServer, XKRWGroupRemove, groupId];
    [self startAsynchronizedPostMethodwithCompleteUrl:groupUrl andParamer:nil andResponseMethod:@selector(getSignOutGroupRes:)];
}

- (NSDictionary *)getSignOutGroupRes:(NSDictionary *)data
{
    return data;
}

// 获取小组内的帖子列表
- (void)getPostlistWithGroupId:(NSString *)groupId
                          type:(NSString *)type
                          page:(int)page
                          size:(int)size
{
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?groupid=%@&type=%@&page=%d&size=%d",kNewServer, XKRWPostlist, groupId,type,page,size];
    [self startAsynchronizedPostMethodwithCompleteUrl:groupUrl andParamer:nil andResponseMethod:@selector(getPostlistRes:)];
}

- (NSMutableArray *)getPostlistRes:(NSDictionary *)data
{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString * statu = data[@"success"];
    if (statu.intValue != 1) {
        return nil;
    }
    NSDictionary *_data = data[@"data"];
    for (NSDictionary *temp in _data[@"tops"]) {   // 置顶在前
        
        XKRWPostEntity *item = [XKRWPostEntity new];
        item.avatar = temp[@"avatar"];
        item.comment_nums = temp[@"comment_nums"];
        item.create_time = temp[@"create_time"];
        item.goods = temp[@"goods"];
        item.is_essence = temp[@"is_essence"];
        item.is_help = temp[@"is_help"];
        item.is_hot = temp[@"is_hot"];
        item.is_pic = temp[@"is_pic"];
        item.is_top = temp[@"is_top"];
        item.level = temp[@"level"];
        item.manifesto = temp[@"manifesto"];
        item.nickname = temp[@"nickname"];
        item.postid = temp[@"postid"];
        item.title = temp[@"title"];
        item.views = temp[@"views"];
        item.nickname = temp[@"nickname"];
        [mutArray addObject:item];
    }
    for (NSDictionary *temp in _data[@"posts"]) {
        
        XKRWPostEntity *item = [XKRWPostEntity new];
        item.avatar = temp[@"avatar"];
        item.comment_nums = temp[@"comment_nums"];
        item.create_time = temp[@"create_time"];
        item.goods = temp[@"goods"];
        item.is_essence = temp[@"is_essence"];
        item.is_help = temp[@"is_help"];
        item.is_hot = temp[@"is_hot"];
        item.is_pic = temp[@"is_pic"];
        item.is_top = temp[@"is_top"];
        item.level = temp[@"level"];
        item.manifesto = temp[@"manifesto"];
        item.nickname = temp[@"nickname"];
        item.postid = temp[@"postid"];
        item.title = temp[@"title"];
        item.views = temp[@"views"];
        item.nickname = temp[@"nickname"];
        [mutArray addObject:item];
    }
    return mutArray;
}


#pragma mark - 老版接口==========================================================================

@end
