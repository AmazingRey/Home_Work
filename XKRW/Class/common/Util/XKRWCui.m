//
//  XKRWCui.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-12.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWCui.h"
#import "UIView+XKCui.h"
#import "XKHudHelper.h"
#import "XKCuiUtil.h"
#import "XKAppInfoHelper.h"
#import "XKRWFileManager.h"
#import "XKRWAccountService.h"

@implementation XKRWCui

+ (void)showServerNGAlertWithDetail:(NSString *)detail {
    if ([XKAppInfoHelper isInformalReleaseType]) {
        [self showAlertWithMessage:[NSString stringWithFormat:@"服务器不可用\n请稍后再尝试\n详细原因：%@", detail]];
    } else {
        [self showAlertWithMessage:@"服务器不可用\n请稍后再尝试"];
    }
}


+ (void)showAlertWithMessage:(NSString *)message {
    [self showAlertWithMessage:message onOKBlock:nil];
}

+ (void)showAlertWithMessage:(NSString *)message
                   onOKBlock:(void (^)(void))onOKBlock {
    [XKCuiUtil showAlertWithMessage:message
                      okButtonTitle:@"确定"
                          onOKBlock:onOKBlock];
}

+ (void)showConfirmWithMessage:(NSString *)message
                     onOKBlock:(void (^)(void))onOKBlock {
    [XKCuiUtil showConfirmWithMessage:message
                        okButtonTitle:@"确定"
                    cancelButtonTitle:@"取消"
                            onOKBlock:onOKBlock];
}

+ (void)showConfirmWithMessage:(NSString *)message okButtonTitle:(NSString *)okButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle onOKBlock:(void (^)(void))onOKBlock{
    [XKCuiUtil showConfirmWithMessage:message
                        okButtonTitle:okButtonTitle
                    cancelButtonTitle:cancelButtonTitle
                            onOKBlock:onOKBlock];
}
+ (void)showConfirmWithTitle:(NSString *)title
                     message:(NSString *)message
               okButtonTitle:(NSString *)okButtonTitle
           cancelButtonTitle:(NSString *)cancelButtonTitle
                   onOKBlock:(void (^)(void)) onOKBlock
               onCancelBlock:(void(^)(void))  cancelBlock{

    [XKCuiUtil showConfirmWithTitle:title message:message okButtonTitle:okButtonTitle cancelButtonTitle:cancelButtonTitle onOKBlock:onOKBlock onCancelBlock:cancelBlock];
}


//
+(void)showProgressHudWithAutoHidden:(BOOL)autoHidden{
    [[XKHudHelper instance] showProgressHudWithText:@"处理中" ];
    if (autoHidden) {
        [[self class] autoHiddenMethod];
    }
}

+ (void)showProgressHud {
    [[self class] showProgressHudWithAutoHidden:NO];
}

+(void)showProgressHud:(NSString *)message WithAutoHidden:(BOOL)autoHidden{
    [[XKHudHelper instance] showProgressHudWithText:message];
    if (autoHidden) {
        [[self class] autoHiddenMethod];
    }
}

+ (void)showProgressHud:(NSString *)message {
    [[self class] showProgressHud:message WithAutoHidden:NO];
}


//自定义显示的view
+ (void)showProgressHudInView:(UIView *)view{
//    [[self class] showProgressHud:nil WithAutoHidden:YES InView:view];
    /**
     *  Modified by Mioke
     */
    [[self class] showProgressHud:nil WithAutoHidden:NO InView:view];
}
+ (void)showProgressHudWithAutoHidden:(BOOL)autoHidden InView:(UIView *)view{
    [[self class] showProgressHud:nil WithAutoHidden:autoHidden InView:view];
}
+ (void)showProgressHud:(NSString *)message InView:(UIView *)view{
    [[self class] showProgressHud:message WithAutoHidden:NO InView:view];
}
+ (void)showProgressHud:(NSString *)message WithAutoHidden:(BOOL)autoHidden InView:(UIView *)view{
    [[XKHudHelper instance] showProgressHudWithText:message inView:view];
    if (autoHidden) {
        [[self class] autoHiddenMethod];
    }
}


//自动隐藏
+ (void) autoHiddenMethod{
    [NSTimer scheduledTimerWithTimeInterval:3 target:[self class] selector:@selector(hideProgressHud) userInfo:nil repeats:NO];
}

//隐藏
+ (void)hideProgressHud {
    [[XKHudHelper instance] hideProgressHud];
}

+ (void)showServerNGInformationHudWithHttpStatusCode:(NSInteger)httpStatusCode {
    if ([XKAppInfoHelper isInformalReleaseType]) {
        [self showInformationHudWithText:[NSString stringWithFormat:@"服务器不可用，HTTP状态码[%ld]", (long)httpStatusCode]];
    } else {
        [self showInformationHudWithText:@"服务器不可用"];
    }
}

+ (void)showInformationHudWithText:(NSString *)text {
    [[XKHudHelper instance] showInformationHudWithText:text andDetail:nil];
}
+ (void)showInformationHudWithText:(NSString *)text andDetail:(NSString *)detail{
    [[XKHudHelper instance] showInformationHudWithText:text andDetail:detail];
}


+ (CGSize)SizeOfFont:(UIFont*)font Str:(NSString*)str
{
    CGSize strSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                nil];
    
    
    strSize = [str sizeWithAttributes:attributes];
   
    return strSize;
}

+ (void)showAdImageOnWindow
{
    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HaveJustOpen"] boolValue];
    
    if (flag) {
        XKLog(@"\n*************显示广告图*************");
        UIWindow *window = [[UIApplication sharedApplication].delegate window] ;
        UIImageView *ADImageView = [[UIImageView alloc] initWithFrame:window.bounds];
        ADImageView.tag = 90990999;
        NSString *localFile = [[NSUserDefaults standardUserDefaults] objectForKey:ADV_PIC_NAME];
        
        if ([XKRWFileManager isFileExist:localFile]) {
            UIImage *image = [UIImage imageWithContentsOfFile:[XKRWFileManager fileFullPathWithName:localFile]];
            ADImageView.image = image;
        } else {
            NSString *image = nil;
            if (XKAppHeight == 480) {
                image = @"Default_640x960";
            } else if (XKAppHeight == 568) {
                image = @"Default_640x1136";
            } else if (XKAppHeight == 667) {
                image = @"Default_750x1334";
            } else {
                image = @"Default_1242x2208";
            }
            ADImageView.image = [UIImage imageNamed:image];
        }
        [window addSubview:ADImageView];
        
        [NSTimer scheduledTimerWithTimeInterval:5.f
                                         target:self
                                       selector:@selector(hideAdImage)
                                       userInfo:nil
                                        repeats:NO];
    }
}



+ (void)hideAdImage
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIImageView *ADImageView = (UIImageView *)[window viewWithTag:90990999];
    
    if (ADImageView) {
        
        XKLog(@"\n*************隐藏广告图*************");
        
        [UIView animateWithDuration:0.3f animations:^{
            ADImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [ADImageView removeFromSuperview];
        }];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"HaveJustOpen"];
    }
}

+ (void)showAdOnWindowWithImage:(UIImage *)image
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIImageView *ADImageView = [[UIImageView alloc] initWithFrame:window.bounds];
    ADImageView.tag = 90990999;
    ADImageView.image = image;
    [window addSubview:ADImageView];
}

+ (UIImage *)resizeImageView:(UIImage *)image withEdgeInset:(UIEdgeInsets )insets
{
   UIImage *resizeImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return resizeImage;
}


@end
