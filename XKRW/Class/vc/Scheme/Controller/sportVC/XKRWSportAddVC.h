//
//  XKRWSportAddVC.h
//  XKRW
//
//  Created by zhanaofan on 14-3-3.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWSportEntity.h"
#import "XKRWRecordEntity.h"
#import "XKRWRecordSportEntity.h"

#import "XKRWRecordService4_0.h"

@interface XKRWSportAddVC : XKRWBaseVC <UIScrollViewDelegate>

@property (nonatomic, strong) XKRWSportEntity *sportEntity;

//操作类型 1添加  2：修改
@property (nonatomic, assign) OpType            opType;
//运动 ID
@property (nonatomic, assign) int32_t           sportID;
//运动 单位
@property (nonatomic, assign) int32_t           sport_unit;

//是否需要隐藏选择日期功能
@property (nonatomic, assign) BOOL              needHiddenDate;

@property (nonatomic,retain) XKRWRecordSportEntity *recordSportEntity;


@property (nonatomic, assign) MetricUnit        unit;

@property (nonatomic, copy)    NSString *     unitDescription;


@property (nonatomic, copy)  NSString * passDayTemp;
@property (nonatomic,assign) MealType   passMealTypeTemp;

@property (nonatomic, copy) NSString * titleTeme;
@property (nonatomic,strong) NSDate   *date;

@property (nonatomic,assign) BOOL  isFromScheme;

@property (nonatomic,assign) BOOL isPresent;

@property (nonatomic) BOOL isNeedHideNaviBarWhenPoped;

@property (nonatomic, weak) XKRWRecordEntity4_0 *recordEneity;
//YES 为 修改    NO 为记录
@property (nonatomic) BOOL isModify;

@end
