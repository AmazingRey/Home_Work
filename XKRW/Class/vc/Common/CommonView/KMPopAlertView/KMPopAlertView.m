//
//  KMPopAlertView.m
//  XKRW
//
//  Created by Klein Mioke on 15/8/5.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "KMPopAlertView.h"

@interface KMPopAlertView ()

@property (nonatomic, strong) UIButton *transparent;

@end

@implementation KMPopAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.cornerRadius = 10;
        self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    }
    return self;
}

- (void)show {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (!self.transparent) {
        self.transparent = [[UIButton alloc] initWithFrame:keyWindow.bounds];
        self.transparent.backgroundColor = [UIColor blackColor];
        self.transparent.alpha = 0;
        [self.transparent addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [keyWindow addSubview:self.transparent];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transparent.alpha = 0.3;
    }];
    
    self.center = CGRectGetCenter(keyWindow.bounds);
    
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
    
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         
                         self.alpha = 1;
                         self.transform = CGAffineTransformMakeScale(1, 1);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.transparent.alpha = 0;
    } completion:^(BOOL finished) {
        [self.transparent removeFromSuperview];
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
