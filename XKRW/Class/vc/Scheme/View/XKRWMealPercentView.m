//
//  XKRWMealPercentView.m
//  XKRW
//
//  Created by ss on 16/4/25.
//  Copyright © 2016年 XiKang. All rights reserved.
//


#import "XKRWMealPercentView.h"
#import "masonry.h"
#import "XKRWAlgolHelper.h"

@implementation XKRWMealPercentView
- (instancetype)initWithFrame:(CGRect)frame currentValue:(NSNumber *)value totalKcal:(CGFloat)totalKcal
{
    self = [super initWithFrame:frame];
    if (self) {
        _totalKcal = totalKcal;
        _startValue = [value floatValue]/100;
        _currentPerCent = value;
         [self addMySlider];
    }
    return self;
}

-(void)addMySlider{
    
    self.slider.value = _startValue;
    self.slider.minimumValue=0.0;
    self.slider.maximumValue=1.0;
    [self.slider setMinimumTrackTintColor:XKMainToneColor_29ccb1];
    [self.slider setMaximumTrackTintColor:[UIColor colorFromHexString:@"#e7e7e7"]];
//    [self.slider setThumbTintColor:XKMainToneColor_29ccb1];
    
    UIImage *thumbImage = [UIImage imageNamed:@"round"];
    [_slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [self addSubview:self.slider];
    
    //滑块拖动时的事件
    [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [_slider addTarget:self action:@selector(sliderDragUp) forControlEvents:UIControlEventTouchUpInside];
    
    _labPercent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    _labPercent.textAlignment = NSTextAlignmentLeft;
    _labPercent.textColor = colorSecondary_999999;
    _labPercent.font = [UIFont systemFontOfSize:15];
    _labPercent.text = [NSString stringWithFormat:@"%d%%",_currentPerCent.intValue];
    [self addSubview:_labPercent];
    
    _btnLock = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLock.frame = CGRectMake(0, 0, 30, 30);
    [_btnLock addTarget:self action:@selector(actBtnLock) forControlEvents:UIControlEventTouchUpInside];
    [_btnLock setImage:[UIImage imageNamed:@"lock3"] forState:UIControlStateNormal];
    [_btnLock setImage:[UIImage imageNamed:@"lock2"] forState:UIControlStateSelected];
    [self addSubview:_btnLock];
    
    UIImage *image = [UIImage imageNamed:@"addmeal5_3"];
    _imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height - image.size.height) / 2.0, image.size.width, image.size.height)];
    _imgHead.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imgHead];
    
    _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    _labTitle.textAlignment = NSTextAlignmentLeft;
    _labTitle.textColor = colorSecondary_999999;
    _labTitle.font = [UIFont systemFontOfSize:15];
    [self addSubview:_labTitle];
    
    _labNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _labNum.textAlignment = NSTextAlignmentCenter;
    _labNum.textColor = colorSecondary_999999;
    _labNum.font = [UIFont systemFontOfSize:15];
    float num = _totalKcal *_currentPerCent.integerValue/100.f + .5;
    NSString *str = [NSString stringWithFormat:@"%.0fkcal",floorf(num)];
    _labNum.text = str;
    [self addSubview:_labNum];
    
    _labSeperate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 1)];
    _labSeperate.backgroundColor = [UIColor colorFromHexString:@"#e7e7e7"];
    [self addSubview:_labSeperate];
}

-(void)setStartValue:(CGFloat)startValue{
    if (_startValue != startValue) {
        _startValue = startValue;
    }
    [self updateConstraints];
}

-(void)setLock:(BOOL)lock{
    if (_lock != lock) {
        _lock = lock;
    }
}

-(void)actBtnLock{
    if (_lock) {
        [_btnLock setImage:[UIImage imageNamed:@"lock3"] forState:UIControlStateNormal];
        _lock = NO;
        self.slider.userInteractionEnabled = !_lock;
        if ([self.delegate respondsToSelector:@selector(lockpercentView:withPercent:lock:)]) {
            [self.delegate lockpercentView:self.slider.tag withPercent:ceilf(_startValue*100)lock:YES];
        }
    }else{
        [_btnLock setImage:[UIImage imageNamed:@"lock2"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(lockpercentView:withPercent:lock:)]) {
            [self.delegate lockpercentView:self.slider.tag withPercent:_currentPerCent.integerValue lock:_lock];
        }
        _lock = YES;
        self.slider.userInteractionEnabled = !_lock;
    }
}

-(void)cancleBtnLock{
    [_btnLock setImage:[UIImage imageNamed:@"lock3"] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(unlockPercentView:)]) {
        [self.delegate unlockPercentView:self.slider.tag];
    }
    _lock = NO;
    self.slider.userInteractionEnabled = !_lock;
}

-(void)cancleBtnLockWithoutDelegate{
    [_btnLock setImage:[UIImage imageNamed:@"lock3"] forState:UIControlStateNormal];
    _lock = NO;
    self.slider.userInteractionEnabled = !_lock;
}

-(XKRWMealPercentSlider *)slider{
    if (_slider == nil) {
        _slider=[[XKRWMealPercentSlider alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    }
    return _slider;
}

-(void)sliderDragUp{
    _startValue = _slider.value;
}

-(void)sliderValueChanged{
    if (fabs(_startValue - _slider.value) >.01) {
        _startValue = _slider.value;
    }
    
    _currentPerCent = @(ceilf(_startValue*100));
    if ([self.delegate respondsToSelector:@selector(slideDidScroll:currentPercent:)]) {
        [self.delegate slideDidScroll:_slider.tag currentPercent:_currentPerCent.integerValue];
    }
}

@end