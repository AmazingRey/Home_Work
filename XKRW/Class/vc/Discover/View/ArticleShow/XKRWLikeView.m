//
//  XKRWLikeView.m
//  XKRW
//
//  Created by Shoushou on 16/1/15.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWLikeView.h"


@implementation XKRWLikeView
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *likeBtn;
    IBOutlet UILabel *likeLabel;
    
}

- (void)setContentWithTitle:(NSString *)title ImageName:(NSString *)imageName ImageLabelText:(NSString *)imageLabelText {
    titleLabel.text = title;
    [likeBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    likeLabel.text = imageLabelText;
}

- (void)hideLikePart {
    likeBtn.hidden = YES;
    likeLabel.hidden = YES;
    self.frame = CGRectMake(0, 0, XKAppWidth, 44);
    
    __block CGFloat y = (self.height - titleLabel.height) / 2.0;
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(y);
    }];
}

- (void)setLikeTitle:(NSString *)title {
    titleLabel.text = title;
}
- (IBAction)likeBtnClick:(id)sender {
    __weak NSString *likeStr = likeLabel.text;
    if (self.likeButtonClicked && [self respondsToSelector:@selector(likeButtonClicked)]) {
        self.likeButtonClicked(likeStr);
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
