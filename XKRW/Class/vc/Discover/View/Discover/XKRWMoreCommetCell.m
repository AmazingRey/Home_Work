//
//  XKRWMoreCommetCell.m
//  XKRW
//
//  Created by Shoushou on 15/10/25.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWMoreCommetCell.h"
#import "define.h"

@implementation XKRWMoreCommetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.moreLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.nocommentImageView];
        [self.contentView insertSubview:self.bottomLine atIndex:0];
    }
    return self;
}

- (UILabel *)moreLabel {
    
    if (_moreLabel == nil) {
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _moreLabel.center = CGPointMake(XKAppWidth/2, 22);
        _moreLabel.textAlignment = NSTextAlignmentCenter;
        _moreLabel.font = XKDefaultFontWithSize(14);
        _moreLabel.textColor = colorSecondary_999999;
    }
    return _moreLabel;
}

- (UIView *)lineView {
    
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        _lineView.backgroundColor = colorSecondary_e0e0e0;
    }
    return _lineView;
}

- (UIView *)bottomLine {
    
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5 , XKAppWidth, 0.5)];
        _bottomLine.backgroundColor = colorSecondary_e0e0e0;
    }
    return _bottomLine;
}
- (UIImageView *)nocommentImageView {
    
    if (_nocommentImageView == nil) {
        UIImage *nocommentImage = [UIImage imageNamed:@"nopinglun"];
        _nocommentImageView = [[UIImageView alloc] initWithImage:nocommentImage];
        _nocommentImageView.center = CGPointMake(XKAppWidth/2, 22);
    }
    return _nocommentImageView;
}

// 是否有评论
- (void)setHaveComment:(BOOL)haveComment {
    
    _haveComment = haveComment;
    if (!haveComment) {
        self.moreLabel.hidden = YES;
        self.lineView.hidden = YES;
        self.nocommentImageView.hidden = NO;
        
    } else {
        self.nocommentImageView.hidden = YES;
        self.moreLabel.hidden = NO;
        self.lineView.hidden = NO;

    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
