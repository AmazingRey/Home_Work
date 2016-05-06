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
//运动 ID
@property (nonatomic, assign) int32_t           sportID;

@property (nonatomic,retain) XKRWRecordSportEntity *recordSportEntity;

@property (nonatomic,retain) XKRWSportEntity *sportEntity;

@property (nonatomic, assign) MetricUnit        unit;

@property (nonatomic,assign) BOOL isPresent;

@end
