//
//  XKRWEnergyCircleView.m
//  XKRW
//
//  Created by Shoushou on 16/3/31.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWEnergyCircleView.h"
#import "XKRWAnimationCircle.h"
#import "POP.h"
#import <YYImage/YYImage.h>
@implementation XKRWEnergyCircleView
{
    UIView *_shadowView;
    UIButton *_startButton;
    
    UILabel *_titleLabel;
    UILabel *_currentNumLabel;
    UILabel *_goalLabel;
    
    XKRWAnimationCircle *_backgroundCircle;
    XKRWAnimationCircle *_progressCircle;
    POPBasicAnimation *_labelAnimation;
    
    YYAnimatedImageView *_stateImageView;
    YYImage *_stateImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initCircleWithFrame:(CGRect)frame Style:(XKRWEnergyCircleStyle)style {
    self = [super initWithFrame:frame];
    
    if (self) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _shadowView.layer.borderWidth = 0.1;
        _shadowView.layer.cornerRadius = self.width/2.0;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowRadius = 3;
        _shadowView.layer.shadowOpacity = 1;
        self.shadowColor = XKMainSchemeColor;
        [self addSubview:_shadowView];
        
        _backgroundCircle = [[XKRWAnimationCircle alloc] initWithFrame:CGRectMake(_shadowView.left + 3, _shadowView.top + 3, _shadowView.width - 6, _shadowView.height - 6)];
        _backgroundCircle.circleWidth = 4.f;
        _backgroundCircle.circleProgressColor = colorSecondary_c7c7cc;
        [_backgroundCircle setPathStartAngle:(- 3 * M_PI_2 + M_PI_2 / 2) endAngle:M_PI_2/2];
        [_backgroundCircle drawCirclePercentage:1 animation:NO duration:NO];
        _backgroundCircle.center = CGPointMake(self.width/2.0, self.height/2.0);
        [self addSubview:_backgroundCircle];
        
        _progressCircle = [[XKRWAnimationCircle alloc] initWithFrame:_backgroundCircle.frame];
        _progressCircle.circleWidth = _backgroundCircle.circleWidth;
        [_progressCircle setPathStartAngle:(- 3 * M_PI_2 + M_PI_2 / 2) endAngle:M_PI_2/2];
        _progressCircle.percentage = 0;
        [self insertSubview:_progressCircle aboveSubview:_backgroundCircle];
        
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake(_shadowView.left + 10, _shadowView.top + 10, _shadowView.width - 20, _shadowView.height - 20);
        _startButton.layer.cornerRadius = _startButton.width / 2.0;
        [_startButton setBackgroundImage:[UIImage imageNamed:@"open_"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
        [_startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self insertSubview:_startButton aboveSubview:_progressCircle];
        
        _currentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 24)];
        _currentNumLabel.textAlignment = NSTextAlignmentCenter;
        _currentNumLabel.font = XKDefaultFontWithSize(24);
        _currentNumLabel.center = _shadowView.center;
        [self addSubview:_currentNumLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
        _titleLabel.bottom = _currentNumLabel.top - 2.5;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = XKDefaultFontWithSize(9);
        _titleLabel.textColor = XK_ASSIST_TEXT_COLOR;
        [self addSubview:_titleLabel];
        
        _goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 12)];
        _goalLabel.top = _currentNumLabel.bottom;
        _goalLabel.textAlignment = NSTextAlignmentCenter;
        _goalLabel.font = XKDefaultFontWithSize(12);
        _goalLabel.textColor = XK_ASSIST_TEXT_COLOR;
        [self addSubview:_goalLabel];
        
        _labelAnimation = [POPBasicAnimation animation];
        _labelAnimation.property = [self animationProperty];
        _labelAnimation.fromValue = @(0);
        
        _stateImageView = [[YYAnimatedImageView alloc] init];
        _stateImageView.size = CGSizeMake(20, 20);
        _stateImageView.center = CGPointMake(CGRectGetMidX(self.bounds), _shadowView.bottom - 10);
        [_stateImageView addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
    
        _stateImageView.autoPlayAnimatedImage = NO;
        [self addSubview:_stateImageView];
        [self setStyle:style];
        
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentAnimatedImageIndex"]) {
        if ([[change objectForKey:NSKeyValueChangeNewKey] integerValue] == 17) {
            [_stateImageView stopAnimating];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc {
    [_stateImageView removeObserver:self forKeyPath:@"currentAnimatedImageIndex"];
}
- (void)setStyle:(XKRWEnergyCircleStyle)style {
    if (style == XKRWEnergyCircleStyleNotOpen) {
        _stateImageView.hidden = YES;
        _startButton.hidden = NO;
        _backgroundCircle.hidden = YES;
        _progressCircle.hidden = YES;
        _titleLabel.hidden = YES;
        _currentNumLabel.hidden = YES;
        _goalLabel.hidden = YES;
        
    } else if (style == XKRWEnergyCircleStyleOpened) {
        _stateImageView.hidden = YES;
        _startButton.hidden = NO;
        _backgroundCircle.hidden = YES;
        _progressCircle.hidden = YES;
        _titleLabel.hidden = NO;
        _currentNumLabel.hidden = NO;
        _goalLabel.hidden = NO;
        
    } else if (style == XKRWEnergyCircleStyleSelected) {
        _stateImageView.hidden = NO;
        _backgroundCircle.hidden = NO;
        _progressCircle.hidden = NO;
        _titleLabel.hidden = NO;
        _currentNumLabel.hidden = NO;
        _goalLabel.hidden = NO;
    }
}

- (void)pressedEvent:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
}
- (void)startButtonClicked:(UIButton *)sender {
    [_stateImageView startAnimating];

    [UIView animateWithDuration:0.5 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.style = XKRWEnergyCircleStyleSelected;
    } completion:^(BOOL finished) {
        [_startButton setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
        if (self.energyCircleViewClickBlock) {
            self.energyCircleViewClickBlock();
        }
    }];
}

- (void)setOpenedViewTiltle:(NSString *)ViewTitle currentNumber:(NSString *)currentNumber goalNumber:(NSString *)goalNumber isBehaveCurrect:(BOOL)isBehaveCurrect {
    _titleLabel.text = ViewTitle;
    _currentNumLabel.text = currentNumber;
    _goalLabel.text = goalNumber;
    if (isBehaveCurrect) {
        self.shadowColor = XKMainSchemeColor;
        _currentNumLabel.textColor = XKMainSchemeColor;
        _stateImage = [YYImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green" ofType:@"gif"]]];
    } else {
        self.shadowColor = XKWarningColor;
        _currentNumLabel.textColor = XKWarningColor;
        _stateImage = [YYImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red" ofType:@"gif"]]];
    }
    _stateImageView.image = _stateImage;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    _shadowView.layer.shadowColor = shadowColor.CGColor;
    _shadowView.layer.borderColor = [shadowColor colorWithAlphaComponent:0.6].CGColor;
}

- (void)runProgressCircleWithColor:(UIColor *)progressColor percentage:(CGFloat)percentage duration:(CGFloat)duration {
    _currentNumLabel.textColor = progressColor;
    _progressCircle.circleProgressColor = progressColor;
    _progressCircle.percentage = 0;
    [_progressCircle drawCirclePercentage:percentage animation:YES duration:duration];
}

- (void)runToCurrentNum:(NSInteger)currentNum duration:(CGFloat)duration {
    _labelAnimation.toValue = @(currentNum);
    _labelAnimation.duration = duration;
    [_currentNumLabel pop_addAnimation:_labelAnimation forKey:@"run_Number"];
}

- (POPMutableAnimatableProperty *)animationProperty {
    return [POPMutableAnimatableProperty propertyWithName:@"run_Number" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            UILabel *label = (UILabel *)obj;
            NSNumber *number = @(values[0]);
            int num = [number intValue];
            label.text = [@(num) stringValue];
        };
    }];
}
@end
