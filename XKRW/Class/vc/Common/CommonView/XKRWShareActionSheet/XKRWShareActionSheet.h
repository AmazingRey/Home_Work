//
//  XKRWShareActionSheet.h
//  XKRW
//
//  Created by XiKang on 15-4-7.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//
@protocol XKRWShareActionSheetDelegate <NSObject>
@optional
- (void)tapHideShareActionSheetAction;

@end

#import <UIKit/UIKit.h>
#import "UMSocial.h"
/**
 分享用ActionSheet，自动根据数量调整大小高度
 */
@interface XKRWShareActionSheet : UIView

@property (nonatomic, assign) id <XKRWShareActionSheetDelegate> delegate;
@property (nonatomic, assign) FromWhichVC fromWhichVC;

/**
 *  初始化方法
 *
 *  @param images       分享图标数组
 *  @param clickHandler 点击按钮时触发事件
 *
 *  @return self实例
 */
- (instancetype)initWithButtonImages:(NSArray *)images fromWhichVC:(FromWhichVC)fromWhich clickButtonAtIndex:(void (^)(NSInteger index))clickHandler;
/**
 *  显示在屏幕上
 */
- (void)show;
- (void)hide;
@end
