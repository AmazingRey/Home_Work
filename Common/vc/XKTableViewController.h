//
//  XKTableViewController.h
//  calorie
//
//  Created by JiangRui on 13-2-4.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "UIViewController+XKVc.h"
#import <UIKit/UIKit.h>

@interface XKTableViewController : UITableViewController

@property (nonatomic) BOOL shouldRegisterDefaultNotification;
@property (nonatomic) BOOL isYouMengAnalysisedPV;

- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

@end
