//
//  XKRWChangePWDViewController.m
//  XKRW
//
//  Created by Leng on 14-4-9.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWChangePWDViewController.h"
#import "XKRWUserService.h"
#import "XKRWCui.h"
#define pwdUseWebV 0
/*
    密码修改
 功能：
    1、验证密码正确性
    2、修改密码
    3、密码格式检验
 
 */
@interface XKRWChangePWDViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView * inputBackgroundView;

@property (nonatomic, strong) UITextField * pOld;
@property (nonatomic, strong) UITextField * pNew;
@property (nonatomic, strong) UITextField * pNewConfirm;
@end

@implementation XKRWChangePWDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    [self addNaviBarBackButton];
    
    self.view.backgroundColor = XKBGDefaultColor;
    
#if pwdUseWebV
    
    UIWebView * pwdView =[[UIWebView alloc] initWithFrame:self.view.bounds];
    [pwdView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://i.xikang.com/online/mobileusersystem/security/mobileresetpwd.html"]]];
    [self.view addSubview:pwdView];

#else
    self.inputBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 280, 45*3)];
    _inputBackgroundView.image = [UIImage imageNamed:@"input_register"];

    [self addNaviBarRightButtonWithText:@"保存" action:@selector(savePersonalInfo) withColor: XKMainToneColor_29ccb1];
    
    int xPox  = 70 + 25 + 15;
    
    UITextField * titleOld = [[UITextField alloc] initWithFrame:CGRectMake(25 , 30 + 2 , 70, 43)];
    titleOld.userInteractionEnabled = NO;
    titleOld.text = @"当前密码";
    titleOld.textColor = XK_TEXT_COLOR;
    UITextField * titleNew = [[UITextField alloc] initWithFrame:CGRectMake(25 , 30+45 + 1, 70, 43)];
    titleNew.userInteractionEnabled = NO;
    titleNew.text = @"新密码";
    titleNew.textColor = XK_TEXT_COLOR;
    UITextField * titleConfirm = [[UITextField alloc] initWithFrame:CGRectMake(25 , 30+45*2, 70, 43)];
    titleConfirm.userInteractionEnabled = NO;
    titleConfirm.text = @"确认密码";
    titleConfirm.textColor = XK_TEXT_COLOR;
    titleOld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
    titleNew.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
    titleConfirm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
    
    
    
    
    self.pOld = [[UITextField alloc] initWithFrame:CGRectMake(xPox, 30 + 2 , XKAppWidth-xPox, 43)];
    _pOld.delegate = self;
    self.pNew = [[UITextField alloc] initWithFrame:CGRectMake(xPox , 30+45 + 1, XKAppWidth-xPox, 43)];
    _pNew.delegate = self;
    self.pNewConfirm = [[UITextField alloc] initWithFrame:CGRectMake(xPox , 30+45*2, XKAppWidth-xPox, 43)];
    _pNewConfirm.delegate = self;
    
    
    _pOld.secureTextEntry = YES;
    _pNew.secureTextEntry = YES;
    _pNewConfirm.secureTextEntry = YES;
    
    _pOld.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pNew.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pNewConfirm.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    _pOld.placeholder = @"当前密码";
    _pNew.placeholder = @"输入新密码";
    _pNewConfirm.placeholder = @"再次输入新密码";
    
    _pOld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
    _pNew.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
    _pNewConfirm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
    
    [self.view addSubview:_inputBackgroundView];
    
    [self.view addSubview:titleOld];
    [self.view addSubview:titleNew];
    [self.view addSubview:titleConfirm];
    
    [self.view addSubview:_pOld];
    [self.view addSubview:_pNew];
    [self.view addSubview:_pNewConfirm];
#endif
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick event:@"in_passport changed"];

    _inputBackgroundView.frame = CGRectMake(0, 30, XKAppWidth, 135);
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    textField.secureTextEntry = NO;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    textField.secureTextEntry = YES;
}

-(void) canNotUse{
    
}

-(void) oldAlert{

    [XKRWCui showInformationHudWithText:@"请输入当前密码"];
    [_pOld performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:3];

}
-(void) newAlart{

    [XKRWCui showInformationHudWithText:@"请输入新密码"];
    [_pNew performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:3];

}
-(void) confirmAlart{

    [XKRWCui showInformationHudWithText:@"请再次输入新密码"];
    [_pNewConfirm performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:3];

}
-(void)savePersonalInfo{
    
    if (![XKRWUtil isNetWorkAvailable]) {
        [self.view endEditing:YES];
        [XKRWCui showInformationHudWithText:@"没有网络无法修改密码哦"];
    }
    
    [self.view endEditing:YES];

    if (!_pOld.text) {
        [self oldAlert];
        return;
    }
    if (!_pOld.text.length) {
        [self oldAlert];
        return;
    }
    
    if ((!_pNew.text) || (!_pNew.text.length)) {
        [self newAlart];
        return;
    }
    
    if ((!_pNewConfirm.text) || (!_pNewConfirm.text.length)) {
        
        [self confirmAlart];
        return;
    }
    
    //检查新密码的一致性
    if ([self checkThePWDSame]) {
        //相同
        
        if ([self checkTheLeng]) {
     
            [self uploadWithTask:^{
                [[XKRWUserService sharedService] uploadUserPWDWithOldP:_pOld.text andNP:_pNew.text];
            }];
            
        }else{
            
            [XKRWCui showInformationHudWithText:@"新密码 6 - 16 个字符"];
            
            [_pNew performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:3];
        }
        
        return;
    }
    
    [XKRWCui showInformationHudWithText:@"确认密码与新密码不一致"];
    [_pNew performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:3];
}

-(BOOL) checkThePWDSame{
    [self.view endEditing:YES];
    BOOL isSame = NO;
    
    if (_pNew.text && _pNew.text.length  && _pNewConfirm.text && _pNewConfirm.text.length) {
        if ([_pNew.text isEqualToString:_pNewConfirm.text]) {
            isSame = YES;
        }
    }
    
    return isSame;
}
-(BOOL) checkTheLeng{
    BOOL leng = NO;

    if ((_pNew.text.length > 5 ) && (_pNew.text.length < 17) && (_pNewConfirm.text.length > 5 ) && (_pNewConfirm.text.length < 17) ) {
        leng = YES;
    }
    return leng;
}

-(void)didUpload {
    XKLog(@"修改成功");
    
    self.pOld = nil;
    self.pNew = nil;
    self.pNewConfirm = nil;
    [XKRWCui showInformationHudWithText:@"密码修改成功"];
    
    [self performSelector:@selector(popView) withObject:Nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
