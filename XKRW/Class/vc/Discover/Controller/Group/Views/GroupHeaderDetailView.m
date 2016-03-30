//
//  GroupHeaderDetailView.m
//  AFN_Test
//
//  Created by Seth Chen on 16/1/13.
//  Copyright © 2016年 xikang. All rights reserved.
//

#import "GroupHeaderDetailView.h"
@implementation GroupHeaderDetailView
{
    __weak IBOutlet UIButton *signOutButton;
    
    groupAuthType currentType;

}
- (void)awakeFromNib {
    
    
    currentType = groupAuthNone;// 初始化 为 未加入 ..
    
    
    signOutButton.layer.borderColor = XKMainSchemeColor.CGColor;
    signOutButton.layer.cornerRadius = 3;
    signOutButton.clipsToBounds = YES;
    [signOutButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    [signOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [signOutButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
}

- (IBAction)joinOrSignout:(UIButton *)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(buttonClickHandler:)]) {
        [self.delegate buttonClickHandler:currentType];
    }
    
}

- (void)setGroupAuthType:(groupAuthType)groupAuthType
{
    currentType = groupAuthType;
    if (groupAuthType == groupAuthNone) {
        [signOutButton setTitle:@"加入小组" forState:UIControlStateNormal];
    }else [signOutButton setTitle:@"退出小组" forState:UIControlStateNormal];
}

- (void)setHidden:(BOOL)hidden
{
    [UIView animateWithDuration:.2 animations:^{
        if (hidden) {
            self.alpha = 0.1;
        }else
        {
            self.alpha = 1;
            [self.superview bringSubviewToFront:self];
        }
    } completion:^(BOOL finished) {
        [super setHidden:hidden];
    }];
}

@end
