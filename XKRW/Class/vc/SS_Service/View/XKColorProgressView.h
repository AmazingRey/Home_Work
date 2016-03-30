//
//  XKColorProgressView.h
//  XKRW
//
//  Created by y on 15-1-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKColorProgressView : UIView
@property(nonatomic,strong)CALayer *colorlayer;
@property(nonatomic,strong)UILabel *SpeedLabel;

-(id)initWithFrame:(CGRect)frame initwithColorProgressWidth:(CGFloat)weight andColor:(UIColor*)color;


-(void)setSpeedlabelHide:(BOOL)yesOrNo;

@end
