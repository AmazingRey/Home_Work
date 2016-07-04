//
//  XKRWPrivacyPassWordVC.m
//  XKRW
//
//  Created by ss on 16/6/12.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPrivacyPassWordVC.h"
#import "XKRWCui.h"
#import <AudioToolbox/AudioServices.h>
#import "XKRWUserService.h"
#import "XKRWAppDelegate.h"
#import "XKRWNavigationController.h"
#import "XKRWTabbarVC.h"
#import "XKRWCui.h"

#define SET_PRIVACYPASSWORD_FIRSTTIME @"setPrivacyPasswordFirstTime"
#define SET_PRIVACYPASSWORD_SUCCESS   @"setPrivacyPasswordSuccess"
#define DeleayTime                    .5

@interface XKRWPrivacyPassWordVC ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView        *imageOne;
@property (strong, nonatomic) IBOutlet UIImageView        *imageTwo;
@property (strong, nonatomic) IBOutlet UIImageView        *imageThree;
@property (strong, nonatomic) IBOutlet UIImageView        *imageFour;
@property (strong, nonatomic) IBOutlet UITextField        *textField;
@property (strong, nonatomic) IBOutlet UILabel            *labelVerify;
@property (strong, nonatomic) IBOutlet UIButton           *forgetPasswordBtn;
@property (strong, nonatomic) IBOutlet UIButton           *configueLaterBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topImageTopConstraint;

- (IBAction)forgetPasswordAction:(id)sender;
- (IBAction)configueLaterAction:(id)sender;

@end

@implementation XKRWPrivacyPassWordVC{
    NSArray *imageViewArray;
    NSString *tmpPwd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _configueLaterBtn.hidden = true;
    if (_privacyType == configue) {
        self.title = @"设置隐私密码";
        if (!self.navigationController) {
            _configueLaterBtn.hidden = false;
            tmpPwd = @"";
        }
        _forgetPasswordBtn.hidden = true;
        _forgetPasswordBtn.userInteractionEnabled = false;
        _labelVerify.text = @"请设置隐私密码";
    }else if (_privacyType == terminate) {
        self.title = @"关闭隐私密码";
        _forgetPasswordBtn.hidden = true;
        _forgetPasswordBtn.userInteractionEnabled = false;
        _labelVerify.text = @"输入密码确认关闭";
    }else if (_privacyType == verify){
        _configueLaterBtn.hidden = true;
        _labelVerify.text = @"验证隐私密码";
        _forgetPasswordBtn.hidden = false;
        _forgetPasswordBtn.userInteractionEnabled = true;
    }
    imageViewArray = @[_imageOne, _imageTwo, _imageThree, _imageFour];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerNotification:true];
    [self.textField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self registerNotification:false];
}

- (void)registerNotification:(BOOL)flag{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPrivacyPasswordFirstTime:) name:SET_PRIVACYPASSWORD_FIRSTTIME object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPrivacyPasswordSuccess:) name:SET_PRIVACYPASSWORD_SUCCESS object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SET_PRIVACYPASSWORD_FIRSTTIME object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SET_PRIVACYPASSWORD_SUCCESS object:nil];
    }
}

- (void)setPrivacyType:(PrivacyPasswordType)privacyType{
    if (_privacyType != privacyType) {
        _privacyType = privacyType;
    }
    if (_privacyType == configue) {
        self.title = @"设置隐私密码";
        if (!self.navigationController) {
            _configueLaterBtn.hidden = false;
            tmpPwd = @"";
        }
        _forgetPasswordBtn.hidden = true;
        _forgetPasswordBtn.userInteractionEnabled = false;
        _labelVerify.text = @"请设置隐私密码";
    }else if (_privacyType == terminate) {
        self.title = @"关闭隐私密码";
        _forgetPasswordBtn.hidden = true;
        _forgetPasswordBtn.userInteractionEnabled = false;
        _labelVerify.text = @"输入密码确认关闭";
    }else if (_privacyType == verify){
        _configueLaterBtn.hidden = true;
        _labelVerify.text = @"验证隐私密码";
        _forgetPasswordBtn.hidden = false;
        _forgetPasswordBtn.userInteractionEnabled = true;
    }
}

- (void)setIsVerified:(BOOL)isVerified{
    if (_isVerified != isVerified) {
        _isVerified = isVerified;
    }
    self.textField.text = @"";
    for (UIImageView  *imgView in imageViewArray) {
        imgView.image = [UIImage new];
    }
}

