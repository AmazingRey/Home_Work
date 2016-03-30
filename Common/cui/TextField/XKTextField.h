//
//  XKTextField.h
//  XKCommon
//
//  Created by Rick Liao on 13-3-23.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString *(^XKTextFieldTextCheckRule)(NSString *);

OBJC_EXTERN NSInteger const XKTextFieldMaxInputLengthUnlimited;

@interface XKTextField : UITextField

// 当其为负数时，是指不限制最大输入长度
@property (nonatomic) NSInteger maxInputLength;

@property (nonatomic) UIResponder *nextResponderForReturn;

// 输入check失败时弹出alert的标题，缺省为无标题
@property (nonatomic) NSString *textCheckAlertTitle UI_APPEARANCE_SELECTOR;
// 输入check失败时弹出alert的按钮标签，缺省为"OK"
@property (nonatomic) NSString *textCheckAlertButtonTitle UI_APPEARANCE_SELECTOR;
// 输入的必需check失败时弹出alert的message，缺省为"输入不能为空"
@property (nonatomic) NSString *textRequiredCheckAlertMessage UI_APPEARANCE_SELECTOR;
// 输入的格式check失败时弹出alert的message，缺省为"输入格式不正确"
@property (nonatomic) NSString *textFormatCheckAlertMessage UI_APPEARANCE_SELECTOR;
// 输入的位数check失败时弹出alert的message，缺省为"输入字数不正确"
@property (nonatomic) NSString *textDigitCheckAlertMessage UI_APPEARANCE_SELECTOR;

+ (void)noticeToEndEditing;

// 在下面两个初始化方法的处理中，会设置垂直布局为居中（UIControlContentVerticalAlignmentCenter）
- (id)initWithFrame:(CGRect)frame;
- (id)initWithCoder:(NSCoder *)decoder;

// 以下check的返回值代表check结果，YES为check通过，NO为check不通过
- (BOOL)checkTextWithRule:(XKTextFieldTextCheckRule)ruleBlock;
- (BOOL)checkTextWithRule:(XKTextFieldTextCheckRule)ruleBlock
               alertTitle:(NSString *)alertTitle;
- (BOOL)checkTextWithRule:(XKTextFieldTextCheckRule)ruleBlock
               alertTitle:(NSString *)alertTitle
         alertButtonTitle:(NSString *)alertButtonTitle;

- (XKTextFieldTextCheckRule)textRequiredCheckRule;
- (XKTextFieldTextCheckRule)textRequiredCheckRuleWithNGMessage:(NSString *)ngMessage;

- (XKTextFieldTextCheckRule)textFormatCheckRuleWithRegex:(NSString *)regex;
- (XKTextFieldTextCheckRule)textFormatCheckRuleWithRegex:(NSString *)regex
                                               ngMessage:(NSString *)ngMessage;

// 注意：下面两个生成位数check规则的方法的实现中，并不区分全角和半角字符，任一个字符都算作1位
- (XKTextFieldTextCheckRule)textDigitCheckRuleWithMinDigit:(NSUInteger)minDigit
                                                  maxDigit:(NSUInteger)maxDigit;
- (XKTextFieldTextCheckRule)textDigitCheckRuleWithMinDigit:(NSUInteger)minDigit
                                                  maxDigit:(NSUInteger)maxDigit
                                                 ngMessage:(NSString *)ngMessage;

@end
