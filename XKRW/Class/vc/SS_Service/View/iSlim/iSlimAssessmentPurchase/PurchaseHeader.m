//
//  PurchaseHeader.m
//  XKRW
//
//  Created by XiKang on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "PurchaseHeader.h"

@implementation PurchaseHeader
{
    void (^_clickButton)(void);
    __weak IBOutlet UIActivityIndicatorView *loadingIndicator;
    __weak IBOutlet UILabel *chancesTextLabel;
    
    BOOL _isActive;
    BOOL _isAnimating;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initSubviewsWithState:(PurchaseState)state
                  clickButton:(void (^)(void))action
{
    self.chanceLabel.alpha = 0.001f;
//    self.width = XKAppWidth;
    self.PurchaseButton.layer.cornerRadius = 4.f;
    self.PurchaseButton.layer.borderColor = XKMainSchemeColor.CGColor;
    self.PurchaseButton.layer.borderWidth = 1.;
    [self.PurchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.PurchaseButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    [self.PurchaseButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
//    self.PurchaseButton.titleLabel.width = self.PurchaseButton.width;
//    self.PurchaseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _clickButton = action;
    
    [loadingIndicator setHidesWhenStopped:YES];
    self.PurchaseButton.titleLabel.alpha = 0.001;
    
    [loadingIndicator startAnimating];
    
    _isActive = NO;
    _isAnimating = YES;
}

- (void)setToState:(PurchaseState)state numberOfChances:(NSInteger)num {
    
    _state = state;
    
    [loadingIndicator stopAnimating];
    
    __block CGFloat alpha = 0.001f;
    if (num) {
        [self setChances:num];
        alpha = 1.f;
    }

    if (state == PurchaseStateDone) {
        [self.PurchaseButton setTitle:@"查看评估报告" forState:UIControlStateNormal];
        
    } else if (state == PurchaseStatePurchased) {
        [self.PurchaseButton setTitle:@"开始评估" forState:UIControlStateNormal];
        
    } else {
        [self.PurchaseButton setTitle:@"购买" forState:UIControlStateNormal];
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.16 animations:^{
                self.PurchaseButton.titleLabel.alpha = 1.f;
                self.chanceLabel.alpha = alpha;
                
            } completion:^(BOOL finished) {
                    
                _isAnimating = NO;
                _isActive = YES;
            }];
        });
    } else {
        [UIView animateWithDuration:0.16 animations:^{
            self.PurchaseButton.titleLabel.alpha = 1.f;
            self.chanceLabel.alpha = alpha;
            
        } completion:^(BOOL finished) {
            
            _isAnimating = NO;
            _isActive = YES;
        }];
    }
}

- (void)setDisable
{
    [loadingIndicator stopAnimating];
    
    _isAnimating = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.PurchaseButton.layer.borderColor = XK_LINEAR_ICON_COLOR.CGColor;
        [self.PurchaseButton setTitle:@"购买" forState:UIControlStateNormal];
        [self.PurchaseButton setTitleColor:XK_LINEAR_ICON_COLOR forState:UIControlStateNormal];
        self.PurchaseButton.titleLabel.alpha = 1.f;
        
        self.chanceLabel.alpha = 0.001f;
        
    } completion:^(BOOL finished) {
        _isActive = NO;
        _isAnimating = NO;
    }];
}

- (void)setChances:(NSInteger)num {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前用户还可评估%d次", (int)num]];
    NSDictionary *attribute = @{NSFontAttributeName: XKDefaultNumEnFontWithSize(14.f),
                                NSForegroundColorAttributeName: XK_TITLE_COLOR};
    
    [string addAttributes:attribute range:NSMakeRange(0, string.length)];
    
    NSInteger lenght = string.length - 9;
    [string addAttribute:NSForegroundColorAttributeName value:XKMainSchemeColor range:NSMakeRange(string.length - lenght - 1, lenght)];
    
    chancesTextLabel.attributedText = string;
}

- (void)loading {
    
    [loadingIndicator startAnimating];
    _isActive = NO;
    
    _isAnimating = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.PurchaseButton.titleLabel.alpha = 0.001f;
    } completion:^(BOOL finished) {
        _isAnimating = NO;
    }];
}

- (IBAction)clickPurchase:(id)sender {
    if (_isActive) {
        _clickButton();
    }
}
@end
