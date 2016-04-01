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
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
/**
 *  0~1
 */
@property (nonatomic, assign) CGFloat percentage;
/**
 *  draw a circle (endAngle - startAngle)= 100%percentage
 *
 *  @param startAngle start destination
 *  @param endAngle   end destination
 *  @param percentage percentage of the circle
 *  @param animation  yes:has animation. no:no animation
 *  @param duration   0:no animation else has animation
 */
- (void)drawCircleWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle percentage:(CGFloat)percentage animation:(BOOL)animation duration:(CGFloat)duration;
/**
 *  draw a circle
 *
 *  @param duration 0:no animation else has animation
 */
- (void)drawCircleDuration:(CGFloat)duration;
@end
