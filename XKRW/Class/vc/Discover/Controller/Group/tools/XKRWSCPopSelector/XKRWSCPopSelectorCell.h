//
//  XKRWSCPopSelectorCell.h
//  XKRW
//
//  Created by Seth Chen on 16/1/25.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWUITableViewCellbase.h"

typedef void(^ButtonClickEvent)(BOOL, NSString *);

@interface XKRWSCPopSelectorCell : XKRWUITableViewCellbase

@property (weak, nonatomic) IBOutlet UIImageView *groupHeaderIcon;
@property (weak, nonatomic) IBOutlet UILabel *groupTitle;
@property (weak, nonatomic) IBOutlet UIButton *selectorButton;
@property (nonatomic, copy) ButtonClickEvent handle;
@property (nonatomic, copy) NSString *groupId;

- (void)setButtonState:(BOOL)abool;

@end
