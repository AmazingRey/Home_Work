//
//  XKRWAttentionWechat.m
//  XKRW
//
//  Created by 忘、 on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWAttentionWechatVC.h"

#import "WXApi.h"
#import "XKRWServerPageService.h"


@interface XKRWAttentionWechatVC ()
{
 
    UIImageView * imagev;
    UIButton *_focusButton;
    UIButton *_wechatButton;
    BOOL _isEnableCopyButton;
    UIImageView *redDotView;
    BOOL _isShowRedDot;
    
    BOOL _isShowiSlim;
    
    UILabel *wechatLabel;
    UILabel *warningLabel;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *actionView;

@end

@implementation XKRWAttentionWechatVC




- (void)viewDidLoad {
    [super viewDidLoad];
    _focusButton.userInteractionEnabled = YES;
    _wechatButton.userInteractionEnabled = NO;
    _focusButton.backgroundColor = XKMainSchemeColor;
    _wechatButton.backgroundColor = XK_LINEAR_ICON_COLOR;
    _isEnableCopyButton = YES;
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([[XKRWServerPageService sharedService] needRequestStateOfSwitch]) {
        _isShowiSlim = NO;
        [self downloadWithTaskID:@"requestState" outputTask:^{
            return @([[XKRWServerPageService sharedService] isShowPurchaseEntry_uploadVersion]);
        }];
    } else {
        _isShowiSlim = YES;
    }
    
    if (_isShowiSlim) {
        self.actionView.hidden = NO;
        wechatLabel.hidden = YES;
        warningLabel.hidden = YES;
    }else{
        self.actionView.hidden = YES;
        wechatLabel.hidden = NO;
        warningLabel.hidden = NO;
    }
    
}


- (void)initSubviews
{
    [self addNaviBarBackButton];
    self.title = @"咨询私人顾问";
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    UIImage *servicePage;
    if (XKAppWidth == 375) {
        servicePage = [UIImage imageNamed:@"ServicePage_750"];
    }else
    {
        servicePage = [UIImage imageNamed:@"ServicePage"];
    }
    UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, servicePage.size.height)];
    [contentImageView setImage:servicePage];
    
    [self.scrollView addSubview:contentImageView];
    
    [self.scrollView setContentSize:CGSizeMake(0, servicePage.size.height + 150)];
    
    wechatLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, XKAppHeight-64-44, XKAppWidth, 29)];
    wechatLabel.backgroundColor = XKBGDefaultColor;
    wechatLabel.text = @"请关注瘦瘦官方微信：shoushou20121230";
    wechatLabel.font = XKDefaultFontWithSize(14.f);
    wechatLabel.textColor = colorSecondary_666666;
    wechatLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:wechatLabel];
    
    warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, wechatLabel.bottom, XKAppWidth, 15)];
    warningLabel.backgroundColor = XKBGDefaultColor;
    warningLabel.text = @"有奖活动的最终解释权归瘦瘦官方所有";
    warningLabel.font = XKDefaultFontWithSize(12.f);
    warningLabel.textColor = colorSecondary_666666;
    warningLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:warningLabel];
    
    self.actionView = [[UIView alloc] initWithFrame:CGRectMake(0, XKAppHeight-64.f-44.f, XKAppWidth, 44)];
    self.actionView.backgroundColor = XK_BACKGROUND_COLOR;
    
    _focusButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 6, 100, 32)];
//    [_focusButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    _focusButton.layer.cornerRadius = 3;
    _focusButton.layer.borderColor = XKMainSchemeColor.CGColor;
    _focusButton.layer.borderWidth = 1.0;
    [_focusButton setTitle:@"复制微信号" forState:UIControlStateNormal];
    [_focusButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    [_focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_focusButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [_focusButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_focusButton addTarget:self action:@selector(copyMethod) forControlEvents:UIControlEventTouchUpInside];

    
    [self.actionView addSubview:_focusButton];
    
    _wechatButton = [[UIButton alloc] initWithFrame:CGRectMake(XKAppWidth - 30 - 100, 6, 100, 32)];
    _wechatButton.backgroundColor = XK_LINEAR_ICON_COLOR;
    _wechatButton.layer.cornerRadius = 3;
    [_wechatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wechatButton setTitle:@"关注有惊喜" forState:UIControlStateNormal];
    [_wechatButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_wechatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_wechatButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [_wechatButton addTarget:self action:@selector(wxBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.actionView addSubview:_wechatButton];
    
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"servicePageArrow"]];
    CGRect rect = arrow.frame;
    rect.origin = CGPointMake(XKAppWidth / 2 - 15, 12);
    arrow.frame = rect;
    [self.actionView addSubview:arrow];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    line.backgroundColor = XK_ASSIST_TEXT_COLOR;
    [self.actionView addSubview:line];
    
    [self.view addSubview:self.actionView];
    
}


- (void)copyMethod {
    
    [MobClick event:@"clk_CopyWeChat"];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"shoushou20121230";
    
    [XKRWCui showInformationHudWithText:@"复制成功"];
    
    
    _focusButton.userInteractionEnabled = NO;
    _wechatButton.userInteractionEnabled = YES;

    _focusButton.layer.borderColor = XK_LINEAR_ICON_COLOR.CGColor;
    [_focusButton setTitleColor:XK_LINEAR_ICON_COLOR forState:UIControlStateNormal];
    _wechatButton.backgroundColor = [UIColor whiteColor];
    [_wechatButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    
    _wechatButton.layer.borderWidth = 1.0;
    _wechatButton.layer.borderColor = XKMainSchemeColor.CGColor;
}


- (void)wxBtnClicked:(id)sender
{
    if ([WXApi isWXAppInstalled]) {
        NSString *str = [NSString stringWithFormat:@"weixin://qr/%@",@"EHTy-b7Eg4d8h6_enye0"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Nil message:@"只有安装了微信客户端,才能互动哦" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
    
    [MobClick event:@"clk_FollowWeChat"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
