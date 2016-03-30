//
//  XKRWChangeManifesto.m
//  XKRW
//
//  Created by XiKang on 14-6-23.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWChangeManifesto.h"
#import "XKRWNaviRightBar.h"
#import "XKRWUserService.h"
#import "XKSilentDispatcher.h"
#import "XKRWCui.h"
#import "XKRWUtil.h"

/*
 修改宣言
 功能：  1、宣言修改
        2、宣言正确性检查
        3、保存宣言
 */
@interface XKRWChangeManifesto ()<UITextFieldDelegate>
{
    NSString * nickNameTemp;
}
@property (nonatomic, strong)    UITextField* textField;

@property (nonatomic,strong) XKRWNaviRightBar * rightBar;

@end
@implementation XKRWChangeManifesto

//视图内容初始化
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"设置减肥宣言";
    
    [self addNaviBarBackButton];
    self.view.backgroundColor = XKBGDefaultColor;
    
    UIView * viewVG = [[UIView alloc] initWithFrame:CGRectMake(0, 15, XKAppWidth, 44)];
    viewVG.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
    [self.view addSubview:viewVG];
    
    UIView * viewSepTop = [[UIView alloc] initWithFrame:CGRectMake(0, 15, XKAppWidth, .5)];
    viewSepTop.backgroundColor = [UIColor colorFromHexString:@"#cccccc"];
    [self.view addSubview:viewSepTop];
    UIView * viewSepBottm = [[UIView alloc] initWithFrame:CGRectMake(0, 15+44.5, XKAppWidth, .5)];
    viewSepBottm.backgroundColor = [UIColor colorFromHexString:@"#cccccc"];
    [self.view addSubview:viewSepBottm];
    
    self.textField= [[UITextField alloc] initWithFrame:CGRectMake(25, 0, (XKAppWidth-50), 44)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.textColor = [UIColor colorFromHexString:@"#333333"];
    _textField.placeholder = @"添加减肥宣言";
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self addNaviBarRightButton];
    
    nickNameTemp = [[XKRWUserService sharedService] getUserManifesto];

    _textField.text = nickNameTemp;
    _textField.delegate = self;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    [_textField becomeFirstResponder];
    [viewVG addSubview:_textField];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick event:@"in_manifesto"];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}
- (void) addNaviBarRightButton
{
    self.rightBar = [[XKRWNaviRightBar alloc] initWithFrameAndTitle:CGRectMake(0.f, 0.f, 44.f, 44.f) title:@"保存"];
    [_rightBar addTarget:self action:@selector(saveNickManifesto) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBar];
    
}

#pragma mark 返回值处理

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    if([taskID isEqualToString:@"changeManifest"]){
        [XKRWCui showInformationHudWithText:@"修改成功"];
        [[XKRWUserService sharedService] setManifesto:_textField.text];
        [[XKRWUserService sharedService] saveUserInfo];
    }
    [super performSelector:@selector(popView) withObject:nil afterDelay:.2];
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID{
    [super handleDownloadProblem:problem withTaskID:taskID];
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication{
    return YES;
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveNickManifesto{
    [_textField endEditing:YES];

    if (![XKRWUtil isNetWorkAvailable]) {

        [XKRWCui showInformationHudWithText:@"无网络无法修改宣言哦"];
        [_textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:2.0];

        return;
    }
    
    if (_textField.text.length>18) {
        [self showAlert];
        return;
    }

    
    [self downloadWithTaskID:@"changeManifest" outputTask:^id{
         return    [[XKRWUserService sharedService] changeUserInfo:_textField.text WithType:@"manifesto"];
    }];
    
    
}

#pragma mark 输出框代理方法


-(void)showAlert{
    
    [_textField endEditing:YES];
    
    NSString * string = nil;
    
    string = @"最多只能18字哦~";

    [XKRWCui showInformationHudWithText:string];
    
    [_textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:2.0];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 18) {
        [self showAlert];
    }
}

@end
