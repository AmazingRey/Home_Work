//
//  KMSearchBar.m
//  XKRW
//
//  Created by Klein Mioke on 15/7/9.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "KMSearchBar.h"

@implementation KMSearchBar


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setValue:@"取消" forKey:@"_cancelButtonText"];
    }
    return self;
}

- (void)setCancelButtonEnable:(BOOL)enable {
    
    for (UIView *view in ((UIView *)self.subviews.lastObject).subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)view;
            cancelButton.enabled = enable;
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
