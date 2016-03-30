//
//  GroupHeaderCell.h
//  AFN_Test
//
//  Created by Seth Chen on 16/1/7.
//  Copyright © 2016年 xikang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *showTip;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@end
