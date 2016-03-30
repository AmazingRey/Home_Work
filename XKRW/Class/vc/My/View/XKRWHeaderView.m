//
//  XKRWHeaderView.m
//  XKRW
//
//  Created by 忘、 on 15/7/8.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWHeaderView.h"

@implementation XKRWHeaderView
{
    __weak IBOutlet UIButton *toInfoButton;
}


- (IBAction)changeBackgroundImageAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeBackgroundImage)]) {
        [self.delegate changeBackgroundImage];
    }
}


+ (instancetype)instance {
    
    XKRWHeaderView *view = LOAD_VIEW_FROM_BUNDLE(@"XKRWHeaderView");
    view.backgroundColor = XKMainSchemeColor;
    if (XKAppWidth == 320) {
        view.frame = CGRectMake(0, 0, XKAppWidth, 210 - 64);
        
    } else if (XKAppWidth == 375) {
        
        view.frame = CGRectMake(0, 0, XKAppWidth, 182);
        
    } else {
        view.frame = CGRectMake(0, 0, XKAppWidth, 207.7);
    }


    view.headerButton.layer.masksToBounds = YES;
    view.headerButton.layer.cornerRadius = 39;
    view.headerArcImageView.layer.masksToBounds = YES;
    view.headerArcImageView.layer.cornerRadius = 41;
    
    return view;
}

- (void)awakeFromNib{
    _nickNamelabel.layer.shadowColor = colorSecondary_666666.CGColor;
    _nickNamelabel.shadowOffset = CGSizeMake(0, -2.0);
    _menifestoLabel.layer.shadowColor = colorSecondary_666666.CGColor;
    if(XKAppWidth == 320)
    {
        _arrowConstraint.constant = 85;
    }else if (XKAppWidth == 375){
        _arrowConstraint.constant = 113;
    }else{
        _arrowConstraint.constant = 131;
    }

    _insistLabel.layer.masksToBounds = YES;
    _insistLabel.layer.cornerRadius = 10;
    _insistLabel.backgroundColor = [UIColor blackColor];
    _insistLabel.alpha = 0.5;
    
}

- (IBAction)changeHeadImageAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeUserInfoHeadImage)]) {
        [self.delegate changeUserInfoHeadImage];
    }
}

- (IBAction)entryUserInfoAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(entryUserInfo)]) {
        [self.delegate entryUserInfo];
    }
}
@end
