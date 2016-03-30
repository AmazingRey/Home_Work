//
//  XKRWUserArticleTitleCell.h
//  XKRW
//
//  Created by Klein Mioke on 15/10/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWUserArticleTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingSpace;

@end
