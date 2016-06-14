//
//  XKRWTaobaoVC.h
//  XKRW
//
//  Created by y on 15-1-4.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWBaseVC.h"
#import "XKRWManagementEntity.h"





@interface XKRWNewWebView : XKRWBaseVC


@property(nonatomic,strong)UIWebView  *xkWebView;
@property(nonatomic,strong)NSString   *contentUrl;
@property(nonatomic,strong)NSString   *webTitle;

@property(nonatomic,strong)NSString *module; //模块名称

@property (nonatomic,strong) NSString *date;//运营日期

@property (nonatomic,strong)NSDictionary *content;
@property (nonatomic,strong) XKRWManagementEntity *entity;

@property (nonatomic ,strong) NSString *shareURL;
@property (nonatomic, strong) NSString *shareTitle;

@property (nonatomic,assign) BOOL showType;  //弹出类型

@property (nonatomic,assign) BOOL isHidenRightNavItem;

@property (nonatomic,assign) BOOL isFromPostDetail;



@end
