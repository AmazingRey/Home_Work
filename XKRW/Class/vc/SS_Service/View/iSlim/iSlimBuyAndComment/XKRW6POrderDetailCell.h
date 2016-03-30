//
//  XKRWOrderDetailCell.h
//  XKRW
//
//  Created by y on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWStarView.h"

@interface XKRW6POrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(nonatomic,strong) XKRWStarView   *star ;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyDescribe;
@property (weak, nonatomic) IBOutlet UILabel *dateDescribe;
@property (weak, nonatomic) IBOutlet UILabel *UnEvaluate;

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *ordeNoDes;

@end