- (NSString *)passWord{
    if (!_passWord) {
        _passWord = [XKRWUserDefaultService getPrivacyPassword];
    }
    return _passWord;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    [self makeEachImageViewWhenTextInput:range string:string];
    if (_privacyType == configue) {
        if (toBeString.length == imageViewArray.count) {
           return [self savePrivacyPassword:toBeString];
        }
    }else if (_privacyType == terminate ){
        if (toBeString.length == imageViewArray.count) {
            return [self terminatePrivacyPassword:toBeString];
        }
    }else{
        if (toBeString.length == self.passWord.length) {
            if ([toBeString isEqualToString:self.passWord]) {
                _labelVerify.text = @"验证成功!";
                if ([self.delegate respondsToSelector:@selector(verifySucceed)]) {
                    [self.delegate verifySucceed];
                }
                [textField resignFirstResponder];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DeleayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                return true;
            }else{
                [self cleanAllInputPassword];
                _labelVerify.text = @"密码错误，请重新输入";
                return false;
            }
        }
    }
    
    return true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.passWord && textField.text.length == self.passWord.length) {
        return false;
    }
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.view layoutIfNeeded];
    if (XKAppHeight <= 480) {
        if (!self.navigationController) {
            _topImageTopConstraint.constant = -20;
        }else{
            _topImageTopConstraint.constant = -45;
        }
    }else if(XKAppHeight == 568){
        _topImageTopConstraint.constant = 50;
    }else if (XKAppHeight == 667){
        _topImageTopConstraint.constant = 120;
    }else{
        _topImageTopConstraint.constant = 120;
    }
    _topImageTopConstraint.constant = _topImageTopConstraint.constant*XKRWScaleHeight;
    [UIView animateWithDuration:.5
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view layoutIfNeeded];
    if (XKAppHeight <= 480) {
        _topImageTopConstraint.constant = 225;
    }else if(XKAppHeight == 568){
        _topImageTopConstraint.constant = 110;
    }else if (XKAppHeight == 667){
        _topImageTopConstraint.constant = 120;
    }else{
        _topImageTopConstraint.constant = 120;
    }
    _topImageTopConstraint.constant = _topImageTopConstraint.constant*XKRWScaleHeight;
    [UIView animateWithDuration:.5
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)makeEachImageViewWhenTextInput:(NSRange)range string:(NSString *)string{
    UIImageView *imageView = [imageViewArray objectAtIndex:range.location];
    if ([string isEqualToString:@""]) {
        imageView.image = [UIImage new];
    }else{
        imageView.image = [UIImage imageNamed:@"circleGreen"];
    }
}

- (BOOL)terminatePrivacyPassword:(NSString *)password{
    if ([password isEqualToString:_passWord]) {
        _labelVerify.text = @"验证成功!";
        [XKRWUserDefaultService removePrivacyPassword];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DeleayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return true;
    }else{
        _labelVerify.text = @"密码错误，请重新输入";
        [self cleanAllInputPassword];
        return false;
    }
}

- (BOOL)savePrivacyPassword:(NSString *)password{
    if (!tmpPwd || [tmpPwd isEqualToString:@""]) {
        //第一次输入，cache
        _labelVerify.text = @"再次确认所设置的密码";
        _labelVerify.textColor = XK_TITLE_COLOR;
        tmpPwd = password;
        [[NSNotificationCenter defaultCenter] postNotificationName:SET_PRIVACYPASSWORD_FIRSTTIME object:nil];
        return true;
    }else if ([tmpPwd isEqualToString:password]){
        //两次一致，设置成功
        _labelVerify.text = @"设置成功";
        _labelVerify.textColor = XKMainSchemeColor;
        [XKRWUserDefaultService setForgetPrivacyPassword:false];
        [[NSNotificationCenter defaultCenter] postNotificationName:SET_PRIVACYPASSWORD_SUCCESS object:password];
        return true;
    }else{
        //两次输入不一致
        _labelVerify.text = @"两次输入的密码不同";
        _labelVerify.textColor = XKWarningColor;
        tmpPwd = @"";
        [self cleanAllInputPassword];
        return false;
    }
}

- (void)cleanAllInputPassword{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _textField.text = @"";
    for (UIImageView  *imgView in imageViewArray) {
        imgView.image = [UIImage new];
    }
}

- (void)setPrivacyPasswordFirstTime:(NSNotification *)notify{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DeleayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cleanAllInputPassword];
    });
}

- (void)setPrivacyPasswordSuccess:(NSNotification *)notify{
    NSString *pwd = (NSString *)notify.object;
    [self.textField resignFirstResponder];
    [XKRWUserDefaultService setPrivacyPassword:pwd];
    if ([self.delegate respondsToSelector:@selector(verifySucceed)]) {
        [self.delegate verifySucceed];
    }
    if (_privacyType == configue) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DeleayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.navigationController) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }
}

- (IBAction)forgetPasswordAction:(id)sender {
    [self.textField resignFirstResponder];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"忘记隐私密码，需重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"重新登录", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [XKRWCui showProgressHud];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [XKRWUserDefaultService setForgetPrivacyPassword:true];
        [XKRWUserDefaultService removePrivacyPassword];
        [self dismissViewControllerAnimated:true completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Exit" object:nil];
        [XKRWCui hideProgressHud];
    }else{
        [self.textField becomeFirstResponder];
    }
}

- (IBAction)configueLaterAction:(id)sender {
    [XKRWUserDefaultService setForgetPrivacyPassword:false];
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:nil];
}
@end