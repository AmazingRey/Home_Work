//
//  UIView+XKCui.h
//  calorie
//
//  Created by Rick Liao on 12-11-13.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XKCui)

@property(nonatomic,retain) NSString *cuiStyle UI_APPEARANCE_SELECTOR;

//- (void)tryCui;

- (void)setRoundCornerBorderWithWidth:(CGFloat)width
                               radius:(CGFloat)radius
                                color:(UIColor *)color;

- (UIImage *)renderToImage;

@end
