//
//  XKRWiSlimExchangeVC.m
//  XKRW
//
//  Created by XiKang on 15-1-19.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWiSlimExchangeVC.h"
#import "XKRWHowToExchangeVC.h"

#import "XKRWRecordService4_0.h"
#import "XKRWServerPageService.h"
#import "XKRWiSlimAssessmentVC.h"

#import "Tips.h"
#import "XKRWPaymentResultVC.h"

@interface XKRWiSlimExchangeVC () <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *attendButton;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet UITextField *exchangeCodeTextField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewYPointConstraint;

- (IBAction)clickAttendButton:(id)sender;
- (IBAction)clickQuestionButton:(id)sender;
- (IBAction)clickExchangeButton:(id)sender;
- (IBAction)clickHowToGetCodeButton:(id)sender;

@end

@implementation XKRWiSlimExchangeVC
{
    CGFloat _keyboardHeight;
}
#pragma mark - System's functions

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"免费兑换";
    
    [self initSubviews];
    [MobClick event:@"in_iSlimPayFree"];
    _keyboardHeight = 216.f;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // Insert the code...
    
    [self initData];
}
#pragma mark - initialize

- (void)initSubviews {

    self.attendButton.layer.cornerRadius = 4.f;
    self.exchangeButton.layer.cornerRadius = 1.5f;
    self.exchangeButton.layer.borderColor = XKMainSchemeColor.CGColor;;
    self.exchangeButton.layer.borderWidth = 1.f;
    [self.exchangeButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [self.exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.exchangeCodeTextField.layer.borderColor = [UIColor clearColor].CGColor;
    self.exchangeCodeTextField.layer.borderWidth = 1.f;
    self.exchangeCodeTextField.layer.cornerRadius = 2.5f;
    self.exchangeCodeTextField.layer.masksToBounds = YES;
    
    self.exchangeCodeTextField.delegate = self;
    self.exchangeCodeTextField.returnKeyType = UIReturnKeyDone;
    
    [self addNaviBarBackButton];
}

- (void)initData {
    
    [self.attendButton setBackgroundColor:XK_LINEAR_ICON_COLOR];
    [self.attendButton setTitle:@"加载中..." forState:UIControlStateNormal];
    self.attendButton.enabled = NO;
    
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"获取信息需要网络支持~请检查网络设置"];
        
        NSInteger days = [[XKRWServerPageService sharedService] getExchangeRestDays];
        
        if (days == -1) {
            
            self.attendButton.enabled = YES;
            [self.attendButton setBackgroundColor:XKMainSchemeColor];
            [self.attendButton setTitle:@"我要参加" forState:UIControlStateNormal];
            
        } else {
            
            [self.attendButton setTitle:[NSString stringWithFormat:@"兑换(剩余%ld天)", (long)days] forState:UIControlStateNormal];
        }
        
    } else {
        [self downloadWithTaskID:@"getRestDays" outputTask:^id{
            
            return [[XKRWServerPageService sharedService] getFreeExchangeRestDays];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Click actions

- (IBAction)clickAttendButton:(id)sender {
    
    [self.attendButton setBackgroundColor:XK_LINEAR_ICON_COLOR];
    [self.attendButton setTitle:@"加载中..." forState:UIControlStateNormal];
    self.attendButton.enabled = NO;
    
    if ([[XKRWServerPageService sharedService] getExchangeRestDays] != -1) {
        
        [self downloadWithTaskID:@"exchange" outputTask:^id{
            return @([[XKRWServerPageService sharedService] exchangeiSlim]);
        }];
    } else {
        
        [MobClick event:@"in_iSlimPayFree1"];
        [self downloadWithTaskID:@"join" outputTask:^id{
            return @([[XKRWServerPageService sharedService] participateFreeExchange]);
        }];
    }
}

- (IBAction)clickQuestionButton:(id)sender {
    
    Tips *tips = [[Tips alloc] initWithOrigin:CGPointMake(15.f, 112 + NAVIGATIONBAR_HEIGHT)
                                      andText:@"每日记录任意一项记录，累计记录60天。只有当天记录才算数，补记无效哦！"];
    UIButton *button = (UIButton *)sender;
    [tips setArrowHorizontalSpace:button.frame.origin.x + button.frame.size.width /2];
    [tips addToWindow];
}

- (IBAction)clickExchangeButton:(id)sender {
    
    if (_exchangeCodeTextField.text && _exchangeCodeTextField.text.length) {
        
        _exchangeButton.enabled = NO;
        [UIView animateWithDuration:0.15 animations:^{
            
            _exchangeButton.backgroundColor = XK_LINEAR_ICON_COLOR;
        }];
        [self downloadWithTaskID:@"uploadExchangeCode" outputTask:^id{
            
            return [[XKRWServerPageService sharedService] uploadExchangeCode:_exchangeCodeTextField.text];
        }];
        
    } else {
        
        [XKRWCui showInformationHudWithText:@"请输入兑换码"];
    }
    [_exchangeCodeTextField resignFirstResponder];
}

- (IBAction)clickHowToGetCodeButton:(id)sender {
    
    XKRWHowToExchangeVC *vc = [[XKRWHowToExchangeVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Networking

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication {
    return YES;
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    if ([taskID isEqualToString:@"uploadExchangeCode"]) {
        
        _exchangeButton.enabled = YES;
        [UIView animateWithDuration:0.15 animations:^{
            
            _exchangeButton.backgroundColor = XKMainSchemeColor;
        }];
        
        NSDictionary *data = result;
        
        if ([data[@"flag"] intValue]) {
            
            [[[UIAlertView alloc] initWithTitle:@"兑换成功！评测次数+1，现在就开始评估么？"
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:@"待会"
                              otherButtonTitles:@"好啊", nil] show];
        } else {
            
            [XKRWCui showInformationHudWithText:data[@"msg"]];
        }
    } else if ([taskID isEqualToString:@"getRestDays"]) {
        
        if ([result integerValue] == -1) {
            
            self.attendButton.enabled = YES;
            [UIView animateWithDuration:0.15 animations:^{
                [self.attendButton setBackgroundColor:XKMainSchemeColor];
                [self.attendButton setTitle:@"我要参加" forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                
            }];
            
        } else {
            /*
             *  保存剩余天数
             */
            [[XKRWServerPageService sharedService] saveExchangeRestDays:[result integerValue]];
            
            if ([result integerValue] == 0) {
                
                self.attendButton.enabled = YES;
                
                [UIView animateWithDuration:0.15 animations:^{
                    self.attendButton.titleLabel.alpha = 0.f;
                    [self.attendButton setBackgroundColor:XKMainSchemeColor];
                    
                } completion:^(BOOL finished) {
                    [self.attendButton setTitle:@"马上兑换" forState:UIControlStateNormal];
                    if (finished) {
                        [UIView animateWithDuration:0.15 animations:^{
                            self.attendButton.titleLabel.alpha = 1.f;
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                }];

            } else {
                
                self.attendButton.enabled = NO;
                
                if (IOS_7_OR_EARLY) {
                    [self.attendButton setTitle:[NSString stringWithFormat:@"兑换(剩余%ld天)", (long)[result integerValue]] forState:UIControlStateDisabled];
                    self.attendButton.backgroundColor = XK_ASSIST_LINE_COLOR;
                } else {
                    
                    [UIView animateWithDuration:0.15 animations:^{
                        self.attendButton.backgroundColor = XK_ASSIST_LINE_COLOR;
                        self.attendButton.titleLabel.alpha = 0.f;
                        
                    } completion:^(BOOL finished) {
                        [self.attendButton setTitle:[NSString stringWithFormat:@"兑换(剩余%ld天)", (long)[result integerValue]] forState:UIControlStateDisabled];
                        if (finished) {
                            [UIView animateWithDuration:0.15 animations:^{
                                self.attendButton.titleLabel.alpha = 1.f;
                            } completion:^(BOOL finished) {
                                
                            }];
                        }
                    }];
                }
            }
        }
    } else if ([taskID isEqualToString:@"exchange"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"兑换成功！可评估次数+1次。是否现在去测评？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"待会"
                                              otherButtonTitles:@"好啊", nil];
        alert.tag = 3;
        [alert show];
        [[XKRWServerPageService sharedService] deleteExchangeRestDays];
        
        [self initData];
        
    } else if ([taskID isEqualToString:@"join"]) {
        
        [[XKRWServerPageService sharedService] saveExchangeRestDays:60];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"参与成功！开始计算天数...请在达到目标后回到本页面兑换。"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
    }
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    
    [super handleDownloadProblem:problem withTaskID:taskID];
    
    if ([taskID isEqualToString:@"getRestDays"]) {
        
        [XKRWCui showInformationHudWithText:@"获取信息失败"];
        
        NSInteger days = [[XKRWServerPageService sharedService] getExchangeRestDays];
        
        if (days == -1) {
            
            self.attendButton.enabled = YES;
            [UIView animateWithDuration:0.15 animations:^{
                [self.attendButton setBackgroundColor:XKMainSchemeColor];
                [self.attendButton setTitle:@"我要参加" forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                
            }];
            
        } else {
            
            [UIView animateWithDuration:0.15 animations:^{
                self.attendButton.titleLabel.alpha = 0.f;
            } completion:^(BOOL finished) {
                [self.attendButton setTitle:[NSString stringWithFormat:@"兑换(剩余%ld天)", (long)days] forState:UIControlStateNormal];
                if (finished) {
                    [UIView animateWithDuration:0.15 animations:^{
                        self.attendButton.titleLabel.alpha = 1.f;
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }];
        }
    } else if ([taskID isEqualToString:@"exchange"]) {
        
        [XKRWCui showInformationHudWithText:@"兑换失败，请检查网络并重试"];
        
    } else if ([taskID isEqualToString:@"join"]) {
        
        [XKRWCui showInformationHudWithText:@"参加失败，请检查网络并重试"];
        
    } else if ([taskID isEqualToString:@"uploadExchangeCode"]) {
        
        [XKRWCui showInformationHudWithText:@"兑换失败"];
    }
}

#pragma mark - UITextField's delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    _contentViewYPointConstraint.constant = 0.f;
    
    [UIView animateWithDuration:1.f animations:^{
        [_contentView setY:0];
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self clickExchangeButton:nil];
    return YES;
}

#pragma mark - UIAlertView's delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 2) {
        
        
    } else if (alertView.tag == 3) {
        
        [self.attendButton setTitle:@"我要参加" forState:UIControlStateNormal];
        
        if (buttonIndex) {
            
            XKRWiSlimAssessmentVC *vc = [[XKRWiSlimAssessmentVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        
        if (buttonIndex) {
            
            XKRWiSlimAssessmentVC *vc = [[XKRWiSlimAssessmentVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - Other functions

- (void)keyboardWillShow:(NSNotification *)notification {
    
    _keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat navigationBarHeight =  self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (317 + _keyboardHeight > XKAppHeight - navigationBarHeight - statusBarHeight) {
        
        _contentViewYPointConstraint.constant = XKAppHeight - navigationBarHeight - statusBarHeight - (317 + _keyboardHeight);
        [UIView animateWithDuration:1.f animations:^{
            
            [_contentView setY:XKAppHeight - navigationBarHeight - statusBarHeight - (317 + _keyboardHeight)];
        } completion:^(BOOL finished) {
            
        }];
    }
}
@end
