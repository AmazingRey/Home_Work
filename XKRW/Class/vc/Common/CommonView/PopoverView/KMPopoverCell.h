//
//  KMPopoverCell.h
//  XKRW
//
//  Created by XiKang on 15-4-3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, KMPopoverCellType) {
    
    KMPopoverCellTypeOnlyText = 1,
    KMPopoverCellTypeImageAndText
};

@interface KMPopoverCell : UITableViewCell

- (instancetype)initWithType:(KMPopoverCellType)type width:(CGFloat)width reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setTitle:(NSString *)title;

- (void)setheadImage:(UIImage *)image;

@end
