//
//  XKRWAnimationCircle.h
//  MCChartView
//
//  Created by Shoushou on 16/3/29.
//  Copyright © 2016年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWAnimationCircle : UIView
@property (nonatomic, strong) UIColor *circleProgressColor;
@property (nonatomic, assign) CGFloat circleWidth;

/**
 *  0~1
 */
@property (nonatomic, assign) CGFloat percentage;

- (void)setPathStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
- (void)drawCirclePercentage:(CGFloat)percentage animation:(BOOL)animation duration:(CGFloat)duration;
/**
 *  draw a circle
 *
 *  @param duration 0:no animation else has animation
 */
- (void)drawCircleDuration:(CGFloat)duration;
@end
