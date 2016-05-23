//
//  XKRWStatiscBussiness5_3.h
//  XKRW
//
//  Created by ss on 16/5/6.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWStatiscEntity5_3.h"
#define DayInterval 1*24*60*60

#define Days 7
#define DateInterval (Days-1)*24*60*60
#define DrecreaseDateInterval Days*24*60*60

@interface XKRWStatiscBussiness5_3 : NSObject

/**
 *  统计分析独立entity
 */
@property (strong, nonatomic) XKRWStatiscEntity5_3 *statiscEntity;

/**
 *  周计划各周entity构成的dic
 */
@property (strong, nonatomic) NSMutableDictionary *dicEntities;


/**
 *  可传日期，默认当天
 */
@property (strong, nonatomic) NSDate *date;


/**
 *  第几周
 */
@property (assign, nonatomic) NSInteger weekIndex;

/**
 *  周数
 */
@property (assign, nonatomic) NSInteger totalNum;

/**
 *  所有周数组组成的dic，供picker初始化
 */
@property (strong, nonatomic) NSDictionary *dicPicker;


/**
 *  内部用量
 */

@property (strong, nonatomic) NSString *dateRegisterStr;
@property (strong, nonatomic) NSNumber *resetTime;
@property (strong, nonatomic) NSDateFormatter *dateFormat;
@property (strong, nonatomic) NSNumber *totalDays;

@end