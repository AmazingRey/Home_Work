//
//  XKRWiSlimAssSuccessStoriesVC.m
//  XKRW
//
//  Created by XiKang on 15-1-20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWiSlimAssSuccessStoriesVC.h"
#import "XKHudHelper.h"

@interface XKRWiSlimAssSuccessStoriesVC () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XKRWiSlimAssSuccessStoriesVC

#pragma mark - System's functions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"成功案例";
    [self addNaviBarBackButton];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ss.xikang.com/weixin/lz/"]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView's Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [[XKHudHelper instance] showProgressHudAnimationInView:self.view];
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
    [XKRWCui showInformationHudWithText:error.domain andDetail:error.description];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
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
