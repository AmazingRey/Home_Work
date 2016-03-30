//
//  XKRWSurfaceView.m
//  XKRW
//
//  Created by Shoushou on 15/8/13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWSurfaceView.h"
#import "define.h"

@implementation XKRWSurfaceView
{
    UIImageView *_surfaceImageView;
    NSUserDefaults *_defaults;
    
//  要添加浮层的类名
    NSString *_destination;
    NSInteger _step;
    NSInteger _maxStep;
    
    void (^_completion)(void);
}

- (instancetype)initWithFrame:(CGRect)frame Destination:(NSString *)destination andUserId:(NSInteger)currentUserId completion:(void (^)(void))block {
    
    if (self = [self initWithFrame:frame Destination:destination andUserId:currentUserId]) {
        _completion = block;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame Destination:(NSString *)destination andUserId:(NSInteger)currentUserId
{
    _destination = destination;
    //      判断是否新用户或第一次进入这个界面
    _defaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    // MARK: 当前版本号、用户的key值
    NSString *key = [NSString stringWithFormat:@"%@_%d_%@", destination, (int)currentUserId, version];

    if ([_defaults boolForKey:key]) {
        return nil;
    }
    if (self = [super initWithFrame:frame]) {
        [_defaults setBool:YES forKey:key];
        [_defaults synchronize];
        
//  隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//      在self上添加ImageView
        _surfaceImageView.alpha = 0.5;
        _surfaceImageView = [[UIImageView alloc] initWithFrame:XKScreenBounds];
        [self addSubview:_surfaceImageView];
        
//      在ImageView上添加手势
        _surfaceImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapPushToNextImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToNextPicture)];
        [_surfaceImageView addGestureRecognizer:tapPushToNextImg];
        
        _step = 1;
        if ([destination isEqualToString:@"XKRWSchemeVC_5_0"]) {
            _maxStep = 7;
        }
        [self loadImageWithHight:XKAppHeight Step:_step andDestination:destination];
        
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    return self;
}

- (void)loadImageWithHight:(CGFloat)hight Step:(NSInteger)step andDestination:(NSString *)destination
{
    NSInteger iPhoneType;
    NSString *pageName;
//  判断
    if ([destination isEqualToString:@"XKRWSchemeVC_5_0"]) {
        pageName = @"surface";
    }
    switch ((int)hight) {
        case 480:
            iPhoneType = 4;
            break;
        case 568:
            iPhoneType = 5;
            break;
        case 667:
            iPhoneType = 6;
            break;
        default:
            iPhoneType = 6;
            break;
    }
    _surfaceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%zd_%zd",pageName,iPhoneType,step]];
}

- (void)pushToNextPicture
{
    _step++;
    if (_step < _maxStep) {
        [self loadImageWithHight:XKAppHeight Step:_step andDestination:_destination];
    } else {
        [self removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        if (_completion) {
            _completion();
        }
    }
}
@end
