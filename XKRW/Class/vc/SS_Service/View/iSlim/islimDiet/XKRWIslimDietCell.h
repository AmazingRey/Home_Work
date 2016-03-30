//
//  XKRWIslimDietCell.h
//  XKRW
//
//  Created by 忘、 on 15-1-21.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@interface XKRWIslimDietCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagLabelWidth;

@end
