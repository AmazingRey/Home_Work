//
//  UIView+XKCui.m
//  calorie
//
//  Created by Rick Liao on 12-11-13.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+XKCui.h"

static char assoObjKey;

@implementation UIView (XKCui)

- (void)setCuiStyle:(NSString *)cuiStyle {
    objc_setAssociatedObject(self, &assoObjKey, cuiStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // todo
    // 注意：上面的设置本应该用下面的代码在dealloc中释放，
    //      但由于在范畴中无法覆盖既有dealloc方法（会导致崩溃），所以目前缺乏有效释放的手段。
    //      将来需要摒弃当前这种使用范畴的扩展方式，而改为使用继承的方式实现。
    // objc_setAssociatedObject(self, &assoObjKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)cuiStyle {
    return objc_getAssociatedObject(self, &assoObjKey);
}

//- (void)tryCui {
//    if ([self respondsToSelector:@selector(cuiOnStyle:)]) {
//        [self performSelector:@selector(cuiOnStyle:) withObject:self.cuiStyle];
//    }
//}

- (void)setRoundCornerBorderWithWidth:(CGFloat)width
                               radius:(CGFloat)radius
                                color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
}

- (UIImage *)renderToImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.f);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
