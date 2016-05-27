//
//  XKRWMoreView.m
//  XKRW
//
//  Created by Shoushou on 15/11/25.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWMoreView.h"

@implementation XKRWMoreView
{
    IBOutlet UIButton *moreViewButton;
    
}

- (void)awakeFromNib {
    [moreViewButton setBackgroundImage:[UIImage createImageWithColor:colorSecondary_f0f0f0] forState:UIControlStateHighlighted];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clicked:(id)sender {
    
    if (self.viewClicked && [self respondsToSelector:@selector(viewClicked)]) {
        self.viewClicked();
    }
}

@end
