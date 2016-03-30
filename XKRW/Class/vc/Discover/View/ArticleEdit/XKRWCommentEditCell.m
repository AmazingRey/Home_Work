//
//  XKRWCommentEditCell.m
//  XKRW
//
//  Created by Shoushou on 15/10/23.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWCommentEditCell.h"
#import "define.h"

@implementation XKRWCommentEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createDivideLineWithFrame:CGRectMake(0, 15, XKAppWidth/2-45, 0.5)];
        [self createDivideLineWithFrame:CGRectMake(XKAppWidth/2 + 45, 15, XKAppWidth/2-45, 0.5)];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _titleLabel.center = CGPointMake(XKAppWidth/2, 15);
        _titleLabel.text = @"评论";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = XKDefaultFontWithSize(12);
        _titleLabel.textColor = XK_ASSIST_TEXT_COLOR;
        [self.contentView addSubview:_titleLabel];
        
        [self.contentView addSubview:self.writeCommentBtn];
        
        [self.contentView addSubview:self.recentCommentLb];
        
    }
    return self;
}

- (void)createDivideLineWithFrame:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = XK_ASSIST_LINE_COLOR;
    [self.contentView addSubview:line];
}

- (UIButton *)writeCommentBtn
{
    if (_writeCommentBtn == nil) {
        _writeCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _writeCommentBtn.layer.cornerRadius = 3;
        _writeCommentBtn.frame = CGRectMake(XKAppWidth-15-70, 25, 70, 26);
        [_writeCommentBtn setTitle:@"写评论" forState:UIControlStateNormal];
        [_writeCommentBtn setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
        _writeCommentBtn.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
        _writeCommentBtn.layer.borderWidth = 1.0;
        _writeCommentBtn.titleLabel.font = XKDefaultFontWithSize(14);
        [_writeCommentBtn setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
        [_writeCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    return _writeCommentBtn;
}

- (UILabel *)recentCommentLb
{
    if (_recentCommentLb == nil) {
        _recentCommentLb = [[UILabel alloc] initWithFrame: CGRectMake(15, 30, 80, 20)];
        _recentCommentLb.textColor = colorSecondary_999999;
        _recentCommentLb.textAlignment = NSTextAlignmentLeft;
        _recentCommentLb.font = XKDefaultFontWithSize(14);
        _recentCommentLb.text = @"最新评论";
        
    }
    return _recentCommentLb;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
