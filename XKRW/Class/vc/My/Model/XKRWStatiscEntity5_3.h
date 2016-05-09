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
 *  统计分析中开始日期
 */
@property (strong, nonatomic) NSString *startDateStr;

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
 *  日期区间内推荐摄入kcal
 */
@property (strong, nonatomic) NSNumber *recommondIntake;

/**
 *  日期区间内实际摄入kcal
 */
@property (strong, nonatomic) NSNumber *actualIntake;

/**
 *  日期区间内减少摄入的kcal总计 （normalIntake - actualIntake）
 */
@property (strong, nonatomic) NSNumber *decreaseIntake;

/**
 *  日期区间内减少摄入的kcal目标
 */
@property (strong, nonatomic) NSNumber *targetIntake;

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
 *  日期区间内运动减少的kcal目标
 */
@property (strong, nonatomic) NSNumber *targetSport;

@end