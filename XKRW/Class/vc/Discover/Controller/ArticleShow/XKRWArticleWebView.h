//
//  XKRWArticleWebView.h
//  XKRW
//
//  Created by Seth Chen on 16/2/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@class XKRWOperationArticleListEntity;

@interface XKRWArticleWebView : XKRWBaseVC

@property (nonatomic, copy) NSString *requestUrl;   ///< web url
@property (nonatomic, copy) NSString *navTitle;     ///< nav title
@property (nonatomic, copy) NSString *nid;          ///< nid
@property (nonatomic, strong) XKRWOperationArticleListEntity *entity; ///< entity
@property (nonatomic, assign) BOOL hiddenShowRightBtn;    ///<  是否显示分享按钮
@property XKManagementSource source;                ///< 来源
@property XKOperation category;                     ///< 类别

@property BOOL isComplete;                          ///< 是否完成答题或者宣誓
@end
