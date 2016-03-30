//
//  XKRWTitleHeadImgCell.h
//  XKRW
//
//  Created by Jack on 15/6/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWManagementEntity5_0.h"

@interface XKRWTitleHeadImgCell : UITableViewCell

@property (strong, nonatomic) XKRWManagementEntity5_0 *articleEntity;

@property (strong, nonatomic) IBOutlet UIImageView *headImg;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *readNumLabel;

@property (strong, nonatomic) IBOutlet UIButton *moreArticleBtn;

@property (strong, nonatomic) IBOutlet UILabel *moduleLabel;

@property (strong, nonatomic) IBOutlet UILabel *moreLabel;

@property (strong, nonatomic) IBOutlet UIImageView *starImg;

- (void)setContentWithArticleEntity:(XKRWManagementEntity5_0 *)entity;
@end
