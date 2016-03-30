//
//  XKRWForgetPasswordVC.m
//  XKRW
//
//  Created by Jiang Rui on 14-4-21.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWForgetPasswordVC.h"

@interface XKRWForgetPasswordVC ()

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation XKRWForgetPasswordVC

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
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
    [self.view addSubview:_webView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    NSURL *url = [[NSURL alloc]initWithString:@"http://i.xikang.com/online/mobileusersystem/security/mobileresetpwd.html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
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
