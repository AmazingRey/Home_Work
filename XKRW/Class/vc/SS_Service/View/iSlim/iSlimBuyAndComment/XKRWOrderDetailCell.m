//
//  XKRWOrderDetailCell.m
//  XKRW
//
//  Created by y on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWOrderDetailCell.h"

@implementation XKRWOrderDetailCell

- (void)awakeFromNib {
    self.star = [[XKRWStarView alloc]initWithFrame:CGRectMake(80, 144+ (44-20)/2, 160, 20) withColorCount:0 isEnable:YES isUserComment:NO];
    [self.contentView addSubview:self.star];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
