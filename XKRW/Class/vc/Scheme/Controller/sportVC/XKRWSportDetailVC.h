//
//  XKRWSportDetailVC.h
//  XKRW
//
//  Created by Leng on 14-4-15.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWSportService.h"

@protocol sportDetailDelegate <NSObject>
@optional
- (void) executeBackHandle; //执行返回操作时的代理方法
@end

@interface XKRWSportDetailVC : XKRWBaseVC
@property (nonatomic, assign) uint32_t sportID;

@property (nonatomic, assign) BOOL     isSecheme;
@property (nonatomic,assign) uint32_t  cal;

@property (nonatomic, strong)XKRWSportEntity * sportEntity;


@property (nonatomic, copy)  NSString * sportName;
@property (nonatomic, copy)  NSString * passDayTemp;  //记录日期
@property (nonatomic,assign) MealType   passMealTypeTemp; //类型
@property (nonatomic, assign) BOOL      needHiddenDate;

@property (nonatomic,strong) NSDate  *date;

@property (nonatomic,assign) BOOL  isFromScheme;  //不需要记录
//判断是否从收藏过来---4.2收藏新增
@property (nonatomic,assign) BOOL isPresent;

@property (nonatomic,assign) id <sportDetailDelegate> delegate;
//-(void) resetContents;


@end
