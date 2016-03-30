//
//  UITextField+XKCui.m
//  calorie
//
//  Created by Rick Liao on 13-1-28.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "UITextField+XKCui.h"

@implementation UITextField (XKCui)

- (void)setSelectedRange:(NSRange)selectedRange {
    UITextPosition *start = [self positionFromPosition:[self beginningOfDocument]
                                                     offset:selectedRange.location];
    UITextPosition *end = [self positionFromPosition:start
                                                   offset:selectedRange.length];
    [self setSelectedTextRange:[self textRangeFromPosition:start toPosition:end]];
}

@end
