//
//  XKRWCalendarItem.m
//  XKRW
//
//  Created by XiKang on 14-11-11.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWCalendarItem.h"
#import "XKRWThinBodyDayManage.h"
#import "XKRWWeightService.h"

@implementation XKRWCalendarItem
{
    UIImageView *_dot;
    UIImageView *_selectedView;
    UIImageView *_changPlanView;
   
    XKRWCalendarMonthType _CalendarMonthType;
    void (^_clickBlock)(XKRWCalendarItem *item);
    
    UILabel *_weightLabel;
}

- (id)initWithOrigin:(CGPoint)origin
           withTitle:(NSString *)title
              record:(BOOL)yesOrNo
          isSelected:(BOOL)isSelected
          outOfMonth:(BOOL)outOfMonth
             isToday:(BOOL)isToday
   calendarMonthType:(XKRWCalendarMonthType )monthType
        onClickBlock:(void (^)(XKRWCalendarItem *item))block
{
    _CalendarMonthType = monthType;
    _clickBlock = block;
    self = [self initWithOrigin:origin withTitle:title record:yesOrNo isSelected:isSelected outOfMonth:outOfMonth isToday:isToday];
    return self;
}

- (id)initWithOrigin:(CGPoint)origin
           withTitle:(NSString *)title
              record:(BOOL)yesOrNo
          isSelected:(BOOL)isSelected
          outOfMonth:(BOOL)outOfMonth
             isToday:(BOOL)isToday
{
    if (self = [super init]) {
        if (_CalendarMonthType == XKRWCalendarTypeStrongMonth) {
            self.frame = CGRectMake(origin.x, origin.y, ITEM_WIDTH, 69);
            [self.titleLabel setFont:XKDefaultNumEnFontWithSize(15.f)];
            _dot = [[UIImageView alloc] initWithFrame:CGRectMake((ITEM_WIDTH - 30) / 2, (69-30)/2 -10, 30.f, 30.f)];
          
            _dot.contentMode = UIViewContentModeScaleAspectFit;
        }else{
            self.frame = CGRectMake(origin.x, origin.y, ITEM_WIDTH, 30);
            [self.titleLabel setFont:XKDefaultNumEnFontWithSize(13.f)];
            _selectedView = [[UIImageView alloc] initWithFrame:CGRectMake((ITEM_WIDTH - 18.f) / 2, 6.f, 18.f, 18.)];
            [_selectedView setImage:[UIImage imageNamed:@"circleGreen"]];
            _dot = [[UIImageView alloc] initWithFrame:CGRectMake((ITEM_WIDTH - 4.f) / 2, 24.5f, 4.f, 4.f)];
            [_dot setImage:[UIImage imageNamed:@"dotGreen"]];
            _dot.contentMode = UIViewContentModeScaleAspectFit;
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }
        self.outOfMonth = outOfMonth;
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _dot.bottom + 2, self.width, 14)];
        _weightLabel.textAlignment = NSTextAlignmentCenter;
        _weightLabel.font = XKDefaultFontWithSize(12);
        _weightLabel.textColor = XKMainSchemeColor;
        
        _changPlanView = [[UIImageView alloc] init];
        UIImage *changPlanImage = [UIImage imageNamed:@"cz"];
        _changPlanView.image = changPlanImage;
        _changPlanView.size = changPlanImage.size;
        _changPlanView.center = CGPointMake(CGRectGetMidX(_weightLabel.frame), _weightLabel.bottom + 2 + changPlanImage.size.height / 2.0);
        
        [self setBackgroundColor:[UIColor whiteColor]];

        [self setDay:title outOfMonth:yesOrNo isToday:isToday isRecord:yesOrNo];

        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (isSelected) {
            [self setSelected:isSelected];
        }
    }
    return self;
}

