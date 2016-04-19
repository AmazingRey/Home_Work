//
//  XKRWPlanTipsCell.h
//  XKRW
//
//  Created by 忘、 on 16/4/15.
//  Copyright © 2016年 XiKang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "XKRWPlanTipsEntity.h"

static NSString * const XKRWPlanTipsCellIdentifier = @"XKRWPlanTips";
@interface XKRWPlanTipsCell : UITableViewCell

@property (nonatomic,assign)  NSString *imageName;

- (void)updateHeightCell:(XKRWPlanTipsEntity *)entity;

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIImageView *backgroundImageView ;
@property (nonatomic, strong) UILabel *TipLabel;
@property (nonatomic, strong) UIColor *TipLabelColor;
@end
