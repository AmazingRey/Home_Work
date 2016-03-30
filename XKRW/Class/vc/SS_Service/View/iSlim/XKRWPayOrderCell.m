//
//  XKRWPayOrderCell.m
//  XKRW
//
//  Created by XiKang on 15-3-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWPayOrderCell.h"

@implementation XKRWPayOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        
        _checkImage.image = [UIImage imageNamed:@"SelectMulti_s"];
    } else {
        
        _checkImage.image = [UIImage imageNamed:@"SelectMulti"];
    }
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle headImage:(NSString *)imageName {
    _platformName.text = title;
    _subtitle.text = subtitle;
    
    _headImage.image = [UIImage imageNamed:imageName];
}

@end
