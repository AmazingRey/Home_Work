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
    UIImageView *_shadowView;
    UIImage *_shadowImage;
    UIButton *_startButton;
    UIImageView *_perfectImageView;
    
    UILabel *_titleLabel;
    UILabel *_currentNumLabel;
    
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
    CGFloat scale = self.width / 95.0;
    if (self) {
        _shadowView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_shadowView];
        
        _backgroundCircle = [[XKRWAnimationCircle alloc] initWithFrame:CGRectMake(_shadowView.left + 6* scale, _shadowView.top + 6 * scale, _shadowView.width - 12 * scale, _shadowView.height - 12 * scale)];
        _backgroundCircle.circleWidth = 4.f * scale;
        _backgroundCircle.circleProgressColor = colorSecondary_c7c7cc;
        [_backgroundCircle setPathStartAngle:(- 3 * M_PI_2 + M_PI_2 / 2) endAngle:M_PI_2/2];
        [_backgroundCircle drawCirclePercentage:1 animation:NO duration:NO];
        _backgroundCircle.center = CGPointMake(self.width/2.0, self.height/2.0);
        [self addSubview:_backgroundCircle];
        
        _progressCircle = [[XKRWAnimationCircle alloc] initWithFrame:_backgroundCircle.bounds];
        _progressCircle.circleWidth = _backgroundCircle.circleWidth;
        [_progressCircle setPathStartAngle:(- 3 * M_PI_2 + M_PI_2 / 2) endAngle:M_PI_2/2];
        _progressCircle.percentage = 0;
        [_backgroundCircle addSubview:_progressCircle];
        
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake(_shadowView.left + 6 * scale, _shadowView.top + 6 * scale, _shadowView.width - 12 * scale, _shadowView.height - 12 * scale);
        _startButton.center = _shadowView.center;
        [_startButton setBackgroundImage:[UIImage imageNamed:@"open_"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self insertSubview:_startButton aboveSubview:_progressCircle];
        
        _currentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 24)];
        _currentNumLabel.textAlignment = NSTextAlignmentCenter;
        _currentNumLabel.font = XKDefaultFontWithSize(24 * scale);
        _currentNumLabel.center = _shadowView.center;
        [self addSubview:_currentNumLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
        _titleLabel.bottom = _currentNumLabel.top - 3 * scale;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = XKDefaultFontWithSize(9 * scale);
        _titleLabel.textColor = XK_ASSIST_TEXT_COLOR;
        [self addSubview:_titleLabel];
        
        _goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 12)];
        _goalLabel.top = _currentNumLabel.bottom + 2 * scale;
        _goalLabel.textAlignment = NSTextAlignmentCenter;
        _goalLabel.font = XKDefaultFontWithSize(12 * scale);
        _goalLabel.textColor = XK_ASSIST_TEXT_COLOR;
        [self addSubview:_goalLabel];
        
        _labelAnimation = [POPBasicAnimation animation];
        _labelAnimation.property = [self animationProperty];
        _labelAnimation.fromValue = @(0);
        _labelAnimation.toValue = @(0);
        
        _stateImageView = [[YYAnimatedImageView alloc] init];
        _stateImageView.hidden = YES;
        _stateImageView.size = CGSizeMake(20 * scale, 20 * scale);
        _stateImageView.center = CGPointMake(CGRectGetMidX(self.bounds), _shadowView.bottom - 12 * scale);
        [_stateImageView addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
        _stateImageView.autoPlayAnimatedImage = NO;
        [self addSubview:_stateImageView];

       
        _perfectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"perfect"]];
        [_perfectImageView sizeToFit];
        _perfectImageView.center = CGPointMake(self.width/2.0, self.height/2.0);
        _perfectImageView.hidden = YES;
        [self addSubview:_perfectImageView];
        
        [self setStyle:style];
        
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"currentAnimatedImageIndex"]) {
        if ([[change objectForKey:NSKeyValueChangeNewKey] integerValue] == 6) {
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
    
    _style = style;
    if (style == XKRWEnergyCircleStyleNotOpen) {
        _shadowView.image = [UIImage imageNamed:@"circle_notOpen_shadow"];
        _stateImageView.hidden = YES;
        _startButton.hidden = NO;
        _backgroundCircle.hidden = YES;
        _progressCircle.hidden = YES;
        _titleLabel.hidden = YES;
        _currentNumLabel.hidden = YES;
        _goalLabel.hidden = YES;
        
    } else if (style == XKRWEnergyCircleStyleOpened) {
        _perfectImageView.hidden = YES;
        _stateImageView.hidden = YES;
        [_startButton setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        _startButton.hidden = NO;
        _backgroundCircle.hidden = YES;
        _progressCircle.hidden = YES;
        _titleLabel.hidden = NO;
        _currentNumLabel.hidden = NO;
        _goalLabel.hidden = NO;
        _shadowView.image = _shadowImage;
    } else if (style == XKRWEnergyCircleStyleSelected) {
        _perfectImageView.hidden = YES;
        _stateImageView.hidden = NO;
        _startButton.hidden = YES;
        _backgroundCircle.hidden = NO;
        _progressCircle.hidden = NO;
        _titleLabel.hidden = NO;
        _currentNumLabel.hidden = NO;
        _goalLabel.hidden = NO;
        _shadowView.image = _shadowImage;
        
    } else if (style == XKRWEnergyCircleStyleHideStateImage) {
        _perfectImageView.hidden = YES;
        _stateImageView.image = nil;
        _stateImageView.hidden = YES;
        _startButton.hidden = YES;
        _backgroundCircle.hidden = NO;
        _progressCircle.hidden = NO;
        _titleLabel.hidden = NO;
        _currentNumLabel.hidden = NO;
        _goalLabel.hidden = NO;
        _shadowView.image = _shadowImage;
        
    } else if (style == XKRWEnergyCircleStylePerfect) {
        _perfectImageView.hidden = NO;
        _stateImageView.hidden = YES;
        [_startButton setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        _startButton.hidden = NO;
        _backgroundCircle.hidden = YES;
        _progressCircle.hidden = YES;
        _titleLabel.hidden = NO;
        _currentNumLabel.hidden = YES;
        _goalLabel.hidden = NO;
        _shadowView.image = _shadowImage;
    }
    
}


- (void)startButtonClicked:(UIButton *)sender {
    
    _isSelected = YES;
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            sender.transform = CGAffineTransformMakeScale(0.5, 0.5);
            if (_style != XKRWEnergyCircleStylePerfect) {
                self.style = XKRWEnergyCircleStyleSelected;
            } else {
                
            }
            
        } completion:^(BOOL finished) {
            [_startButton setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
            if (self.energyCircleViewClickBlock) {
                self.energyCircleViewClickBlock(self.tag);
            }
        }];
        
    }];
}

