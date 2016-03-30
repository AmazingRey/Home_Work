//
//  XKRWPersonCircumstancesCell.m
//  XKRW
//
//  Created by 忘、 on 15-1-21.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWPersonCircumstancesCell.h"

@implementation XKRWPersonCircumstancesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    CGSize size = [_descriptionLabel optimumSize];
    _descriptionLabel.lineSpacing = 7;
    _descriptionLabel.textColor = colorSecondary_666666;
    _descriptionLabel.text = _descriptionText;
    _descriptionLabel.font = XKDefaultFontWithSize(13.f);
    if(_locationImageView.hidden)
    {
        _descriptionLabel.frame = CGRectMake(15, 44, XKAppWidth-30, size.height);
    }else
    {
        _descriptionLabel.frame = CGRectMake(15, 122, XKAppWidth-30, size.height);
    }
}


- (CGFloat) getCurrentCellHeight:(NSString *)text;
{
    _descriptionLabel.text = text;
    RTLabel *lable = [[RTLabel alloc]initWithFrame:CGRectMake(15, 0, XKAppWidth-30, 0)];
    lable.lineSpacing = 7;
    lable.text = text;
    CGSize size = [lable optimumSize];
    return size.height;
}

@end
