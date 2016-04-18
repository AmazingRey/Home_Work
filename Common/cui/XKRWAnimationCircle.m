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
    CGFloat _startAngle;
    CGFloat _endAngle;
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
        _percentage = 0;
    }
    return self;
}
- (void)setPercentage:(CGFloat)percentage {
    _percentage = percentage;
    _progressShapeLayer.strokeEnd = percentage;
}

- (void)setPathStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    _startAngle = startAngle;
    _endAngle = endAngle;
    _progressBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) radius:(self.bounds.size.width - _circleWidth)/2 startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    _progressShapeLayer.path = _progressBezierPath.CGPath;

}


- (void)setCircleProgressColor:(UIColor *)circleProgressColor {
    _progressShapeLayer.strokeColor = circleProgressColor.CGColor;
}

- (void)setCircleWidth:(CGFloat)circleWidth {
    _circleWidth = circleWidth;
    _progressShapeLayer.lineWidth = circleWidth;
}

- (void)drawCirclePercentage:(CGFloat)percentage animation:(BOOL)animation duration:(CGFloat)duration {
    
    if (!animation || duration == 0) {
        _progressShapeLayer.strokeEnd = percentage;
        return;
    } else {
        _progressShapeLayer.strokeEnd = percentage;
        CABasicAnimation *baseAnimation = [CABasicAnimation animation];
        baseAnimation.fromValue = @(_percentage);
        baseAnimation.toValue = @(percentage);
        baseAnimation.duration = duration;
        baseAnimation.repeatCount = 1.f;
        [_progressShapeLayer addAnimation:baseAnimation forKey:@"strokeEnd"];
    }
    _percentage = percentage;
}
- (void)drawCircleDuration:(CGFloat)duration {
    [self drawCirclePercentage:_percentage animation:YES duration:duration];
}

@end
