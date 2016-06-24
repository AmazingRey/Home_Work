//
//  XKRWTaobaoVC.m
//  XKRW
//
//  Created by y on 15-1-4.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWNewWebView.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "XKHudHelper.h"
#import "KMPopoverView.h"
#import "XKRWShareActionSheet.h"
#import "XKRWCollectionEntity.h"
#import "XKRWCollectionEntity.h"
#import "XKRWUserService.h"
#import "XKRWCollectionService.h"
#import "XKRWPayOrderVC.h"
#import "XKRWProductEntity.h"
#import <YouMeng/umeng_ios_social_sdk_4.2.5_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenAPI.framework/Headers/QQApiInterface.h>
@interface XKRWNewWebView () <UIWebViewDelegate, KMPopoverViewDelegate, UMSocialUIDelegate, NJKWebViewProgressDelegate>
{
    XKRWCollectionEntity *_collectionEntity;
    NJKWebViewProgressView *_progressView;
    UIView *_progressBackView;
    NJKWebViewProgress *_progressProxy;
    UIImage *_shareImage;
    NSString *_shareContent;
}

@property (nonatomic, strong) UIView *noNetWorkView;
@property (nonatomic, strong) UIImageView *noNetWorkImageView;
@property (nonatomic, strong) UIButton *noNetWorkButton;

@end

@implementation XKRWNewWebView

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _xkWebView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressBackView];
}

- (void)dealloc {
    [_progressBackView removeFromSuperview];
}

- (void)popView
{
    if (_showType) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        
        if(self.xkWebView.canGoBack)
        {
            [self.xkWebView goBack];
        }else{
            [super popView];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  

    if (_shareURL.length == 0) {
        _shareURL = _contentUrl;
    }
    
    [self addNaviBarBackButton];
    
    if ([_contentUrl rangeOfString:@"ssbuy.xikang.com"].location == NSNotFound) {
        if ([_shareURL rangeOfString:[[XKRWUserService sharedService] getToken]].location != NSNotFound || _isHidenRightNavItem || [_shareURL rangeOfString:@"taobao.com"].location != NSNotFound) {
            self.isHidenRightNavItem = YES;
        } else {
            self.isHidenRightNavItem = NO;
        }
    }

    
    if (!_showType && [_contentUrl rangeOfString:@"ssapi.xikang.com/static/go?"].location == NSNotFound && [_contentUrl rangeOfString:@"ssapi.xikang.com"].location != NSNotFound) {
        
        if ([_contentUrl rangeOfString:@"?"].location == NSNotFound) {
            _contentUrl = [NSString stringWithFormat:@"%@?token=%@", _contentUrl,[[XKRWUserService sharedService] getToken]];
        } else {
            _contentUrl = [NSString stringWithFormat:@"%@&token=%@", _contentUrl,[[XKRWUserService sharedService] getToken]];
        }
    }
    
    
    {
        self.title = self.webTitle;
        _progressProxy = [[NJKWebViewProgress alloc] init];
        self.xkWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64 )];
        self.xkWebView.scalesPageToFit = true;
        [self.view addSubview:_xkWebView];
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = (id)self;
        _progressProxy.progressDelegate = (id)self;
        self.xkWebView.delegate = _progressProxy;
        _progressBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height, XKAppWidth, 4)];
        _progressBackView.backgroundColor = colorSecondary_e0e0e0;
        
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 4)];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progress = 0.;
        
        [_progressBackView addSubview:_progressView];
        
    }
    
    if (!self.isHidenRightNavItem) {
        [self addNaviBarRightButtonWithNormalImageName:@"more" highlightedImageName:@"more_p" selector:@selector(clickRightNavigationBarItem:)];
    }

    [self initData];
    
}

