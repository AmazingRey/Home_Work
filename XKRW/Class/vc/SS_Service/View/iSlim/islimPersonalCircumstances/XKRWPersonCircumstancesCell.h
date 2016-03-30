//
//  XKRWPersonCircumstancesCell.h
//  XKRW
//
//  Created by 忘、 on 15-1-21.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@interface XKRWPersonCircumstancesCell : UITableViewCell

@property (nonatomic,strong) NSString * descriptionText;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightStateLabel;

@property (weak, nonatomic) IBOutlet RTLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;


- (CGFloat) getCurrentCellHeight:(NSString *)text;

@end
