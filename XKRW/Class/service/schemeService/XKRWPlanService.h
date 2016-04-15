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

/**
 *  根据时间获取当时的食物、运动等记录
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
 *  <#Description#>
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)queryLatestItemNumber:(NSInteger)itemNumber FoodRecord:(NSDate *)date;


@end
