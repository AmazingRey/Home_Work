//
//  XKRWIslimModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWBodyModel.h"
#import "XKRWIslimSportModel.h"
#import "XKRWOtherFactorsModel.h"
#import "XKRWDietModel.h"
#import "XKRWHabitModel.h"

@interface XKRWIslimModel : NSObject

@property (nonatomic,assign) NSInteger success;

@property (nonatomic,strong) XKRWBodyModel *bodyModel;
@property (nonatomic,strong) XKRWOtherFactorsModel *otherFactorsModel;
@property (nonatomic,strong) XKRWHabitModel *habitModel;
@property (nonatomic,strong) XKRWDietModel *dietModel;
@property (nonatomic,strong) XKRWIslimSportModel *sportmodel;
@property (nonatomic,strong) NSArray  *guideStepArray;

@property (nonatomic, strong) NSString *dateString;
@end


/**
 *  Islim 服务页面广告 Item
 */
@interface XKRWIslimAddModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *day_on;
@property (nonatomic, copy) NSString *day_off;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *addr;

@end
