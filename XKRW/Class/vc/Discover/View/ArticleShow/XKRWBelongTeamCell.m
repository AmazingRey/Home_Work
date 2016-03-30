//
//  XKRWBelongTeamCell.m
//  XKRW
//
//  Created by 忘、 on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBelongTeamCell.h"

@implementation XKRWBelongTeamCell

- (void)awakeFromNib {
    // Initialization code
    _teamImageView.layer.masksToBounds = YES;
    _teamImageView.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
