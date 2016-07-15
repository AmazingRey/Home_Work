//
//  XKRWBaseVC.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-11.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKAuthService.h"
#import "XKDidPerformTaskNotification.h"
#import "XKDispatcher.h"
#import "XKServerException.h"
#import "XKBusinessProblem.h"
#import "XKCuiUtil.h"
#import "XKUtil.h"
#import "XKRWCui.h"
#import "XKRWNeedLoginAgain.h"
#import "XKHudHelper.h"
#import "XKMustBeOverridedMethodException.h"
#import "XKRW-Swift.h"
#import "XKRWNetWorkException.h"
#import "Masonry.h"
static NSString * const kNormalCharacterFormat = @"^[\x20-\x7e\u4e00-\u9fa5]*$";

@interface XKRWBaseVC ()
{
    UIImageView *leftRedDotImageView;
    UIImageView *rightRedDotImageView;
    UILabel     *leftDotNumLabel;
    UILabel     *rightDotNumLabel;
    UIView      *warningView;   //文章加载失败后的展示
}

@property (nonatomic) BOOL vcWillAppear;
@property (nonatomic) BOOL vcDidAppear;

@end

@implementation XKRWBaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置iOS7系统下(0,0)点的位置
    [XKUtil executeCodeWhenSystemVersionAbove:7.0 blow:0 withBlock:^{
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }];

// 设置背景颜色
    [self.view setBackgroundColor:XK_BACKGROUND_COLOR];
    
//
    _vcWillAppear = YES;
    _vcDidAppear = NO;
    

    if (!_forbidAutoAddPopButton && !_forbidAutoAddCloseButton) {
        [self addNaviBarBackButton];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _vcWillAppear = YES;
    _vcDidAppear = NO;
//    [self checkNeedHideNaviBarWhenPoped];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    _vcWillAppear = NO;
    _vcDidAppear = YES;
    
    //interactivePopGestureRecognizer close in those vcs...
    
//    UIViewController * rootvc = self.navigationController.viewControllers[0];
//    if ([rootvc isEqual:self]||[self isKindOfClass:[XKRWLoginVC class]]||[self isKindOfClass:[XKRWRecordOthersVC class]]) { //||[self isKindOfClass:[XKRWRecordOthersVC class]]
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }else{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
}



-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _vcWillAppear = NO;
    _vcDidAppear = NO;
    
//  [self.navigationController.interactivePopGestureRecognizer removeTarget:self action:@selector(checkNeedHideNaviBarWhenPoped)];
}

- (void)setTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = XKDefaultFontWithSize(17);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView = label;
    label.text = title;
    [label sizeToFit];
}

- (void)addNaviBarLeftButtonWithNormalImageName:(NSString *)normalImageName
                           highlightedImageName:(NSString *)highlightedImageName
                                       selector:(SEL)action {
    if (action == nil) {
        action = @selector(doClickNaviBarRightButton:);
    }
    UIBarButtonItem *item = [XKCuiUtil createBarButtonItemWithNormalImageName:normalImageName
                                                         highlightedImageName:highlightedImageName
                                                                       target:self
                                                                       action:action];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)addNaviBarRightButtonWithNormalImageName:(NSString *)normalImageName
                            highlightedImageName:(NSString *)highlightedImageName
                                        selector:(SEL)action {
    if (action == nil) {
        action = @selector(doClickNaviBarRightButton:);
    }
    UIBarButtonItem *item = [XKCuiUtil createBarButtonItemWithNormalImageName:normalImageName
                                                         highlightedImageName:highlightedImageName
                                                                       target:self
                                                                       action:action];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)addNaviBarBackButton {
    UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *back = [UIImage imageNamed:@"navigationBarback"];
    
    [leftItemButton setImage:back forState:UIControlStateNormal];
    [leftItemButton setImage:[UIImage imageNamed:@"navigationBarback_p"] forState:UIControlStateHighlighted];
    leftItemButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    leftItemButton.frame = CGRectMake(0, 0, back.size.width, back.size.height);

    [leftItemButton setTitleColor:[UIColor colorWithRed:247/255.f green:106/255.f blue:8/255.f alpha:1.0] forState:UIControlStateNormal];
    [leftItemButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemButton];
}

