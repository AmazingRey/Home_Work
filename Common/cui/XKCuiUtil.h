//
//  XKCuiUtil.h
//  calorie
//
//  Created by Rick Liao on 12-12-28.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKCuiUtil : NSObject

// 限制TextField的最大输入位数，不考虑字符的物理字节数，各种字符都看作size为1
// 当参数maxInputSize为负时，含义为不限制最大输入位数。
+ (void)limitTextField:(UITextField *)textField maxInputLengthTo:(NSInteger)maxInputLength;

// 限制TextField的最大输入位数，不考虑字符的物理字节数，各种字符都看作size为1
// 当参数maxInputSize为负时，含义为不限制最大输入位数。
// 本方法仅适合于在[UITextFieldDelegate textField:shouldChangeCharactersInRange:replacementString:]方法中被调用
// 返回值的意义也与上述方法相同，应该作为上述方法返回值返回。
// 注意：此方法在iOS6.0之前的版本中与resignFirstResponder连用时，如果遇到自动check或快捷输入导致超过最大允许输入长度的情况，会导致应用崩溃
+ (BOOL)limitTextField:(UITextField *)textField
        maxInputLengthTo:(NSInteger)maxInputLength
beforeChangingCharsInRange:(NSRange)range
     replacementString:(NSString *)string;
    
+ (NSArray *)createEaseInEaseOutTimesForTotalTime:(float)totalTime
                                       totalCount:(NSUInteger)totalCount;

+ (NSArray *)createCenterBalancedTimesForTotalTime:(float)totalTime
                                        totalcount:(NSUInteger)totalCount
                                       centerCount:(NSUInteger)centerCount  // 有效区间［1，totalCount］
                                   centerTimeRatio:(float)centerTimeRatio;  // 有效区间［0，1］

+ (NSArray *)convertTimesToDurations:(NSArray *)times;

+ (UIButton *)createButtonWithNormalImageName:(NSString *)normalImageName
                         highlightedImageName:(NSString *)highlightedImageName;
+ (UIButton *)createButtonWithNormalImageName:(NSString *)normalImageName
                         highlightedImageName:(NSString *)highlightedImageName
                                       target:(id)target
                                       action:(SEL)action;

+ (UIBarButtonItem *)createBarButtonItemWithNormalImageName:(NSString *)normalImageName
                                       highlightedImageName:(NSString *)highlightedImageName
                                                     target:(id)target
                                                     action:(SEL)action;

+ (void)showAlertWithMessage:(NSString *)message
               okButtonTitle:(NSString *)okButtonTitle
                   onOKBlock:(void (^)(void))onOKBlock;
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             okButtonTitle:(NSString *)okButtonTitle
                 onOKBlock:(void (^)(void))onOKBlock;
+ (void)showConfirmWithMessage:(NSString *)message
                 okButtonTitle:(NSString *)okButtonTitle
             cancelButtonTitle:(NSString *)cancelButtonTitle
                     onOKBlock:(void (^)(void))onOKBlock;
+ (void)showConfirmWithTitle:(NSString *)title
                     message:(NSString *)message
               okButtonTitle:(NSString *)okButtonTitle
           cancelButtonTitle:(NSString *)cancelButtonTitle
                   onOKBlock:(void (^)(void))onOKBlock;
+ (void)showConfirmWithTitle:(NSString *)title
                     message:(NSString *)message
               okButtonTitle:(NSString *)okButtonTitle
           cancelButtonTitle:(NSString *)cancelButtonTitle
                   onOKBlock:(void (^)(void))onOKBlock
               onCancelBlock:(void (^)(void)) onCancelBlock;

@end
