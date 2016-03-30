//
//  UIImage+Helper.m
//  vik_learning_ios
//
//  Created by Yang Lijuan on 13-3-12.
//  Copyright (c) 2013年 neu. All rights reserved.
//

#import "UIImage+Helper.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Helper)
+(UIImage*)screenShot{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	
	UIGraphicsBeginImageContext(screenRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextClearRect(ctx , screenRect);
	
	UIApplication * app = [UIApplication sharedApplication];
	UIWindow * win = [app keyWindow];
	[win.layer renderInContext:ctx];
	CGContextFlush(ctx);
	
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	
	return img;
}

#pragma mark private

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
	CGContextBeginPath(context);
	CGContextSaveGState(context);
	
	if (radius == 0) {
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextAddRect(context, rect);
	} else {
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextScaleCTM(context, radius, radius);
		float fw = CGRectGetWidth(rect) / radius;
		float fh = CGRectGetHeight(rect) / radius;
		
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	}
	
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}
#pragma mark Public
+ (UIImage*)imageWithContentsOfURL:(NSURL*)url {
	NSData* data =[NSData dataWithContentsOfURL:url];
	
	return [UIImage imageWithData:data];
}

- (UIImage*)scaleToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage*)scaleAndCropToSize:(CGSize)size {
	if(size.height > size.width) {
		if(self.size.height > self.size.width) {
			if((self.size.width  / self.size.height) >= (size.width / size.height)) {
				return [self scaleHeightAndCropWidthToSize:size];
			} else {
				return [self scaleWidthAndCropHeightToSize:size];
			}
		} else {
			return [self scaleHeightAndCropWidthToSize:size];
		}    
	} else {
		if(self.size.width > self.size.height) {
			if((self.size.height / self.size.width) >= (size.height / size.width)) {
				return [self scaleWidthAndCropHeightToSize:size];
			} else {
				return [self scaleHeightAndCropWidthToSize:size];
			}
		} else {
			return [self scaleWidthAndCropHeightToSize:size];
		}    
	}
}

- (UIImage*)scaleHeightAndCropWidthToSize:(CGSize)size {
	float newWidth = (self.size.width * size.height) / self.size.height;
	return [self scaleToSize:size withOffset:CGPointMake((newWidth - size.width) / 2, 0.0f)];
}

- (UIImage*)scaleWidthAndCropHeightToSize:(CGSize)size {
	float newHeight = (self.size.height * size.width) / self.size.width;
	return [self scaleToSize:size withOffset:CGPointMake(0, (newHeight - size.height) / 2)];
}

- (UIImage*)scaleToSize:(CGSize)size withOffset:(CGPoint)offset {
	UIImage* scaledImage = [self scaleToSize:CGSizeMake(size.width + (offset.x * -2), size.height + (offset.y * -2))];
	
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGRect croppedRect;
	croppedRect.size = size;
	croppedRect.origin = CGPointZero;
	
	CGContextClipToRect(context, croppedRect);
	
	CGRect drawRect;
	drawRect.origin = offset;
	drawRect.size = scaledImage.size;
	
	CGContextDrawImage(context, drawRect, scaledImage.CGImage);
	
	
	UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return croppedImage;
}

- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode {
	BOOL clip = NO;
	CGRect originalRect = rect;
	if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
		if (contentMode == UIViewContentModeLeft) {
			rect = CGRectMake(rect.origin.x,
							  rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
							  self.size.width, self.size.height);
			clip = YES;
		} else if (contentMode == UIViewContentModeRight) {
			rect = CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
							  rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
							  self.size.width, self.size.height);
			clip = YES;
		} else if (contentMode == UIViewContentModeTop) {
			rect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
							  rect.origin.y,
							  self.size.width, self.size.height);
			clip = YES;
		} else if (contentMode == UIViewContentModeBottom) {
			rect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
							  rect.origin.y + floor(rect.size.height - self.size.height),
							  self.size.width, self.size.height);
			clip = YES;
		} else if (contentMode == UIViewContentModeCenter) {
			rect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
							  rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeBottomLeft) {
			rect = CGRectMake(rect.origin.x,
							  rect.origin.y + floor(rect.size.height - self.size.height),
							  self.size.width, self.size.height);
			clip = YES;
		} else if (contentMode == UIViewContentModeBottomRight) {
			rect = CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
							  rect.origin.y + (rect.size.height - self.size.height),
							  self.size.width, self.size.height);
			clip = YES;
		} else if (contentMode == UIViewContentModeTopLeft) {
			rect = CGRectMake(rect.origin.x,
							  rect.origin.y,
							  self.size.width, self.size.height);
			clip = YES;
		} else if (contentMode == UIViewContentModeTopRight) {
			rect = CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
							  rect.origin.y,
							  self.size.width, self.size.height);
			clip = YES;
		} else if (contentMode == UIViewContentModeScaleAspectFill) {
			CGSize imageSize = self.size;
			if (imageSize.height < imageSize.width) {
				imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
				imageSize.height = rect.size.height;
			} else {
				imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
				imageSize.width = rect.size.width;
			}
			rect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
							  rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
							  imageSize.width, imageSize.height);
		} else if (contentMode == UIViewContentModeScaleAspectFit) {
			CGSize imageSize = self.size;
			if (imageSize.height < imageSize.width) {
				imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
				imageSize.width = rect.size.width;
			} else {
				imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
				imageSize.height = rect.size.height;
			}
			rect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
							  rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
							  imageSize.width, imageSize.height);
		}
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (clip) {
		CGContextSaveGState(context);
		CGContextAddRect(context, originalRect);
		CGContextClip(context);
	}
	
	[self drawInRect:rect];
	
	if (clip) {
		CGContextRestoreGState(context);
	}
}

- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius {
	[self drawInRect:rect radius:radius contentMode:UIViewContentModeScaleToFill];
}

- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	if (radius) {
		[self addRoundedRectToPath:context rect:rect radius:radius];
		CGContextClip(context);
	}
	
	[self drawInRect:rect contentMode:contentMode];
	
	CGContextRestoreGState(context);
}

- (UIImage *)gtm_imageByResizingLikeSize:(CGSize)size{
    CGSize imageSize = [self size];
    if (imageSize.height < 1 || imageSize.width < 1) {
        return nil;
    }
    if (size.height < 1 || size.width < 1) {
        return nil;
    }
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGFloat targetRatio = size.width / size.height;
    CGRect projectTo = CGRectZero;
    CGSize targetSize = CGSizeZero;
    
    if (aspectRatio > targetRatio) {
        targetSize.width = imageSize.height * targetRatio;
        targetSize.height = imageSize.height;
        
        
        projectTo.origin.x = (targetSize.width -imageSize.width) / 2;
        projectTo.origin.y = 0;
        projectTo.size = imageSize;
    }else{
        targetSize.width = imageSize.width;
        targetSize.height = imageSize.width / targetRatio;
        
        projectTo.origin.x = 0;
        projectTo.origin.y = (targetSize.height -imageSize.height) / 2;;
        projectTo.size = imageSize;
    }
    
    projectTo = CGRectIntegral(projectTo);
    // There's no CGSizeIntegral, so we fake our own.
    CGRect integralRect = CGRectZero;
    integralRect.size = targetSize;
    targetSize = CGRectIntegral(integralRect).size;
    
    // Resize photo. Use UIImage drawing methods because they respect
    // UIImageOrientation as opposed to CGContextDrawImage().
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:projectTo];
    UIImage* resizedPhoto = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedPhoto;
}

- (UIImage *)gtm_imageByResizingToSize:(CGSize)targetSize
                   preserveAspectRatio:(BOOL)preserveAspectRatio
                             trimToFit:(BOOL)trimToFit
{
    CGSize imageSize = [self size];
    if (imageSize.height < 1 || imageSize.width < 1) {
        return nil;
    }
    if (targetSize.height < 1 || targetSize.width < 1) {
        return nil;
    }
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGFloat targetAspectRatio = targetSize.width / targetSize.height;
    CGRect projectTo = CGRectZero;
    if (preserveAspectRatio) {
        if (trimToFit) {
            // Scale and clip image so that the aspect ratio is preserved and the
            // target size is filled.
            if (targetAspectRatio < aspectRatio) {
                // clip the x-axis.
                projectTo.size.width = targetSize.height * aspectRatio;
                projectTo.size.height = targetSize.height;
                projectTo.origin.x = (targetSize.width - projectTo.size.width) / 2;
                projectTo.origin.y = 0;
            } else {
                // clip the y-axis.
                projectTo.size.width = targetSize.width;
                projectTo.size.height = targetSize.width / aspectRatio;
                projectTo.origin.x = 0;
                projectTo.origin.y = (targetSize.height - projectTo.size.height) / 2;
            }
        } else {
            // Scale image to ensure it fits inside the specified targetSize.
            if (targetAspectRatio < aspectRatio) {
                // target is less wide than the original.
                projectTo.size.width = targetSize.width;
                projectTo.size.height = projectTo.size.width / aspectRatio;
                targetSize = projectTo.size;
            } else {
                // target is wider than the original.
                projectTo.size.height = targetSize.height;
                projectTo.size.width = projectTo.size.height * aspectRatio;
                targetSize = projectTo.size;
            }
        } // if (clip)
    } else {
        // Don't preserve the aspect ratio.
        projectTo.size = targetSize;
    }
    
    projectTo = CGRectIntegral(projectTo);
    // There's no CGSizeIntegral, so we fake our own.
    CGRect integralRect = CGRectZero;
    integralRect.size = targetSize;
    targetSize = CGRectIntegral(integralRect).size;
    
    // Resize photo. Use UIImage drawing methods because they respect
    // UIImageOrientation as opposed to CGContextDrawImage().
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, [[UIScreen mainScreen] scale]);
    //  UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:projectTo];
    UIImage* resizedPhoto = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedPhoto;
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


@end
