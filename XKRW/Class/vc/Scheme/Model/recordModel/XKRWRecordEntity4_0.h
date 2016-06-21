//
//  XKRWRecordEntity4_0.h
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWRecordFoodEntity.h"
#import "XKRWRecordSportEntity.h"
#import "XKRWRecordCustomEntity.h"
#import "XKRWHabbitEntity.h"
#import "XKRWRecordCircumferenceEntity.h"

@interface XKRWRecordEntity4_0 : NSObject
/**
 *  记录id
 */
@property (nonatomic) uint32_t rid;
/**
 *  记录用户的id
 */
@property (nonatomic) uint32_t uid;
/**
 *  食物记录数组，储存食物实例
 */
@property (nonatomic ,strong) NSMutableArray *FoodArray;
/**
 *  运动记录数组，储存运动实例
 */
@property (nonatomic ,strong) NSMutableArray *SportArray;
/**
 *  自定义食物记录数组，储存自定义食物实例
 */
@property (nonatomic ,strong) NSMutableArray *customFoodArray;
/**
 *  自定义运动数组，存储自定义运动实例
 */
@property (nonatomic, strong) NSMutableArray *customSportArray;
/**
 *  体重记录
 */
@property (nonatomic) float weight;
/**
 *  体脂率
 */
@property (nonatomic) float fatPercent;
/**
 *  围度实例
 */
@property (nonatomic, strong) XKRWRecordCircumferenceEntity *circumference;
/**
 *  习惯改善情况，储存习惯实例
 */
@property (nonatomic, strong) NSMutableArray *habitArray;
/**
 *  大姨妈情况 0表示无，1表示有
 */
@property (nonatomic) int menstruation;
/**
 *  睡觉时长
 */
@property (nonatomic) float sleepingTime;
/**
 *  起床时间 格式:08:00:00
 */
@property (nonatomic, strong) NSDate *getUp;
/**
 *  饮水量 饮水量表示 范围1-10
 */
@property (nonatomic) int water;
/**
 *  心情，0-5，0代表无心情
 */
@property (nonatomic) int mood;
/**
 *  备注
 */
@property (nonatomic, strong) NSString *remark;
/**
 *  记录时间
 */
@property (nonatomic, strong) NSDate *date;
/**
 *  是否同步到服务器，是为1，否为0
 */
@property (nonatomic) int sync;
/**
 *  联接习惯id和习惯改善情况，形成服务器格式字符串
 */
- (NSString *)jointHabitString;
/**
 *  根据字符串还原成习惯改善情况
 */
- (void)splitHabitStringIntoArray:(NSString *)jointString;

- (NSDictionary *)dictionaryInRecordTable;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)reloadHabitArray;

@end
