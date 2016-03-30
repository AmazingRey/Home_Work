//
//  XKRWSportEntity.h
//  XKRW
//
//  Created by zhanaofan on 14-3-3.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWSportEntity : NSObject <NSCoding>

@property (nonatomic, assign) uint32_t sportId;     //运动id
@property (nonatomic, strong) NSString *sportName;  //运动名
@property (nonatomic, assign) uint32_t cateId;      //分类id
@property (nonatomic, strong) NSString *sportPic;   //运动图片
@property (nonatomic, strong) NSString *vedioPic;   //视频图片
@property (nonatomic, assign) float     sportMets;  //运动mets
@property (nonatomic, assign) SportUnit sportUnit;  //运动计量单位
@property (nonatomic, strong) NSString *sportIntensity;//运动强度
@property (nonatomic, strong) NSString *sportVedio; //视频地址
@property (nonatomic, strong) NSString *sportEffect;//运动功效
@property (nonatomic, strong) NSString *sportCareTitle;//运动注意事项标题
@property (nonatomic, strong) NSString *sportCareDesc;//注意事项内容
@property (nonatomic, strong) NSString *sportActionPic;//动作描述
@property (nonatomic, strong) NSString *sportActionDesc;//动作描述

#pragma mark - 5.0 new

@property (nonatomic, strong) NSString *iFrame;

@property (nonatomic, assign) uint32_t sportTime;   //运动时间
@property (nonatomic, assign) NSInteger scale;

//卡路里计算 返回值单位千卡
- (uint32_t) consumeCaloriWithMinuts:(uint32_t)minute weight:(float)weight;

- (uint32_t) timesOfSport:(uint32_t)cal weight:(float)weight;
@end
