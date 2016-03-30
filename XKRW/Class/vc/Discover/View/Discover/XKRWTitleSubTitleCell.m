//
//  XKRWTitleSubTitleCell.m
//  XKRW
//
//  Created by 韩梓根 on 15/6/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWTitleSubTitleCell.h"

@implementation XKRWTitleSubTitleCell

- (void)awakeFromNib {
    _titleLabel.font = XKDefaultFontWithSize(17);
    _titleLabel.textColor = XK_TITLE_COLOR;
    
    _timeLabel.font = XKDefaultFontWithSize(12);
    _timeLabel.textColor = XK_ASSIST_TEXT_COLOR;
    
    _readNumLabel.font = XKDefaultFontWithSize(12);
    _readNumLabel.textColor = XK_ASSIST_TEXT_COLOR;
    
    _moduleLabel.font = XKDefaultFontWithSize(12);
    _moduleLabel.textColor = XK_ASSIST_TEXT_COLOR;
    
    _moreLabel.font = XKDefaultFontWithSize(12);
    _moreLabel.textColor = XK_ASSIST_TEXT_COLOR;
    
    _subTitleLabel.font = XKDefaultFontWithSize(12);
    _subTitleLabel.textColor = XK_TEXT_COLOR;
    
    UIImageView *bottomLineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _moreArticleBtn.bottom-0.5, XKAppWidth, 0.5)];
    bottomLineImg.backgroundColor = XK_ASSIST_LINE_COLOR;
    [_moreArticleBtn addSubview:bottomLineImg];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
