//
//  XKRWInputBoxView.m
//  XKRW
//
//  Created by Shoushou on 16/1/26.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWInputBoxView.h"

@interface XKRWInputBoxView ()<UITextViewDelegate>

@end

@implementation XKRWInputBoxView
{
    UIView *line;
    UITapGestureRecognizer *dropGesture;
    UITextView *inputBox;
    UIButton *senderButton;
    UILabel *placeholderLabel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.size = CGSizeMake(XKAppWidth, XKAppHeight);
        self.clipsToBounds = NO;
        self.backgroundColor = XKClearColor;
        self.hidden = YES;
        
        dropGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputBoxEndEdit)];
        _inputBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 40)];
        _inputBgView.backgroundColor = colorSecondary_fafafa;
        [self addSubview:_inputBgView];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        line.backgroundColor = colorSecondary_e0e0e0;
        [_inputBgView addSubview:line];
        
        inputBox = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, XKAppWidth - 20, 30)];
        inputBox.delegate = self;
        inputBox.layer.cornerRadius = 5.0;
        inputBox.layer.borderWidth = 1.0;
        inputBox.layer.borderColor = colorSecondary_e0e0e0.CGColor;
        inputBox.textColor = colorSecondary_333333;
        inputBox.font = XKDefaultFontWithSize(14);
        inputBox.keyboardType = UIKeyboardTypeDefault;
        [_inputBgView addSubview:inputBox];
        
        placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(inputBox.left, 5, inputBox.width, 20)];
        placeholderLabel.backgroundColor = XKClearColor;
        placeholderLabel.font = XKDefaultFontWithSize(14);
        placeholderLabel.textColor = colorSecondary_999999;
        placeholderLabel.textAlignment = NSTextAlignmentLeft;
        [inputBox addSubview:placeholderLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    [self setStyle:original];
    
    return self;
}
- (instancetype)initWithPlaceholder:(NSString *)placeholder style:(XKRWInputBoxViewStyle)style {
    self = [self init];
    
    [self setStyle:style];
    placeholderLabel.text = placeholder;
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setStyle:(XKRWInputBoxViewStyle)style {
    
    _style = style;
    if (style == footer) {
        inputBox.size = CGSizeMake(XKAppWidth - 100, 30);
        senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        senderButton.frame = CGRectMake(inputBox.right + 10, _inputBgView.height - 35, 70, 30);
        senderButton.layer.cornerRadius = 2.5;
        senderButton.clipsToBounds = YES;
        [senderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [senderButton setBackgroundImage:[UIImage createImageWithColor:[XKMainSchemeColor colorWithAlphaComponent:0.6]] forState:UIControlStateHighlighted];
        [senderButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateNormal];
        senderButton.titleLabel.font = XKDefaultFontWithSize(16);
        [senderButton setTitle:@"发送" forState:UIControlStateNormal];
        [senderButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [_inputBgView addSubview:senderButton];
        [inputBox setReturnKeyType:UIReturnKeyDefault];
        
    } else {
        [inputBox setReturnKeyType:UIReturnKeySend];
    }
}


- (void)showIn:(UIView *)view {
    if (_style == footer) {
        self.origin = CGPointMake(0, XKAppHeight - 40 - 64);
    } else {
        self.origin = CGPointMake(0, view.height);
    }
    [view addSubview:self];
    self.hidden = NO;
}

- (void)beginEditWithPlaceholder:(NSString *)placeholder {
    placeholderLabel.text = placeholder;
    [inputBox becomeFirstResponder];
}

- (void)isForbidActions:(BOOL)isForbid {
    if (isForbid) {
        [senderButton removeTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [senderButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    placeholderLabel.text = placeholder;
}

#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        placeholderLabel.hidden = NO;
    } else {
        placeholderLabel.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (_style == footer) {
        return YES;
    } else {
        if ([text isEqualToString:@"\n"]) {
            [self sendMessage];
            return NO;
        } else {
            return YES;
        }
    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    int height = (int)[self calculateCommentHeightWithText:textView.text];
    CGSize inputBoxSize = inputBox.size;
    CGFloat inputBgViewBottom = _inputBgView.bottom;
    if (height != inputBoxSize.height) {
        
        if ( height > [self calculateCommentHeightWithText:@"\n\n\n\n"]) {
            
        } else if (height >= 30) {
            _inputBgView.frame = CGRectMake(0, inputBgViewBottom - height - 10, self.width, height + 10);
            inputBox.size = CGSizeMake(inputBoxSize.width, height);
            
        } else {
            _inputBgView.frame = CGRectMake(0, inputBgViewBottom - 40, XKAppWidth, 40);
            inputBox.height = 30;
        }
        
    }
    if (textView.text.length == 0) {
        placeholderLabel.hidden = NO;
    } else {
        placeholderLabel.hidden = YES;
    }
}

- (CGFloat)calculateCommentHeightWithText:(NSString *)text
{
    NSMutableAttributedString *commentStr = [XKRWUtil createAttributeStringWithString:text font:XKDefaultFontWithSize(14) color:colorSecondary_666666 lineSpacing:3 alignment:NSTextAlignmentLeft];
    
    CGSize commentSize = [commentStr boundingRectWithSize:CGSizeMake(inputBox.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return  commentSize.height;
}

#pragma mark keyboard notification

- (void)keyboardWillShow:(NSNotification *) notification {
    [self addGestureRecognizer:dropGesture];
    
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.hidden = NO;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.origin = CGPointMake(0, XKAppHeight - height - _inputBgView.height - 64);
    }];
    [UIView performWithoutAnimation:^{
        self.origin = CGPointMake(0, 0);
        _inputBgView.bottom = self.superview.height - height;
    }];
    
    typeof(self) __weak weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(inputBoxView:inHeight:willShowDuration:)]) {
        [_delegate inputBoxView:weakSelf inHeight:height + _inputBgView.height willShowDuration:animationDuration];
    }
}

- (void)keyboardWillHide:(NSNotification *) notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (_style == footer) {
    
        [UIView animateWithDuration:animationDuration animations:^{
            _inputBgView.bottom = XKAppHeight - 64;
        }];
        [UIView performWithoutAnimation:^{
            if ([inputBox.text isEqualToString:@""]) {
                inputBox.height = 30;
                _inputBgView.height = 40;
            }
            self.origin = CGPointMake(0, XKAppHeight - 64 - _inputBgView.height);
            _inputBgView.top = 0;
        }];
        
    } else {
        [UIView animateWithDuration:animationDuration animations:^{
            _inputBgView.top = XKAppHeight - 64;
        }];
        [UIView performWithoutAnimation:^{
            if ([inputBox.text isEqualToString:@""]) {
                inputBox.height = 30;
                _inputBgView.height = 40;
            }
            self.top = self.superview.height;
            _inputBgView.top = 0;
        }];
    }
    

    typeof(self) __weak weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(inputBoxView:WillHideDuration:inHeigh:)]) {
        [_delegate inputBoxView:weakSelf WillHideDuration:animationDuration inHeigh:height];
    }

    [self removeGestureRecognizer:dropGesture];
}

- (void)recruitSelf {
    CGFloat width = inputBox.size.width;
    _inputBgView.frame = CGRectMake(0, 0, XKAppWidth, 40);
    inputBox.size = CGSizeMake(width, 30);
}

#pragma mark Action
- (void)inputBoxEndEdit {
    [inputBox resignFirstResponder];
}

- (void)sendMessage {
    typeof(self) __weak weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(inputBoxView:sendMessage:)]) {
        [_delegate inputBoxView:weakSelf sendMessage:inputBox.text];
    }
    inputBox.text = nil;
    [inputBox resignFirstResponder];
    placeholderLabel.hidden = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
