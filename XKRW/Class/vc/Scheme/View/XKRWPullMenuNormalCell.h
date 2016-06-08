//
//  XKRWPullMenuNormalCell.h
//  XKRW
//
//  Created by ss on 16/6/6.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWPullMenuNormalCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelTrailingConstraint;

@end
