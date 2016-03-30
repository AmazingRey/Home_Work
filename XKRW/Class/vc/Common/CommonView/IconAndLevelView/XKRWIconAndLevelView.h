//
//  XKRWIconAndLevelView.h
//  XKRW
//
//  Created by Shoushou on 15/10/9.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWIconAndLevelView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *levelImageView;

- (instancetype)initWithFrame:(CGRect)frame IconUrl:(NSString *)iconUrl AndlevelUrl:(NSString *)level;

- (void)setIconUrl:(NSString *)icon andLevelUrl:(NSString *)level;

@end