- (void)setOpenedViewTiltle:(NSString *)ViewTitle
              currentNumber:(NSString *)currentNumber
                 goalNumber:(NSInteger)goalNumber
                       unit:(NSString *)unit
            isBehaveCurrect:(BOOL)isBehaveCurrect {
    
    _titleLabel.text = ViewTitle;
    _currentNumLabel.text = currentNumber;
    _goalLabel.text = [NSString stringWithFormat:@"%ld%@",(long)goalNumber,unit];
    _goalNumber = goalNumber;
    _progressCircle.percentage = [currentNumber intValue]/(CGFloat)goalNumber;
    [self setColorWithAbool:isBehaveCurrect];
}

- (void)runProgressCircleWithColor:(UIColor *)progressColor
                        percentage:(CGFloat)percentage
                          duration:(CGFloat)duration {
//    _progressCircle.percentage = 0;
    _currentNumLabel.textColor = progressColor;
    _progressCircle.circleProgressColor = progressColor;
    [_progressCircle drawCirclePercentage:percentage animation:YES duration:duration];
}

- (void)runToCurrentNum:(NSInteger)currentNum
               duration:(CGFloat)duration
        isBehaveCurrect:(BOOL)isBehaveCurrent {
    
    [self setColorWithAbool:isBehaveCurrent];
    _progressCircle.percentage = 0;
    _labelAnimation.toValue = @(currentNum);
    _labelAnimation.duration = duration;
    [_currentNumLabel pop_addAnimation:_labelAnimation forKey:@"run_Number"];
    
    if (_style == XKRWEnergyCircleStyleSelected) {
        _stateImageView.image = _stateImage;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_stateImageView startAnimating];
            
        });

    } else {
        _stateImageView.hidden = YES;
    }
    
}

- (void)setColorWithAbool:(BOOL)abool {
    if (abool) {
        _shadowImage = [UIImage imageNamed:@"circle_shadow"];
        _progressCircleColor = XKMainSchemeColor;
        _currentNumLabel.textColor = XKMainSchemeColor;
        _stateImage = [YYImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green" ofType:@"gif"]]];
        
    } else {
        _shadowImage = [UIImage imageNamed:@"circle_warming_shadow"];
        _progressCircleColor = XKWarningColor;
        _currentNumLabel.textColor = XKWarningColor;
        _stateImage = [YYImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red" ofType:@"gif"]]];
    }
    if (_style != XKRWEnergyCircleStyleNotOpen) {
        _shadowView.image = _shadowImage;
    }
    _stateImageView.image = _stateImage;

}

- (void)runToNextNumber:(NSInteger)nextNumber
               duration:(CGFloat)duration
   resetIsBehaveCurrect:(BOOL)isBehaveCurrect {
    
    id exNumber = _labelAnimation.toValue;
    _labelAnimation.fromValue = exNumber;
    
    [self setColorWithAbool:isBehaveCurrect];
    CGFloat currentPercentage = (CGFloat)nextNumber/_goalNumber;
    [self runToCurrentNum:nextNumber duration:duration isBehaveCurrect:isBehaveCurrect];
    _progressCircle.percentage = [exNumber integerValue]/(CGFloat)_goalNumber;
    [self runProgressCircleWithColor:_progressCircleColor percentage:currentPercentage duration:duration];
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
