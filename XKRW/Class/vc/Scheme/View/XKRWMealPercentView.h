//
//  XKRWMealPercentView.h
//  XKRW
//
//  Created by ss on 16/4/25.
//  Copyright © 2016年 XiKang. All rights reserved.
//

@class XKRWMealPercentView;
@protocol XKRWMealPercentViewDelegate <NSObject>
@optional
-(void)slideDidScroll:(NSInteger)tag currentPercent:(NSInteger)percent;
-(void)lockMealPercentView:(NSInteger)tag withPercent:(NSInteger)percent lock:(BOOL)lock;
@end

#import <UIKit/UIKit.h>
#import "XKRWMealPercentSlider.h"

@interface XKRWMealPercentView : UIView

@property (assign, nonatomic) id<XKRWMealPercentViewDelegate> delegate;
@property (strong, nonatomic) XKRWMealPercentSlider *slider;
@property (strong, nonatomic) UILabel *labNum;
@property (strong, nonatomic) UILabel *labPercent;
@property (strong, nonatomic) UILabel *labTitle;
@property (assign, nonatomic) CGFloat startValue;
@property (strong, nonatomic) NSNumber *currentPerCent;
@property (assign, nonatomic) BOOL lock;
@property (strong, nonatomic) UIButton *btnLock;
@property (strong, nonatomic) UIImageView *imgHead;
@property (strong, nonatomic) UILabel *labSeperate;
- (instancetype)initWithFrame:(CGRect)frame currentValue:(NSNumber *)value;
@end
