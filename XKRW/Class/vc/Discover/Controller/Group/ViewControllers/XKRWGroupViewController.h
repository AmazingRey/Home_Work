//
//  XKRWGroupViewController.h
//  XKRW
//
//  Created by Seth Chen on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWGroupItem.h"

typedef enum groupAuthType
{
   groupAuthNor = 0,        ///< 正常发帖
   groupAuthBin = 1,        ///< 禁言、 拉黑  不能发言
   groupAuthKickOut = 2,    ///< 被踢
   groupAuthNone = 3        ///< 未加入
}groupAuthType;

typedef enum postShowType
{
    postShowNor = 0,        ///< 正常显示
    postShowNone = 1,       ///< 没有内容 显示无内容提示
    postShowNetError = 2,   ///< 显示网络异常
}postShowType;

/**
 *  小组详情页面
 */
@interface XKRWGroupViewController : XKRWBaseVC

@property (nonatomic, assign) groupAuthType groupAuthType;

@property (nonatomic, strong) XKRWGroupItem *groupItem;

@property (nonatomic, copy) NSString *groupId;
/**
 *  减肥知识是否答题完成
 */
@property (nonatomic, assign) BOOL isCompeleteJfzs;
/**
 *  运动推荐是否答题完成
 */
@property (nonatomic, assign) BOOL isCompeleteYdtj;
/**
 *  每日励志是否答题完成
 */
@property (nonatomic, assign) BOOL isCompeleteLiZhi;
@end
