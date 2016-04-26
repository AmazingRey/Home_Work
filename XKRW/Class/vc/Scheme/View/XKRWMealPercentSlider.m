//
//  XKRWMealPercentSlider.m
//  XKRW
//
//  Created by 刘睿璞 on 16/4/24.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWMealPercentSlider.h"

@implementation XKRWMealPercentSlider

-(CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds.size.height=7;
    return bounds;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - 5 ;
    rect.size.width = rect.size.width +10;
    CGRect res = CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 5 , 5);
    return res;
}

//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
//    bounds.size.height=50;
//    return bounds;
//}
//
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
//    bounds.size.height=20;
//    return bounds;
//}

@end
