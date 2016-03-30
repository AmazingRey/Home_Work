//
//  XKRWUserCommentCell.h
//  XKRW
//
//  Created by XiKang on 15-1-19.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWStarView.h"
@interface XKRWUserCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property(nonatomic,strong)XKRWStarView   *star ;

@end
