//
//  XKRWPostEntity.h
//  XKRW
//
//  Created by Seth Chen on 16/1/20.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWPostEntity : NSObject

@property (nonatomic, copy) NSString *avatar;           /**<帖子图*/

@property (nonatomic, copy) NSString *comment_nums;     /**<帖子评论数*/

@property (nonatomic, copy) NSString *goods;            /**<小组成员数*/


@property (nonatomic, copy) NSString *is_essence;       /**<精华*/

@property (nonatomic, copy) NSString *is_help;          /**<求助*/

@property (nonatomic, copy) NSString *is_hot;           /**<热门*/

@property (nonatomic, copy) NSString *is_pic;           /**<0无图 >0 几张图*/

@property (nonatomic, copy) NSString *is_top;           /**<置顶*/


@property (nonatomic, copy) NSString *level;            /**<级别*/

@property (nonatomic, copy) NSString *manifesto;        /**<小组类型*/

@property (nonatomic, copy) NSString *nickname;         /**<帖子名*/

@property (nonatomic, copy) NSString *postid;           /**<帖子id*/

@property (nonatomic, copy) NSString *title;            /**<帖子名*/

@property (nonatomic, copy) NSString *views;            /**<帖子id*/

@property (nonatomic, copy) NSString *create_time;      /**<帖子发布时间*/

@property (nonatomic, copy) NSString *latest_comment_time;      /**<帖子最后发言时间*/
/**
 *  当前用户在帖子最后发言时间
 */
@property (nonatomic, copy) NSString *user_latest_cmt_time;
@property (nonatomic,copy) NSString *postNums;          /**<帖子数*/
/**
 *  删除状态：“1”正常，“2”作者删除帖子，“3”管理员删除
 */
@property (nonatomic,assign) NSInteger del_status;
/**
 *  最后一条被赞的时间
 */
@property (nonatomic,assign) NSInteger praiseTime;
@end
