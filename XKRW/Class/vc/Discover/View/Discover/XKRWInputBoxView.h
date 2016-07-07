//
//  XKRWInputBoxView.h
//  XKRW
//
//  Created by Shoushou on 16/1/26.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XKRWInputBoxViewStyle){
    original = 0,
    footer
};

@class XKRWInputBoxView;

@protocol XKRWInputBoxViewDelegate <NSObject>

@optional
- (void)inputBoxView:(XKRWInputBoxView *)inputBoxView
         sendMessage:(NSString *)message;

- (void)inputBoxView:(XKRWInputBoxView *)inputBoxView
    willShowDuration:(CGFloat)duration
            riseHeight:(CGFloat)height;

- (void)inputBoxView:(XKRWInputBoxView *)inputBoxView
    willHideDuration:(CGFloat)duration
             dropHeigh:(CGFloat)height;
@end

@interface XKRWInputBoxView : UIView
@property (nonatomic, strong) UIView *inputBgView;
@property (nonatomic, weak) id<XKRWInputBoxViewDelegate> delegate;
@property (nonatomic, assign) XKRWInputBoxViewStyle style;

- (instancetype)initWithPlaceholder:(NSString *)placeholder style:(XKRWInputBoxViewStyle)style;
- (void)showIn:(UIView *)view;
- (void)setPlaceholder:(NSString *)placeholder;
- (void)beginEditWithPlaceholder:(NSString *)placeholder;
- (void)isForbidActions:(BOOL)isForbid;
@end
