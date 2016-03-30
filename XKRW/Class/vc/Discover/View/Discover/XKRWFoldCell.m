//
//  XKRWFoldCell.m
//  XKRW
//
//  Created by Shoushou on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWFoldCell.h"

@implementation XKRWFoldCell
{
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIImageView *_imageView;
    
}

- (void)fold {
    _titleLabel.text = @"展开";
    [_imageView setImage:[UIImage imageNamed:@"unfold"]];
}

- (void)unfold {
    _titleLabel.text = @"收起";
    [_imageView setImage:[UIImage imageNamed:@"fold"]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
