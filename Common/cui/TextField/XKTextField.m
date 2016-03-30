//
//  XKTextField.m
//  XKCommon
//
//  Created by Rick Liao on 13-3-23.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "NSString+XKUtil.h"
#import "XKCuiUtil.h"
#import "XKUtil.h"
#import "XKNotification.h"
#import "XKDefine.h"
#import "XKTextField.h"

NSInteger const XKTextFieldMaxInputLengthUnlimited = -1;

@interface XKTextDelegate : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id<UITextFieldDelegate> outerDelegate;

@property (nonatomic, weak) XKTextField *textField;

+ delegateWithTextField:(XKTextField *)textField;

- (id)initWithTextField:(XKTextField *)textField;

@end

@implementation XKTextDelegate

+ (XKTextDelegate *)delegateWithTextField:(XKTextField *)textField {
    return [[XKTextDelegate alloc] initWithTextField:textField];
}

- (id)initWithTextField:(XKTextField *)textField {
    self = [super init];
    
    if (self) {
        self.outerDelegate = nil;
        self.textField = textField;
    }
    
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return  [XKTextDelegate instancesRespondToSelector:aSelector] || [_outerDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _outerDelegate;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL ret = YES;
    
    if (textField == _textField) {
        if (_textField.nextResponderForReturn) {
            [_textField.nextResponderForReturn becomeFirstResponder];
        } else {
            [_textField resignFirstResponder];
        }
    }
    
    if ([_outerDelegate respondsToSelector:_cmd]) {
        ret = [_outerDelegate textFieldShouldReturn:textField];
    }
    
    return ret;
}

- (void)textDidChange:(NSNotification *)notification {
    if (notification.object == _textField) {
        [XKCuiUtil limitTextField:_textField maxInputLengthTo:_textField.maxInputLength];
    }
}

- (void)endEditing:(NSNotification *)notification {
    if (_textField.editing) {
        [_textField resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endEditing:)
                                                 name:kXKTextFieldShouldEndEditingNotification
                                               object:nil];
    
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self removeNotificationObservers];
    
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate textFieldDidEndEditing:textField];
    }
}

- (void)dealloc {
    // 用于一直未能出现textFieldDidEndEditing的场合，来额外的取消对通知的订阅
    [self removeNotificationObservers];
}

- (void)removeNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kXKTextFieldShouldEndEditingNotification
                                                  object:nil];
}

@end


@interface XKTextField () <UITextFieldDelegate>

@property (nonatomic) XKTextDelegate *xkDelegate;

@end

@implementation XKTextField

+ (void)noticeToEndEditing {
    [[NSNotificationCenter defaultCenter] postNotification:[XKNotification notificationWithName:kXKTextFieldShouldEndEditingNotification object:nil]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
   
    _xkDelegate = [XKTextDelegate delegateWithTextField:self];
    super.delegate = _xkDelegate;
    
    _maxInputLength = XKTextFieldMaxInputLengthUnlimited;
    _nextResponderForReturn = nil;
    
    _textCheckAlertTitle = nil;
    _textCheckAlertButtonTitle = @"OK";
    
    _textRequiredCheckAlertMessage = @"输入不能为空";
    _textFormatCheckAlertMessage = @"输入格式不正确";
    _textDigitCheckAlertMessage = @"输入字数不正确";
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (id<UITextFieldDelegate>)delegate {
    return _xkDelegate.outerDelegate;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    _xkDelegate.outerDelegate = delegate;
}

- (void)setNextResponderForReturn:(UIResponder *)nextResponderForReturn {
    _nextResponderForReturn = nextResponderForReturn;
    
    if (nextResponderForReturn) {
        self.returnKeyType = UIReturnKeyNext;
    }
}

- (BOOL)checkTextWithRule:(NSString *(^)(NSString *))ruleBlock {
    return [self checkTextWithRule:ruleBlock alertTitle:_textCheckAlertTitle];
}

- (BOOL)checkTextWithRule:(NSString *(^)(NSString *))ruleBlock
               alertTitle:(NSString *)alertTitle {
    return [self checkTextWithRule:ruleBlock
                        alertTitle:alertTitle
                  alertButtonTitle:_textCheckAlertButtonTitle];
}

- (BOOL)checkTextWithRule:(NSString *(^)(NSString *))ruleBlock
               alertTitle:(NSString *)alertTitle
         alertButtonTitle:(NSString *)alertButtonTitle {
    BOOL result = YES;
    
    NSString *message = ruleBlock(self.text);
    
    if (message) {
        [XKCuiUtil showAlertWithTitle:alertTitle
                              message:message
                        okButtonTitle:alertButtonTitle
                            onOKBlock:^{
                                [self becomeFirstResponder];
                            }];
        result = NO;
    } // else NOP
    
    return result;
}

- (XKTextFieldTextCheckRule)textRequiredCheckRule {
    return [self textRequiredCheckRuleWithNGMessage:_textRequiredCheckAlertMessage];
}

- (XKTextFieldTextCheckRule)textRequiredCheckRuleWithNGMessage:(NSString *)ngMessage {
    return ^(NSString *text) {
        NSString *message = [text isNotEmpty] ? nil : ngMessage;
        return message;
    };
}

- (XKTextFieldTextCheckRule)textFormatCheckRuleWithRegex:(NSString *)regex {
    return [self textFormatCheckRuleWithRegex:regex
                                    ngMessage:_textFormatCheckAlertMessage];
}

- (XKTextFieldTextCheckRule)textFormatCheckRuleWithRegex:(NSString *)regex
                                               ngMessage:(NSString *)ngMessage {
    return ^(NSString *text) {
        NSString *message = [XKUtil wholeString:text matchRegex:regex] ? nil : ngMessage;
        return message;
    };
}

- (XKTextFieldTextCheckRule)textDigitCheckRuleWithMinDigit:(NSUInteger)minDigit
                                                  maxDigit:(NSUInteger)maxDigit {
    return [self textDigitCheckRuleWithMinDigit:minDigit
                                       maxDigit:maxDigit
                                      ngMessage:_textDigitCheckAlertMessage];
}

- (XKTextFieldTextCheckRule)textDigitCheckRuleWithMinDigit:(NSUInteger)minDigit
                                                  maxDigit:(NSUInteger)maxDigit
                                                 ngMessage:(NSString *)ngMessage {
    return ^(NSString *text) {
        NSUInteger length = [text length];
        NSString *message = (length >= minDigit && length <= maxDigit) ? nil : ngMessage;
        return message;
    };
}

@end
