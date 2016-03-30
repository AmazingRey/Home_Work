//
//  XKRWPostDeatilCell.m
//  XKRW
//
//  Created by 忘、 on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPostDeatilCell.h"

@implementation XKRWPostDeatilCell

- (void)awakeFromNib {
    // Initialization code
    _userImageButton.layer.masksToBounds = YES;
    _userImageButton.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowLikeButton:(BOOL)showLikeButton
{
    if(showLikeButton){
//        _personLikeNumLabelHeight.constant = 0;
        _personLikeNumAndLikeButtonIntervalHeight.constant = 0;
        _likeButtonHeight.constant = 0;
        _likeButtonAndLikeLabelIntervalHeight.constant = 0;
        _likeLabelHeight.constant = 0;
    }
//    _personLikeNumLabel.hidden = showLikeButton;
    _likeStateButton.hidden = showLikeButton;
    _likeStateLabel.hidden = showLikeButton;
}

@end
