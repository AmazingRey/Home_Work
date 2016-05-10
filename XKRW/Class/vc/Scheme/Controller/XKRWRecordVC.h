//
//  XKRWRecordVC.h
//  XKRW
//
//  Created by 忘、 on 16/4/13.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWEnumDefine.h"

@interface XKRWRecordVC : XKRWBaseVC

@property (nonatomic,assign) SchemeType schemeType;

@property (nonatomic,assign) MealType mealType;

@property (nonatomic,strong) NSDate *recordDate;

@end
