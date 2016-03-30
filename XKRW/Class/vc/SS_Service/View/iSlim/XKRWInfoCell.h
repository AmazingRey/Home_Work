//
//  XKRWInfoCell.h
//  XKRW
//
//  Created by XiKang on 15-3-24.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *autoLayoutView;

- (void)setTitle:(NSString *)title content:(NSString *)content;

@end
