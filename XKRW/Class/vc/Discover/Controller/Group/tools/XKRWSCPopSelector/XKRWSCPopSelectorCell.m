//
//  XKRWSCPopSelectorCell.m
//  XKRW
//
//  Created by Seth Chen on 16/1/25.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWSCPopSelectorCell.h"

@interface XKRWSCPopSelectorCell ()

@property (assign, nonatomic) BOOL isSelect;

@end

@implementation XKRWSCPopSelectorCell

- (void)awakeFromNib {
    // Initialization code
    self.groupHeaderIcon.layer.cornerRadius = self.groupHeaderIcon.width/2;
    self.groupHeaderIcon.clipsToBounds = YES;
    self.isSelect = NO;
}

- (IBAction)selectClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isSelect = sender.selected;

    if (self.handle) {
        self.handle(self.isSelect,self.groupId);
    }
}

- (void)setHandle:(ButtonClickEvent)handle
{
    _handle = handle;
}

- (void)setButtonState:(BOOL)abool
{
    if (abool) {
        self.selectorButton.selected = YES;
    }else
    {
        self.selectorButton.selected = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
