//
//  XKRWphysicalAssessmentCell.h
//  XKRW
//
//  Created by 忘、 on 15-1-19.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWphysicalAssessmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *detailedContentLable;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@end
