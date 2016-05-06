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
 *  周计划各周entity构成的数组
 */
@property (strong, nonatomic) NSMutableArray *array;


/**
 *  可传日期，默认当天
 */
@property (strong, nonatomic) NSDate *date;
@end
