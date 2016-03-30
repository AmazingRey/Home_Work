//
//  XKRWHabitStateCellTableViewCell.h
//  XKRW
//
//  Created by y on 15-1-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "NZLabel.h"

@interface XKRWHabitStateCellTableViewCell : UITableViewCell

@property (strong, nonatomic) NZLabel *titleLabel;
@property (strong, nonatomic) NZLabel *subTitleLabel;
@property (strong, nonatomic) RTLabel *connentLabel;

@property (nonatomic ,assign) CGFloat  cell_h;

- (CGFloat)getCellHeight;

- (void)loadDescribeData:(NSDictionary *)dic;






@end
