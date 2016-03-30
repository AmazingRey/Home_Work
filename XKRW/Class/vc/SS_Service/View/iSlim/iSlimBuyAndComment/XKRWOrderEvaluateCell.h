//
//  XKRWOrderEvaluateCell.h
//  XKRW
//
//  Created by y on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWStarView.h"

@interface XKRWOrderEvaluateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *UnEvaluate;

@property(nonatomic,strong)XKRWStarView   *star ; 

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@end
