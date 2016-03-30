//
//  XKRWWarningView.m
//  XKRW
//
//  Created by 忘、 on 14-12-31.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWWarningView.h"
#import "XKRWCui.h"

@implementation XKRWWarningView



+ (void) showWainingViewWithString:(NSString *)str
{
    UIView *temp = [[UIApplication sharedApplication].keyWindow viewWithTag:9988776];
    if (temp) {
        [temp removeFromSuperview];
    }
    CGSize size = [str boundingRectWithSize:CGSizeMake(XKAppWidth - 60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.f]} context:nil].size;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, size.width, size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.text = str;
    [label setFont:[UIFont boldSystemFontOfSize:16.f]];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((XKAppWidth - size.width - 30 )/2, XKAppHeight / 2, size.width + 30, size.height + 10)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    view.layer.cornerRadius = 12.f;
    view.tag = 9988776;
    [view addSubview:label];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    [[self class] performSelector:@selector(hideWarningView) withObject:nil afterDelay:2.f];
}

+ (void)hideWarningView
{
    UIView *temp = [[UIApplication sharedApplication].keyWindow viewWithTag:9988776];
    if (!temp) {
        return;
    }
    [UIView animateWithDuration:0.2f animations:^{
        temp.alpha = 0.f;
    } completion:^(BOOL finished) {
        [temp removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
