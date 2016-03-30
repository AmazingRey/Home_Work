//
//  XKRWSurroundCell.m
//  XKRW
//
//  Created by 忘、 on 15/7/10.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWSurroundCell.h"

@implementation XKRWSurroundCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)entrySurroundVCAction:(UIButton *)sender {
//    _block(sender.tag);
    
    if (self.entrySurroundDelegate && [self.entrySurroundDelegate respondsToSelector:@selector(entrySurroundVCDelegate:)]) {
        [self.entrySurroundDelegate entrySurroundVCDelegate:sender.tag];
    }
    
}
@end
