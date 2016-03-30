//
//  XKRWConsultantVC.m
//  XKRW
//
//  Created by yaowq on 14-3-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWConsultantVC.h"
#import "XKRWCui.h"
#import "WXApi.h"
#import <CoreGraphics/CoreGraphics.h>

@interface XKRWConsultantVC ()
{
    
}
@property (strong, nonatomic)  UILabel *weixinLabel;
@property (strong, nonatomic)  UIView *remindView;

@end

@implementation XKRWConsultantVC

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
    [self addNaviBarBackButton];
    self.title = @"咨询私人顾问";
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, (XKAppWidth-35), 60)];
    if (XKAppWidth == 375) {
        [imageV setImage:[UIImage imageNamed:@"counselorBig_750"]];
        
        
    }else
    {
        [imageV setImage:[UIImage imageNamed:@"counselorBig"]];
    }
    
    imageV.frame = CGRectMake(15, 15, imageV.image.size.width, imageV.image.size.height);
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 94, XKAppWidth, 20)];
    [oneLabel setText:@"瘦瘦微信号"];
    [oneLabel setTextColor:[UIColor colorFromHexString:@"#1a1a1a"]];
    [oneLabel setFont:[UIFont systemFontOfSize:16]];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    
    self.weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, XKAppWidth, 20)];
    [_weixinLabel setText:@"shoushou20121230"];
    [_weixinLabel setTextAlignment:NSTextAlignmentCenter];
    [_weixinLabel setTextColor:XKMainToneColor_00b4b4];
    [_weixinLabel setFont:[UIFont systemFontOfSize:13]];
    
    _focusButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 160, 100, 32)];
    _focusButton.backgroundColor = [UIColor whiteColor];
    _focusButton.layer.borderWidth = 1.0;
    _focusButton.layer.borderColor = XKMainSchemeColor.CGColor;
    _focusButton.layer.cornerRadius = 3;
    [_focusButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [_focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_focusButton setTitle:@"复制微信号" forState:UIControlStateNormal];
    [_focusButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    [_focusButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [_focusButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_focusButton addTarget:self action:@selector(copyMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"servicePageArrow"]];
    arrow.frame = CGRectMake((XKAppWidth-30)/2, 160+5, 30, 20);
    
    
    
    _wechatButton = [[UIButton alloc] initWithFrame:CGRectMake(XKAppWidth - 30 - 100, 160, 100, 32)];
    _wechatButton.backgroundColor = XK_LINEAR_ICON_COLOR;
    _wechatButton.layer.cornerRadius = 3;
    _wechatButton.layer.borderWidth = 1.0;
    [_wechatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wechatButton setTitle:@"关注有惊喜" forState:UIControlStateNormal];
    [_wechatButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_wechatButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [_wechatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_wechatButton addTarget:self action:@selector(wxBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:imageV];
    [self.view addSubview:oneLabel];
    [self.view addSubview:arrow];
    [self.view addSubview:_weixinLabel];
    [self.view addSubview:_focusButton];
    [self.view addSubview:_wechatButton];
    self.view.backgroundColor = colorSecondary_f4f4f4;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick event:@"in_Message"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)copyMethod {

    if (_type == 1) {
        [MobClick event:@"clk_PlanBrkWcCo"];
    }else if (_type ==2)
    {
        [MobClick event:@"clk_PlanLunWcCo"];
    }else if (_type ==3)
    {
        [MobClick event:@"clk_PlanDinWcCo"];
    }else if (_type ==4)
    {
        [MobClick event:@"clk_PlanExtWcCo"];
    }else if (_type == 0)
    {
        [MobClick event:@"clk_PlanSptWcCo"];
    }
    
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"shoushou20121230";
    
    [XKRWCui showInformationHudWithText:@"复制成功"];
    
    _focusButton.userInteractionEnabled = NO;
    _wechatButton.userInteractionEnabled = YES;
    _focusButton.layer.backgroundColor = XKClearColor.CGColor;
    _focusButton.backgroundColor = XK_LINEAR_ICON_COLOR;
    _wechatButton.backgroundColor = [UIColor whiteColor];
    [_wechatButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    _wechatButton.layer.borderColor = XKMainSchemeColor.CGColor;
}


- (void)wxBtnClicked:(id)sender
{
    if (_type == 1) {
        [MobClick event:@"clk_PlanBrkWc"];
    }else if (_type ==2)
    {
        [MobClick event:@"clk_PlanLunWc"];
    }else if (_type ==3)
    {
        [MobClick event:@"clk_PlanDinWc"];
    }else if (_type ==4)
    {
        [MobClick event:@"clk_PlanExtWc"];
    }else if (_type == 0)
    {
        [MobClick event:@"clk_PlanSptWc"];
    }
    
    if ([WXApi isWXAppInstalled]) {
        NSString *str = [NSString stringWithFormat:@"weixin://qr/%@",@"EHTy-b7Eg4d8h6_enye0"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Nil message:@"只有安装了微信客户端,才能互动哦" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
    
    [MobClick event:@"clk_FollowWeChat"];
}

- (void)clickWeixinBtn:(id)sender
{
    [MobClick event:@"Click_wechat"];
#pragma --mark  微信
    
    if ([WXApi isWXAppInstalled]) {
        NSString *str = [NSString stringWithFormat:@"weixin://qr/%@",@"EHTy-b7Eg4d8h6_enye0"];
        //@"weixin://qr/EHTy-b7Eg4d8h6_enye0";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Nil message:@"请安装微信客户端,才能互动" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }
    
    
}

- (void)dealloc
{
    XKLog(@"内存释放");
}



@end