- (void)initData {
    
    if ([XKRWUtil isNetWorkAvailable]) {
        
        [_xkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [_contentUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
        
    } else {
        

        self.noNetWorkView.hidden = NO;
        
    }

}

//没有网 的UI处理
-(void)addNoNetWorkView {
    
    self.noNetWorkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, self.view.height)];
    self.noNetWorkView.backgroundColor = colorSecondary_f4f4f4;
    self.noNetWorkView.hidden = YES;
    
    self.noNetWorkImageView =[[UIImageView alloc] initWithFrame:CGRectMake((XKAppWidth-99)/2, (XKAppHeight-132)/2-64, 99, 132)];
    _noNetWorkImageView.image = [UIImage imageNamed:@"noNetwork"];
    [self.noNetWorkView addSubview:_noNetWorkImageView];
    
    self.noNetWorkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _noNetWorkButton.frame = CGRectMake((XKAppWidth-250)/2, _noNetWorkImageView.bottom+90, 250, 40);
    [_noNetWorkButton setBackgroundImage:[UIImage imageNamed:@"buttonGreen"] forState:UIControlStateNormal];
    [_noNetWorkButton setBackgroundImage:[UIImage imageNamed:@"buttonGreen_p"] forState:UIControlStateHighlighted];
    [_noNetWorkButton setTitle:@"点击重试" forState:UIControlStateNormal];
    [_noNetWorkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _noNetWorkButton.titleLabel.font = XKDefaultFontWithSize(16.f);
    [_noNetWorkButton addTarget:self action:@selector(loadDataFromNetwork:) forControlEvents:UIControlEventTouchUpInside];
    [self.noNetWorkView addSubview:self.noNetWorkButton];
    
    [self.view insertSubview:self.noNetWorkView aboveSubview:_xkWebView];
}

- (void)loadDataFromNetwork:(id)sender {
    self.noNetWorkView.hidden = YES;
    [self initData];
}

- (void)clickRightNavigationBarItem:(UIBarButtonItem *)sender {
    
    NSArray *images = nil;
    NSArray *titles = nil;
    
    images = @[[UIImage imageNamed:@"share_icon"]];
    titles = @[@"分享"];
    
    KMPopoverView *view = [[KMPopoverView alloc] initWithFrame:CGRectMake(0, 0, 125, 88.f)
                                                arrowDirection:KMDirectionUp
                                                 positionratio:0.8
                                                  withCellType:KMPopoverCellTypeImageAndText
                                                     andTitles:titles
                                                        images:images];
    view.tag = sender.tag;
    
    [view setSeparatorColor:[UIColor whiteColor]];
    view.delegate = self;
    
    [view addUnderOfNavigationBarRightItem:self];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    
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

#pragma mark - Web Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([request.URL.absoluteString rangeOfString:@"tel"].location != NSNotFound && request.URL.absoluteString != nil) {

        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",[request.URL.absoluteString stringByReplacingOccurrencesOfString:@"tel:" withString:@""]];//而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        return NO;
    }
    
    if ([request.URL.absoluteString rangeOfString:@"pay://"].location != NSNotFound && request.URL.absoluteString != nil) {
        NSString *string = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *subString = [string substringFromIndex:6];
        
        XKRWPayOrderVC *payVC = [[XKRWPayOrderVC alloc] initWithPID: @"10000"];
        payVC.product = [self dealWithProductString:subString];
        [self.navigationController pushViewController:payVC animated:YES];
        
        return NO;
    }

    return YES;
}

- (XKRWProductEntity *)dealWithProductString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    XKRWProductEntity *entity = [[XKRWProductEntity alloc] init];
    entity.title = [NSString stringWithFormat:@"%@",dic[@"title"]];
    entity.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
    entity.desc = [NSString stringWithFormat:@"%@",dic[@"description"]];
    entity.pid = [NSString stringWithFormat:@"%@",dic[@"out_trade_no"]];

    return entity;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if(_isFromPostDetail){
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        _shareImage = [UIImage imageNamed:@"icon"];
    }else{
        _shareImage = nil;
        self.shareTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    self.noNetWorkView.hidden = YES;
    
    NSString * key =[NSString stringWithFormat:@"yunying%@%@%ld",self.date,[self.content objectForKey:@"title"],(long)[XKRWUserDefaultService getCurrentUserId]];
    
    NSMutableString * string = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!string) {
        string = [NSMutableString stringWithString:@""];
    }
    string = [NSMutableString stringWithString:[string stringByAppendingString:[NSString stringWithFormat:@",%@",self.module]]];
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    XKLog(@"%@",error.description);
    self.noNetWorkView.hidden = NO;
}



#pragma mark - 网络处理
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    if ([taskID isEqualToString:@"saveArticleCollection"])
    {
        BOOL isSuccess = [[XKRWCollectionService sharedService] collectToDB:_collectionEntity];
        if (isSuccess) {
            [XKRWCui showInformationHudWithText:@"收藏成功"];
        }
    }
}


- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
}

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName
{
    return YES;
}


#pragma mark - KMPopoverView's delegate

- (void)KMPopoverView:(KMPopoverView *)KMPopoverView clickButtonAtIndex:(NSInteger)index {
    
    if (index == 0) {
        [MobClick event:@"clk_OpShare"];
        NSArray *images = @[[UIImage imageNamed:@"weixin"],
                            [UIImage imageNamed:@"weixinpengypou"],
                            [UIImage imageNamed:@"qqzone"],
                            [UIImage imageNamed:@"weibo"]];
        XKRWShareActionSheet *sheet = [[XKRWShareActionSheet alloc] initWithButtonImages:images clickButtonAtIndex:^(NSInteger index) {
            
            XKLog(@"Click at index: %d", (int)index);
            
            NSString *shareTitle = nil;
            
            if (_shareTitle && _shareTitle.length) {
                
                shareTitle = [NSString stringWithFormat:@"%@ - %@", _webTitle, _shareTitle];
            } else if (_webTitle && _webTitle.length) {
                
                shareTitle = _webTitle;
            } else if (self.title && self.title.length) {
                shareTitle = self.title;
            } else {
                shareTitle = @"分享自瘦瘦";
            }
            
            if (_isFromPostDetail) {
                _shareContent = shareTitle;
            } else {
                _shareContent = nil;
            }
            if (index == 0) {
                //微信分享
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareURL;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
                
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession]
                                                                   content:_shareContent
                                                                     image:_shareImage
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
            } else if (index == 1) {
                //朋友圈
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareURL;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
                
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline]
                                                                   content:nil
                                                                     image:_shareImage
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
            } else if (index == 2) {
                //QZone

                 if (![QQApiInterface isQQInstalled]) {
                 [XKRWCui showInformationHudWithText:@"您的设备没有QQ哦~"];
                 
                 return;
                 }
                
                [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
                [UMSocialData defaultData].extConfig.qzoneData.url = _shareURL;
                
                 [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone]
                 content:nil
                 image:_shareImage
                 location:nil
                 urlResource:nil
                 presentedController:self
                 completion:^(UMSocialResponseEntity *response){
                 if (response.responseCode == UMSResponseCodeSuccess) {
                 XKLog(@"分享成功！");
                 }
                 }];

                
            } else if (index == 3) {
                //weibo
                NSString *shareText = [NSString stringWithFormat:@"%@ - %@\n - 分享自瘦瘦", shareTitle, _shareURL];
                
                [[UMSocialControllerService defaultControllerService] setShareText:shareText
                                                                        shareImage:_shareImage
                                                                  socialUIDelegate:self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }
        }];
        [sheet show];
    }
    else if (index ==1)
    {
        [self checkNetWork];
        XKLog(@"开始执行收藏操作");
        
        _collectionEntity = [[XKRWCollectionEntity alloc] init];
        //nid
        _collectionEntity.originalId  = [[_entity.content objectForKey:@"nid"] intValue];
        _collectionEntity.collectName = [_entity.content objectForKey:@"title"];
        _collectionEntity.contentUrl  = [_entity.content objectForKey:@"contenturl"];
        _collectionEntity.collectType = 0;
        _collectionEntity.uid         = [[XKRWUserService sharedService]getUserId];
        _collectionEntity.date        = [NSDate date];
        
        if([[XKRWCollectionService sharedService] queryCollectionWithCollectType:_collectionEntity.collectType andNid:_collectionEntity.originalId])
        {//已经收藏过了返回YES
            [XKRWCui showInformationHudWithText:@"已经收藏过了"];
            return;
        }

        if(!_entity.category)
        {
            _entity.category = 7;
        }
        _collectionEntity.categoryType = _entity.category;
        
        if(!_collectionEntity.collectName)
        {
            [XKRWCui showInformationHudWithText:@"收藏失败"];
            return;
        }
        else
        {
            [self downloadWithTaskID:@"saveArticleCollection" outputTask:^id{
                return  [[XKRWCollectionService sharedService] saveCollectionToRemote:_collectionEntity];

            }];
        }

    }
 }

-(void)checkNetWork
{
    if (![XKUtil isNetWorkAvailable])
    {
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        return;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
