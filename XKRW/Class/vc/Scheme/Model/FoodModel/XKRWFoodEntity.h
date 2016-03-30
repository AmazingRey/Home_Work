//
//  XKRWFoodEntity.h
//  XKRW
//
//  Created by zhanaofan on 14-2-7.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWFoodEntity : NSObject<NSCoding>
//食物id
@property (nonatomic, assign) NSInteger foodId;
//食物名称
@property (nonatomic, strong) NSString *foodName;
//食物logo
@property (nonatomic, strong) NSString *foodLogo;
//食物营养
@property (nonatomic, strong) NSArray  *foodNutri;
//食物能量 一般是每百克
@property (nonatomic, assign) NSInteger foodEnergy;
//是否适合减肥吃
@property (nonatomic, assign) NSInteger  fitSlim;
//食物度量单位
//@property (nonatomic, strong) NSArray  *foodUnit;
#pragma mark - 5.0 new
@property (nonatomic ,strong) NSDictionary *foodUnit;

//


@end
