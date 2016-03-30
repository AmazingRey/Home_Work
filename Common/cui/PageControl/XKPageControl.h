//
//  XKPageControl.h
//  calorie
//
//  Created by Rick Liao on 12-10-9.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

// 注意：本控件仅是用于
@interface XKPageControl : UIPageControl

@property (nonatomic, retain) UIImage *dotOnImage;
@property (nonatomic, retain) UIImage *dotOffImage;

- (void)setDotOnImageWithName:(NSString *)imageName;
- (void)setDotOffImageWithName:(NSString *)imageName;

@end
