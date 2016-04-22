//
//  XKRWCalendar.h
//  XKRW
//
//  Created by XiKang on 14-10-28.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWCalendarHeaderView.h"
#import "XKRWCalendarView.h"
#import "XKRWCalendarHelper.h"

@protocol XKRWCalendarDelegate <NSObject>

- (void)calendarSelectedDate:(NSDate *)date;

@optional

- (void)calendarScrollToPreMonth;
- (void)calendarScrollToNextMonth;

@end

@interface XKRWCalendar : UIView

@property (nonatomic          ) XKRWCalendarType       type;

@property (nonatomic)  XKRWCalendarMonthType   monthType;

@property (nonatomic, readonly) CGFloat                heightOfCurrentType;

@property (nonatomic, strong  ) XKRWCalendarView       *calendarView;
@property (nonatomic, strong  ) XKRWCalendarHeaderView *headerView;
@property (nonatomic, strong  ) UIView                 *footerView;

/**
 *  ues in gesture animation
 */
@property (nonatomic) BOOL isFooterHide;
@property (nonatomic) BOOL isHeaderHide;
@property (nonatomic) BOOL isAnimating;

@property (nonatomic, weak) id <XKRWCalendarDelegate> delegate;
@property (nonatomic, weak) NSMutableArray *recordDateArray;

- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                andResizeBlock:(void (^)(void))block
                     delayLoad:(CGFloat)second;

- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                andResizeBlock:(void (^)(void))block;

- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                    headerType:(XKRWCalendarHeaderType)type
                andResizeBlock:(void (^)(void))block;

- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                    headerType:(XKRWCalendarHeaderType)type
                andResizeBlock:(void (^)(void))block
                  andMonthType:(XKRWCalendarMonthType )monthType;

- (void)transformToType:(XKRWCalendarType)type;

- (void)resizeFooterView:(CGFloat)offset;
- (void)offsetHeight:(CGFloat)offset;

- (void)scrollingAnimationWithOffset:(CGFloat)yOffset;
- (void)endDragAnimationWithOffset:(CGFloat)yOffset scrollView:(UIScrollView *)scrollView;
- (void)endDecelaratingAnimationWithOffset:(CGFloat)yOffset scrollView:(UIScrollView *)scrollView;

- (void)backToToday;
- (void)reloadCalendar;

- (void)outerSetSelectedDate:(NSDate *)date andNeedReload:(BOOL)flag;

- (void)addBackToTodayButtonInFooterView;

@end
