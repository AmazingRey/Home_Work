//
//  XKRWCalendarView.h
//  XKRW
//
//  Created by XiKang on 14-11-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWCalendarHelper.h"
#import "NSDate+XKRWCalendar.h" 

@interface XKRWCalendarView : UIView

@property (nonatomic        ) NSInteger        selectedLine;
@property (nonatomic        ) NSInteger        currentLine;
@property (nonatomic, strong) NSDate           *selectedDay;
@property (nonatomic, strong) NSDate           *date;

@property (nonatomic        ) XKRWCalendarType type;
@property (nonatomic, weak  ) NSArray          *recordDateArray;

@property (nonatomic) XKRWCalendarMonthType monthType;

- (instancetype)initWithDate:(NSDate *)date
             recordDateArray:(NSArray *)dateArray
                returnHeight:(void (^)(CGFloat height))block
           calendarMonthType:(XKRWCalendarMonthType )monthType
              clickDateBlock:(void (^)(NSDate *date, BOOL outOfMonth))block2;

- (void)resetWithDate:(NSDate *)date returnHeight:(void (^)(CGFloat height))block;
- (void)resetWeekStyleWithDate:(NSDate *)date;

- (void)offsetYPoint:(CGFloat)offset;

- (void)setDateSelected:(NSDate *)date;
- (void)resetWeekStyleAsPrimaryView:(NSDate *)date
                          animation:(BOOL)yesOrNo
                       returnHeight:(void (^)(CGFloat height))block;

- (CGFloat)animationEndTopLine;
- (CGFloat)animationEndBottomLine;

- (void)clickDayOutOfMonth:(void (^)(int flag))block;

@end
