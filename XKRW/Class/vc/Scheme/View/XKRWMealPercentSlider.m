//
//  XKRWMealPercentSlider.m
//  XKRW
//
//  Created by 刘睿璞 on 16/4/24.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWMealPercentSlider.h"

@implementation XKRWMealPercentSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - 10 ;
    rect.size.width = rect.size.width +20;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 0 , 0);
}

//-(CGRect)trackRectForBounds:(CGRect)bounds
//{
//    bounds.size.height=20;
//    return bounds;
//}
//
//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
//    bounds.size.height=20;
//    return bounds;
//}
//
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
//    bounds.size.height=20;
//    return bounds;
//}

@end
