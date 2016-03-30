//
//  UIImageView+XKCui.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-3.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "UIImageView+XKCui.h"

@implementation UIImageView (XKCui)

+ (UIImageView *)imageViewWithImageName:(NSString *)imageName originPoint:(CGPoint)originPoint {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    CGRect frame = imageView.bounds;
    frame.origin = originPoint;
    imageView.frame = frame;
    
    return imageView;
}

@end
