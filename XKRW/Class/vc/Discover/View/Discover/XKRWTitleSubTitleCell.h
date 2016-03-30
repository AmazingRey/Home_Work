//
//  XKRWTitleSubTitleCell.h
//  XKRW
//
//  Created by 韩梓根 on 15/6/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWTitleSubTitleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *curArticleBtn;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *starImg;

@property (strong, nonatomic) IBOutlet UILabel *readNumLabel;

@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (strong, nonatomic) IBOutlet UIButton *moreArticleBtn;

@property (strong, nonatomic) IBOutlet UILabel *moduleLabel;

@property (strong, nonatomic) IBOutlet UILabel *moreLabel;

@end
