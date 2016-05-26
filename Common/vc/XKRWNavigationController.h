//
//  XKRWNavigationController.h
//  XKRW
//
//  Created by 忘、 on 15/7/7.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWNavigationController : UINavigationController
{
    BOOL changeAlpha;
    UIImageView *imageView;
}



- (instancetype)initWithRootViewController:(UIViewController *)rootViewController withNavigationBarType:(NavigationBarType) type;


// default style
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

- (void)navigationBarChangeFromDefaultNavigationBarToTransparencyNavigationBar;

- (void)navigationBarChangeFromTransparencyNavigationBarToDefaultNavigationBar;
// 从透明的navigationBar设置为黑色半透明的navigationbar
- (void)navigationBarChangeFromDefaultNavigationBarToBlackHarfTransNavigationBar;
// 从黑色半透明的navigationBar设置为透明的navigationBar
- (void)navigationBarChangeFromBlackHalfTransNavigationBarToTransparencyNavigationBar;
- (void)changeImageViewAlpha:(CGFloat) tableViewSlideDistance  andHeaderViewHeight:(CGFloat)height AndViewController:(UIViewController *)viewController andnavigationBarTitle:(NSString *)title;

////处理ios7以上的手势问题
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
//
//- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
//
//- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

@end
