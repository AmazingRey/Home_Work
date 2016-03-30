//
//  XKRWUserCommentCell.m
//  XKRW
//
//  Created by XiKang on 15-1-19.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWUserCommentCell.h"

@implementation XKRWUserCommentCell

- (void)awakeFromNib {
    // Initialization code
    self.star = [[XKRWStarView alloc]initWithFrame:CGRectMake(60, 38,160 , 20) withColorCount:0 isEnable:NO isUserComment:YES];
    [self.contentView addSubview:self.star];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
