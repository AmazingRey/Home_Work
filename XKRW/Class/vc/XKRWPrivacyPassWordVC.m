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

#define SET_PRIVACYPASSWORD_FIRSTTIME @"setPrivacyPasswordFirstTime"
#define SET_PRIVACYPASSWORD_SUCCESS   @"setPrivacyPasswordSuccess"
#define DeleayTime                    .5

@interface XKRWPrivacyPassWordVC ()
@property (strong, nonatomic) IBOutlet UIImageView *imageOne;
@property (strong, nonatomic) IBOutlet UIImageView *imageTwo;
@property (strong, nonatomic) IBOutlet UIImageView *imageThree;
@property (strong, nonatomic) IBOutlet UIImageView *imageFour;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel     *labelVerify;
@property (strong, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

- (IBAction)forgetPasswordAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *configueLaterBtn;
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
        }
        _forgetPasswordBtn.hidden = true;
        _forgetPasswordBtn.userInteractionEnabled = false;
        _labelVerify.text = @"请设置隐私密码";
    }else if (_privacyType == terminate) {
        self.title = @"关闭隐私密码";
        _forgetPasswordBtn.hidden = true;
        _forgetPasswordBtn.userInteractionEnabled = false;
        _labelVerify.text = @"输入密码确认关闭";
    }
    imageViewArray = @[_imageOne, _imageTwo, _imageThree, _imageFour];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
    [self registerNotification:true];
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
        }
        _forgetPasswordBtn.hidden = true;
        _forgetPasswordBtn.userInteractionEnabled = false;
        _labelVerify.text = @"请设置隐私密码";
    }else if (_privacyType == terminate) {
        self.title = @"关闭隐私密码";
        _forgetPasswordBtn.hidden = true;
        _forgetPasswordBtn.userInteractionEnabled = false;
        _labelVerify.text = @"输入密码确认关闭";
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
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return true;
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
//        [_textField resignFirstResponder];
        [XKRWUserDefaultService removePrivacyPassword];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DeleayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return true;
    }else{
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
//    XKRWAppDelegate *appdelegate = (XKRWAppDelegate *)[[UIApplication sharedApplication] delegate];
    [XKRWUserDefaultService setForgetPrivacyPassword:true];
    [XKRWUserDefaultService removePrivacyPassword];
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Exit" object:nil];
//    XKRWNavigationController *nav = (XKRWNavigationController *)appdelegate.window.rootViewController;
//    NSArray *arr = nav.viewControllers;
//    for (UIViewController *vc in arr) {
//        if ([vc isKindOfClass:[XKRWTabbarVC class]]) {
//            XKRWTabbarVC *tabbarVC = (XKRWTabbarVC *)vc;
//            [tabbarVC exitTheAccount];
//        }
//    }
//    appdelegate.window.rootViewController.tabBarController.selectedViewController
//    if ([[XKRWUserService sharedService] checkSyncData]) {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"你还有数据未同步" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消同步并退出" otherButtonTitles:@"同步", nil];
//        [actionSheet showInView:self.view];
//    }else{
//        [[NSUserDefaults standardUserDefaults] setObject:nil forKey: @"DailyIntakeSize"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//
//    }
}
- (IBAction)configueLaterAction:(id)sender {
    [XKRWUserDefaultService setForgetPrivacyPassword:false];
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:nil];
}
@end