//
//  XKRWPayOrderCell.h
//  XKRW
//
//  Created by XiKang on 15-3-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWPayOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *platformName;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle headImage:(NSString *)imageName;

@end
