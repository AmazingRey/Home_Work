
//  XKHudHelper.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-16.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "MBProgressHUD.h"
#import "NSTimer+XKDispatch.h"
#import "XKUnsupportedMethodException.h"
#import "XKHudHelper.h"
#import "YLImageView.h"
#import "YLGIFImage.h"

static XKHudHelper *_instance = nil;

@interface XKHudHelper ()

@property BOOL progressHudIsShown;

@property NSTimer *currentInformationHudHideTimer;

@end

@implementation XKHudHelper

+ (XKHudHelper *)instance {
    @synchronized (self) {
        if (!_instance) {
            _instance = [self new];
        }
    }
    
    return _instance;
}

- (id)init {
    @synchronized (self.class) {
        if (_instance) {
            XK_THROW_UNSUPPORTED_INSTANCE_METHOD_EXCEPTION_FOR_SINGLETON_PATTERN;
        } else {
            self = [super init];
            
            if (self) {
                _progressHud = [MBProgressHUD showHUDAddedTo:[self window] animated:NO];
                [_progressHud hide:NO];
                _progressHud.dimBackground = NO;
                
                _informationHud = [MBProgressHUD showHUDAddedTo:[self window] animated:NO];
                [_informationHud hide:NO];
                _informationHud.userInteractionEnabled = NO;
                _informationHud.mode = MBProgressHUDModeText;
                _informationHud.margin = 10.f;
                _informationHud.yOffset = 100.f;
                
                _progressHudIsShown = NO;
                
                _currentInformationHudHideTimer = nil;
                
                _instance = self;
            }
        }
    }
    
    return self;
}

- (void)showProgressHudWithText:(NSString *)text {
    if (!_progressHudIsShown) {
        // 注意：此处不能使用MBProgressHUD的hideAllHUDsForView: animated:方法
        //      因为该方法中会把所有被隐藏的hud的removeFromSuperViewOnHide属性置为YES，使得_progressHud不再能直接重用;
        [_informationHud hide:NO];
        
        _progressHud.labelText = text;
        [_progressHud show:YES];
        
        _progressHudIsShown = YES;
    }
}


- (void)showProgressHudAnimationInView:(UIView *)view
{
    UIView *hudView = [[UIView alloc]init];
    hudView.frame =CGRectMake(0, 0, XKAppWidth, view.height);
    hudView.tag = 9999;
    hudView.backgroundColor = colorSecondary_f4f4f4;
    YLImageView *imageView = [[YLImageView alloc]initWithFrame:CGRectMake((XKAppWidth-160)/2, (view.frame.size.height-190)/2, 160, 190)];
    imageView.image = [YLGIFImage imageNamed:@"reading.gif"];
    [hudView addSubview:imageView];
    [view addSubview:hudView];

}


- (void)hideProgressHudAnimationInView:(UIView *)view
{
     NSArray * subViews =   [view subviews];
    for (UIView *view  in subViews) {
        if ( view .tag == 9999) {
            [view removeFromSuperview];
        }
    }
}

- (void) showProgressHudWithText:(NSString *)text inView:(UIView *)view{

    if (!self.progressHuds) {
        self.progressHuds = [NSMutableArray array];
    }
    
    MBProgressHUD * progress = [MBProgressHUD showHUDAddedTo:view animated:NO];
    progress.labelText = text;
    [self.progressHuds addObject:progress];
}


- (void)hideProgressHud {
    [_progressHud hide:YES];

    if (self.progressHuds && self.progressHuds.count) {
        for (MBProgressHUD *progress in self.progressHuds) {
            [progress removeFromSuperview];
        }
        
        [self.progressHuds removeAllObjects];
    }
    
    _progressHudIsShown = NO;
}
- (void)showInformationHudWithText:(NSString *)text{
    [self showInformationHudWithText:text andDetail:nil];
}

- (void)showInformationHudWithText:(NSString *)text andDetail:(NSString * )detail{
    if (!_progressHudIsShown) {
        if (_currentInformationHudHideTimer) {
            [_currentInformationHudHideTimer invalidate];
        }
        // 注意：此处不能使用MBProgressHUD的hideAllHUDsForView: animated:方法
        //      因为该方法中会把所有被隐藏的hud的removeFromSuperViewOnHide属性置为YES，使得_progressHud不再能直接重用;
        [_informationHud hide:NO];
        
        _informationHud.labelText = text;
        if (text && text.length && detail && detail.length) {
            _informationHud.detailsLabelText = detail;
        }else {
            _informationHud.detailsLabelText = @"";
        }
        _informationHud.yOffset = -50.f;
        [_informationHud show:YES];
        _currentInformationHudHideTimer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO task:^{
            [_informationHud hide:YES];
        }];
    }
}

- (UIWindow *)window {
    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
    return keyWindow;
}

@end
