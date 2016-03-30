//
//  KMHeaderTips.m
//  XKRW
//
//  Created by Klein Mioke on 15/8/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "KMHeaderTips.h"

@interface KMHeaderTips ()

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation KMHeaderTips {
    
    CGPoint _startPoint;
    CGPoint _endPoint;
    
    NSTimer *_timer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame text:(NSString *)text type:(KMHeaderTipsType)type {
    
    if (self = [super initWithFrame:frame]) {
        
        self.type = type;
        self.backgroundColor = [UIColor clearColor];
        
        NSAttributedString *content = [XKRWUtil createAttributeStringWithString:text
                                                                           font:[UIFont systemFontOfSize:12]
                                                                          color:[UIColor whiteColor]
                                                                    lineSpacing:3.5
                                                                      alignment:NSTextAlignmentCenter];
        
        CGFloat height = [content boundingRectWithSize:CGSizeMake(frame.size.width - 110, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 12;
        self.height = height;
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 6, frame.size.width - 110, height - 12)];
        self.textLabel.attributedText = content;
        self.textLabel.numberOfLines = 0;
        
        [self addSubview:self.textLabel];
        
        self.leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_ic_attention"]];
        self.leftImageView.origin = CGPointMake(15, (self.height - self.leftImageView.height) / 2);
        
        [self addSubview:self.leftImageView];
        
        self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 55, 0, 55, height)];
        [self.closeButton setImage:[UIImage imageNamed:@"history_delete"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self
                             action:@selector(remove)
                   forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.closeButton];
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [self setBackgroundColor:[UIColor blackColor] blur:YES];
        
        [self insertSubview:self.backgroundView atIndex:0];
        
        if (type == KMHeaderTipsTypeClickable) {
         
            // TODO: Clickable class
        }
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor blur:(BOOL)blur {
    
    if (blur && IOS_8_OR_LATER) {
        
        self.backgroundView.backgroundColor = [backgroundColor colorWithAlphaComponent:0.3];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        view.frame = self.bounds;
        
        [self.backgroundView addSubview:view];
        
    } else {
        
        self.backgroundView.backgroundColor = [backgroundColor colorWithAlphaComponent:0.5];
    }
}

- (void)setTextColor:(UIColor *)color andFont:(UIFont *)font {
    
    NSAttributedString *content = [XKRWUtil createAttributeStringWithString:(NSString *)self.textLabel.attributedText
                                                                       font:font
                                                                      color:color
                                                                lineSpacing:3.5
                                                                  alignment:NSTextAlignmentCenter];
    
    CGFloat height = [content boundingRectWithSize:CGSizeMake(self.frame.size.width - 110, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 12;
    self.height = height;
    
    self.textLabel.frame = CGRectMake(55, 6, self.frame.size.width - 110, height - 12);
    self.textLabel.attributedText = content;
    
    self.leftImageView.origin = CGPointMake(15, (self.height - self.leftImageView.height) / 2);
    
    self.closeButton.frame = CGRectMake(self.frame.size.width - 55, 0, 55, height);
}

- (void)startAnimationWithStartOrigin:(CGPoint)startPoint endOrigin:(CGPoint)endPoint {
    
    [self startAnimationWithStartOrigin:startPoint
                              endOrigin:endPoint
                         animateOptions:UIViewAnimationOptionCurveLinear];
}

- (void)startAnimationWithStartOrigin:(CGPoint)startPoint endOrigin:(CGPoint)endPoint animateOptions:(UIViewAnimationOptions)option {
    
    self.origin = startPoint;
    
    _startPoint = startPoint;
    _endPoint = endPoint;
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:option
                     animations:^{
                         self.origin = endPoint;
                     } completion:^(BOOL finished) {
                         
                     }];
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(remove) userInfo:nil repeats:NO];
}

- (void)remove {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_timer invalidate];
        _timer = nil;
        [self removeFromSuperview];
    }];
}

- (void)free {
    [_timer invalidate];
    _timer = nil;
}

@end
