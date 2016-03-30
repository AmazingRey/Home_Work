//
//  XKRWDescribeModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//  描述Model

#import <Foundation/Foundation.h>

@interface XKRWDescribeModel : NSObject


@property (nonatomic,assign) NSInteger Calories;
@property (nonatomic,assign) NSInteger flag ;       //等级
@property (nonatomic,strong) NSString *result;       //结果
@property (nonatomic,strong) NSString *advise;       //建议
@property (nonatomic,strong) NSString *best_advise;  //最佳加餐建议

@end
