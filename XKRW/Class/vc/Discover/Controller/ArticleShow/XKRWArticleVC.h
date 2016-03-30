//
//  XKRWArticleVC.h
//  XKRW
//
//  Created by 韩梓根 on 15/6/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWManagementEntity5_0.h"

@interface XKRWArticleVC : XKRWBaseVC

@property (nonatomic, strong) XKRWManagementEntity5_0 *entity;
@property (nonatomic, strong) NSString *contentURL;
@property (nonatomic, strong) NSString *naviTitle;
@property (nonatomic, strong) NSString *shareTitle;       /**<分享*/
@property (nonatomic, strong) NSString *shareURL;
@property (nonatomic, assign) BOOL hiddenShowRightBtn;    /**<是否显示分享按钮*/
@property (nonatomic) XKManagementSource source;
@property (nonatomic, strong) NSString *nid;

@end
