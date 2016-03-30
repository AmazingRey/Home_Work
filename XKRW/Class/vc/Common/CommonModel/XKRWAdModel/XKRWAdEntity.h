//
//  XKRWAdEntity.h
//  XKRW
//
//  Created by y on 14-11-13.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XKRWAdService.h"

@interface XKRWAdEntity : NSObject

/// 广告img地址
@property(nonatomic,strong)NSString *imgsrc;

/// 外链网址
@property(nonatomic,strong)NSString *imgurl;

/// 广告位的标识
@property(nonatomic,strong)NSString *position_code;

/// 广告位置
@property (nonatomic) XKRWAdPostion position;

/// 广告标题
@property(nonatomic,strong)NSString *title;

/// 是否被点击 1为被展示   0 代表没被展示
@property(nonatomic,strong)NSString *showType;

/// 广告id
@property(nonatomic,assign)int32_t aid;

/// 广告排序
@property(nonatomic,assign)int32_t sort;



@end
