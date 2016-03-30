//
//  XKRWHabitModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWStatusModel.h"
#import "XKRWDescribeModel.h"

@interface XKRWHabitModel : NSObject

@property (nonatomic,strong) XKRWStatusModel *model;

@property (nonatomic,assign) NSInteger  total;

@property (nonatomic,strong) NSArray  *reduceCalArray;

@property (nonatomic,strong) NSArray  *bodyConsumeArray;

@property (nonatomic,strong) NSArray  *secretionArray;

@property (nonatomic,strong) XKRWDescribeModel *otherDescribeModel;

@end
