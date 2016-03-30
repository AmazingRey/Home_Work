//
//  XKRWCourseDietAndSportCell.h
//  XKRW
//
//  Created by 忘、 on 15/7/13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWCourseDietAndSportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dietAndSportDetailImageView;
@property (weak, nonatomic) IBOutlet UILabel *perfectExecutionLabel;
@property (weak, nonatomic) IBOutlet UILabel *lazyLabel;
@property (weak, nonatomic) IBOutlet UILabel *doOtherLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dietAndSportImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dietAndSportDetailImageViewConstraint;
@end
