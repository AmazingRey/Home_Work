//
//  iSlimBaseInfoCell.h
//  XKRW
//
//  Created by XiKang on 15-1-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWiSlimBaseCell.h"

@interface iSlimBaseInfoCell : XKRWiSlimBaseCell

- (void)setEvaluateGender:(void (^)(XKSex))gender;

@property (nonatomic, strong) UIImageView *upDownImageView;

@end
