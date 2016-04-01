//
//  XKRWEnergyCircleView.h
//  XKRW
//
//  Created by Shoushou on 16/3/31.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XKRWEnergyCircleStyle) {
    XKRWEnergyCircleStyleNotOpen = 1,//未开启
    XKRWEnergyCircleStyleSelected, //开启并选中
    XKRWEnergyCircleStyleOpened //已开启未选中
};
typedef void(^startButtonClickBlock)(void);
@interface XKRWEnergyCircleView : UIView
@property (nonatomic, strong) UIColor *outCircleColor;
@property (nonatomic, strong) UIColor *progressCircleBackgroundColor;
@property (nonatomic, strong) UIColor *progressCircleColor;
@property (nonatomic, assign) CGFloat percentage;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, copy) startButtonClickBlock energyCircleViewClickBlock;
@property (nonatomic, assign) XKRWEnergyCircleStyle style;

- (void)runProgressCircleWithColor:(UIColor *)progressColor percentage:(CGFloat)percentage duration:(CGFloat)duration;

@end
