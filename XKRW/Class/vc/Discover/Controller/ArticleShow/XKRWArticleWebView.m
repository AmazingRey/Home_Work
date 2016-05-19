//
//  XKRWArticleWebView.m
//  XKRW
//
//  Created by Seth Chen on 16/2/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWArticleWebView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "KMPopoverView.h"
#import "WXApi.h"
#import <YouMeng/umeng_ios_social_sdk_4.2.5_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenAPI.framework/Headers/QQApiInterface.h>
#import "XKRWShareActionSheet.h"
#import "XKRWCollectionEntity.h"
#import "XKRWCollectionService.h"
#import "XKRWUserService.h"

#import "XKRWArticleWebViewTip.h"
#import "XKRW-Swift.h"
#import "DrawerView.h"
#import "XKTaskDispatcher.h"

NSString * const completeKey = @"THeAcountIsComplete";

@interface XKRWArticleWebView()
{
    NJKWebViewProgressView *_progressView;
    UIView *_progressBackView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic, strong) UIWebView * web;
@property (nonatomic, strong) XKRWArticleWebViewTip * contentComeFrom;
@property (nonatomic) BOOL isShowContentFromTip;
@property (nonatomic, copy) NSString *shareUrl;   ///< share url
@property (nonatomic, strong) XKRWCollectionEntity *collectEntity;

@property (nonatomic, strong) DrawerView *drawView;                 /**<减肥知识问题框*/
@property (nonatomic, strong) NSMutableArray<UILabel *>*answerLabelArray;
@property (nonatomic, strong) NSMutableArray<UIButton *>*answerCheckBoxArray;
@property (nonatomic, strong) UIButton *knowledgeCommitButton;
@property (nonatomic, strong) UIButton *commitButton;               /**<确认按钮*/
@property (nonatomic, strong) UILabel * moreInfo;
@property (nonatomic, strong) UIView * buttonContainer;

@end

@implementation XKRWArticleWebView

