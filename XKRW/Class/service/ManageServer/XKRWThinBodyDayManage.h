//
//  XKRWThinBodyDayManage.h
//  XKRW
//
//  Created by 忘、 on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWBaseVC.h"
@interface XKRWThinBodyDayManage : NSObject <UIAlertViewDelegate>

+(instancetype)shareInstance;


- (void)viewWillApperShowFlower:(XKRWBaseVC *) vc;
/**
 *  获取日历中计划进程描述
 *
 *  @return <#return value description#>
 */
- (NSAttributedString *)calenderPlanDayText;
- (NSString *)PlanDayText ;

- (NSString *)TipsTextWithDayAndWhetherOpen ;
/**
 *  获取预期结束时间
 *
 *  @return <#return value description#>
 */
- (NSDate *)planExpectFinishDay;

/**
 *  日历的日期是否在 计划预期时间内
 *
 *  @param date 日历显示的日期
 *
 *  @return
 */
- (BOOL) calendarDateInPlanTimeWithDate:(NSDate *)date;

- (BOOL) calendarDateIsStartDayWithDate:(NSDate *)date;

- (BOOL) calendarDateIsEndDayWithDate:(NSDate *)date;


@end
