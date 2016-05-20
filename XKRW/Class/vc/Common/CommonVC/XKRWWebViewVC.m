//
//  XKRWWebViewVC.m
//  XKRW
//
//  Created by zhanaofan on 14-4-2.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWWebViewVC.h"
#import "RNCachingURLProtocol.h"
#import "XKRWCui.h"
#import "NSTimer+XKDispatch.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface XKRWWebViewVC ()<NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    UIView *_progressBackView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic,assign) BOOL isLoad;
@property (nonatomic,strong) NSTimer *timer;


@end

@implementation XKRWWebViewVC

#pragma mark - System's functions

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
    
    self.isLoad = NO;

    if (!self.initialTitle) {
        self.title = self.initialTitle;
    } else {
        self.title = @"文章";
    }
    //缓存网页
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    [self drawSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.url && !self.isLoad) {
        NSURL *requestURL = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:requestURL]];
    }
    self.webView.frame = self.view.bounds;
    [self.navigationController.navigationBar addSubview:_progressBackView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSURLProtocol unregisterClass:[RNCachingURLProtocol class]];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc {
    _webView = nil;
    [_progressBackView removeFromSuperview];
}

#pragma mark -

- (void)drawSubviews
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.f, 0.f, XKAppWidth, XKAppHeight-128)];
    [self.view addSubview:self.webView];
    
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
}

- (void)cancelLoad {
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = nil;
    [XKRWCui hideProgressHud];
    [self.webView stopLoading];
}

- (void)popView {
    if(self.webView.canGoBack)
    {
        [self.webView goBack];
    }else{
        [super popView];
    }

}

#pragma mark - UIWebView's delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([request.URL.absoluteString rangeOfString:@"tel"].location != NSNotFound && request.URL.absoluteString != nil) {
        
        // NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",[request.URL.absoluteString stringByReplacingOccurrencesOfString:@"tel:" withString:@""]];//而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [XKRWCui showProgressHud:@"加载中..." InView:self.view];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelLoad) userInfo:Nil repeats:NO];
}


- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [XKRWCui hideProgressHud];
     _progressBackView.hidden = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.isLoad = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_progressView setProgress:0 animated:YES];
    _progressBackView.hidden = YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
