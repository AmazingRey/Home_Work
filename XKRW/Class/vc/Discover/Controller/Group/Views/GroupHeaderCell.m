//
//  GroupHeaderCell.m
//  AFN_Test
//
//  Created by Seth Chen on 16/1/7.
//  Copyright © 2016年 xikang. All rights reserved.
//

#import "GroupHeaderCell.h"
@interface GroupHeaderCell ()
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end

@implementation GroupHeaderCell

- (void)awakeFromNib {
    // Initialization code
    self.showTip.hidden = NO;
    self.headerImageView.layer.cornerRadius = self.headerImageView.width/2;
    self.headerImageView.clipsToBounds = YES;
}

// override
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
//    self.separatorLine.backgroundColor = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    self.separatorLine.backgroundColor = [UIColor blackColor];
}

@end
