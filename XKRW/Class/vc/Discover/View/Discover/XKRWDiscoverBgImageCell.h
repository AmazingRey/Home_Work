//
//  XKRWDiscoverBgImageCell.h
//  XKRW
//
//  Created by Shoushou on 15/11/10.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWManagementEntity5_0.h"

@interface XKRWDiscoverBgImageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;
@property (strong, nonatomic) IBOutlet UILabel *topicLabel;

@property (strong, nonatomic) XKRWManagementEntity5_0 *discoverBgImageEntity;
- (void)setContentWithDiscoverBgImageEntity:(XKRWManagementEntity5_0 *)discoverBgImageEntity;
@end
