//
//  XKRWTopicListCell.m
//  XKRW
//
//  Created by Shoushou on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWTopicListCell.h"

typedef enum {
 styleNone,
 twoTitleStyle,
 oneTitleStyle,
 asLastCellStyle
}XKRWTopicListCellStyle;

@implementation XKRWTopicListCell
{
    IBOutlet UILabel *leftTitleLabel;
    IBOutlet UILabel *rightTitleLabel;
    IBOutlet UIView *centerLine;
    IBOutlet UIView *leftLine;
    IBOutlet UIView *rightLine;
    
    UIView *separateLine;
    NSArray *titleArray;
}
- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_leftBtn setBackgroundImage:[UIImage createImageWithColor:colorSecondary_f4f4f4] forState:UIControlStateHighlighted];
    [_rightBtn setBackgroundImage:[UIImage createImageWithColor:colorSecondary_f4f4f4] forState:UIControlStateHighlighted];
    [self addSeparateLine];
}

- (void)setTitles:(NSArray *)titles {
    titleArray = titles;
    
    if (titles.count == 1) {
        [self setSelfStyle:oneTitleStyle];
        leftTitleLabel.text = titles[0];
     
    } else if (titles.count == 2) {
        [self setSelfStyle:twoTitleStyle];
        leftTitleLabel.text = titles[0];
        rightTitleLabel.text = titles[1];
    }
}

- (void)setSelfStyle:(XKRWTopicListCellStyle)style {
    
    if (style == twoTitleStyle) {
        centerLine.hidden = NO;
        leftLine.hidden = NO;
        rightLine.hidden = NO;
        separateLine.hidden = YES;
        
        _rightBtn.hidden = NO;
        rightTitleLabel.hidden = NO;
        
    } else if (style == oneTitleStyle || titleArray.count == 1) {
        centerLine.hidden = YES;
        rightLine.hidden = YES;
        leftLine.hidden = YES;
        separateLine.hidden = NO;
        _rightBtn.hidden = YES;
        rightTitleLabel.hidden = YES;
        [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-15);
        }];
        
    } else if (style == asLastCellStyle && titleArray.count == 2){
        centerLine.hidden = NO;
        leftLine.hidden = YES;
        rightLine.hidden = YES;
        separateLine.hidden = NO;
        
        _rightBtn.hidden = NO;
        rightTitleLabel.hidden = NO;
    }
}

- (void)setLastCellStyle {
    [self setSelfStyle:asLastCellStyle];
}

- (void)addSeparateLine {
    separateLine = [[UIView alloc] initWithFrame:CGRectMake(5, 43.5, XKAppWidth - 10, 0.5)];
    separateLine.backgroundColor = colorSecondary_e0e0e0;
    [self.contentView addSubview:separateLine];
    separateLine.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
