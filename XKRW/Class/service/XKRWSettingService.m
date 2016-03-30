//
//  XKRWSettingService.m
//  XKRW
//
//  Created by zhanaofan on 14-3-13.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSettingService.h"

#import "XKRWUserDefaultService.h"
#import "XKSilentDispatcher.h"

static XKRWSettingService *settingService;
static NSString *const settingTable = @"settings";
@implementation XKRWSettingService

+(id)shareService
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        settingService = [[XKRWSettingService alloc]init];
    });
    return settingService;
}
/*
 设置三餐比例
 scales:array(20,40,10,30)
 */
- (BOOL) setMealScales:(NSDictionary*)scales
{
//    NSData *data = [XKRWUtil toJSONData:scales];
    if ([self saveValueWithKey:scales key:kMealScale]) {
        [XKRWUserDefaultService saveDietScale:scales];
         //异步保存到服务器
        [self saveToRemote:scales];
        return YES;
    }
    return NO;
}


/*获取三餐比例*/
- (NSDictionary*) getMealScales
{
    NSDictionary *mealScales = [XKRWUserDefaultService getDietScale];
    if (!mealScales) {
        mealScales = (NSDictionary*)[self valueOfKey:kMealScale];
        if (!mealScales) {
            NSDictionary *dict = @{kBreakfast:[NSNumber numberWithInt:30],kLunch:[NSNumber numberWithInt:40],kSnack:[NSNumber numberWithInt:10],kDinner:[NSNumber numberWithInt:20]};
            [self saveValueWithKey:[XKRWUtil toJSONData:dict ] key:kMealScale];
            mealScales = [NSDictionary dictionaryWithDictionary:dict];
            if (mealScales) {
                [XKRWUserDefaultService saveDietScale:mealScales];
            }
        }
    }
    return mealScales;
}

@end
