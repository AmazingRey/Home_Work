//
//  XKRWNewCalendar.m
//  XKRW
//
//  Created by 忘、 on 16/4/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//


#import "XKRWNewCalendar.h"

#define LABEL_WIDTH ([UIScreen mainScreen].bounds.size.width - 30.f) / 7
#define LABEL_HEIGHT 20.f

@implementation XKRWNewCalendar

- (instancetype)initWithOrigin:(CGPoint)origin recordDateArray:(NSMutableArray *)dateArray andResizeBlock:(void (^)(void))block{
    self = [super self];
    
    if (self) {
        [self initSubViews];
    }
    return self;
}



- (void) initSubViews {
    [self calendarHeadViewWithweekDay];
}





//创建日历头 （周一 到 周日）
- (void) calendarHeadViewWithweekDay {
    UIView *calendarHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
    calendarHeadView.backgroundColor = XK_BACKGROUND_COLOR;
    
    NSArray *dateStringArr = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    CGFloat _xPoint = 15.f;
    for (int i = 0; i < 7; i ++) {
        [calendarHeadView addSubview:
         [self weekdayLabelWithOrigin:CGPointMake(_xPoint, 0.f)
                              andText:dateStringArr[i]]];
        _xPoint += LABEL_WIDTH;
    }
    [self addSubview:calendarHeadView];

}

- (UILabel *)weekdayLabelWithOrigin:(CGPoint)origin andText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, LABEL_WIDTH, LABEL_HEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont boldSystemFontOfSize:14.f]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:text];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

@end
