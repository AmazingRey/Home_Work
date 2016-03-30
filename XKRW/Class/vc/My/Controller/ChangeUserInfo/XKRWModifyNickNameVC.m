//
//  XKRWModifyNickNameViewController.m
//  XKRW
//
//  Created by Leng on 14-4-2.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWModifyNickNameVC.h"
#import "XKRWNaviRightBar.h"
#import "XKRWUserService.h"
#import "XKRWCui.h"
// 昵称最大值 10
/*
 昵称修改
 功能：  
    1、昵称修改
    2、昵称正确性检查
    3、保存昵称
 */
@interface XKRWModifyNickNameVC ()<UITextFieldDelegate>
{
    NSString * nickNameTemp;
    NSString * oldNicekNameTemp;
}
@property(nonatomic,retain)XKRWNaviRightBar *rightBar;
@end

@implementation XKRWModifyNickNameVC



- (void)viewDidLoad
{

    self.forbidAutoAddCloseButton = YES;
    [super viewDidLoad];
    if(!_notShowBackButton){
        [self addNaviBarBackButton];
    }else{
        self.navigationItem.hidesBackButton = YES;
       
    }
    self.title = @"朋友们称呼你为";
    
    
    self.view.backgroundColor = XKBGDefaultColor;
    
    UIView * viewVG = [[UIView alloc] initWithFrame:CGRectMake(0, 15, XKAppWidth, 44)];
    viewVG.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
    [self.view addSubview:viewVG];
    
    UIView * viewSepTop = [[UIView alloc] initWithFrame:CGRectMake(0, 15, XKAppWidth, .5)];
    viewSepTop.backgroundColor = [UIColor colorFromHexString:@"#cccccc"];
    [self.view addSubview:viewSepTop];
    UIView * viewSepBottm = [[UIView alloc] initWithFrame:CGRectMake(0, 15.5+44, XKAppWidth, .5)];
    viewSepBottm.backgroundColor = [UIColor colorFromHexString:@"#cccccc"];
    [self.view addSubview:viewSepBottm];
    
    UITextField* textField= [[UITextField alloc] initWithFrame:CGRectMake(25, 0, XKAppWidth-50, 44)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.textColor = [UIColor colorFromHexString:@"#333333"];
    textField.placeholder = @"设置昵称";
    textField.tag = 332211;
    textField.font = [UIFont systemFontOfSize:15];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self addNaviBarRightButtonWithText:@"保存" action:@selector(saveNickName)];
    
    nickNameTemp =[[XKRWUserService sharedService] getUserNickName];
    if (!(nickNameTemp && nickNameTemp.length)) {
        _rightBar.userInteractionEnabled = NO;
    }
    textField.text = nickNameTemp;
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    [textField becomeFirstResponder];
    [viewVG addSubview:textField];
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick event:@"in_nickname"];
    
}

-(void) saveNickName {
    
    [self.view endEditing:YES];

    if ((!nickNameTemp) || (!(nickNameTemp.length > 0))) {
        
        [XKRWCui showInformationHudWithText:@"昵称不能为空"];
        [self textFieldBecomFirstResponse];
        return;
    }
    //    }
    NSError *error = NULL;
    NSRegularExpression *regexObj = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5_a-zA-Z0-9]*$"
                                                                              options:NSRegularExpressionAnchorsMatchLines
                                                                                error:&error];
    NSUInteger matchCount = [regexObj numberOfMatchesInString:nickNameTemp
                                                      options:0
                                                        range:NSMakeRange(0, nickNameTemp.length)];
    
    
    if (!matchCount) {
        [XKRWCui showInformationHudWithText:@"注意" andDetail:@"昵称中只能含有汉字、字母、数字或下划线"];
        [self textFieldBecomFirstResponse];
        return;
    }

    if (nickNameTemp.length > 10) {
        [XKRWCui showInformationHudWithText:@"昵称最大长度为10"];
        [self textFieldBecomFirstResponse];
        return;
    }

    oldNicekNameTemp = [[XKRWUserService sharedService] getUserNickName];
    [self uploadWithTask:^{
        [[XKRWUserService sharedService] changeUserInfo:nickNameTemp WithType:@"nickname"];
        
    }];
}
- (void) textFieldBecomFirstResponse{
    [[self.view viewWithTag:332211] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:2.0];
}
#pragma mark 返回值处理
-(void)didUpload{
    [[XKRWUserService sharedService] setUserNickName:nickNameTemp];
    [[XKRWUserService sharedService] setUserNickNameIsEnable:YES];
    [[XKRWUserService sharedService] saveUserInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finallyJobWhenUploadFail {
    [[XKRWUserService sharedService] setUserNickName:oldNicekNameTemp];
}

#pragma mark textFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    self.rightBar.userInteractionEnabled = YES;
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    XKLog(@"%@",textField.text);
//    if (textField.text.length > 10) {
    
    nickNameTemp = textField.text;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
