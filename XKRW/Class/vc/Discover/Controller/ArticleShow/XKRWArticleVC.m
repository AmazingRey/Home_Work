//
//  XKRWArticleVC.m
//  XKRW
//
//  Created by 韩梓根 on 15/6/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWArticleVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "DrawerView.h"
#import "RNCachingURLProtocol.h"
#import "XKHudHelper.h"
#import "KMPopoverView.h"
#import "XKRWManagementService5_0.h"
#import "XKTaskDispatcher.h"
#import "XKRWShareActionSheet.h"
#import "XKRWCollectionEntity.h"
#import "XKRWUserService.h"
#import "XKRWCollectionService.h"
#import "WXApi.h"
#import "XKRWActionSheet.h"
#import <YouMeng/umeng_ios_social_sdk_4.2.5_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenAPI.framework/Headers/QQApiInterface.h>


@interface XKRWArticleVC ()<UIWebViewDelegate,KMPopoverViewDelegate,UMSocialUIDelegate,NJKWebViewProgressDelegate,XKRWActionSheetDelegate>
{
    UIWebView    * _webView;
    UIButton     *leftItemButton;
    UIView       *_buttonContainer;
    
    NJKWebViewProgressView *_progressView;
    UIView *_progressBackView;
    NJKWebViewProgress *_progressProxy;
}


@property (nonatomic, strong) DrawerView *drawView;                 /**<减肥知识问题框*/
@property (nonatomic, strong) NSMutableArray *answerLabelArray;
@property (nonatomic, strong) NSMutableArray *answerCheckBoxArray;
@property (nonatomic, strong) UIButton *knowledgeCommitButton;
@property (nonatomic, strong) UIButton *commitButton;               /**<确认按钮*/
@property (nonatomic, strong) UILabel * moreInfo;
@property (nonatomic, strong) XKRWCollectionEntity *collectEntity;

@end

@implementation XKRWArticleVC

#pragma mark - UI生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //缓存网页
//    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    if (_entity.category == eOperationKnowledge ) {
        DrawerView *dView = [[DrawerView alloc] initWithView:[self generateQuestionViewWithQuestion:self.entity.content] parentView:self.view];
        dView.hidden = YES;
        dView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:dView];
        self.drawView = dView;
    }
    [self.navigationController.navigationBar addSubview:_progressBackView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSURLProtocol unregisterClass:[RNCachingURLProtocol class]];
    [_webView stopLoading];
}

