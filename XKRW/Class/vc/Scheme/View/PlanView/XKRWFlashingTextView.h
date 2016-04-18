//
//  XKRWFlashingTextView.h
//  XKRW
//
//  Created by Shoushou on 16/4/15.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWFlashingTextView : UIView

@property (nonatomic,strong) NSString *text;
@property (nonatomic,assign) NSTextAlignment alignment;
@property (nonatomic,strong) UIColor *backColor;
@property (nonatomic,strong) UIColor *foreColor;
@property (nonatomic,strong) UIFont *font;

- (void)textFlashingWithDuration:(NSTimeInterval)duration;
- (void)endFlash;
- (void)startFlash;
@end
