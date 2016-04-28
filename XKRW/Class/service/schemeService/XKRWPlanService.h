//
//  XKRWPlanService.h
//  XKRW
//
//  Created by Shoushou on 16/4/11.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWRecordService4_0.h"

@interface XKRWPlanService : XKRWBaseService
+ (instancetype)shareService;

/**
 *  根据时间获取当时的食物、运动等记录XKRWRecordEntity4_0.foodArray(XKRWFoodRecordEntity *)
 *
 *  @param date 记录日期
 *
 *  @return XKRWRecordEntity4_0
 */
- (XKRWRecordEntity4_0 *)getAllRecordOfDay:(NSDate *)date;
/**
 *  通过不同的entity类型及相应XKRWRecordType类型保存方案、食物或者运动
 *
 *  @param recordEntity 现在在用的entity类型有 XKRWRecordFoodEntity 、XKRWRecordSportEntity 、 XKRWRecordEntity4_0
 *  @param type         XKRWRecordType
 *
 *  @return 返回YES：保存成功 NO：保存失败
 */
- (BOOL)saveRecord:(id)recordEntity ofType:(XKRWRecordType)type;
/**
 *  根据表名获取最近记录的20条不同的运动或食物
 *
 *  @param tableName @“food_record”/@"sport_record"
 *
 *  @return (NSArray <XKRWFoodEntity *> *)/(NSArray <XKRWSportEntity *> *)
 */
- (NSArray *)getRecent_20_RecordWithTableName:(NSString *)tableName;
/**
 *  存储当天能量环是否被点击过
 *
 *  @param type ResultType
 */
- (void)saveEnergyCircleClickEvent:(ResultType)type;
/**
 *  根据type获取能量环当天是否被点击过
 *
 *  @param type ResultType
 *
 *  @return a bool value
 */
- (BOOL)getEnergyCircleClickEvent:(ResultType)type;
/**
 *  获取date之前离date日期最近的体重记录，若没有则返回体重原始值
 *
 *  @param date NSDate
 *
 *  @return float (kg)
 */
- (CGFloat)getHistoryWeightWithDate:(NSDate *)date;
@end
