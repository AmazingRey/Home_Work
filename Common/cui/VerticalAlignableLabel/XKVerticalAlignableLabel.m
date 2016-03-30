//
//  XKVerticalAlignableLabel.m
//  calorie
//
//  Created by Rick Liao on 12-12-25.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "XKVerticalAlignableLabel.h"

@implementation XKVerticalAlignableLabel

@synthesize textVerticalAlignment = _textVerticalAlignment;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    _textVerticalAlignment = XKVerticalAlignmentCenter;
}

- (void)setTextVerticalAlignment:(XKTextVerticalAlignment)verticalAlignment {
    _textVerticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    switch (self.textVerticalAlignment) {
        case XKTextVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case XKTextVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case XKVerticalAlignmentCenter:
            // fall through
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    
    [super drawTextInRect:actualRect];
}

@end
