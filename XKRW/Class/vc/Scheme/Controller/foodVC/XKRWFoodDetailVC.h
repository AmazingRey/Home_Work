//
//  XKRWFoodDetailVC.h
//  XKRW
//
//  Created by zhanaofan on 14-2-7.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWFoodTopView.h"
#import "XKRWFoodEntity.h"
#import "XKRWFoodService.h"

#import "XKRWCollectionService.h"
@protocol foodDetailDelegate <NSObject>

- (void) executeBackHandle; //执行返回操作时的代理方法

@end

@interface XKRWFoodDetailVC : XKRWBaseVC <UITableViewDelegate,UITableViewDataSource>

//食物id
@property (nonatomic, assign) NSInteger        foodId;
@property (nonatomic, strong) NSNumber      *foodIdObj;
//食物对象
@property (nonatomic, strong) XKRWFoodEntity  *foodEntity;
@property (nonatomic, strong) NSMutableArray  *data;
@property (nonatomic, strong) NSString      *foodName;

@property (nonatomic, copy)  NSString  *passDayTemp;
@property (nonatomic,assign) MealType   passMealTypeTemp;
@property (nonatomic, assign) BOOL      needHiddenDate;

@property (nonatomic) BOOL needShowRecord;
//@property (nonatomic) BOOL hideCollect;

@property (nonatomic,strong) NSDate     *date;   //记录页闯过来的日期

@property (nonatomic, copy) NSString  *titleTeme;
//判断是否是通过present方法跳转过来的
@property (nonatomic,assign) BOOL isPresent;

//用食物id，初始化
- (id) initWithFoodId:(uint32_t)food_id;


@property (nonatomic,assign) BOOL   isFromSchmem;  //从方案页过来的记录

@property (nonatomic,assign) id <foodDetailDelegate> delegate;

//判断是否从收藏过来---4.2收藏新增
//@property (nonatomic,assign) BOOL isCollect;
@property (nonatomic,strong) XKRWCollectionEntity *collectFoodEntity;

@end
