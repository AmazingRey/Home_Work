//
//  UIImage+XKCui.h
//  XKCommon
//
//  Created by Rick Liao on 13-3-18.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XKCui)

+ (UIImage *)screenSensitiveImageNamed:(NSString *)name;

- (UIImage *)fixOrientation;

@end
