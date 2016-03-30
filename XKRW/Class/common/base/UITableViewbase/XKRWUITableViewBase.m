//
//  XKRWUITableViewBase.m
//  XKRW
//
//  Created by Seth Chen on 15/12/30.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWUITableViewBase.h"

@implementation XKRWUITableViewBase

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self forbidTouchContenDelay];
    
    }
    return self;
}

- (void)forbidTouchContenDelay
{
    self.delaysContentTouches = NO;
    // default is YES. if NO, we immediately call -touchesShouldBegin:withEvent:inContentView:. this has no effect on presses
    
    // iterate over all the UITableView's subviews
    for (id view in self.subviews)
    {
        // looking for a UITableViewWrapperView
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"])
        {
            // this test is necessary for safety and because a "UITableViewWrapperView" is NOT a UIScrollView in iOS7
            if([view isKindOfClass:[UIScrollView class]])
            {
                // turn OFF delaysContentTouches in the hidden subview
                UIScrollView *scroll = (UIScrollView *) view;
                scroll.delaysContentTouches = NO;
            }
            break;
        }
    }

}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ([view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
    
}
@end
