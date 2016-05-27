//
//  XKRWStatiscEntity5_3.h
//  XKRW
//
//  Created by ss on 16/5/6.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XKRWStatiscEntity5_3 : NSObject

/**
 *  周计划／统计分析
 */
@property (assign, nonatomic) StatisticType type;

/**
 *  所选周数显示的num
 */
@property (assign, nonatomic) NSInteger num;

/**
 *  所选周数的index
 */
@property (assign, nonatomic) NSInteger index;

/**
 *  所选的所有具体日期
 */
@property (strong, nonatomic) NSArray *arrDaysDate;

/**
 *  所选周数对应的日期区间
 */
@property (strong, nonatomic) NSString *dateRange;

/**
 *  日期区间最后一天的体重
 */
@property (assign, nonatomic) CGFloat weight;

/**
 *  日期区间内体重变化（区间最后一天减去第一天的）
 */
@property (assign, nonatomic) CGFloat weightChange;

/**
 *  日期区间内记录的天数
 */
@property (strong, nonatomic) NSNumber *dayRecord;

/**
 *  日期区间内完成的天数
 */
@property (strong, nonatomic) NSNumber *dayAchieve;

/******************************饮食**********************************/
/**
 *  日期区间内正常所需摄入kcal
 */
@property (strong, nonatomic) NSNumber *normalIntake;

/**
 *  日期区间内的正常摄入量和日期对应的字典
 */
@property (strong, nonatomic) NSDictionary *dicNormalIntake;

/**
 *  日期区间内推荐摄入kcal
 */
@property (strong, nonatomic) NSNumber *recommondIntake;

/**
 *  日期区间内的推荐摄入量和日期对应的字典
 */
@property (strong, nonatomic) NSDictionary *dicRecommondIntake;

/**
 *  日期区间内实际摄入kcal
 */
@property (strong, nonatomic) NSNumber *actualIntake;

/**
 *  日期区间内的实际摄入量和日期对应的字典
 */
@property (strong, nonatomic) NSDictionary *dicActualIntake;

/**
 *  日期区间内减少摄入的kcal总计 （normalIntake - actualIntake）
 */
@property (strong, nonatomic) NSNumber *decreaseIntake;

/**
 *  日期区间内减少摄入的kcal目标
 */
@property (strong, nonatomic) NSNumber *targetIntake;

/**
 *  日期区间是否完成饮食摄入的kcal目标
 */
@property (assign, nonatomic) BOOL isAchieveIntakeTarget;

/******************************运动**********************************/
/**
 *  日期区间内运动时长总计
 */
@property (strong, nonatomic) NSNumber *timeSport;

/**
 *  日期区间内运动减少的kcal总计
 */
@property (strong, nonatomic) NSNumber *decreaseSport;

/**
 *  日期区间内的运动量和日期对应的字典
 */
@property (strong, nonatomic) NSDictionary *dicSportActual;

/**
 *  日期区间内的运动量和日期对应的字典
 */
@property (strong, nonatomic) NSDictionary *dicSportRecommond;

/**
 *  日期区间内运动减少的kcal目标
 */
@property (strong, nonatomic) NSNumber *targetSport;

/**
 *  日期区间是否完成运动减少的kcal目标
 */
@property (assign, nonatomic) BOOL isAchieveSportTarget;

@end