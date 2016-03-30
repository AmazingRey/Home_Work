//
//  XKRWSepLine.m
//  XKRW
//
//  Created by zhanaofan on 14-3-3.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSepLine.h"

@implementation XKRWSepLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *img = [UIImage imageNamed:@"sep_line.png"];
        [self setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 1.f, 0.f, 2.f)]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
