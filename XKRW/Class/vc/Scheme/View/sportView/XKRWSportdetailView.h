//
//  XKRWSportdetailView.h
//  XKRW
//
//  Created by 忘、 on 15/7/30.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWSportEntity.h"

@protocol XKRWSportdetailViewDelegate <NSObject>
@optional
- (void)playSportVideo;
- (void)resetScrollViewContentsize:(CGFloat) height;
@end

@interface XKRWSportdetailView : UIView <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webLoadV;

- (instancetype)initWithFrame:(CGRect)frame andEntity:(XKRWSportEntity *)entity;

@property (nonatomic,assign) id <XKRWSportdetailViewDelegate > sportDelegate;

@end
