//
//  XKRWAnimationCircle.m
//  MCChartView
//
//  Created by Shoushou on 16/3/29.
//  Copyright © 2016年 zhmch0329. All rights reserved.
//

#import "XKRWAnimationCircle.h"

@interface XKRWAnimationCircle ()
{
    CAShapeLayer *_progressShapeLayer;
    UIBezierPath *_progressBezierPath;
}

@end

@implementation XKRWAnimationCircle

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _progressShapeLayer = [CAShapeLayer new];
        [self.layer addSublayer:_progressShapeLayer];
        _progressShapeLayer.fillColor = nil;
        _progressShapeLayer.lineCap = kCALineCapRound;
        _progressShapeLayer.frame = self.bounds;
        _progressShapeLayer.strokeStart = 0;
        _circleWidth = 5.0;
        
    }
    return self;
}


- (void)setCircleProgressColor:(UIColor *)circleProgressColor {
    _progressShapeLayer.strokeColor = circleProgressColor.CGColor;
}

- (void)setCircleWidth:(CGFloat)circleWidth {
    _circleWidth = circleWidth;
    _progressShapeLayer.lineWidth = circleWidth;
}

- (void)drawCircleWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle percentage:(CGFloat)percentage animation:(BOOL)animation duration:(CGFloat)duration{
    _startAngle = startAngle;
    _endAngle = endAngle;
    _percentage = percentage;
    
    _progressShapeLayer.strokeEnd = percentage;
    _progressBezierPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _circleWidth)/2 startAngle:startAngle endAngle:endAngle clockwise:YES];
    _progressShapeLayer.path = _progressBezierPath.CGPath;
    
    if (animation && duration != 0) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basicAnimation.fromValue = @(0.0);
        basicAnimation.toValue = @(percentage);
        basicAnimation.repeatCount = 0.f;
        basicAnimation.duration = duration;
        [_progressShapeLayer addAnimation:basicAnimation forKey:@"animation"];
    }

}
- (void)drawCircleDuration:(CGFloat)duration {
    [self drawCircleWithStartAngle:_startAngle endAngle:_endAngle percentage:_percentage animation:YES duration:duration];
}

@end
