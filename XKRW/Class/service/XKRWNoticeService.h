//
//  XKRWNoticeService.h
//  XKRW
//
//  Created by 忘、 on 15/8/3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"

@interface XKRWNoticeService : XKRWBaseService

/**
 *  创建消息单例
 *
 *  @return <#return value description#>
 */
+(instancetype)sharedService;

/**
 *  app关闭状态下接收到远程通知处理
 *
 *  @param notificationInfo 通知消息
 */
- (void)appCloseStateDealNotificationWithInfo:(NSDictionary *)notificationInfo;

/**
 *  app打开状态下接收到远程通知处理
 *
 *  @param notificationInfo 通知消息
 */
- (void)appOpenStateDealNotification:(NSDictionary *)notificationInfo;
/**
 *  App处于关闭状态下 注册远程通知监听机制
 *
 *  @param viewController <#viewController description#>
 *  @param window         <#window description#>
 */
- (void)addAppCloseStateNotificationInViewController:(UIViewController *) viewController andKeyWindow:(UIWindow *)window;
/**
 *  注册远程消息监听机制
 *
 *  @param viewController 在哪一个VC上注册监听
 *  @param window         消息显示的window
 */
- (void)addNotificationInViewController:(UIViewController *) viewController andKeyWindow:(UIWindow *)window;


/**
 *  获取消息详情
 *
 *  @param blogId    blogId
 *  @param commentId 评论ID
 *
 *  @return 消息详情
 */
- (NSDictionary *)getNoticeDetailDataWithBlogId:(NSString *)blogId andCommentId:(NSString *)commentId andNoticeType:(NSInteger) type;

/**
 *  获取 评论列表
 *
 *  @return 评论列表
 */
- (NSMutableArray *) getNoticeListFromDatabaseAndUserId:(NSInteger) userid andNoticeType:(NSString *) noticeTypeString;



- (NSMutableArray *) getBePraiseFromDatabaseWithUserId:(NSInteger) userid;

/**
 *  获取瘦瘦客服信息
 *
 *  @param userid <#userid description#>
 *
 *  @return －1（表示没有瘦瘦客服信息） 0 （表示有瘦瘦客服聊天信息 但是没有未读信息） >0 未读信息
 */
- (NSInteger) ShouShouServerChat:(NSInteger) userid;

/**
 *  设置消息已读
 *
 *  @param uid 用户ID
 */
- (BOOL) setAllNoticeHadRead:(NSInteger)uid;

- (BOOL) setChatNoticeHadRead:(NSInteger)uid;

- (BOOL) setSystemNoticeHadRead:(NSInteger)uid;

/**
 *  设置单条消息为已读状态
 *
 *  @param uid 用户ID
 *  @param nid 消息ID
 */
- (BOOL) setCurrentNoticeHadRead:(NSInteger)uid andNid:(NSInteger)nid;
/**
 *  获取未读的被喜欢消息的条数
 *
 *  @return 获得未读的被喜欢条数
 */
- (NSInteger) getUnreadBePraisedNoticeNum;

/**
 *  删除未读的被赞消息
 *
 *  @return 删除成功返回YES 删除失败返回NO
 */
- (BOOL)deleteUnreadBePraisedNotice;

/**
 *  获取未读的评论消息条数 和 系统消息数
 *
 *  @return 返回未读的评论消息条数 和 系统消息数
 */
- (NSInteger) getUnreadCommentOrSystemNoticeNum;

/**
 *  获取所有的未读消息条数
 *
 *  @return 返回所有的未读消息条数
 */
- (NSInteger) getAllUnreadNoticeNum;

/**
 *  删除消息
 *
 *  @param nid 消息id
 *
 *  @return 成功删除 返回YES  失败返回NO
 */
- (BOOL)deleteNoticeWithNid:(NSInteger)nid;

/**
 *  从服务器获取所有的消息数据
 *
 *  @param time 从某个时间开始
 *  @param type 消息的类型
 *
 *  @return 消息数据
 */
- (NSDictionary *)getAllNoticeInfomationFromNetWorkWithTime:(NSNumber *)time AndMessageType:(NSString *)type;

/**
 *  将点赞消息 或 评论消息 插入数据库
 *
 *  @param noticeDic 消息
 */
- (void)insertNoticeListToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push;

/**
 *  将 瘦瘦客服 信息插入数据库
 *
 *  @param noticeDic
 *  @param uid    用户id
 *  @param read   是否已读
 *  @param push   是否是推送
 */
- (void)insertShouShouServicerNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push;

/**
 *  将 对瘦瘦客服 的回复信息 插入数据库
 *
 *  @param replayInfo 回复信息
 *  @param uid        用户id
 */
- (void)insertUserToShoushouServiceNoticeToDatabase:(NSString *)replayInfo andUserId:(NSInteger)uid ;


/**
 *  将帖子评论消息插入数据库
 *
 *  @param noticeDic <#noticeDic description#>
 *  @param uid       <#uid description#>
 *  @param read      <#read description#>
 *  @param push      <#push description#>
 */
- (void)insertPostCommentNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push;


/**
 *  将系统消息插入数据库
 *
 *  @param noticeDic 消息
 *  @param uid       用户ID
 *  @param read      设置是否已读
 */
- (void)insertSystemNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push;


/**
 *  获取瘦瘦客服聊天信息
 *
 *  @param uid 用户ID
 */
- (NSArray *)getAllShouShouServerAndUserReplayFromDatabaseWithUserId:(NSInteger) uid;


/**
 *  发送聊天信息 给瘦瘦客服
 *
 *  @param Content
 *
 *  @return 是否发送成功
 */
- (BOOL) sendChatInfoToShouShouServer:(NSString *)content;

/**
 *  插入拉取的被赞信息
 *
 *  @param noticeDic <#noticeDic description#>
 *  @param uid       <#uid description#>
 *  @param read      <#read description#>
 *  @param push      <#push description#>
 */
- (void)insertThumpNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push;


- (void)insertDeleteNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push;

@end
