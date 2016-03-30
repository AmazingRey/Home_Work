//
//  XKRWGroupService.m
//  XKRW
//
//  Created by Seth Chen on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWGroupService.h"
#import "XKRWUserService.h"
static XKRWGroupService * shareInstance;

@implementation XKRWGroupService

+(instancetype)shareInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWGroupService alloc]init];
    });
    return shareInstance;
}




//  获取指定小组的帖子列表
- (NSMutableArray *)getPostlistWithGroupId:(NSString *)groupId
                                      type:(NSString *)type
                                      page:(NSInteger)page
                                      size:(NSInteger)size
{
    
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?groupid=%@&type=%@&page=%ld&size=%ld",kNewServer, XKRWPostlist, groupId,type,(long)page,(long)size];
    NSDictionary * data = [self syncBatchDataUrl:XKURL(groupUrl) andForm:nil andOutTime:10];
    
    
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString * statu = data[@"success"];
    if (statu.intValue != 1) {
        return nil;
    }
    NSDictionary *_data = data[@"data"];
    
    [[NSUserDefaults standardUserDefaults]setObject:_data[@"post_nums"] forKey:[NSString stringWithFormat:@"GROUPID_%@_%ld",groupId,(long)[[XKRWUserService sharedService] getUserId]]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for (NSDictionary *temp in _data[@"tops"]) {   // 置顶在前
        
        XKRWPostEntity *item = [XKRWPostEntity new];
        item.avatar = temp[@"avatar"];
        item.comment_nums = temp[@"comment_nums"];
        item.create_time = temp[@"create_time"];
        item.latest_comment_time = temp[@"latest_comment_time"];
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
        item.latest_comment_time = temp[@"latest_comment_time"];
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

//获取最新的活跃小组
- (XKRWGroupWithtServerTimeItem *)getActivitiesGroupsWithCtime:(NSString *)ctime
{
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?server_time=%@",kNewServer, XKRWActivitiesGroups, ctime];
    NSDictionary * data = [self syncBatchDataUrl:XKURL(groupUrl) andForm:nil andOutTime:10];
    
    XKRWGroupWithtServerTimeItem *  groupWithtServerTimeItem = [[XKRWGroupWithtServerTimeItem alloc]init];
    NSString * statu = data[@"success"];
    if (statu.intValue != 1) {
        return nil;
    }
    NSDictionary * dic = data[@"data"];
    groupWithtServerTimeItem.server_time = XKSTR(@"%@",dic[@"server_time"]);
    for (NSDictionary *temp in dic[@"data"]) {
        
        XKRWGroupItem *item = [XKRWGroupItem new];
        item.groupName = temp[@"name"];
        item.grouptype = temp[@"type"];
        item.groupIcon = temp[@"icon"];
        item.groupDescription = temp[@"description"];
        item.groupId = temp[@"id"];
        item.groupCTime = temp[@"ctime"];
        item.groupNum = temp[@"nums"];
        [groupWithtServerTimeItem.groupItems addObject:item];
    }
    return groupWithtServerTimeItem;
}

//小组详情
- (XKRWGroupItem *)getGroupDetailWithGroupId:(NSString *)groupId
{
    
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?gid=%@",kNewServer, XKRWGroupDetail,groupId];
    NSDictionary * data = [self syncBatchDataUrl:XKURL(groupUrl) andForm:nil andOutTime:10];
    
    
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString * statu = data[@"success"];
    if (statu.intValue != 1) {
        return nil;
    }
    NSDictionary *temp = data[@"data"];
    
    XKRWGroupItem *item = [XKRWGroupItem new];
    item.groupName = temp[@"name"];
    item.grouptype = temp[@"type"];
    item.groupIcon = temp[@"icon"];
    item.groupDescription = temp[@"description"];
    item.groupId = temp[@"id"];
    item.groupCTime = temp[@"ctime"];
    item.groupNum = temp[@"member_nums"];
    item.groupIs_add = temp[@"is_add"];
    item.groupHelp_nums = temp[@"help_nums"];
    item.postNums = temp[@"post_nums"];
    [mutArray addObject:item];
    return item;
}

- (NSDictionary *)checkGroupIdentifyWithGroupId:(NSString *)groupId
{
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?gid=%@",kNewServer, XKRWGroupIdentify,groupId];
    NSDictionary * data = [self syncBatchDataUrl:XKURL(groupUrl) andForm:nil andOutTime:30];
    
    return data;
}

// 检验用户是否已经加入小组
- (NSMutableArray *)getGroupHasrecord
{
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@",kNewServer, XKRWGroupHasRecord];
    NSDictionary * data = [self syncBatchDataUrl:XKURL(groupUrl) andForm:nil andOutTime:30];
    
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
        item.groupNum = temp[@"nums"];
        [mutArray addObject:item];
    }
    return mutArray;
    
}

// 批量加小组.
- (NSString *)addMutilGroupbyGroupIds:(NSArray *)groupids
{
    NSString * groupid_ = nil;
    for (NSString * str in groupids) {
        if (groupid_.length !=0) {
            groupid_ = XKSTR(@"%@,%@",groupid_,str);
        }else{
            groupid_ = str;
        }
    }
    
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?gids=%@",kNewServer, XKRWGroupAddMulti, groupid_];
    NSDictionary * dic = [self syncBatchDataUrl:[NSURL URLWithString:groupUrl] andForm:nil andOutTime:10];
    return XKSTR(@"%@",dic[@"success"]);
}

/**
 *  我的发布的帖子
 *
 *  @return
 */
- (NSMutableArray *)getMyReportPostWithNickName:(NSString *)nickName postId:(NSString *)postId size:(NSString *)size;
{
    NSString *groupUrl = [[NSString stringWithFormat:@"%@%@?nickname=%@&postid=%@&size=%@",kNewServer, XKRWPostMy, nickName, postId, size] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * data = [self syncBatchDataUrl:XKURL(groupUrl) andForm:nil andOutTime:10];
    
    
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString * statu = data[@"success"];
    if (statu.integerValue != 1) {
        return nil;
    }
    for (NSDictionary * temp in data[@"data"]) {
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
        item.latest_comment_time = temp[@"latest_comment_time"];
        [mutArray addObject:item];
    }
    return mutArray;
}

/**
 *  我的回复的帖子
 *
 *  @return
 */
- (NSMutableArray *)getMyReplyPostWithTime:(NSString *)ctime andSize:(NSString *)size
{
    NSString *groupUrl = [NSString stringWithFormat:@"%@%@?cmt_time=%@&size=%@",kNewServer, XKRWReplyMy, ctime, size];
    NSDictionary * data = [self syncBatchDataUrl:XKURL(groupUrl) andForm:nil andOutTime:10];
    
//1458097529 1457666052 
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString * statu = data[@"success"];
    if (statu.integerValue != 1) {
        return nil;
    }
    for (NSDictionary * temp in data[@"data"]) {
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
        item.latest_comment_time = temp[@"latest_comment_time"];
        item.user_latest_cmt_time = temp[@"user_latest_cmt_time"];
        item.del_status = [temp[@"del_status"] integerValue];
        [mutArray addObject:item];
    }
    return mutArray;
}


@end
