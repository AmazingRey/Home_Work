//
//  XKRWStageOneTableViewCell.h
//  XKRW
//
//  Created by y on 15-1-21.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKRWCircleView;


@interface XKRWStageOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gogalDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageSatelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stageSateLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *gogalWeightlabel;
@property (weak, nonatomic) IBOutlet UILabel *num1;
@property (weak, nonatomic) IBOutlet UILabel *num2;
@property (weak, nonatomic) IBOutlet UILabel *num3;
@property (weak, nonatomic) IBOutlet UIImageView *stageImage;
@property (weak, nonatomic) IBOutlet UILabel *everydayHadEnery;
@property (weak, nonatomic) IBOutlet UILabel *foodEnery;
@property (weak, nonatomic) IBOutlet UILabel *forcePercent;
@property (weak, nonatomic) IBOutlet UILabel *AerobicPercent;

@property (weak, nonatomic) IBOutlet UIImageView *sportImageView;

@property (weak, nonatomic) IBOutlet UILabel *p_label;
@property (weak, nonatomic) IBOutlet UILabel *y_label;

@property(nonatomic,strong)XKRWCircleView  *circleView;


-(void)setCirclePro:(CGFloat)rain;

@end
