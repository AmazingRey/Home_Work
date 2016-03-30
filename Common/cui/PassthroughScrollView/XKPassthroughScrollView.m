//
//  XKPassthroughScrollView.m
//  calorie
//
//  Created by Rick Liao on 13-2-20.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "XKPassthroughScrollView.h"

@implementation XKPassthroughScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL ret = NO;
    
    for (UIView *view in self.subviews) {
        if (!view.hidden
            && view.userInteractionEnabled
            && [view pointInside:[self convertPoint:point toView:view]
                       withEvent:event]) {
            ret = YES;
            break;
        } // else NOP
    }
    
    return ret;
}

@end
