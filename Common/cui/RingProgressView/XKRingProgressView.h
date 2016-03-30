//
//  XKRingProgressView.h
//  calorie
//
//  Created by Rick Liao on 12-11-30.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

// 进度条顶端形状
enum XKProgressCapStyle {
    kXKProgressCapStyleButt = 0,    // 平头
    kXKProgressCapStyleRound        // 圆头
};
typedef enum XKProgressCapStyle XKProgressCapStyle;

// 进度文本模式
enum XKProgressTextMode {
    kXKProgressTextModeNone = 0,    // 无：文本不显示
    kXKProgressTextModeAuto,        // 自动：根据进度自动生成文本（文本格式可定制）
    kXKProgressTextModeAssign       // 指定：外部指定文本
};
typedef enum XKProgressTextMode XKProgressTextMode;


// 进度文本格式化Protocol
@protocol XKProgressTextFormatter <NSObject>

@required
// 格式化指定进度数，返回格式化后的文本
- (NSString *)fomatProgress:(float)progress;

@end


// 环形进度条View
@interface XKRingProgressView : UIView

@property(nonatomic) float progress;    // 进度数(0至1小数)

@property(nonatomic) CGFloat progressRatio UI_APPEARANCE_SELECTOR;      // 进度条宽度占环半径的比率
@property(nonatomic) CGFloat trackRatio UI_APPEARANCE_SELECTOR;         // 进度轨道宽度占环半径的比率
@property(nonatomic) CGFloat innerBorderRatio UI_APPEARANCE_SELECTOR;   // 内边界宽度占环半径的比率
@property(nonatomic) CGFloat outerBorderRatio UI_APPEARANCE_SELECTOR;   // 外边界宽度占环半径的比率

@property(nonatomic) CGFloat progressWidth UI_APPEARANCE_SELECTOR;      // 进度条宽度
@property(nonatomic) CGFloat trackWidth UI_APPEARANCE_SELECTOR;         // 进度轨道宽度
@property(nonatomic) CGFloat innerBorderWidth UI_APPEARANCE_SELECTOR;   // 内边界宽度
@property(nonatomic) CGFloat outerBorderWidth UI_APPEARANCE_SELECTOR;   // 外边界宽度

@property(nonatomic, retain) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;     // 进度条颜色
@property(nonatomic, retain) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;        // 进度轨道颜色
@property(nonatomic, retain) UIColor *innerBorderTintColor UI_APPEARANCE_SELECTOR;  // 内边界颜色
@property(nonatomic, retain) UIColor *outerBorderTintColor UI_APPEARANCE_SELECTOR;  // 外边界颜色
@property(nonatomic, retain) UIColor *centerTintColor UI_APPEARANCE_SELECTOR;       // 中心（圆）颜色

@property(nonatomic) XKProgressCapStyle progressCapStyle UI_APPEARANCE_SELECTOR;    // 进度条顶端形状(缺省为“平头”)

@property(nonatomic) XKProgressTextMode progressTextMode UI_APPEARANCE_SELECTOR;    // 进度文本模式（缺省为“自动”）
@property(nonatomic, copy) NSString *progressText;                                   // 进度文本(仅当进度文本模式为“指定”时有效)
@property(nonatomic, assign) id<XKProgressTextFormatter> progressTextFormatter UI_APPEARANCE_SELECTOR;   // 进度文本格式化代理（仅当进度文本模式为“自动”时有效；不指定时处理为缺省格式：两位整数的百分数：如“50%”）

@property(nonatomic, retain) UIFont *progressTextFont UI_APPEARANCE_SELECTOR;       // 进度文本字体
@property(nonatomic, retain) UIColor *progressTextColor UI_APPEARANCE_SELECTOR;     // 进度文本颜色

// 设置进度数，可设置是否显示动画效果
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
