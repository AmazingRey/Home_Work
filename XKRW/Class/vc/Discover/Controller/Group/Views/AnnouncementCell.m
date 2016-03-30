//
//  AnnouncementCell.m
//  AFN_Test
//
//  Created by Seth Chen on 16/1/7.
//  Copyright © 2016年 xikang. All rights reserved.
//

#import "AnnouncementCell.h"

@interface AnnouncementCell ()
@property (weak, nonatomic) IBOutlet UIView *separatorLine;
@property (weak, nonatomic) IBOutlet UILabel *announceLabel;

@end

@implementation AnnouncementCell

- (void)awakeFromNib {
    // Initialization codes
    _announceLabel.layer.borderColor = XKMainSchemeColor.CGColor;
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
