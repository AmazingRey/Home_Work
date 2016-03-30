//
//  XKRWTipView.h
//  XKRW
//
//  Created by Shoushou on 15/12/17.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKRWTipView;

@protocol XKRWTipViewDelegate <NSObject>

@optional
- (void)tipView:(XKRWTipView *)tipView delectCommentWithCommentId:(NSInteger)commentId;
- (void)tipView:(XKRWTipView *)tipView copyAtIndexPath:(NSIndexPath *)mainIndexPath subIndexPath:(NSIndexPath *)subIndexPath;
- (void)tipView:(XKRWTipView *)tipView reportCommentWithCommentId:(NSInteger)commentId;
@end

@interface XKRWTipView : UIView
@property (nonatomic, strong) id<XKRWTipViewDelegate> delegate;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, strong) NSArray <NSIndexPath *> *indexArray;

- (void)showUpView:(UIView *)view titles:(NSArray *)titles;
@end
