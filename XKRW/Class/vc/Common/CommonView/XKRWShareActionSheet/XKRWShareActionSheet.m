//
//  XKRWShareActionSheet.m
//  XKRW
//
//  Created by XiKang on 15-4-7.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWShareActionSheet.h"

@implementation XKRWShareActionSheet
{
    NSArray *_images;
    void (^_clickButton)(NSInteger index);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithButtonImages:(NSArray *)images clickButtonAtIndex:(void (^)(NSInteger index))clickHandler {
    if (self = [super init]) {
        
        _images = images;
        
        CGFloat _xPoint, _yPoint;
        _xPoint = -XKAppWidth / 4;
        _yPoint = 0.f;
        
        NSInteger index = 10;
        for (UIImage *image in images) {
            
            _xPoint += XKAppWidth / 4;
            if (_xPoint >= XKAppWidth) {
                _xPoint = 0.f;
                _yPoint += 60.f;
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(_xPoint, _yPoint, XKAppWidth / 4, 60.f);
            button.backgroundColor = [UIColor clearColor];
            button.tag = index ++;
            
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
        }
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        self.frame = CGRectMake(0, keyWindow.height - _yPoint - 60.f, XKAppWidth, _yPoint + 60.f);
        
        self.backgroundColor = [UIColor whiteColor];
        
        _clickButton = clickHandler;
    }
    return self;
}

- (void)clickButton:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if ([self.superview isEqual:[UIApplication sharedApplication].keyWindow]) {
        [self hideButton:nil];
    }
    
    if (_clickButton) {
        _clickButton(button.tag - 10);
    }
}

- (void)show {
    
    self.alpha = 0.f;
    [self addTransparentButton];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addTransparentButton {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIButton *button = [[UIButton alloc] initWithFrame:keyWindow.bounds];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1010204;

    button.alpha = 0.f;
    [keyWindow addSubview:button];
    
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 0.2;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideButton:(id)sender {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        
        [UIView animateWithDuration:0.15 animations:^{
            button.alpha = 0.001;
            self.alpha = 0.001;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [button removeFromSuperview];
        }];
        
    } else {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIButton *button = (UIButton *)[keyWindow viewWithTag:1010204];
        
        [UIView animateWithDuration:0.15 animations:^{
            button.alpha = 0.001;
            self.alpha = 0.001;
        } completion:^(BOOL finished) {
            [button removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}
@end
