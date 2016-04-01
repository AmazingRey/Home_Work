//
//  XKRWEnergyCircleView.m
//  XKRW
//
//  Created by Shoushou on 16/3/31.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWEnergyCircleView.h"
#import "XKRWAnimationCircle.h"

@implementation XKRWEnergyCircleView
{
    UIView *_circleBackgroundView;
    UIButton *_startButton;
    
    XKRWAnimationCircle *_backgroundCircle;
    XKRWAnimationCircle *_progressCircle;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [self initCircleWithFrame:CGRectZero Style:XKRWEnergyCircleStyleNotOpen];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initCircleWithFrame:frame Style:XKRWEnergyCircleStyleNotOpen];
    
    return self;
}

- (instancetype)initCircleWithFrame:(CGRect)frame Style:(XKRWEnergyCircleStyle)style {
    self = [super init];
    self.frame = frame;
    
    if (self) {
        _circleBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _circleBackgroundView.layer.borderWidth = 0.1;
        _circleBackgroundView.layer.borderColor = XKMainSchemeColor.CGColor;
        _circleBackgroundView.layer.cornerRadius = self.width/2.0;
        _circleBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
        _circleBackgroundView.layer.shadowRadius = 1.5;
        _circleBackgroundView.layer.shadowColor = XKMainSchemeColor.CGColor;
        _circleBackgroundView.layer.shadowOpacity = 0.6;
        [self addSubview:_circleBackgroundView];
        
        _backgroundCircle = [[XKRWAnimationCircle alloc] init];
        _backgroundCircle.frame = CGRectMake(-(_circleBackgroundView.width - 10)/2.0, -(_circleBackgroundView.width - 10)/2.0, _circleBackgroundView.width - 10, _circleBackgroundView.width - 10);
        _backgroundCircle.circleProgressColor = colorSecondary_c7c7cc;
        [_backgroundCircle drawCircleWithStartAngle:(- 3 * M_PI_2 + M_PI_2 / 2) endAngle:M_PI_2/2 percentage:1 animation:NO duration:0];
        [self insertSubview:_backgroundCircle aboveSubview:_circleBackgroundView];
        
        _progressCircle = [[XKRWAnimationCircle alloc] init];
        _progressCircle.frame = _progressCircle.bounds;
        _progressCircle.startAngle = _backgroundCircle.startAngle;
        _progressCircle.endAngle = _backgroundCircle.endAngle;
        _progressCircle.percentage = 0;
        [self insertSubview:_progressCircle aboveSubview:_backgroundCircle];
        
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake(_circleBackgroundView.left - 10, _circleBackgroundView.top - 10, _circleBackgroundView.width - 20, _circleBackgroundView.height - 20);
        _startButton.layer.cornerRadius = _startButton.width / 2.0;
        [_startButton setBackgroundImage:[UIImage createImageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_startButton aboveSubview:_progressCircle];
    }
    return self;
}

- (void)setStyle:(XKRWEnergyCircleStyle)style {
    if (style == XKRWEnergyCircleStyleNotOpen) {
        _backgroundCircle.hidden = YES;
        _progressCircle.hidden = YES;
        
    } else if (style == XKRWEnergyCircleStyleOpened) {
        _backgroundCircle.hidden = YES;
        _progressCircle.hidden = YES;
        
    } else if (style == XKRWEnergyCircleStyleSelected) {
        _backgroundCircle.hidden = NO;
        _progressCircle.hidden = NO;
    }
}
- (void)startButtonClicked {
    if (self.energyCircleViewClickBlock) {
        self.energyCircleViewClickBlock();
    }
}
- (void)runProgressCircleWithColor:(UIColor *)progressColor percentage:(CGFloat)percentage duration:(CGFloat)duration {
    _progressCircle.circleProgressColor = progressColor;
    _progressCircle.percentage = percentage;
    [_progressCircle drawCircleDuration:duration];
}

@end
