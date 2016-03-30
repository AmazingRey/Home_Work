//
//  XKRWCui.h
//  XKRW
//
//  Created by Jiang Rui on 13-12-12.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWCui : NSObject

+ (void)showAlertWithMessage:(NSString *)message;
+ (void)showAlertWithMessage:(NSString *)message
                   onOKBlock:(void (^)(void))onOKBlock;
+ (void)showConfirmWithMessage:(NSString *)message
                     onOKBlock:(void (^)(void))onOKBlock;
+ (void)showConfirmWithMessage:(NSString *)message
                 okButtonTitle:(NSString *)okButtonTitle
             cancelButtonTitle:(NSString *)cancelButtonTitle
                     onOKBlock:(void (^)(void))onOKBlock;

+ (void)showConfirmWithTitle:(NSString *)title
                     message:(NSString *)message
               okButtonTitle:(NSString *)okButtonTitle
           cancelButtonTitle:(NSString *)cancelButtonTitle
                   onOKBlock:(void (^)(void)) onOKBlock
               onCancelBlock:(void(^)(void))  cancelBlock;


//窗体最上层显示
+ (void)showProgressHud;
+ (void)showProgressHudWithAutoHidden:(BOOL)autoHidden;
+ (void)showProgressHud:(NSString *)message;
+ (void)showProgressHud:(NSString *)message WithAutoHidden:(BOOL)autoHidden;

//自定义显示的view
+ (void)showProgressHudInView:(UIView *)view;
+ (void)showProgressHudWithAutoHidden:(BOOL)autoHidden InView:(UIView *)view;
+ (void)showProgressHud:(NSString *)message InView:(UIView *)view;
+ (void)showProgressHud:(NSString *)message WithAutoHidden:(BOOL)autoHidden InView:(UIView *)view;

//隐藏
+ (void)hideProgressHud;

+ (void)showServerNGInformationHudWithHttpStatusCode:(NSInteger)httpStatusCode;

+ (void)showInformationHudWithText:(NSString *)text;
+ (void)showInformationHudWithText:(NSString *)text andDetail:(NSString *)detail;

+ (void)showServerNGAlertWithDetail:(NSString *)detail;

+ (CGSize)SizeOfFont:(UIFont*)font Str:(NSString*)str;

//隐藏跳转到Tabbar时的白色页面

+ (void)showAdImageOnWindow;

+ (void)hideAdImage;

+ (void)showAdOnWindowWithImage:(UIImage *)image;

+ (UIImage *)resizeImageView:(UIImage *)image withEdgeInset:(UIEdgeInsets )insets;

@end
