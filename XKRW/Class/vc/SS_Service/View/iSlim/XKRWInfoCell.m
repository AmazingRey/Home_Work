//
//  XKRWInfoCell.m
//  XKRW
//
//  Created by XiKang on 15-3-24.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWInfoCell.h"

@implementation XKRWInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title content:(NSString *)content {
    
    _titleLabel.text = title;
    _contentLabel.text = content;
}
@end
