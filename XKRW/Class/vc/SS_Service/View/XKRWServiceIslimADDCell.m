//
//  XKRWServiceIslimADDCell.m
//  XKRW
//
//  Created by Seth Chen on 16/3/15.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWServiceIslimADDCell.h"

@implementation XKRWServiceIslimADDCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addpush:(UIButton *)sender {
    if (self.ButtonHanle) {
        self.ButtonHanle();
    }
}


@end
