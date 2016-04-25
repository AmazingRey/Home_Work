//
//  XKRWMealPercentView.h
//  XKRW
//
//  Created by ss on 16/4/25.
//  Copyright © 2016年 XiKang. All rights reserved.
//

@class XKRWMealPercentView;
@protocol XKRWMealPercentViewDelegate <NSObject>
@optional
-(void)slideDidScroll:(NSInteger)tag currentPercent:(NSInteger)percent;

@end

#import <UIKit/UIKit.h>
#import "XKRWMealPercentSlider.h"

@interface XKRWMealPercentView : UIView

@property (assign, nonatomic) id<XKRWMealPercentViewDelegate> delegate;
@property (strong, nonatomic) XKRWMealPercentSlider *slider;
@property (strong, nonatomic) UILabel *labNum;
@property (strong, nonatomic) UILabel *labPercent;
@property (assign, nonatomic) CGFloat startValue;

- (instancetype)initWithFrame:(CGRect)frame currentValue:(CGFloat)value;
@end