- (void)dealloc {
    _webView = nil;
    [_progressBackView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//UI
- (void)initUI {
    self.title = _naviTitle;
    
    if (([_contentURL rangeOfString:@"token="].location != NSNotFound)) {
        NSRange range = [[_contentURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] rangeOfString:@"?token="];
        _shareURL = [_contentURL substringToIndex:range.location];
    }else{
        _shareURL = [_contentURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    if ([_contentURL rangeOfString:@"token="].location == NSNotFound) {
        if ([_contentURL rangeOfString:@"?"].location == NSNotFound) {
            _contentURL = [[NSString stringWithFormat:@"%@?token=%@", _contentURL,[[XKRWUserService sharedService] getToken]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            _contentURL = [[NSString stringWithFormat:@"%@&token=%@", _contentURL,[[XKRWUserService sharedService] getToken]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0,XKAppWidth , XKAppHeight - 64)];
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = (id)self;
    _progressProxy.progressDelegate = (id)self;
    _webView.delegate = _progressProxy;
    _progressBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height, XKAppWidth, 4)];
    _progressBackView.backgroundColor = colorSecondary_e0e0e0;

    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 4)];
    _progressView.backgroundColor = [UIColor clearColor];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0.;
    
    [_progressBackView addSubview:_progressView];
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    
    [self.view addSubview:_webView];
    
    //返回按钮
    [self addNaviBarBackButton];
    
    //添加...右按钮
    if (!_hiddenShowRightBtn) {
        [self addRightNavigationBarItem];
    }
}


//添加...右按钮
-(void)addRightNavigationBarItem{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_option_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightNavigationBarItem:)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    item.tintColor = [UIColor whiteColor];
    
    if (_source == eFromCollection || _source == eFromMoreRecomandInWebView) {
        item.tag = 1;
    }else{
        item.tag = 2;
    }
    
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 数据处理
-(void)initData{
    
    self.title = _naviTitle;
    self.answerLabelArray = [[NSMutableArray alloc] initWithCapacity:4];
    self.answerCheckBoxArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    //加载数据
    if([XKRWUtil isNetWorkAvailable]){
        [self loadDataToView];
    }else{
        [self showRequestArticleNetworkFailedWarningShow];
    }
    
}

//数据加载
- (void)loadDataToView {
    if (_contentURL != nil  &&  _contentURL.length > 0) {
//        [[XKHudHelper instance] showProgressHudAnimationInView:self.view];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_contentURL]]];
    }
}

#pragma mark - 网络处理
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



#pragma mark - 减肥知识 题目
-(UIView *)generateQuestionViewWithQuestion:(NSDictionary *)question {
    
    //question[@"field_question_value"]
    NSMutableAttributedString *attributedstring = [XKRWUtil createAttributeStringWithString: question[@"field_question_value"] font:XKDefaultFontWithSize(14.f) color:XK_TITLE_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
    
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
    
    //答案列表
    NSArray *answerArray = [(NSString *)question[@"field_answers_value"] componentsSeparatedByString:@"&&"];
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
        
        if(i == 0)
        {
            checkBox.selected = YES;
            answerLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        }
        [_answerLabelArray addObject:answerLabel];
        [_answerCheckBoxArray addObject:checkBox];
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


#pragma mark - KMPopoverView's delegate

- (void)actionSheet:(XKRWActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        if (![XKUtil isNetWorkAvailable]){
            [XKRWCui showInformationHudWithText:kNetWorkDisable];
            return;
        }
        _collectEntity = [[XKRWCollectionEntity alloc] init];
        
        if(_source == eFromHistory){
            _collectEntity.originalId  = [_nid intValue];
            _collectEntity.collectName = _naviTitle;
            _collectEntity.contentUrl  = _contentURL;
        }else{
            _collectEntity.originalId  = [[_entity.content objectForKey:@"nid"] intValue];
            _collectEntity.collectName = [_entity.content objectForKey:@"title"];
            _collectEntity.contentUrl  = [_entity.content objectForKey:@"url"];
        }
        
        _collectEntity.collectType = 0;  //0 文章，1 食物，2 运动
        _collectEntity.uid         = [[XKRWUserService sharedService] getUserId];
        _collectEntity.date        = [NSDate date];
        if(!_entity.category)
        {
            _entity.category = 7;
        }
        _collectEntity.categoryType = _entity.category;
        
        
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

- (void)actionSheet:(XKRWActionSheet *)actionSheet clickedHeaderAtIndex:(NSInteger)buttonIndex {
    
    NSString *shareTitle = nil;
    if (_shareTitle && _shareTitle.length) {
        shareTitle = [NSString stringWithFormat:@"%@ - %@", _naviTitle, _shareTitle];
    } else {
        shareTitle = _naviTitle;
    }
    
    if (buttonIndex == 1) {
        //微信分享
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareURL;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
        
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
   
    } else if (buttonIndex == 2) {
        //朋友圈
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareURL;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
        
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
 
    } else if (buttonIndex == 3) {
        //weibo
        NSString *shareText = [NSString stringWithFormat:@"%@ - %@\n - 分享自瘦瘦", shareTitle, _shareURL];
        
        [[UMSocialControllerService defaultControllerService] setShareText:shareText
                                                                shareImage:nil
                                                          socialUIDelegate:self];
        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    } else {
        //QZone
        [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
        [UMSocialData defaultData].extConfig.qzoneData.url = _shareURL;
        
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
    
    //减肥知识问题
    [self operationKnowledgeQuestion];
    
    _shareTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('title')[0].text"];
    
    if (_entity.category == eOperationEncourage || _entity.category == eOperationSport) {
        
        _buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 70, XKAppWidth, 70)];
        _buttonContainer.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        line.backgroundColor = XK_BACKGROUND_COLOR;
        
        [_buttonContainer addSubview:line];
        
        if (_entity.category != eOperationTalentShow && _entity.category != eOperationFamous) {
            [self.view addSubview:_buttonContainer];
            //设置scrollView的frame给提交按钮留下空间

            _webView.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64 - 70);
        }
        
        //创建提交按钮
        self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setBackgroundColor:XKMainSchemeColor];
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //添加点击事件
        [_commitButton addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
        _commitButton.layer.cornerRadius = 4;
        
//        [_noNetWorkView removeGestureRecognizer:_tapGesture];
        
        switch (_entity.category) {
            case eOperationEncourage:
                _commitButton.frame = CGRectMake((XKAppWidth-230)/2, 19, 230, 32);
                [_commitButton setTitle:@"我宣誓:一定会坚持下去!" forState:UIControlStateNormal];
                break;
            case eOperationSport:
                _commitButton.frame = CGRectMake((XKAppWidth-180)/2, 19, 180, 32);
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
                _entity.complete = YES ;
                break;
            default:
                break;
        }
        
        if (_entity.complete && _entity.category != eOperationFamous && _entity.category != eOperationTalentShow) {
            _commitButton.enabled = NO;
            [_commitButton setBackgroundColor:XK_LINEAR_ICON_COLOR];
        }
        
        //添加到contentView中
        [_buttonContainer addSubview:_commitButton];
        if (_entity.category == eOperationFamous) {
            [_buttonContainer addSubview:_moreInfo];
        }
        
    }//灵活运营模块完全展示网页，不做任何特殊处理
     else if (_entity.category == eOperationKnowledge) {
        
        _webView.frame = CGRectMake(0, 0, XKAppWidth, _webView.height - 30);
    }
    
    
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

//减肥知识的调查问卷
-(void)operationKnowledgeQuestion{
    if (_entity.category == eOperationKnowledge) {
        self.drawView.hidden = NO;
        if (_entity.complete) {
            
            for (int  i = 0; i < _answerCheckBoxArray.count; i++) {
                ((UIButton *)_answerCheckBoxArray[i]).selected = NO;
                ((UILabel *)_answerLabelArray[i]).textColor = [UIColor colorFromHexString:@"#666666"];
            }
            
            _knowledgeCommitButton.enabled = NO;
            [_knowledgeCommitButton setBackgroundColor:XK_LINEAR_ICON_COLOR];
            int32_t rightAnswer = ((NSString *)_entity.content[@"field_zhengda_value"]).intValue;
            ((UIButton *)_answerCheckBoxArray[rightAnswer -1]).selected = YES;
            ((UILabel *)_answerLabelArray[rightAnswer - 1]).textColor = XKMainToneColor_00b4b4;
            
            [((UIButton *)_answerCheckBoxArray[rightAnswer -1]) setBackgroundImage:[UIImage imageNamed:@"answer_check.png"] forState:UIControlStateSelected];
            
            for (UIButton * btn in _answerCheckBoxArray) {
                [btn setUserInteractionEnabled:NO];
            }
        }
    }
    
}

#pragma mark - 触发事件

- (void)reLoadDataFromNetwork:(UIButton *)button
{
    [self loadDataToView];
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
            [[UIApplication sharedApplication]openURL:url];
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
    
    [_webView stopLoading];
    
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
    
    XKRWArticleVC *vc = [[XKRWArticleVC alloc]init];
    XKRWManagementEntity5_0 *entity =[[XKRWManagementEntity5_0 alloc]init];
    
    if ([naviTitle isEqualToString:@""]){
    
    }else if ([naviTitle isEqualToString:@""]){
    
    }
        
    entity.category = eOperationOthers;
    vc.entity = entity;
    vc.contentURL = url;
    vc.source = eFromMoreRecomandInWebView;
    vc.naviTitle = naviTitle;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)clickRightNavigationBarItem:(UIBarButtonItem *)sender {
    
    XKRWActionSheet *actionSheet = [[XKRWActionSheet alloc] initShareHeaderSheetWithCancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@"收藏"];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}


-(void)checkBox:(id)sender {
    UIButton *checkBox = sender;
    checkBox.selected = !checkBox.selected;
    if (checkBox.selected) {
        ((UILabel *)_answerLabelArray[checkBox.tag]).textColor = [UIColor colorFromHexString:@"#333333"];
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
    
    if (_entity.category == eOperationKnowledge) {
        NSInteger selectedIndex = 0;
        for (UIButton *checkBox in _answerCheckBoxArray) {
            if (checkBox.selected) {
                selectedIndex = checkBox.tag;
            }
        }
        int32_t rightAnswer = ((NSString *)_entity.content[@"field_zhengda_value"]).intValue;
        
        if (rightAnswer == selectedIndex + 1) {
            
            [self commitResultToServer];
            
            UIButton *btn = _answerCheckBoxArray[rightAnswer - 1];
            btn.selected = YES;
        }else {
            [XKRWCui showInformationHudWithText:@"答案不对哦，再看看"];
        }
    }
    else if ((_entity.category == eOperationEncourage) || _entity.category == eOperationSport) {
        [self commitResultToServer];
    }
    else if( _entity.category == eOperationFamous)
    {   //pk  关注微博
        XKRWArticleVC *vc = [[XKRWArticleVC alloc]init];
        vc.contentURL = @"http://m.weibo.cn/d/xikangshoushou/";
        vc.naviTitle = @"关注微博";
        [self.navigationController  pushViewController:vc animated:YES];
        
    }
}

-(void)commitResultToServer {
    [self uploadWithTask:^{
        if(_entity.complete){
            _commitButton.enabled = NO;
            [_commitButton setBackgroundColor:XK_LINEAR_ICON_COLOR];
        }else{
            [XKRWCui showProgressHud:@"提交中，请稍后" ];
            [[XKRWManagementService5_0 sharedService] uploadCompleteTask:[NSString stringWithFormat:@"%ld",(long)_entity.nid]];
            [XKRWCui hideProgressHud];
        }
    }];
}

- (void)uploadWithTask:(XKDispatcherTask)task {
    [XKRWCui showProgressHud:@"提交中，请稍后" ];
    [XKTaskDispatcher uploadWithTaskID:[self defaultTaskID] task:task];
}

-(void)didUpload {
    _entity.complete = YES;
    if (!_commitButton) {
        _knowledgeCommitButton.enabled = NO;
        [_knowledgeCommitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        _commitButton.enabled = NO;
    }
    
    //根据不同的类别显示不同的提示语
    if (_entity.category == eOperationKnowledge) {
        [XKRWCui showInformationHudWithText:@"答对了 +1⭐️"];
        [_knowledgeCommitButton setBackgroundColor:XK_LINEAR_ICON_COLOR];
        
        int32_t rightAnswer = ((NSString *)_entity.content[@"field_zhengda_value"]).intValue;
        ((UIButton *)_answerCheckBoxArray[rightAnswer-1]).selected = YES;
        [((UIButton *)_answerCheckBoxArray[rightAnswer-1]) setBackgroundImage:[UIImage imageNamed:@"answer_check"] forState:UIControlStateSelected];
    }else{
        [XKRWCui showInformationHudWithText:@"恭喜 +1⭐️"];
    }
    
    [_webView reload];
}

- (void)loadDataFromNetwork:(UIButton *)button
{
    [self loadDataToView];
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



@end
