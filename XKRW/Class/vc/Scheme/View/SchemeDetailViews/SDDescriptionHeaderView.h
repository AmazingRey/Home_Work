//
//  SDDescriptionHeaderView.h
//  XKRW
//
//  Created by Klein Mioke on 15/8/13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKRWSchemeEntity_5_0;

@interface SDDescriptionHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;

+ (SDDescriptionHeaderView *)instanceView;

- (void)setContentWithEntity:(XKRWSchemeEntity_5_0 *)entity;

@end
