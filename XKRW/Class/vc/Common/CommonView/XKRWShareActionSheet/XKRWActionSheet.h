//
//  XKRWActionSheet.h
//  XKRW
//
//  Created by Shoushou on 16/1/5.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelButtonClickBlock)();

@class XKRWActionSheet;

@protocol XKRWActionSheetDelegate <NSObject>
- (void)actionSheet:(XKRWActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@optional
- (void)actionSheet:(XKRWActionSheet *)actionSheet clickedHeaderAtIndex:(NSInteger)buttonIndex;
@end

@interface XKRWActionSheet : UIView

@property (nonatomic, assign) NSInteger destructiveButtonIndex;
@property (nonatomic, copy) cancelButtonClickBlock cancelButtonClicked;

@property (nonatomic, weak) id<XKRWActionSheetDelegate> delegate;
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

- (instancetype)initShareHeaderSheetWithCancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;
- (NSInteger)addButtonWithTitle:(NSString *)title;

- (void)showInView:(UIView *)view;
@end
