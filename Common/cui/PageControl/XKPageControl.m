//
//  XKPageControl.m
//  calorie
//
//  Created by Rick Liao on 12-10-9.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "XKPageControl.h"
#import "XKUtil.h"

@interface XKPageControl ()

- (void)updateDots;

@end


@implementation XKPageControl

@synthesize dotOnImage = _dotOnImage;
@synthesize dotOffImage = _dotOffImage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    [XKUtil executeCodeWhenSystemVersionAbove:7.0 blow:0 withBlock:^{
        if ([self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)] && [self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
            [self setCurrentPageIndicatorTintColor:[UIColor clearColor]];
            [self setPageIndicatorTintColor:[UIColor clearColor]];
        }
        
        [self setBackgroundColor:[UIColor clearColor]];
 
        for (UIView *su in self.subviews) {
            [su removeFromSuperview];
        }
        self.contentMode=UIViewContentModeRedraw;
            
        }];
        
    }
    return self;
}

- (void)setDotOnImageWithName:(NSString *)imageName {
    _dotOnImage = [UIImage imageNamed:imageName];
}

- (void)setDotOffImageWithName:(NSString *)imageName {
    _dotOffImage = [UIImage imageNamed:imageName];
}

- (void)drawRect:(CGRect)rect {
    [self updateDots];

    [super drawRect:rect];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    NSInteger oldCurrentPage = self.currentPage;
    
    [super setCurrentPage:currentPage];
    
    if (oldCurrentPage != self.currentPage) {
        [self setNeedsDisplay];
    }
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSInteger oldCurrentPage = self.currentPage;
    
    [super endTrackingWithTouch:touch withEvent:event];
    
    if (oldCurrentPage != self.currentPage) {
        [self setNeedsDisplay];
    }
}

- (void)updateDots {
  
    [XKUtil executeCodeWhenSystemVersionAbove:7.0 blow:0 withBlock:^{
        
        int i;
        CGRect mRect;
        UIImage *image;
        CGRect rect = self.bounds;
        
        if (self.opaque) {
            [self.backgroundColor set];
            UIRectFill(rect);
        }
        
        CGFloat _kSpacing = 5.0f;
        
        if (self.hidesForSinglePage && self.numberOfPages == 1) {
            return;
        }
        
        mRect.size.height = _dotOnImage.size.height;
        mRect.size.width = self.numberOfPages * _dotOnImage.size.width + (self.numberOfPages - 1) * _kSpacing;
        mRect.origin.x = floorf((rect.size.width - mRect.size.width) / 2.0);
        mRect.origin.y = floorf((rect.size.height - mRect.size.height) / 2.0);
        mRect.size.width = _dotOnImage.size.width;
        for (i = 0; i < self.numberOfPages; ++i) {
            image = (i == self.currentPage) ? _dotOnImage : _dotOffImage;
            [image drawInRect:mRect];
            mRect.origin.x += _dotOnImage.size.width + _kSpacing;
        }
        
    }];
    
    [XKUtil executeCodeWhenSystemVersionAbove:5.1 blow:7.0 withBlock:^{
   
        UIImageView *dot = nil;
        
        if (_dotOnImage) {
            dot = [self.subviews objectAtIndex:(self.currentPage)];
            dot.image = _dotOnImage;
        }
        
        
        if (_dotOffImage) {
            for (int i = 0; i < self.subviews.count; ++i) {
                if (self.currentPage != i) {
                    dot = [self.subviews objectAtIndex:(i)];
                    dot.image = _dotOffImage;
                }
            }
        }
        

    }];
  
    
}




@end
