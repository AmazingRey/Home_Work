//
//  XKRWPullMenuNormalCell.m
//  XKRW
//
//  Created by ss on 16/6/6.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPullMenuNormalCell.h"

@implementation XKRWPullMenuNormalCell
- (void)awakeFromNib {
    if (XKAppHeight <= 480) {
        _imageLeadingConstraint.constant = 10;
        _labelLeadingCOnstraint.constant = 5;
    }else if (XKAppHeight == 568){
        _imageLeadingConstraint.constant = 10;
        _labelLeadingCOnstraint.constant = 5;
    }
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
