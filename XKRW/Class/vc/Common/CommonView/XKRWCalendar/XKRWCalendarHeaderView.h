//
//  XKRWCalendarHeaderView.h
//  XKRW
//
//  Created by XiKang on 14-11-7.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWCalendarHelper.h"
#import "NSDate+XKRWCalendar.h"

@interface XKRWCalendarHeaderView : UIView

@property (nonatomic, strong) NSDate                 *date;
@property (nonatomic        ) XKRWCalendarHeaderType type;

- (instancetype)initWithType:(XKRWCalendarHeaderType)type
        onClickPreMonthBlock:(void (^)(void))preMonth
       onClickNextMonthBlock:(void (^)(void))nextMonth
     onClickBackToTodayBlock:(void (^)(void))backToToday;

@end
