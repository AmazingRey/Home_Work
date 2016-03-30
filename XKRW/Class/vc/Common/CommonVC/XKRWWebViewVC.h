//
//  XKRWWebViewVC.h
//  XKRW
//
//  Created by zhanaofan on 14-4-2.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@interface XKRWWebViewVC : XKRWBaseVC <UIWebViewDelegate>

/*加载的url*/
@property (nonatomic, strong) NSString *url;
/*webView*/
@property (nonatomic, strong) UIWebView *webView;
/*是否缓存内容*/
@property (nonatomic, assign) BOOL isCache;

@property (nonatomic, strong) NSString *initialTitle;

@end
