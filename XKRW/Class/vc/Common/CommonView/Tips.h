//
//  Tips.h
//  XKRW
//
//  Created by XiKang on 15-3-26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TipsCallbackDelegate <NSObject>

- (void)disappearCallback;

@end

@interface Tips : UIView

@property (weak, nonatomic) id <TipsCallbackDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *upArrow;
@property (weak, nonatomic) IBOutlet UIView *frameView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
/**
 *  初始化方法,
 *
 *  @attention  view宽度始终为screenWidth，此处Point坐标的x为内容框（frameView，.y始终为11）的x坐标，y坐标为view的y坐标
 *
 *  @param origin 坐标点
 *  @param string 内容文字
 *
 *  @return Tips实例
 */
- (instancetype)initWithOrigin:(CGPoint)origin andText:(NSString *)string;
/**
 *  设置箭头横向间距
 *
 *  @param space 间距
 */
- (void)setArrowHorizontalSpace:(CGFloat)space;
/**
 *  显示在KeyWindow上
 */
- (void)addToWindow;
/**
 *  显示在View上
 *
 *  @param superView 加载的父视图
 */
- (void)showInView:(UIView *)superView;

@end
