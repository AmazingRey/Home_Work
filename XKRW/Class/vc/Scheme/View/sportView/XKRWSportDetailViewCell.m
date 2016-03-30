//
//  XKRWSportDetailViewCell.m
//  XKRW
//
//  Created by 忘、 on 15/9/14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWSportDetailViewCell.h"

@implementation XKRWSportDetailViewCell

- (void)awakeFromNib {
    // Initialization code
    _sportWebView.scrollView.scrollEnabled = NO;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