- (void)setDay:(NSString *)day outOfMonth:(BOOL)yesOrNO isToday:(BOOL)isToday isRecord:(BOOL)isRecord
{
    if (yesOrNO) {
        [self setTitleColor:XK_ASSIST_TEXT_COLOR forState:UIControlStateNormal];
    } else {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
    [self setTitle:day forState:UIControlStateNormal];
    self.outOfMonth = yesOrNO;
    self.isRecord = isRecord;
    
    
    if (_CalendarMonthType == XKRWCalendarTypeStrongMonth) {
        [_storangIsToday removeFromSuperview];
        [_dot removeFromSuperview];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone fromDate:self.date];
        
        if (yesOrNO) {
            [comps setDay:self.tag - 100];
            if (comps.day < 8) {
                [comps setMonth:comps.month + 1];
            } else {
                [comps setMonth:comps.month - 1];
            }
            
        } else {
            [comps setDay:self.tag];
        }
        [comps setHour:12];
        NSDate *currentDate = [cal dateFromComponents:comps];
        
        BOOL isInPlan = [[XKRWThinBodyDayManage shareInstance ] calendarDateInPlanTimeWithDate:currentDate];
        BOOL isEndDay = [[XKRWThinBodyDayManage shareInstance ] calendarDateIsEndDayWithDate:currentDate];
        BOOL isStartDay =  [[XKRWThinBodyDayManage shareInstance] calendarDateIsStartDayWithDate:currentDate];
        
        CGFloat weight = [[XKRWWeightService shareService] getWeightRecordWithDate:currentDate];
        if (weight) {
            _weightLabel.text = [NSString stringWithFormat:@"%.1fkg",weight];
            [self addSubview:_weightLabel];
        } else {
            [_weightLabel removeFromSuperview];
        }
        
        if (isStartDay) {
            [self addSubview:_changPlanView];
        } else {
            [_changPlanView removeFromSuperview];
        }
        
        if (isInPlan) {
            [_dot setImage:[UIImage imageNamed:@"circleGray"]];
            [self insertSubview:_dot belowSubview:self.titleLabel];
            
        }
        
        if (isRecord) {
            [_dot setImage:[UIImage imageNamed:@"circleGreen"]];
            [self insertSubview:_dot belowSubview:self.titleLabel];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
        
        }
        
        if (isEndDay) {
          
            [_dot removeFromSuperview];
            _storangIsToday = [[UIView alloc] initWithFrame:CGRectMake((ITEM_WIDTH - 30) / 2, (69-30)/2 - 10 , 30.f, 30.f)];
            _storangIsToday.layer.cornerRadius = 15;
            _storangIsToday.layer.masksToBounds = YES;
            _storangIsToday.layer.borderWidth = 1;
            _storangIsToday.layer.borderColor = XKMainSchemeColor.CGColor;
            [self insertSubview:_storangIsToday belowSubview:self.titleLabel];
             [self setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
        }
        
    }else{
        if (isRecord) {
             [self addSubview:_dot];
        }else{
            [_dot removeFromSuperview];
        }
        
        if (isToday) {
             [self setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
        }
    }
    
    if (_CalendarMonthType == XKRWCalendarTypeStrongMonth) {
        self.titleEdgeInsets = UIEdgeInsetsMake(-20,0,0,0);
    }
}

- (void)setHidden:(BOOL)hidden withAnimation:(BOOL)yesOrNo
{
    if (yesOrNo) {
        if (hidden) {
            [UIView animateWithDuration:0.25f animations:^{
                self.alpha = 0.f;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        } else {
            [UIView animateWithDuration:0.25f animations:^{
                self.alpha = 1.f;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        }
    } else {
        if (hidden) {
            self.alpha = 0.f;
        } else {
            self.alpha = 1.f;
        }
        [super setHidden:hidden];
    }
}

#pragma mark - other functions

- (void)pressButton:(UIButton *)button
{
    _clickBlock(self);
    if (!self.isSelected) {
        [self setSelected:!self.isSelected];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self insertSubview:_selectedView belowSubview:self.titleLabel];
    } else {
        [_selectedView removeFromSuperview];
    }
}
@end
