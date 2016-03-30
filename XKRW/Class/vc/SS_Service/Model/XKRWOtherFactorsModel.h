//
//  XKRWOtherFactorsModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWStatusModel.h"
#import "XKRWDescribeModel.h"

@interface XKRWOtherFactorsModel : NSObject

@property (nonatomic,assign)  NSInteger flag;

@property (nonatomic,strong) XKRWDescribeModel *characterModel;

@property (nonatomic,strong) NSMutableArray *mindArray;

@property (nonatomic,strong) NSMutableArray *reasonArray;

@property (nonatomic,strong) XKRWStatusModel *model;

- (NSDictionary *)getTitleStrings;

@end
