//
//  XKRWGlobalHelper.h
//  XKRW
//  算法fa
//  Created by zhanaofan on 14-3-11.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWBMIEntity.h"

@interface XKRWAlgolHelper : NSObject

//最低推荐饮食值
+ (float)minRecommendedValueWith:(XKSex)sex;

/*BM*/
+ (float)BM;
+ (float)BM_of_origin;
+ (float)BM_of_date:(NSDate *)date;
+ (NSArray *)BMs_of_dates:(NSArray *)dateArray;
+ (float)BM_with_weight:(float)weight height:(float)height age:(NSInteger)age sex:(XKSex)sex;
/*PAL*/
+ (float)PAL;
+ (float)PAL_with_sex:(XKSex)sex physicalLabor:(XKPhysicalLabor)labor;

/*BMI*/
+ (float)BMI;
+ (float)BMI_with_height:(float)height weight:(float)weight;

/*每日正常饮食摄入量*/
+ (float) dailyIntakEnergy;
+ (float) dailyIntakEnergyOfDates:(NSArray *)dateArray;
+ (float) dailyIntakEnergyWithBM:(float)BM PAL:(float)PAL;
+ (float) dailyIntakEnergyOfOrigin;
/*初始体重下的摄入能量*/
+ (float)originIntakeRecomEnergy;
/*每日推荐饮食摄入量*/
+ (float)dailyIntakeRecomEnergy;
+ (float)dailyIntakeRecomEnergyOfDate:(NSDate *)date;
+ (float)dailyIntakeRecomEnergyOfDates:(NSArray *)dateArray;
+ (float)dailyIntakeRecommendEnergyWithBM:(float)BM PAL:(float)PAL sex:(XKSex)sex age:(NSInteger)age;

+ (float)dailyIntakeRecomEnergyOfOrigin;

//获取每日记录饮食摄入量
+(float)dailyTotalRecordEnergyWithDate:(NSDate *)date;

//每日推荐饮食记录的摄入量
+(float)dailySchemeRecordEnergrWithDate:(NSDate *)date;

/*每日运动消耗量*/
+ (float)dailyConsumeSportEnergy;

+ (float)dailyConsumeSportEnergyOfOrigin;
/*添加v5.3新逻辑新用户注册前五天推荐运动量为0*/
+ (float)dailyConsumeSportEnergyV5_3OfDate:(NSDate *)date;
+ (float)dailyConsumeSportEnergyOfDate:(NSDate *)date;
+ (float)dailyConsumeSportEnergyOfDates:(NSArray *)dateArray;
+ (float)dailyConsumeSportEnergyWithPhysicalLabor:(XKPhysicalLabor)labor BM:(float)BM PAL:(float)PAL sex:(XKSex)sex;

//至少需要的热量
+(float)atLeastEnergy;
+ (float)atLeastEnergyWithBM:(float)BM PAL:(float)PAL sex:(XKSex)sex age:(NSInteger)age;

//获取用户某一天的运动总时长
+ (NSInteger )getSportRecordAndSportSchemeRecordTimeWithDate:(NSDate *)date;

//4.1新增  获取 每日 三种  营养标准
+(NSDictionary*)getAdviceThreeNutrition;

 
/*按餐次，获取需要摄入的能量*/
+ (float)intakeRecomWithMealType:(MealType)type;
/*达成目标，还需要的天数*/
+ (NSInteger) dayOfAchieveTarget;
/*达成目标，预期天数*/
+ (NSNumber *) expectDayOfAchieveTarget;
/*设置达成目标，预期天数*/
+ (void) setExpectDayOfAchieveTarget:(NSInteger )weight andStartTime:(id)time;
/*达成目标体重的 剩余时间*/
+ (NSInteger ) remainDayToAchieveTarget;

/*是否事方案最后一天*/
+ (BOOL) isSchemeLastDay;

/*达成目标体重的新方案开始了多少天*/
+ (NSInteger ) newSchemeStartDayToAchieveTarget;

/*每日少吃的能量值*/
+ (NSInteger) limitOfEnergywithCurWeight:(CGFloat )curWeight andTargetWeight:(CGFloat) targetWeight;
+ (foodMetric) metricWithMealType:(MealType)type scale:(uint32_t)scale unitEnergy:(uint32_t)unitEnergy;
/*成功减肥*/
+ (float) didReduceWeight;
/*成功减肥几率*/
+ (NSInteger) sucessProbability;
/*将卡路里转换成脂肪克*/
+ (NSInteger) fatWithCalorie:(NSInteger)calorie;
/*运动消耗的卡路里值 = METs * 分钟数 * 3.5 / 200 *当前体重（公斤）
 即：？千卡 / 60分钟 = METs * 60* 3.5 / 200 *当前体重
 minutes 分钟数
 mets 运动的梅脱
 */
+ (NSInteger) sportConsumeWithTime:(NSInteger)minutes mets:(float)mets;

/// 运动消耗calorie的卡路里，需要多少分钟
+ (NSInteger)sportTimeWithCalorie:(float)calorie mets:(float)mets;

/*根据身高和年龄和性别求健康体重下限*/
+(NSInteger)calcHealthyWeightFloorWithHeight:(NSInteger)height sex:(XKSex)sex andAge:(NSInteger)age;

//根据性别，身高，年龄计算bmi和体重范围
+(XKRWBMIEntity *)calcBMIInfoWithSex:(XKSex)sex age:(NSInteger)age andHeight:(NSInteger)height;

//根据难度计算减肥时间
+(NSInteger)calcReduceWeightDurationWithDiffiuclty:(XKDifficulty)difficulty origWeight:(NSInteger)orig andDestiWeight:(NSInteger)desti;

+(NSInteger) getReduceDaysWithDiffCulty:(XKDifficulty)diffculty;

///*还能吃多少*/
//+ (NSInteger) intakeOfRemainEnergy:(NSString *)day;
///*还需要运动*/
//+ (NSInteger) sportOfRemain:(NSString *)day;

/*计算用户超过多少减肥比例*/
+(NSString *)calcUserPercentWithStarNum:(NSInteger)num;

/*通过单位得到最后的数值*/
+(NSInteger) calcCaloriesWithUnit:(MetricUnit)unit andValue:(NSInteger) value andEnergy:(NSInteger ) energy;

+(NSString *) getPercentWithDays:(NSInteger) days;


+(NSDate*)getYesterdayDate;


/// 获取当前用户（当前体重）的方案建议值所对应推荐方案份量大小
+(NSString *)getDailyIntakeSize;
+(NSRange)getOriginDailyIntakeRange;//初始体重获取范围
/// 获取当前用户（当前体重）的方案建议值所对应推荐方案份量大小， 1 大， 2 中， 3小
+ (NSInteger)getDailyIntakeSizeNumber;

+ (NSString *)getDailyIntakeTipsContent;


+ (NSString *)getSportTipsContent:(NSString *)sportCal;


+(NSString *)getLossWeek;

#pragma mark - 5.0 new
/// 根据餐次获取方案推荐比例 5.0版本定为 3:5:2
+ (CGFloat)getSchemeRecomandDietScaleWithType:(RecordType)type;
/// 根据餐次获取date当天的方案推荐calorie数
+ (NSInteger)getSchemeRecomandCalorieWithType:(RecordType)type date:(NSDate *)date;
@end
