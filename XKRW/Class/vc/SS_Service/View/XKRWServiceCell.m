//
//  XKRWServiceCell.m
//  XKRW
//
//  Created by 忘、 on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWServiceCell.h"

@implementation XKRWServiceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void) initSubViewsWithIconImageName:(NSString *)iconImageName Title:(NSString *)title Describe:(NSString *)describe tip:(NSString *)tip isShowHotImageView:(BOOL ) isShow  isShowRedDot:(BOOL)isShowRedDot
{
    _iconImageView.image = [UIImage imageNamed:iconImageName];
    if (!_iconImageView.image) {
        _iconImageView.image = [UIImage imageWithContentsOfURL:[NSURL URLWithString:iconImageName]];
    }
    _titleLable.text = title;
    _describeLable.text = describe;
    _tipLable.text = tip;
    
    if (isShow) {
        _hotImageView.image = [UIImage imageNamed:@"serviceIcon_hot"];
    }
    
    if (isShowRedDot) {
        _redDotImageView.image = [UIImage imageNamed:@"unread_red_dot"];
    }
    
}


@end
