//
//  XKRWIconAndLevelView.m
//  XKRW
//
//  Created by Shoushou on 15/10/9.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWIconAndLevelView.h"
#import "UIImageView+WebCache.h"
#import "XKRWUserService.h"

#define ORIGINALWIDTH self.bounds.size.width
#define RATIO (60.0/235.0)
@implementation XKRWIconAndLevelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame IconUrl:(NSString *)iconUrl AndlevelUrl:(NSString *)level
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self setIconUrl:iconUrl andLevelUrl:level];
    }
    return self;
}

- (void)setIconUrl:(NSString *)icon andLevelUrl:(NSString *)level {
    
    UIImage *placeholder = [UIImage imageNamed:@"lead_nor"];
    
    if (icon && ![icon isKindOfClass:[NSNull class]] && icon.length != 0) {
        [self.iconImageView setImageWithURL:[NSURL URLWithString:icon]
                           placeholderImage:placeholder options:SDWebImageRetryFailed];
        
    } else {
        [self.iconImageView setImage:placeholder];
    }
    
    if (level && level.length != 0) {
        [self.levelImageView setImageWithURL:[NSURL URLWithString:level]];
        [self addSubview:self.levelImageView];
    } else {
        [self.levelImageView removeFromSuperview];
    }
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _iconImageView.layer.borderWidth = 2;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.cornerRadius = self.bounds.size.width/2;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UIImageView *)levelImageView
{
    if (_levelImageView == nil) {
        CGFloat height = self.width * RATIO;
        
        _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height + 3 - height, self.width, height)];
    }
    return _levelImageView;
}
@end
