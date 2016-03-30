//
//  XKRWExcerciseAssResultVC.h
//  XKRW
//
//  Created by XiKang on 15-1-20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWIslimModel.h"

@interface XKRWExcerciseAssResultVC : XKRWBaseVC

@property (nonatomic, strong) XKRWIslimModel *iSlimModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sportAdviseViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *sportAdviseView;

@end