#pragma mark - life cycle & init UI
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.answerLabelArray = [[NSMutableArray alloc] initWithCapacity:4];
    self.answerCheckBoxArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    [self initWeb];
    
    [self setupSomethings];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.source != eFromToday) self.isShowContentFromTip = YES;
    else self.isShowContentFromTip = NO;
    
    self.isComplete = [[NSUserDefaults standardUserDefaults] boolForKey:[self e_theKeycomplete]];
    
    if (self.category == eOperationKnowledge &&self.entity.field_question_value.length > 0 &&self.drawView == nil) {
        DrawerView *dView = [[DrawerView alloc] initWithView:[self generateQuestionViewWithQuestion:self.entity] parentView:self.view];
        dView.hidden = NO;
        dView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:dView];
        self.drawView = dView;
        
        self.web.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        
        if (self.isComplete) {
           
            [self setEnabelStatus:_knowledgeCommitButton];
        }
    }
    
    [self.navigationController.navigationBar addSubview:_progressBackView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.entity.starState != 0 &&(self.category == eOperationEncourage ||self.category == eOperationSport)) {
        
        [self creatSwearLabel];
       
        if (self.isComplete) {
            [self setEnabelStatus:_commitButton];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    _progressProxy.webViewProxyDelegate = nil;
    _progressProxy.progressDelegate = nil;
    self.web.delegate = nil;
    [self.web stopLoading];
    [_progressBackView removeFromSuperview];
}

- (void)dealloc {
 
    
}

- (void)setupSomethings
{
//    self.title = self.navTitle;
    self.view.backgroundColor = [UIColor blackColor];
    self.contentComeFrom = [[NSBundle mainBundle]loadNibNamed:@"XKRWArticleWebViewTip" owner:nil options:nil].lastObject;
    self.contentComeFrom.top = 0;
    [self.contentComeFrom.enter addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [XKDispatcher syncExecuteTask:^{
        [self.view addSubview:self.contentComeFrom];
    }];
    [self setcomeForm];
}

- (void)setcomeForm
{
    NSString * fromStr = nil;
    
    switch (self.category) {
        case eOperationKnowledge:
            fromStr = @"减肥知识";
            break;
        case eOperationEncourage:
            fromStr = @"每日励志";
            break;
        case eOperationSport:
            fromStr = @"运动推荐";
            break;
        default:
            break;
    }
    
    NSMutableAttributedString * attributText = [[NSMutableAttributedString alloc]initWithString:XKSTR(@"内容来自%@", fromStr)];
    [attributText addAttribute:NSForegroundColorAttributeName value:XKMainSchemeColor range:NSMakeRange(4, fromStr.length)];
    self.contentComeFrom.comeFromLable.attributedText = attributText;
}

- (void)initWeb
{
    if (([self.requestUrl rangeOfString:@"token="].location != NSNotFound)) {
        NSRange range = [[self.requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] rangeOfString:@"?token="];
        self.shareUrl = [self.requestUrl substringToIndex:range.location];
    }else{
        self.shareUrl = [self.requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    if ([self.requestUrl rangeOfString:@"token="].location == NSNotFound && [self.requestUrl rangeOfString:@"ssapi.xikang.com"].location != NSNotFound) {
        if ([self.requestUrl rangeOfString:@"?"].location == NSNotFound) {
            self.requestUrl = [[NSString stringWithFormat:@"%@?token=%@", self.requestUrl,[[XKRWUserService sharedService] getToken]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            self.requestUrl = [[NSString stringWithFormat:@"%@&token=%@", self.requestUrl,[[XKRWUserService sharedService] getToken]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }

    self.web = [[UIWebView alloc]initWithFrame:(CGRect){0, 45 , XKAppWidth, XKAppHeight-(64 + 45)}];
    [self.view addSubview:self.web];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:XKURL(self.requestUrl) cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [self.web loadRequest:request];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = (id)self;
    _progressProxy.progressDelegate = (id)self;
    self.web.delegate = _progressProxy;
    _progressBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height, XKAppWidth, 4)];
    _progressBackView.backgroundColor = colorSecondary_e0e0e0;
    
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 4)];
    _progressView.backgroundColor = [UIColor clearColor];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0.;
    
    [_progressBackView addSubview:_progressView];
    
    //添加...右按钮
    if (!self.hiddenShowRightBtn) {
        [self addRightNavigationBarItem];
    }
}

- (void)setIsShowContentFromTip:(BOOL)isShowContentFromTip
{
    if (isShowContentFromTip) {
        self.web.frame = (CGRect){0, 45, XKAppWidth, XKAppHeight-(64 + 45)};
        self.contentComeFrom.hidden = NO;
    }else{
        self.web.frame = (CGRect){0, 0, XKAppWidth, XKAppHeight- 64};
        self.contentComeFrom.hidden = YES;
    }
}

- (void)creatSwearLabel{
    
    _buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50, XKAppWidth, 50)];
    _buttonContainer.backgroundColor = [UIColor whiteColor];
    
    if (self.category != eOperationTalentShow && self.category != eOperationFamous) {
        [self.view addSubview:_buttonContainer];
        //设置scrollView的frame给提交按钮留下空间
        
        self.web.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64 - 50);
    }
    
    //创建提交按钮
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_commitButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_commitButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [_commitButton setBackgroundColor:[UIColor whiteColor]];
//    _commitButton.layer.borderColor = XKMainSchemeColor.CGColor;
//    _commitButton.layer.borderWidth = 1;
    
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    line.backgroundColor = XK_BACKGROUND_COLOR;
    [_commitButton addSubview:line];
    
    //添加点击事件
    [_commitButton addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    _commitButton.layer.cornerRadius = 4;
    
    UIView * __line = [UIView new];
    __line.frame = CGRectMake(0, 0, _commitButton.width, 0.5);
    __line.backgroundColor = XKSepDefaultColor;
    [_commitButton addSubview:__line];
    //        [_noNetWorkView removeGestureRecognizer:_tapGesture];
    
    switch (self.category) {
        case eOperationEncourage:
            _commitButton.frame = _buttonContainer.bounds;
            [_commitButton setTitle:@"我宣誓:一定会坚持下去!" forState:UIControlStateNormal];
            break;
        case eOperationSport:
            _commitButton.frame = _buttonContainer.bounds;
            [_commitButton setTitle:@"我会努力去完成" forState:UIControlStateNormal];
            break;
        case eOperationFamous:
            //更多请关注瘦瘦微博
            self.moreInfo = [[UILabel alloc] initWithFrame:CGRectMake(15, 19, 180, 32)];
            _moreInfo.backgroundColor = [UIColor clearColor];
            _moreInfo.text = @"更多请关注瘦瘦微博";
            _moreInfo.textColor = [UIColor colorFromHexString:@"#333333"];
            _moreInfo.font = [UIFont systemFontOfSize:15.f];
            
            _commitButton.frame = CGRectMake(XKAppWidth - 70 - 15, 19, 70, 32);
            [_commitButton setTitle:@"关注微博" forState:UIControlStateNormal];
            //                _entity.complete = YES ;
            break;
        default:
            break;
    }
    
    //        if (_entity.complete && _entity.category != eOperationFamous && _entity.category != eOperationTalentShow) {
    //            _commitButton.enabled = NO;
    //            [_commitButton setBackgroundColor:XK_LINEAR_ICON_COLOR];
    //        }
    
    //添加到contentView中
    [_buttonContainer addSubview:_commitButton];
    if (self.category == eOperationFamous) {
        [_buttonContainer addSubview:_moreInfo];
    }
}

#pragma mark - reponse & aciton
//添加...右按钮
-(void)addRightNavigationBarItem{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_option_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightNavigationBarItem:)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    item.tintColor = [UIColor whiteColor];
    
    if (_source == eFromCollection || _source == eFromMoreRecomandInWebView || _category == eOperationOthers) {
        item.tag = 1;
    }else{
        item.tag = 2;
    }
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clickRightNavigationBarItem:(UIBarButtonItem *)sender {
    
    NSArray *images = nil;
    NSArray *titles = nil;
    if (sender.tag == 1) {
        images = @[[UIImage imageNamed:@"share_icon"]];
        titles = @[@"分享"];
        
    }else if (sender.tag == 2){
        images = @[[UIImage imageNamed:@"share_icon"],
                   [UIImage imageNamed:@"discover_collect"]];
        titles = @[@"分享",@"收藏"];
    }
    
    KMPopoverView *view = [[KMPopoverView alloc] initWithFrame:CGRectMake(0, 0, 125, 88.f)
                                                arrowDirection:KMDirectionUp
                                                 positionratio:0.8
                                                  withCellType:KMPopoverCellTypeImageAndText
                                                     andTitles:titles
                                                        images:images];
    view.tag = sender.tag;
    [view setSeparatorColor:[UIColor whiteColor]];
    view.delegate = (id)self;
    
    [view addUnderOfNavigationBarRightItem:self];
}


- (BOOL)openWechat:(NSString *)urlStr
{
    NSRange range = [urlStr rangeOfString:@"weixin"];
    if (range.location != NSNotFound) {
        
        [MobClick event:@"clk_CopyWeChat"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"shoushou20121230";
        
        NSURL *url = [NSURL URLWithString:@"weixin://"];
        BOOL canOpen = [[UIApplication sharedApplication]canOpenURL:url];
        
        if (canOpen) {
            [XKRWCui showInformationHudWithText:@"复制成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication]openURL:url];   
            });
        }else{
            [[XKHudHelper instance] showInformationHudWithText:@"未安装微信客户端"];
        }
        
        return YES;
        
    }else{
        
        return NO;
    }
}

- (void)entryNewWebView:(NSString *)urlStr
{
    if ([self openWechat:urlStr]) {
        return;
    }
    
    NSString *naviTitle ;
    NSMutableArray *httpAndUrlArrays =  [NSMutableArray arrayWithArray:[urlStr componentsSeparatedByString:@"?"]];
    
    NSMutableArray *paramsArray ;
    
    [self.web stopLoading];
    
    for (int i =0; i <[httpAndUrlArrays count]; i++) {
        NSString *str = [httpAndUrlArrays objectAtIndex:i];
        if ([str rangeOfString:@"article_type"].location != NSNotFound) {
            paramsArray = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"&"]];
            for (int i = 0; i < [paramsArray count]; i++) {
                NSString *params = [paramsArray objectAtIndex:i];
                if ([params rangeOfString:@"article_type"].location != NSNotFound) {
                    NSArray *array = [params componentsSeparatedByString:@"="];
                    NSString *titleUTF = array[1];
                    naviTitle = [titleUTF stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [paramsArray removeObjectAtIndex:i];
                }
            }
        }
    }
    
    NSMutableString *url = [NSMutableString stringWithString:[httpAndUrlArrays objectAtIndex:0]];
    
    for (NSString *param in paramsArray) {
        
        if ([url rangeOfString:@"?"].location == NSNotFound) {
            [url appendFormat:@"?%@",param];
        }else{
            [url appendFormat:@"&%@",param];
        }
    }
    
    
    
    XKRWArticleWebView *vc = [[XKRWArticleWebView alloc]init];
    vc.source = eFromMoreRecomandInWebView;
    if ([naviTitle isEqualToString:@"减肥知识"]) {
        vc.category = eOperationKnowledge;
    }else if ([naviTitle isEqualToString:@"运动推荐"]){
        vc.category = eOperationSport;
    }else{
        if ([naviTitle isEqualToString:@"瘦瘦微博"]) {
            vc.category = eOperationOthers;
            vc.source = eFromToday;
            vc.title = @"瘦瘦微博";
        }else vc.category = eOperationEncourage;
    }
    
    vc.requestUrl = url;
    vc.navTitle = naviTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterButtonClick:(id)sender
{
    [MobClick event:@"clk_ContentFrom"];
    switch (self.category) {
        case eOperationKnowledge:   /**<进入减肥知识列表*/
        {
            XKRWOperateArticleListVC * vc = [[XKRWOperateArticleListVC alloc] initWithNibName:@"XKRWOperateArticleListVC" bundle:nil];
            vc.operateString = @"jfzs";
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"减肥知识";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case eOperationSport:
        {
            XKRWOperateArticleListVC * vc = [[XKRWOperateArticleListVC alloc] initWithNibName:@"XKRWOperateArticleListVC" bundle:nil];
            vc.operateString = @"ydtj";
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"运动推荐";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case eOperationEncourage:
        {
            XKRWOperateArticleListVC * vc = [[XKRWOperateArticleListVC alloc] initWithNibName:@"XKRWOperateArticleListVC" bundle:nil];
            vc.operateString = @"lizhi";
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"每日励志";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - refresh data
- (void)reLoadDataFromNetwork:(UIButton *)button
{
    [self.web loadRequest:[NSURLRequest requestWithURL:XKURL(self.requestUrl)]];
}

- (void)setEnabelStatus:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
    sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(void)checkBox:(id)sender {
    UIButton *checkBox = sender;
    checkBox.selected = !checkBox.selected;
    if (checkBox.selected) {
        ((UILabel *)_answerLabelArray[checkBox.tag]).textColor = XKMainSchemeColor;
        [checkBox setImage:[UIImage imageNamed:@"answer_check.png"] forState:UIControlStateSelected];
        
    }
    else {
        ((UILabel *)_answerLabelArray[checkBox.tag]).textColor = [UIColor colorFromHexString:@"#666666"];
    }
    for (UIButton *btn in _answerCheckBoxArray) {
        if (btn.tag == checkBox.tag) {
            continue;
            
        }
        else {
            btn.selected = NO;
            ((UILabel *)_answerLabelArray[btn.tag]).textColor = [UIColor colorFromHexString:@"#666666"];
        }
    }
}

-(void)commit:(id)sender {
    if ([XKRWUserDefaultService isLogin]) {
        [self commitToServer];
    }else{
        
        [XKRWCui showInformationHudWithText:@"请登录后，再试试"];
    }
    
}

- (void)commitToServer {
    
    if (self.category == eOperationKnowledge) {
        NSInteger selectedIndex = 0;
        for (UIButton *checkBox in _answerCheckBoxArray) {
            if (checkBox.selected) {
                selectedIndex = checkBox.tag;
            }
        }
        int32_t rightAnswer = self.entity.field_zhengda_value.intValue;
        
        if (rightAnswer == selectedIndex + 1) {
            
            [self commitResultToServer];
            
            UIButton *btn = _answerCheckBoxArray[rightAnswer - 1];
            btn.selected = YES;
        }else {
            [XKRWCui showInformationHudWithText:@"答案不对哦，再看看"];
        }
    }
    else if ((self.category == eOperationEncourage) || self.category == eOperationSport) {
        [self commitResultToServer];
    }
    else if( self.category == eOperationFamous)
    {   //pk  关注微博

    }
}

-(void)commitResultToServer {
    [self uploadWithTask:^{
        [XKRWCui showProgressHud:@"提交中，请稍后" ];
        [[XKRWManagementService5_0 sharedService] uploadCompleteTask:[NSString stringWithFormat:@"%d",[self.entity.nid intValue]]];
        [XKRWCui hideProgressHud];
    }];
}

- (void)uploadWithTask:(XKDispatcherTask)task {
    [XKRWCui showProgressHud:@"提交中，请稍后" ];
    [XKTaskDispatcher uploadWithTaskID:[self defaultTaskID] task:task];
}

//提交成功以后
-(void)didUpload {
//    _entity.complete = YES;
    if (self.category == eOperationKnowledge && _knowledgeCommitButton!=nil) {
        
        [self setEnabelStatus:_knowledgeCommitButton];
        
    }else{
        
        [self setEnabelStatus:_commitButton];
    }
    
    //根据不同的类别显示不同的提示语
    if (self.category == eOperationKnowledge) {
        [XKRWCui showInformationHudWithText:@"答对了 +1⭐️"];
        
        int32_t rightAnswer = self.entity.field_zhengda_value.intValue;
        
        if(rightAnswer >= 1 && rightAnswer <= _answerCheckBoxArray.count){
            _answerCheckBoxArray[rightAnswer-1].selected = YES;
            [_answerCheckBoxArray[rightAnswer-1] setBackgroundImage:[UIImage imageNamed:@"answer_check"] forState:
             UIControlStateSelected];
            for (UIButton * but in _answerCheckBoxArray) {
                but.userInteractionEnabled = NO;
            }
        }
    }else{
        [XKRWCui showInformationHudWithText:@"恭喜 +1⭐️"];
        
    }
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[self e_theKeycomplete]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.web stopLoading];
    [self.web reload];
}


#pragma mark - 减肥知识 题目
-(UIView *)generateQuestionViewWithQuestion:(XKRWOperationArticleListEntity *)question {
    
    //question[@"field_question_value"]
    NSMutableAttributedString *attributedstring = [XKRWUtil createAttributeStringWithString: self.entity.field_question_value font:XKDefaultFontWithSize(14.f) color:XK_TITLE_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
    
    CGRect rect = [attributedstring boundingRectWithSize:CGSizeMake(XKAppWidth-50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    UIView *questionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 320)];
    questionView.backgroundColor = [UIColor whiteColor];
    
    //circle
    UIImage *image1 = [self imageWithTintColor:[UIImage imageNamed:@"block_circle.png"] Color:XKMainToneColor_29ccb1];
    UIImage *circleImage = [ image1 resizableImageWithCapInsets:UIEdgeInsetsMake(130, 270, 130, 270)];
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 280, questionView.bounds.size.height)];
    backImageView.image = circleImage;
    [questionView addSubview:backImageView];
    
    //问题
    UILabel *questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 20, XKAppWidth-50, rect.size.height)];
    questionLabel.backgroundColor = [UIColor clearColor];
    questionLabel.font = [UIFont systemFontOfSize:14.f];
    questionLabel.numberOfLines = 0;
    
    
    questionLabel.attributedText = attributedstring;
    [questionView addSubview:questionLabel];
    
    NSInteger correctAnswerIndex = self.entity.field_zhengda_value.integerValue;
    
    //答案列表
    NSArray *answerArray = [(NSString *)self.entity.field_answers_value componentsSeparatedByString:@"&&"];
    for (int i = 0; i < [answerArray count]; i++) {
        
        UILabel *answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, questionLabel.bottom +10 + i*40, 270, 40)];
        answerLabel.backgroundColor = [UIColor clearColor];
        answerLabel.font = [UIFont systemFontOfSize:14.f];
        answerLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        
        //生成 A.B.C
        char seq[] = "A.";
        seq[0] += i;
        
        NSMutableString *questionAnswer = [[NSMutableString alloc]initWithString:answerArray[i]];
        
        NSString *questionStr =  [questionAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        answerLabel.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithCString:seq encoding:NSUTF8StringEncoding],questionStr];
        [questionView addSubview:answerLabel];
        
        UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBox setImage:[UIImage imageNamed:@"answer_uncheck.png"] forState:UIControlStateNormal];
        [checkBox setImage:[UIImage imageNamed:@"answer_check.png"] forState:UIControlStateSelected];
        checkBox.frame = CGRectMake((XKAppWidth-44-24), questionLabel.bottom +10 + i*44, 44, 44);
        checkBox.center = CGPointMake((XKAppWidth-44-24)+22, answerLabel.center.y);
        checkBox.tag = i;
        [checkBox addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
        [questionView addSubview:checkBox];
        
        
        [_answerLabelArray addObject:answerLabel];
        [_answerCheckBoxArray addObject:checkBox];
        
        if (self.isComplete) {
            checkBox.userInteractionEnabled = NO;
            if(i == (correctAnswerIndex -1)) //初始化正确的选项
            {
                checkBox.selected = YES;
                answerLabel.textColor = XKMainSchemeColor;
            }
        }else if(i == 0) //初始化第一选项为选中状态
        {
            checkBox.selected = YES;
            answerLabel.textColor = XKMainSchemeColor;
        }
        
    }
    self.knowledgeCommitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_knowledgeCommitButton setBackgroundColor:[UIColor whiteColor]];
    [_knowledgeCommitButton setTitle:@"提交" forState:UIControlStateNormal];
    _knowledgeCommitButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_knowledgeCommitButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    _knowledgeCommitButton.layer.cornerRadius = 1.5f;
    _knowledgeCommitButton.layer.borderColor = XKMainSchemeColor.CGColor;
    _knowledgeCommitButton.layer.borderWidth = 1.f;
    [_knowledgeCommitButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [_knowledgeCommitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    _knowledgeCommitButton.frame = CGRectMake(XKAppWidth/2.0 - 35 , questionLabel.bottom +10+[answerArray count]*40, 70, 26);
    [_knowledgeCommitButton addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [questionView addSubview:_knowledgeCommitButton];
    
    questionView.frame = CGRectMake(0, 0, XKAppWidth, questionLabel.bottom +30+[answerArray count]*40);
    backImageView.frame = CGRectMake(20, 10, XKAppWidth-40, questionView.bounds.size.height);
    return questionView;
}


#pragma mark -
#pragma mark - Net handle
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    [XKRWCui hideProgressHud];
    if([taskID isEqualToString:@"saveArticleCollection"])
    {
        if([[result objectForKey:@"isSuccess"] isEqualToString:@"success"]){
            BOOL isSuccess =  [[XKRWCollectionService sharedService] collectToDB:_collectEntity];
            if (isSuccess) {
                [XKRWCui showInformationHudWithText:@"收藏成功"];
            }
        }else{
            [XKRWCui showInformationHudWithText:@"收藏失败"];
        }
        
        return;
    }
    
    if ([taskID isEqualToString:@"downloadInfo"]) {
        [self loadDataToView];
        return;
    }
}

-(void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [XKRWCui hideProgressHud];
}

-(void)handleUploadProblem:(id)problem withTaskID:(NSString *)taskID{
    
    [XKRWCui hideProgressHud];
}

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName
{
    return YES;
}


#pragma mark - WebView's delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableString *urlStr = [NSMutableString stringWithString:[request.URL absoluteString]];
    
    if ([urlStr rangeOfString:@"article_type"].location != NSNotFound) {
        
        [self performSelector:@selector(entryNewWebView:) withObject:urlStr afterDelay:0.1];
        return NO;
        
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [self hiddenRequestArticleNetworkFailedWarningShow];
    if (self.title.length == 0) {
        self.title = [self.web stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('title')[0].text"];
    }
    [self setcomeForm];
    
}

//网页加载失败
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
    
    [self showRequestArticleNetworkFailedWarningShow];
    
    [_progressView setProgress:0 animated:YES];
    _progressBackView.hidden = YES;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    
    [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
    if (progress >= _progressView.progress) {
        [_progressView setProgress:progress animated:YES];
    }
    
    if (progress > 0.9) {
        
        [XKDispatcher syncExecuteTask:^{
            //置零和移除
            _progressView.progress = 0.;
            _progressBackView.hidden = YES;
        } afterSeconds:0.5];
    }else{
        
        if (_progressBackView.hidden) {
            
            _progressBackView.hidden = NO;
        }
    }
}

#pragma mark -
#pragma mark - KMPopoverView's delegate

- (void)KMPopoverView:(KMPopoverView *)KMPopoverView clickButtonAtIndex:(NSInteger)index {
    if (index == 0) {
        
        [MobClick event:@"clk_share1"];
        
        NSMutableArray *imageNames = [[NSMutableArray alloc] init];
        
        if ([WXApi isWXAppInstalled]) {
            [imageNames addObject:@"weixin"];
            [imageNames addObject:@"weixinpengypou"];
        }
        if ([QQApiInterface isQQInstalled]) {
            
            [imageNames addObject: @"qqzone"];
        }
        [imageNames addObject:@"weibo"];
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSString *name in imageNames) {
            [images addObject:[UIImage imageNamed:name]];
        }
        
        XKRWShareActionSheet *sheet = [[XKRWShareActionSheet alloc] initWithButtonImages:images clickButtonAtIndex:^(NSInteger index) {
            
            NSString *name = imageNames[index];
            
            if ([name isEqualToString:@"weixin"]) {
                
                if (![WXApi isWXAppInstalled]) {
                    
                    [XKRWCui showInformationHudWithText:@"您的设备没有安装微信哦~"];
                    
                    return;
                }
                
                //微信分享
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = self.navTitle;
                
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession]
                                                                   content:nil
                                                                     image:nil
                                                                  location:nil
                                                               urlResource:nil
                                                       presentedController:self
                                                                completion:^(UMSocialResponseEntity *response){
                                                                    if (response.responseCode == UMSResponseCodeSuccess) {
                                                                        XKLog(@"分享成功！");
                                                                    } else {
                                                                        XKLog(@"分享微信好友失败");
                                                                    }
                                                                }];
            }
            else if ([name isEqualToString:@"weixinpengypou"]) {
                
                if (![WXApi isWXAppInstalled]) {
                    
                    [XKRWCui showInformationHudWithText:@"您的设备没有安装微信哦~"];
                    
                    return;
                }
                //朋友圈
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.navTitle;
                
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline]
                                                                   content:nil
                                                                     image:nil
                                                                  location:nil
                                                               urlResource:nil
                                                       presentedController:self
                                                                completion:^(UMSocialResponseEntity *response){
                                                                    if (response.responseCode == UMSResponseCodeSuccess) {
                                                                        XKLog(@"分享成功！");
                                                                    } else {
                                                                        XKLog(@"分享朋友圈失败");
                                                                    }
                                                                }];
            }
            else if ([name isEqualToString:@"qqzone"]) {
                
                if (![QQApiInterface isQQInstalled]) {
                    [XKRWCui showInformationHudWithText:@"您的设备没有QQ哦~"];
                    
                    return;
                }
                //QZone
                [UMSocialData defaultData].extConfig.qzoneData.title = self.navTitle;
                [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
                
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone]
                                                                   content:nil
                                                                     image:nil
                                                                  location:nil
                                                               urlResource:nil
                                                       presentedController:self
                                                                completion:^(UMSocialResponseEntity *response){
                                                                    if (response.responseCode == UMSResponseCodeSuccess) {
                                                                        XKLog(@"分享成功！");
                                                                    }
                                                                }];
            }
            else if ([name isEqualToString:@"weibo"]) {
                
                //weibo
                NSString *shareText = [NSString stringWithFormat:@"%@ - %@\n - 分享自瘦瘦", self.navTitle, self.shareUrl];
                
                [[UMSocialControllerService defaultControllerService] setShareText:shareText
                                                                        shareImage:nil
                                                                  socialUIDelegate:(id)self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }
        }];
        [sheet show];
        
    } else if (index == 1) {
        
        if (![XKUtil isNetWorkAvailable]){
            [XKRWCui showInformationHudWithText:kNetWorkDisable];
            return;
        }
        _collectEntity = [[XKRWCollectionEntity alloc] init];
        
        if(_source == eFromHistory){
            _collectEntity.originalId  = [_nid intValue];
            _collectEntity.collectName = self.title;
            _collectEntity.contentUrl  = self.requestUrl;
        }else{
            _collectEntity.originalId  = [self.entity.nid intValue];
            _collectEntity.collectName = self.entity.title;
            _collectEntity.contentUrl  = self.entity.url;
        }

        
        _collectEntity.collectType = 0;
        _collectEntity.uid         = [[XKRWUserService sharedService] getUserId];
        _collectEntity.date        = [NSDate date];
        if(!self.category)
        {
            self.category = 7;
        }
        _collectEntity.categoryType = self.category;
        
        
        if(!_collectEntity.collectName || !_collectEntity.originalId) {
            [XKRWCui showInformationHudWithText:@"请等待加载完再收藏..."];
            return;
        }
        if([[XKRWCollectionService sharedService] queryCollectionWithCollectType:_collectEntity.collectType andNid:_collectEntity.originalId]){
            [XKRWCui showInformationHudWithText:@"已经收藏过了"];
        }else{
            
            [MobClick event:@"clk_collection2"];
            
            [XKRWCui showProgressHud:@"正在收藏中..." InView:self.view];
            XKDispatcherOutputTask block = ^(){
                return  [[XKRWCollectionService sharedService] saveCollectionToRemote:_collectEntity];
            };
            
            [self downloadWithTaskID:@"saveArticleCollection" outputTask:block];
            
        }
    }
    
}

#pragma mark - 工具
-(UIImage *) imageWithTintColor:(UIImage*)srcImg Color:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(srcImg.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, srcImg.size.width, srcImg.size.height);
    UIRectFill(bounds);
    
    [srcImg drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

// the key for userDefault
- (NSString *)e_theKeycomplete
{
    NSDateFormatter * formt = [NSDateFormatter new];
    [formt setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr = [formt stringFromDate:[NSDate date]];
    return  XKSTR(@"%@_%ld_%@_%@", completeKey, (long)[XKRWUserDefaultService getCurrentUserId], self.entity.nid, dateStr);
}

@end
