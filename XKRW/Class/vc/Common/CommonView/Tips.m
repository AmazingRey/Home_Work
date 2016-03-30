//
//  Tips.m
//  XKRW
//
//  Created by XiKang on 15-3-26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "Tips.h"

@implementation Tips

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithOrigin:(CGPoint)origin andText:(NSString *)string {
    
    self = LOAD_VIEW_FROM_BUNDLE(@"Tips");
    if (self) {
        
        self.frame = CGRectMake(0, origin.y, XKAppWidth, self.frame.size.height);
        
        self.frameView.layer.cornerRadius = 3.f;
        self.frameView.layer.masksToBounds = YES;
        
        self.frameView.width = XKAppWidth - origin.x * 2;
        self.frameView.x = origin.x;
        
        if (string) {
            
            NSAttributedString *text =
            [XKRWUtil createAttributeStringWithString:string
                                                 font:XKDefaultNumEnFontWithSize(12.f)
                                                color:[UIColor whiteColor ]
                                          lineSpacing:3.5 alignment:NSTextAlignmentLeft];
            
            CGRect tRect =
            [text boundingRectWithSize:CGSizeMake(self.frameView.width - 10.f, CGFLOAT_MAX)
                               options:NSStringDrawingUsesLineFragmentOrigin
                               context:nil];
            
            self.textLabel.size = CGSizeMake(tRect.size.width, tRect.size.height);
            self.frameView.height = tRect.size.height + 10.f;
            
            self.textLabel.attributedText = text;
        }
    }
    return self;
}

- (void)setArrowHorizontalSpace:(CGFloat)space {
    
    self.upArrow.x = space - 5.5;
}

- (void)addToWindow {
    
    self.alpha = 0.f;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    UIButton *transparentButton = [[UIButton alloc] initWithFrame:keyWindow.bounds];
    transparentButton.backgroundColor = [UIColor clearColor];
    
    [transparentButton addTarget:self action:@selector(hideTransparentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [keyWindow addSubview:transparentButton];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showInView:(UIView *)superView {
    
    self.alpha = 0.f;
    [superView addSubview:self];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIButton *transparentButton = [[UIButton alloc] initWithFrame:keyWindow.bounds];
    
    transparentButton.backgroundColor = [UIColor clearColor];
    
    [transparentButton addTarget:self action:@selector(hideTransparentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [keyWindow addSubview:transparentButton];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];

}

- (void)hideTransparentButton:(UIButton *)sender {
    
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [sender removeFromSuperview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(disappearCallback)]) {
            [self.delegate disappearCallback];
        }
    }];
}
@end
