//
//  UIViewController+XKCui.m
//  calorie
//
//  Created by Rick Liao on 12-11-13.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "UIView+XKCui.h"
#import "UIViewController+XKCui.h"

@implementation UIViewController (XKCui)

- (void)cui {
    [self doCui:self.view];
}

- (void)cui:(UIView *)view {
    [self doCui:view];
}

- (void)doCui:(UIView *)currentView {
//    [currentView tryCui];

    for (UIView  *subview in currentView.subviews) {
        [self doCui:subview];
    }
}

@end
