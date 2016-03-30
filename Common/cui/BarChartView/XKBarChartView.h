//
//  XKBarChartView.h
//  calorie
//
//  Created by Rick Liao on 12-12-22.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

// 目前仅支持Y轴向上类型，其余类型留待后续开发。
typedef enum {    
    XKBarChartViewStyleYAxisPointToTop = 0,
//    XKBarChartViewStyleYAxisPointToRight,
//    XKBarChartViewStyleYAxisPointToBottom,
//    XKBarChartViewStyleYAxisPointToLeft,
} XKBarChartViewStyle;


@interface XKBarChartViewBarData : NSObject

@property (nonatomic, assign) float value;
@property (nonatomic) NSString *style;

- (id)initWithValue:(float)value style:(NSString *)style;

@end


// 目前仅支持底部坐标（bottom coord），对左、顶、右部的坐标的支持留待后续开发。
@interface XKBarChartView : UIView

@property (nonatomic, assign) XKBarChartViewStyle barChartViewStyle UI_APPEARANCE_SELECTOR; // 缺省为XKBarChartViewTypeYAxisPointToTop

@property (nonatomic, copy) NSArray *chartData;         // 数组中元素为XKBCVBarData类型
@property (nonatomic, copy) NSArray *bottomCoordData;   // 数组中元素要求为NSString类型，要求至少有两个元素

@property (nonatomic, assign) CGFloat barMargin UI_APPEARANCE_SELECTOR; // 缺省为0

@property (nonatomic, assign) CGFloat bottomCoordHeight UI_APPEARANCE_SELECTOR; // 缺省为0

@property (nonatomic) UIFont *bottomCoordFont UI_APPEARANCE_SELECTOR;   // 缺省为UILabel文本缺省字体
@property (nonatomic) UIColor *bottomCoordColor UI_APPEARANCE_SELECTOR; // 缺省为UILabel文本缺省颜色

@property (nonatomic) UIColor *chartBackgroundColor UI_APPEARANCE_SELECTOR;         // 缺省为白色
@property (nonatomic) UIColor *bottomCoordBackgroundColor UI_APPEARANCE_SELECTOR;   // 缺省为白色

@property (nonatomic) BOOL allowBackgroundCreatingForAnimationData UI_APPEARANCE_SELECTOR; // YES:允许在后台（多线程）创建动画数据，NO:必需在前台（单线程）创建动画数据，缺省为YES

- (void)setChartData:(NSArray *)chartData animated:(BOOL)animated;  // chartData数组中元素为XKBCVBarData类型

- (UIColor *)barColorForStyle:(NSString *)style;
- (void)setBarColor:(UIColor *)color forStyle:(NSString *)style;

@end