- (void)addNaviBarRightButtonWithText:(NSString *)text action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat titleWidth = [text boundingRectWithSize:CGSizeMake(XKAppWidth, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: XKDefaultFontWithSize(15)}
                                             context:nil].size.width;
    button.frame = CGRectMake(0, 0, titleWidth, 20);
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
    [button setTitleColor:[XKMainToneColor_29ccb1 colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    button.titleLabel.font = XKDefaultFontWithSize(15.f);
    
    if (action != nil) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    } else {
        [button addTarget:self action:@selector(doClickNaviBarRightButton) forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addNaviBarRightDeleteButton {
    [self addNaviBarRightButtonWithNormalImageName:@"del" highlightedImageName:@"del_p" selector:nil];
}



-(void)pressLeft:(UIButton*)sender
{
    
}

-(void)pressRight:(UIButton*)sender
{
    
}

-(void)addQuestionNextButtonWithTitle:(NSString *)title {
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.tag = 446655;
    nextButton.layer.cornerRadius=5;
    nextButton.layer.masksToBounds=YES;
    
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"buttonGreen"] stretchableImageWithLeftCapWidth:45 topCapHeight:15] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"buttonGreen_p"] stretchableImageWithLeftCapWidth:45 topCapHeight:15] forState:UIControlStateSelected];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"buttonGreen_p"] stretchableImageWithLeftCapWidth:45 topCapHeight:15] forState:UIControlStateHighlighted];
    [nextButton setTitle:title forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [nextButton addTarget:self action:@selector(nextQuestion:) forControlEvents:UIControlEventTouchUpInside];
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        nextButton.frame = CGRectMake((XKAppWidth-250)/2, (self.view.height-40-52-64), 250, 40);
    }
    else {
        nextButton.frame = CGRectMake((XKAppWidth-250)/2, (self.view.height-40-32-64), 250, 40);
    }
    [self.view addSubview:nextButton];
}


-(void)nextQuestion:(id)sender {
    XK_THROW_MUST_BE_OVERRIDED_INSTANCE_METHOD_EXCEPTION;
}

//问卷系统右上item显示阶段
-(void)addStageButton:(int32_t)stage {
    return;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,70, 20)];
    label.font = [UIFont systemFontOfSize:13.0];
    label.layer.borderColor = [UIColor colorFromHexString:@"#999999"].CGColor;
    label.layer.borderWidth = .5;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    [XKUtil executeCodeWhenSystemVersionAbove:5.1 blow:6.0 withBlock:^{
        label.text = [NSString stringWithFormat:@"评测中  %i/4",stage];
        label.textColor = XKMainToneColor_00b4b4;
    }];
    
    [XKUtil executeCodeWhenSystemVersionAbove:6.0 blow:0 withBlock:^{
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评测中  %i/4",stage]];
        
        // Red text attributes;
        NSRange textRange = NSMakeRange(0, 8);
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:textRange];
        UIColor *redColor = XKMainToneColor_00b4b4;
        NSRange redTextRange = NSMakeRange(0, 6);
        [attributedText addAttribute:NSForegroundColorAttributeName value:redColor range:redTextRange];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#999999"] range:NSMakeRange(6, 2)];

        label.attributedText = attributedText;
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
}

//问卷系统右上阶段label
-(void)addStageLabel:(NSString*)text {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,60, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor colorFromHexString:@"#999999"].CGColor;
    label.layer.borderWidth = .5;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = XKMainToneColor_00b4b4;
    label.font = [UIFont systemFontOfSize:13.f];
    label.text = text;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
}

