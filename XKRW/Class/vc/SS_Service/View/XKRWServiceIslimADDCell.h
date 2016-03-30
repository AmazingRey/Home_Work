//
//  XKRWServiceIslimADDCell.h
//  XKRW
//
//  Created by Seth Chen on 16/3/15.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWServiceIslimADDCell : XKRWUITableViewCellbase

@property (weak, nonatomic) IBOutlet UIButton *IconButton;

@property (copy, nonatomic) void(^ButtonHanle)();

@end
