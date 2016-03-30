//
//  XKRWDietModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-10.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//  饮食情况

#import <Foundation/Foundation.h>
#import "XKRWStatusModel.h"
#import "XKRWDescribeModel.h"
@interface XKRWDietModel : NSObject



@property (nonatomic,strong) XKRWDescribeModel *caloriesCtrlModel;
//@property (nonatomic,strong) XKRWDescribeModel *dietaryStatueModel;
@property (nonatomic,strong) NSArray  *dietaryStatueArray;
@property (nonatomic,strong) XKRWDescribeModel *extraMealModel;
@property (nonatomic,strong) XKRWDescribeModel *repastPlanModel;

@property (nonatomic,strong) XKRWStatusModel *model;

@property (nonatomic,assign) NSInteger total;

@end
