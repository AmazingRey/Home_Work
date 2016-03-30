//
//  XKHudHelper.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-16.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface XKHudHelper : NSObject

@property (readonly) MBProgressHUD *progressHud;
@property (readonly) MBProgressHUD *informationHud;

@property (nonatomic, strong) NSMutableArray * progressHuds;

+ (XKHudHelper *)instance;

- (void) showProgressHudWithText:(NSString *)text ;

- (void) showProgressHudWithText:(NSString *)text inView:(UIView *)view;

- (void)hideProgressHud;

////////////////////////////////////////////

- (void) showInformationHudWithText:(NSString *)text andDetail:(NSString * )detail;

- (void)showInformationHudWithText:(NSString *)text;


- (void)showProgressHudAnimationInView:(UIView *)view;

- (void)hideProgressHudAnimationInView:(UIView *)view;

@end
