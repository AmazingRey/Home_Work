//
//  XKRWWeightService.h
//  XKRW
//
//  Created by Jiang Rui on 14-3-12.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "NSDate+XKUtil.h"

@interface XKRWWeightService : XKRWBaseService

//单例
+(id)shareService;

#pragma mark 网络相关
//批量获取体重记录
-(void)batchDownloadWeightRecord;
//上传体重记录
- (void)uploadWeightRecord:(NSString *)weight weightDate:(NSDate *)weightDate;
/*批量上传体重记录*/
- (BOOL)batchUploadWeightToRemoteNeedLong:(BOOL) need;
//删除体重记录
- (void)deleteWeightRecord:(NSDate *)weightDate;


#pragma mark 本地操作
//更新首页曲线
-(void)updateTheCurve;

//获取体重的值数组
- (NSMutableArray *) getCurve;
//体重记录本地
- (void)saveWeightRecord:(NSString *)weight date:(NSDate *)weightDate sync:(NSString *)sync andTimeRecord:(NSDate *) recordTime;

//获取上个月，当月和下个月的体重记录
- (NSArray *)getWeightRecordWithPreDate:(NSDate *)preDate nowDate:(NSDate *)nowDate nextDate:(NSDate *)nextDate;

//根据date倒序获得12天的历史体重数组
-(NSArray *)getDayWeightRecord;

//根据date倒序获得12*7天的历史体重数组
-(NSArray *)getWeekWeightRecord;

//根据date倒序获得365天的历史体重数组
-(NSArray *)getMonthWeightRecord;

//更新最早记录
- (void) updateOriWeight:(float)weight;
//最早
- (NSString *)getOldWeight;
- (NSString *)getOldMMdd;
- (NSString *)getNewMMdd;
- (NSString *)getMaxWeight;
- (NSString *)getMinWeight;

//最早体重   方案重置前不变
- (NSString*)getStartingValueWeight;


- (float) weightDiscrepancy;
- (float) minWeight;

//当前重置方案
- (NSString *)getCurrentWeightString;
- (int) getMinValue;
- (float) weeklyLoseWeight;

//平均周 减肥
-(float)weeklyLoseWeightSpeed;

//searching before
- (float)getNearestWeightRecordOfDate:(NSDate *)date;


- (NSString*)getOldWeightFromACCount;

//获取最初的时间  
-(NSDate*)getOrWeightTime;
/**
 *  根据date获取记录的体重
 *
 *  @param date nsdate
 *
 *  @return 有则返回数值，无则返回0
 */
- (float)getWeightRecordWithDate:(NSDate *)date;
@end
