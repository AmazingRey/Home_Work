//
//  XKRWGroupItem.h
//  XKRW
//
//  Created by Seth Chen on 16/1/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWGroupItem : NSObject

@property (nonatomic, copy) NSString *groupId;         /**<小组id*/

@property (nonatomic, copy) NSString *groupName;       /**<小组名*/

@property (nonatomic, copy) NSString *groupNum;        /**<小组成员数*/

@property (nonatomic, copy) NSString *groupIcon;       /**<小组头像*/

@property (nonatomic, copy) NSString *groupDescription;/**<小组描叙*/

@property (nonatomic, copy) NSString *grouptype;       /**<小组类型*/

@property (nonatomic, copy) NSString *groupCTime;      /**<时间戳*/

@property (nonatomic,copy) NSString *postNums;          /**<帖子数*/

//  获取小组详情的接口返回新增两个字段。
@property (nonatomic, copy) NSString *groupIs_add;     /**<是否已加入小组*/

@property (nonatomic, copy) NSString *groupHelp_nums;  /**<新增求助贴数量*/

//  获取小组详情的接口返回新增一个字段。
@property (nonatomic, copy) NSString *rank;            /**<小组权重*/

@end



@interface XKRWGroupWithtServerTimeItem : NSObject

@property (nonatomic, strong) NSMutableArray <XKRWGroupItem *>*groupItems; /**<小组s*/

@property (nonatomic, copy) NSString *server_time;        /**<时间戳*/

@end