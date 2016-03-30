//
//  XKRWUserArticleVC.h
//  XKRW
//
//  Created by Klein Mioke on 15/10/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@class XKRWUserArticleEntity;

@interface XKRWUserArticleVC : XKRWBaseVC
/**
 *  文章实体对象
 */
@property (nonatomic, strong) XKRWUserArticleEntity *articleEntity;
/**
 *  文章id，如果传入id，会从网络下载相应id地文章，而忽略传进来的文章对象。
 */
@property (nonatomic, strong) NSString *aid;

/**
 *  用户喜欢的文章是否已被删除
 */
@property(nonatomic,assign) BOOL likeArticleDeleted;

/**
 *  预览模式
 */
@property (nonatomic, assign) BOOL isPreview;
/**
 *  是否显示“删除”按钮，默认不显示
 */
@property (nonatomic, assign) BOOL showDeleteButton;

@end
