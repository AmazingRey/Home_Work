//
//  XKRWUITableViewCellbase.m
//  XKRW
//
//  Created by Seth Chen on 15/12/30.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWUITableViewCellbase.h"

@implementation XKRWUITableViewCellbase

- (void)awakeFromNib {
    // Initialization code
    for (id obj in self.subviews)
    {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }  
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
