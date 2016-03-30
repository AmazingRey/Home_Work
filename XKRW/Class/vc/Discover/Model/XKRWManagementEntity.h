//
//  XKRWManagementEntity.h
//  XKRW
//
//  Created by Jiang Rui on 14-4-4.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWManagementEntity : NSObject

//模块类别
@property (nonatomic) XKOperation category;

//模块名称
@property (nonatomic,strong) NSString *module;

//模块内容
@property (nonatomic,strong) NSDictionary *content;

//排序
@property (nonatomic) int32_t seq;

//id
@property (nonatomic) int32_t nid;

//是否完成
@property (nonatomic) BOOL complete;

//判断是哪一天的运营内容
@property (nonatomic) int32_t day;

//运营内容的日期
@property (nonatomic,strong) NSString *date;


//icon链接地址
@property(nonatomic,strong) NSString  *iconUrlSelect;

@property(nonatomic,strong) NSString  *iconUrlUnSelect;

@property(nonatomic,strong)NSString   *pv;  //帖子浏览量



@end