- (void)setNavifationItemWithLeftItemTitle:(NSString *) leftItemTitle AndRightItemTitle:(NSString *)rightItemTitle AndItemColor:(UIColor *)color andShowLeftRedDot:(BOOL) leftShow AndShowRightRedDot:(BOOL)rightShow AndLeftRedDotShowNum:(BOOL)leftShowNum AndRightRedDotShowNum:(BOOL)rightShowNum AndLeftItemIcon:(NSString *)leftItemIcon AndRightItemIcon:(NSString *)rightItemIcon
{
    
    if (leftItemTitle != nil || leftItemIcon!= nil) {
        
        if (self.navigationItem.leftBarButtonItem!= nil) {
            self.navigationItem.leftBarButtonItem = nil;
        }
        
        UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat titleWidth ;
        
        if(leftItemTitle != nil)
        {
            titleWidth = [leftItemTitle boundingRectWithSize:CGSizeMake(XKAppWidth, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName: XKDefaultFontWithSize(15)}
                                          context:nil].size.width;
            [leftItemButton setTitle:leftItemTitle forState:UIControlStateNormal];
            [leftItemButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
            leftItemButton.titleLabel.font = XKDefaultFontWithSize(15.f);
        }

        if(leftItemIcon != nil){
            UIImage *image =   [UIImage imageNamed:leftItemIcon];
            titleWidth = image.size.width;
            [leftItemButton setImage:image forState:UIControlStateNormal];
            [leftItemButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_p",leftItemIcon]] forState:UIControlStateHighlighted];
        }
       
        [leftItemButton addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        leftItemButton.frame = CGRectMake(0, 0, titleWidth, 20);

        if(leftShowNum){
            leftRedDotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleWidth-5, -4, 16, 16)];
            leftDotNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
            leftDotNumLabel.textColor = [UIColor whiteColor];
            leftDotNumLabel.textAlignment = NSTextAlignmentCenter;
            leftDotNumLabel.font = XKDefaultFontWithSize(11);
            leftDotNumLabel.text = @"99";
            [leftRedDotImageView addSubview:leftDotNumLabel];
        }else{
            leftRedDotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleWidth+4, (20-6)/2, 6, 6)];
        }
        
        leftRedDotImageView.image = [UIImage imageNamed:@"notice_l"];
        leftRedDotImageView.tag = 2000;
        [leftItemButton addSubview:leftRedDotImageView];
        leftRedDotImageView.hidden = !leftShow;
        
        UIBarButtonItem *leftButtonItem =[[UIBarButtonItem alloc]initWithCustomView:leftItemButton];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
    
    if (rightItemTitle != nil || rightItemIcon != nil) {
        
        if (self.navigationItem.rightBarButtonItem!= nil) {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat titleWidth ;
        
        if(rightItemTitle != nil){
            titleWidth =  [rightItemTitle boundingRectWithSize:CGSizeMake(XKAppWidth, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: XKDefaultFontWithSize(15)}
                                                        context:nil].size.width;
            [rightItemButton setTitle:rightItemTitle forState:UIControlStateNormal];
            [rightItemButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
            rightItemButton.titleLabel.font = XKDefaultFontWithSize(15.f);

        }
        
        if(rightItemIcon != nil){
            UIImage *image =   [UIImage imageNamed:rightItemIcon];
            titleWidth = image.size.width;
            [rightItemButton setImage:image forState:UIControlStateNormal];
            [rightItemButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_p",rightItemIcon]] forState:UIControlStateHighlighted];
        }
        
        rightItemButton.frame = CGRectMake(0, 0, titleWidth, 20);
                [rightItemButton addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
        
        if(rightShowNum){
            rightRedDotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleWidth-5, -4, 16, 16)];
            rightDotNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
            rightDotNumLabel.text = @"99";
            rightDotNumLabel.textAlignment = NSTextAlignmentCenter;
            rightDotNumLabel.textColor = [UIColor whiteColor];
            rightDotNumLabel.font = XKDefaultFontWithSize(11);
            [rightRedDotImageView addSubview:rightDotNumLabel];
        }else{
            rightRedDotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleWidth+4, (20-6)/2 - 5, 6, 6)];
        }
        rightRedDotImageView.image = [UIImage imageNamed:@"notice_l"];
        rightRedDotImageView.tag = 2000;
        [rightItemButton addSubview:rightRedDotImageView];
        rightRedDotImageView.hidden = !rightShow;
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
}


- (void)showRequestArticleNetworkFailedWarningShow
{
    if(warningView == nil){
        warningView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
        warningView.backgroundColor = colorSecondary_f4f4f4;
        [self.view addSubview:warningView];
        UIImage *image = [UIImage imageNamed:@"load_failed_monkey"];
        UIImageView * noNetWorkImageView = [[UIImageView alloc] initWithImage:image];
        noNetWorkImageView.center = CGPointMake(XKAppWidth/2, 92 * XKAppHeight/668.0 + self.navigationController.navigationBar.bottom + image.size.height/2.0);
        [warningView addSubview:noNetWorkImageView];
        
        UILabel *faildLabel = [[UILabel alloc] initWithFrame:CGRectMake(XKAppWidth/2 - 100, noNetWorkImageView.bottom + 53, 200, 15)];
        faildLabel.font = XKDefaultFontWithSize(15);
        faildLabel.textAlignment = NSTextAlignmentCenter;
        faildLabel.textColor = colorSecondary_999999;
        faildLabel.text = @"服务器开小差，内容消失啦！";
        [warningView addSubview:faildLabel];
        
        UIButton *noNetWorkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        noNetWorkButton.frame = CGRectMake(XKAppWidth/2-35, faildLabel.bottom + 22, 70, 15);
        [noNetWorkButton setBackgroundColor:XKClearColor];
        [noNetWorkButton setTitle:@"点击刷新" forState:UIControlStateNormal];
        [noNetWorkButton setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
        noNetWorkButton.titleLabel.font = XKDefaultFontWithSize(15.f);
        [noNetWorkButton addTarget: self action:@selector(reLoadDataFromNetwork:) forControlEvents:UIControlEventTouchUpInside];
        [warningView addSubview:noNetWorkButton];
    }
    warningView.hidden = NO;
}

- (void)hiddenRequestArticleNetworkFailedWarningShow
{
    if(warningView){
         warningView.hidden = YES;
    }
}

- (void)hideNavigationLeftItemRedDot:(BOOL)leftItemRedDotNeedHide andRightItemRedDotNeedHide:(BOOL)rightItemRedDotNeedHide{
    leftRedDotImageView.hidden = leftItemRedDotNeedHide ;
    rightRedDotImageView.hidden = rightItemRedDotNeedHide;
}


- (void)setNavigationLeftRedNum:(NSString *)leftNum
{
    leftDotNumLabel.text = leftNum;
}

- (void)setNavigationRightRedNum:(NSString *)rightNum
{
    rightDotNumLabel.text = rightNum;
}



- (void)closeView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeViewAnimated:(BOOL)animate {
    [self.presentingViewController dismissViewControllerAnimated:animate completion:nil];
}

- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)popViewWithCheckNeedHideNaviBarWhenPoped {
//    [self checkNeedHideNaviBarWhenPoped];
//    [self.navigationController popViewControllerAnimated:YES];
//}

//- (void)checkNeedHideNaviBarWhenPoped {
//    XKLog(@"%@",[self class]);
//    if (self.isNeedHideNaviBarWhenPoped) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }else
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

- (void)pop2Views {
    NSArray *vcs = self.navigationController.viewControllers;
    [self.navigationController popToViewController:vcs[vcs.count - 3] animated:YES];
}

- (void)pop3Views{
    NSArray *vcs = self.navigationController.viewControllers;
    [self.navigationController popToViewController:vcs[vcs.count - 4] animated:YES ];
}


- (BOOL)checkRequiredForTextField:(XKTextField *)textField
                    withInputName:(NSString *)inputName {
    return [textField checkTextWithRule:[textField textRequiredCheckRuleWithNGMessage:[NSString stringWithFormat:@"%@不能为空", inputName]]];
}

- (BOOL)checkFormatForTextField:(XKTextField *)textField
                      withRegex:(NSString *)regex
                      ngMessage:(NSString *)ngMessage {
    return [textField checkTextWithRule:[textField textFormatCheckRuleWithRegex:regex
                                                                      ngMessage:ngMessage]];
}

- (BOOL)checkCharacterForTextField:(XKTextField *)textField
                     withInputName:(NSString *)inputName {
    return [textField checkTextWithRule:[textField textFormatCheckRuleWithRegex:kNormalCharacterFormat
                                                                      ngMessage:[NSString stringWithFormat:@"%@不允许使用特殊符号", inputName]]];
}

- (BOOL)checkDigitForTextField:(XKTextField *)textField
                  withMinDigit:(NSUInteger)minDigit
                      maxDigit:(NSUInteger)maxDigit
                     ngMessage:(NSString *)ngMessage {
    return [textField checkTextWithRule:[textField textDigitCheckRuleWithMinDigit:minDigit
                                                                         maxDigit:maxDigit
                                                                        ngMessage:ngMessage]];
}

- (BOOL)checkTextField:(XKTextField *)textField
        notEqualToText:(NSString *)equalText
         withNGMessage:(NSString *)ngMessage {
    return [textField checkTextWithRule:^(NSString *text) {
        NSString *message = ((!text && !equalText)
                             || [text isEqualToString:equalText]) ? ngMessage : nil;
        return message;
    }];
}

- (void)downloadWithTask:(XKDispatcherTask)task {
    [super downloadWithTask:task];
}

- (void)uploadWithTask:(XKDispatcherTask)task {
    [XKRWCui showProgressHudInView:self.view];
    [super uploadWithTask:task];
}

- (void)uploadWithTask:(XKDispatcherTask)task message:(NSString *)message{
    
    [XKRWCui showProgressHud:message InView:self.view];
    [super uploadWithTask:task];
}

- (void)uploadBlockingWithTask:(XKDispatcherTask)task{
    
    [XKRWCui showProgressHud];
    [super uploadWithTask:task];
}

- (void)uploadBlockingWithTask:(XKDispatcherTask)task inView:(UIView *)view
{
    [XKRWCui showProgressHud:@"加载中..." InView:view];
    [super uploadWithTask:task];
}

- (void)uploadBlockingWithTask:(XKDispatcherTask)task message:(NSString *)message{
    [XKRWCui showProgressHud:message];
    [super uploadWithTask:task];
}

- (void)downloadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task {
    [super downloadWithTaskID:taskID task:task];
}

- (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task {
    [XKRWCui showProgressHud];
    [super uploadWithTaskID:taskID task:task];
}

- (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task message:(NSString *)message{
    [XKRWCui showProgressHud:message];
    [super uploadWithTaskID:taskID task:task];
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    [XKDispatcher syncExecuteTask:^{
        [self loadDataToView];
    }];
}

- (void)didUploadWithResult:(id)result taskID:(NSString *)taskID {
    [XKDispatcher syncExecuteTask:^{
        [XKRWCui hideProgressHud];
        [self didUpload];
    }];
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [XKDispatcher syncExecuteTask:^{
        if ([problem isKindOfClass:BizException.class]) {
            [XKRWCui showInformationHudWithText:[problem message]];
        }
        else if ([problem isKindOfClass:[XKRWNeedLoginAgain class]]){
            [XKRWUserDefaultService setLogin:NO];
            
     
            [[XKRWLoginVC class] showLoginVCWithTarget:self loginSuccess:^{
                
            } failed:^(BOOL isFailed) {
                
            } alertMessage:((XKRWNeedLoginAgain *)problem).detail];
            
        }else if ([problem isKindOfClass:[XKRWNetWorkException class]])
        {
        
        }
        else if ([problem isKindOfClass:AuthException.class]) {
            [XKAuthService sharedService].isLogin = NO;
            
            if (_vcDidAppear) {
                XKRWLoginVC *loginNaviVC = [[XKRWLoginVC alloc] initWithNibName:@"XKRWLoginVC" bundle:nil];
                [self presentViewController:loginNaviVC animated:YES completion:nil];
            } else if (_vcWillAppear) {
                [XKDispatcher syncExecuteTask:^{
                    if (_vcDidAppear) {
                        XKRWLoginVC *loginNaviVC = [[XKRWLoginVC alloc] initWithNibName:@"XKRWLoginVC" bundle:nil];
                        [self presentViewController:loginNaviVC animated:YES completion:nil];
                    
                    }
                } afterSeconds:1];
            }
        }
        else if ([problem isKindOfClass:VersionException.class]) {
            [XKRWCui showAlertWithMessage:[problem message] onOKBlock:^{
                [XKUtil openCurrentIntroInAppStore];
            }];
        } else if ([problem isKindOfClass:XKServerException.class]) {
            [XKRWCui showServerNGInformationHudWithHttpStatusCode:[problem httpStatusCode]];
        } else if ([problem conformsToProtocol:@protocol(XKBusinessProblem)]) {
            [XKRWCui showInformationHudWithText:[problem detail]];
        } else {
            XKLog(@"%@ ", problem);
        }
    }];
}

- (void)handleUploadProblem:(id)problem withTaskID:(NSString *)taskID {
    [XKDispatcher syncExecuteTask:^{
        [XKRWCui hideProgressHud];
        
        if ([problem isKindOfClass:BizException.class]) {
            [XKRWCui showAlertWithMessage:[problem message]];
        }
        else if ([problem isKindOfClass:[XKRWNeedLoginAgain class]]){
            [XKRWUserDefaultService setLogin:NO];
    
            [[XKRWLoginVC class] showLoginVCWithTarget:self loginSuccess:^{
                    
            } failed:^(BOOL isFailed) {
                    
            } alertMessage:((XKRWNeedLoginAgain *)problem).detail];
            

        }else if ([problem isKindOfClass:[XKRWNetWorkException class]])
        {

            
        }
        else if ([problem isKindOfClass:AuthException.class]) {
            [XKAuthService sharedService].isLogin = NO;
            
            if (_vcDidAppear) {
                UIViewController *loginNaviVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviVC"];
                [self presentViewController:loginNaviVC animated:YES completion:nil];
            } else if (_vcWillAppear) {
                [XKDispatcher syncExecuteTask:^{
                    if (_vcDidAppear) {
                        UIViewController *loginNaviVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviVC"];
                        [self presentViewController:loginNaviVC animated:YES completion:nil];
                    }
                } afterSeconds:1];
            }
        } else if ([problem isKindOfClass:VersionException.class]) {
            [XKRWCui showAlertWithMessage:[problem message] onOKBlock:^{
                [XKUtil openCurrentIntroInAppStore];
            }];
        } else if ([problem isKindOfClass:XKServerException.class]) {

            [XKRWCui showServerNGAlertWithDetail:[problem detail]];
        } else if ([problem conformsToProtocol:@protocol(XKBusinessProblem)]) {
            
            [XKRWCui showInformationHudWithText:[problem detail]];
        } else {
          //  XKLog(@"%@", [problem detail]);
        }
        [XKDispatcher syncExecuteTask:^{
            [self finallyJobWhenUploadFail];
        }];
    }];
    
    [self didUploadFail];
}



- (void)popUpTheTipViewOnWindowAsUserFirstTimeEntryVC:(UIWindow *)window andImageView:(UIImageView *)imageView andShowTipViewTime:(NSTimeInterval) time andTimeEndBlock:(void (^)(UIView *backgroundView,UIImageView *imageView))timeEndBlock
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:window.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.48;
    [window addSubview:backgroundView];
    
    
    
    [window addSubview:imageView];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        timeEndBlock(backgroundView,imageView);
    });
}

- (void)doClickNaviBarLeftButton:(id)sender {
    // NOP
}

- (void)doClickNaviBarRightButton:(id)sender {
    // NOP
}

- (void)loadDataToView {
    // NOP
}

- (void)didUpload {

    // NOP
}

- (void)didUploadFail
{
 // NOP

}

- (void)reLoadDataFromNetwork:(UIButton *)button
{

}

- (void)leftItemAction:(UIButton *)button
{
    //NOP
}

- (void)rightItemAction:(UIButton *)button{
    //NOP
}

- (void)finallyJobWhenUploadFail {
    //NOP
}

#pragma mark - 
-(BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
