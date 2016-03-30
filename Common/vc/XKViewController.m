//
//  XKViewController.m
//  calorie
//
//  Created by JiangRui on 13-2-4.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "XKConfigUtil.h"
#import "XKViewController.h"

@interface XKViewController ()

@end

@implementation XKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _shouldRegisterDefaultNotification = YES;
    
    _isYouMengAnalysisedPV = ([XKConfigUtil stringForKey:@"YouMengAppKey"]
                              && ![self isKindOfClass:UINavigationController.class]
                              && ![self isKindOfClass:UITabBarController.class]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNotification];
    
    if (self.isYouMengAnalysisedPV) {
        [self beginLogPageViewPV];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.isYouMengAnalysisedPV) {
        [self endLogPageViewPV];
    }
    
    [self unregisterNotification];
    
    [super viewWillDisappear:animated];
}

- (void)registerNotification {
    if (_shouldRegisterDefaultNotification) {
        [self registerDefaultNotification];
    }
}

- (void)unregisterNotification {
    if (_shouldRegisterDefaultNotification) {
        [self unregisterDefaultNotification];
    }
}

@end
