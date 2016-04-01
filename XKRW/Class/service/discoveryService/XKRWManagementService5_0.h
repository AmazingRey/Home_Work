//
//  XKRWManagementService5_0.h
//  XKRW
//
//  Created by Jack on 15/6/3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWManagementEntity5_0.h"
#import "XKRWArticleDetailEntity.h"
#import "XKRWCommentEtity.h"
@class XKRWOperationArticleListEntity;
@interface XKRWManagementService5_0 : XKRWBaseService
/**
 *  单例
 */
+(instancetype)sharedService;

#pragma mark - 发现
#pragma mark -

// 获取瘦身分享达人榜
- (NSDictionary *)getBlogRankListFromServer;
/**
 *  写评论
 *
 *  @param massege 评论内容
 *  @param blogid  文章id
 *  @param sid     收到评论的commentId
 *  @param fid     发送评论的commentId
 *  @param type    默认评论瘦身分享，2：评论帖子
 *
 *  @return “passed”： “commend”：XKRWReplyEntity， “success”：{“1”：成功，“0”：失败}
 */
- (NSMutableDictionary *)writeCommentWithMessage:(NSString *)massege Blogid:(NSString *)blogid sid:(NSInteger)sid fid:(NSInteger)fid type:(NSInteger)type;

/**
 *  从服务器获取评论列表
 *
 *  @param blogId 文章id
 *  @param index  起始comment_id
 *  @param rows   获取条数
 *  @param type   nil默认为“瘦身分享”，2为帖子
 *
 *  @return “commentNum”：评论总数，“comment”：评论详情Array
 */
- (NSMutableDictionary *)getCommentFromServerWithBlogId:(NSString *)blogId Index:(NSNumber *)index andRows:(NSNumber *)rows type:(NSNumber *)type;

- (XKRWCommentEtity *)getCommentEntityFromDic:(NSDictionary *)temp;

// 删除评论
- (NSDictionary *)deleteCommentWithBlogId:(NSString *)blogid andComment_id:(NSNumber *)comment_id;


/**
 *  从服务器获取瘦身分享推荐内容
 *
 *  @param page 列表页码
 *
 *  @return 瘦身分享推荐array
 */
- (NSMutableArray *)getBlogRecommendFromServerWithPage:(NSNumber *)page;
/**
 *  dictionaryArray to articleListEntityArray
 *
 *  @param array dictionaryArray
 *
 *  @return articleListEntityArray
 */
- (NSMutableArray *)dealDataArrayToArticleListEntityArray:(NSArray *)array;
/**
 *  从服务器获取瘦身分享话题列表内容
 *
 *  @param topic    话题类型
 *  @param pagetime 文章创建时间
 *
 *  @return 话题文章array
 */
- (NSMutableArray *)getBlogMoreArticlesWithTopic:(NSNumber *)topic AndPagetime:(NSNumber *)pagetime;
/**
 *  从服务器获取运营内容
 */

-(NSDictionary *)downloadArticleFromServer;

/**
 *  从本地获取运营内容
 */

-(NSMutableDictionary *)getArticleInfoFromDB;

/**
 *  保存下载的运营内容到本地
 */

-(void)saveDownloadArticleInfoToDB:(NSDictionary*)dic;

/**
 *  PK提交 1 正方 0 反方
 */

-(NSDictionary *)uploadTogetherPK:(NSString *)side andPKId:(NSString *)nid ;


#pragma mark - 更多文章
#pragma mark -

/**
 *  从服务器获取更多文章 并存进数据库
 */
-(void)getMoreArticleInfoFromServerType:(XKOperation)type andPage:(NSInteger)pages needLong:(BOOL)needLong;

/**
 *  根据类别 获取本地更多文章数据
 */

-(NSMutableArray *)getMoreArticleFromDBByCategory:(XKOperation)category;

/**
 *  从本地获取文章详细信息
 */

-(XKRWArticleDetailEntity *)getArticleDetailFromDBByCategory:(XKOperation)category andId:(NSString *)nid;

/**
 *  根据类别和nid获取  当天的文章内容
 */

-(XKRWManagementEntity5_0 *)getTodayArticleEntityBy:(XKOperation)category andNid:(NSString *)nid;

/**
 *  从服务器获取PK详情信息
 */

-(XKRWArticleDetailEntity *)getPKDetailFromServerByNid:(NSString *)nid;
/**
 *  获取PK、减肥知识、励志、运动推荐、名人瘦瘦、减肥达人秀
 *
 *  @param nid  文章id
 *  @param type

 pkinfo = PK
 
 jfzs = 减肥知识
 
 lizhi = 励志
 
 mrss = 名人瘦瘦
 
 jfdrx = 减肥达人秀
 
 lhyy=灵活运营
 *
 *  @return XKRWOperationArticleListEntity
 */
- (XKRWOperationArticleListEntity *)getArticleDetailFromServerByNid:(NSString *)nid andType:(NSString *)type;
- (NSDictionary *)getPKNum:(NSString *)nid;


/**
 *  浏览量统计--用于用户统计调用本接口时使用Silent模式
 */
//-(void)uploadPVForCategory:(XKOperation)category andNid:(NSString *)nid;

#pragma mark - 星星
#pragma mark -

/**
 *  从服务器获取用户星星数
 */

- (NSDictionary*)getUserStarNumFromServer;

/**
 *  设置当天 获得星星的文章
 *  complete = 1 表示获得了 星星变灰
 *  complete = 0 表示还没摘 星星
 */
-(void)setArticleStarToGet:(NSDictionary*)dic;

/**
 *  提交完成任务nid
 */
-(void)uploadCompleteTask:(NSString *)taskId;

#pragma mark - 设置为阅读过
#pragma mark -
/**
 * 设置为阅读过
 */
-(void)setReadStatusToDB:(XKRWManagementEntity5_0 *)entity;

-(void)setArticleDetailReadStatusToDB:(XKRWArticleDetailEntity *)entity andModule:(XKOperation)module;

#pragma mark - 工具
#pragma mark -

/**
 *  字符串 转  数字
 */

-(XKOperation)yunYingStringToNumber:(NSString*)string;

- (void) setHadPKNum:(NSString *)nid;

- (BOOL) checkHadPKNum:(NSString *)nid;


#pragma  --mark 5.2 发现页新接口

/**获取用户加入的小组信息*/
- (NSMutableArray *)getUserJoinTeamInfomation;

/**获取发现页运营数据状态*/
- (NSDictionary *)getDiscoverOperationState;

/**
 *  获取运营文章列表数据
 *
 *  @param type     运营文章类型
 *  @param page     运营文章页面
 *  @param pageSize 每页的大小
 *
 *  @return 返回运营文章实体数组
 */
- (NSMutableArray *)getOperationArticleListWithType:(NSString *)type andPage:(NSInteger)page andPageSize:(NSInteger) pageSize;


/**
 *  保存已读的运营文章信息到coredata
 *
 *  @param operationArticleTitle <#operationArticleTitle description#>
 *  @param operationArticleID    <#operationArticleID description#>
 */
- (void)setOperationArticleHadReadWithTitle:(NSString *)operationArticleTitle withID:(NSString *)operationArticleID;

/**
 *  判断该运营文章是否已读
 *
 *  @param operationArticleID <#operationArticleID description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)operationArticleHadReadWithOperationArticleID:(NSString *)operationArticleID;

@end
