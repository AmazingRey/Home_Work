//
//  XKRWServiceCell.h
//  XKRW
//
//  Created by 忘、 on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *describeLable;
@property (weak, nonatomic) IBOutlet UILabel *tipLable;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UIImageView *redDotImageView;


- (void) initSubViewsWithIconImageName:(NSString *)iconImageName Title:(NSString *)title Describe:(NSString *)describe tip:(NSString *)tip isShowHotImageView:(BOOL ) isShow  isShowRedDot:(BOOL)isShowRedDot;

@end
