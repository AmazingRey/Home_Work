//
//  UIImage+Helper.h
//  vik_learning_ios
//
//  Created by Yang Lijuan on 13-3-12.
//  Copyright (c) 2013年 neu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)
/** return a current screen shot, and it must be in size of 320*480 */
+(UIImage*)screenShot;

/*
 * Creates an image from the contents of a URL
 */
+ (UIImage*)imageWithContentsOfURL:(NSURL*)url;

/*
 * Scales the image to the given size
 */
- (UIImage*)scaleToSize:(CGSize)size;

/*
 * Scales and crops the image to the given size
 * Automatically detects the size/height and offset
 * Sides of the image will be cropped so the result is centered
 */
- (UIImage*)scaleAndCropToSize:(CGSize)size;

/*
 * Scales the height and crops the width to the size
 * Sides of the image will be cropped so the result is centered
 */
- (UIImage*)scaleHeightAndCropWidthToSize:(CGSize)size;

/*
 * Scales the width and crops the height to the size
 * Sides of the image will be cropped so the result is centered
 */
- (UIImage*)scaleWidthAndCropHeightToSize:(CGSize)size;

/*
 * Scales image to the size, crops to the offset
 * Provide offset based on scaled size, not original size
 *
 * Example:
 * Image is 640x480, scaling to 480x320
 * This will then scale to 480x360
 *
 * If you want to vertically center the image, set the offset to CGPointMake(0.0,-20.0f)
 * Now it will clip the top 20px, and the bottom 20px giving you the desired 480x320
 */
- (UIImage*)scaleToSize:(CGSize)size withOffset:(CGPoint)offset;

/**
 * Draws the image using content mode rules.
 */
- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;

/**
 * Draws the image as a rounded rectangle.
 */
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius;
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode;

//按size的比例调整原图
- (UIImage *)gtm_imageByResizingLikeSize:(CGSize)size;
//按照原图比例压缩至size大小
- (UIImage *)gtm_imageByResizingToSize:(CGSize)targetSize
                   preserveAspectRatio:(BOOL)preserveAspectRatio
                             trimToFit:(BOOL)trimToFit;
//UIColor 转 UIImage
- (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)createImageWithColor:(UIColor *)color;
@end
