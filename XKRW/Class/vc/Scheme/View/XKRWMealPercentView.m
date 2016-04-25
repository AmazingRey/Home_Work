//
//  XKRWMealPercentView.m
//  XKRW
//
//  Created by ss on 16/4/25.
//  Copyright © 2016年 XiKang. All rights reserved.
//


#import "XKRWMealPercentView.h"
#import "masonry.h"

@implementation XKRWMealPercentView
- (instancetype)initWithFrame:(CGRect)frame currentValue:(CGFloat)value
{
    self = [super initWithFrame:frame];
    if (self) {
        _startValue = value;
         [self addMySlider];
    }
    return self;
}

-(void)addMySlider{
    UIImage *thumbImage = [[UIImage imageNamed:@"round"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14) resizingMode:UIImageResizingModeStretch];
    [_slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    self.slider.value = _startValue;
    self.slider.minimumValue=0.0;
    self.slider.maximumValue=1.0;
    [self.slider setMinimumTrackTintColor:XKMainToneColor_29ccb1];
    [self.slider setMaximumTrackTintColor:[UIColor colorFromHexString:@"#e7e7e7"]];
    [self addSubview:self.slider];
    
    //滑块拖动时的事件
    [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [_slider addTarget:self action:@selector(sliderDragUp) forControlEvents:UIControlEventTouchUpInside];
    
    _labPercent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    _labPercent.textAlignment = NSTextAlignmentLeft;
    _labPercent.textColor = colorSecondary_999999;
    _labPercent.font = [UIFont systemFontOfSize:17];
    [self addSubview:_labPercent];
    
    
}

-(void)setStartValue:(CGFloat)startValue{
    if (_startValue != startValue) {
        _startValue = startValue;
    }
    [self updateConstraints];
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
//        NSLog(@"😀%ld:变化为:%.2f",(long)_slider.tag,_slider.value);
//        NSLog(@"_sliderValueChanged");
        _startValue = _slider.value;
    }
    NSInteger percent = ceilf(_startValue*100);
    _labPercent.text = [NSString stringWithFormat:@"%ld%%",(long)percent];
    
    if ([self.delegate respondsToSelector:@selector(slideDidScroll:currentPercent:)]) {
        [self.delegate slideDidScroll:_slider.tag currentPercent:(long)percent];
    }
}

@end