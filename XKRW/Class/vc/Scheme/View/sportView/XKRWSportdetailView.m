//
//  XKRWSportdetailView.m
//  XKRW
//
//  Created by 忘、 on 15/7/30.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWSportdetailView.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@implementation XKRWSportdetailView
{
    UIImageView * sportHolederIm;
    UIButton  *sportAction;
    
    __block CGFloat _headerImageH;
    
    __block  CGRect rect;
    XKRWSportEntity *sportEntity;
    UIWebView *sportWebView;
}



- (instancetype)initWithFrame:(CGRect)frame andEntity:(XKRWSportEntity *)entity
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _headerImageH = 210;
        
        rect = self.bounds;
        sportEntity = entity;
        [self reloadContentView:entity];
    }
    return self;
}


-(void)reloadContentView:(XKRWSportEntity *)entity{
    if (entity.iFrame && entity.iFrame.length) {
        
        sportHolederIm =[[UIImageView alloc] initWithFrame:CGRectMake(20, 20 , (XKAppWidth-40), _headerImageH)];
        sportHolederIm.backgroundColor = colorSecondary_333333;
        sportWebView = [[UIWebView alloc]initWithFrame:sportHolederIm.frame];
        sportWebView.hidden = YES;
        [self addSubview:sportWebView];
        
        sportAction =[UIButton buttonWithType:UIButtonTypeCustom];
        sportAction.frame = sportHolederIm.frame;
        [sportAction setImage:[UIImage imageNamed:@"playNor"] forState:UIControlStateNormal];
        [sportAction setImage:[UIImage imageNamed:@"playSel"] forState:UIControlStateHighlighted];
        [sportAction addTarget:self action:@selector(pushPlayVC) forControlEvents:UIControlEventTouchUpInside];
        sportAction.hidden = YES;
      
        
        __weak UIImageView *sportImageView = sportHolederIm;
        __weak UIButton *sportPlay = sportAction;
         __weak XKRWSportdetailView * weakself = self;
         rect.origin.y = _headerImageH;
        
        [sportHolederIm setImageWithURL:[NSURL URLWithString:entity.sportActionPic]placeholderImage:[UIImage imageNamed:@"sportWH"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                sportImageView.frame = CGRectMake(20,20 , (XKAppWidth-40), image.size.height / (image.size.width/(XKAppWidth-40)));
                sportImageView.contentMode = UIViewContentModeScaleAspectFit;
                sportPlay.frame = sportImageView.frame;
                _headerImageH = sportImageView.height;
                rect.origin.y = _headerImageH;
                [weakself resetWebViewFrame];
            }
        }];
        
        [self addSubview:sportHolederIm];
        [self addSubview:sportAction];
        
        if (entity.iFrame && entity.iFrame.length) {
            sportAction.hidden = NO;
        }
        else if(entity){
            
        }
        
    }
    else if(entity.sportActionPic && entity.sportActionPic.length){
        
        sportHolederIm =[[UIImageView alloc] initWithFrame:CGRectMake(20, -20 , (XKAppWidth-40), _headerImageH)];
        sportHolederIm.backgroundColor = colorSecondary_333333;
        __weak UIImageView *sportImageView = sportHolederIm;
        
        __weak XKRWSportdetailView * weakself = self;
        
         rect.origin.y = _headerImageH;
        
        [sportHolederIm setImageWithURL:[NSURL URLWithString:entity.sportActionPic]placeholderImage:[UIImage imageNamed:@"sportWH"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                
                XKLog(@"%f,%f",image.size.width,image.size.height);
                
                sportImageView.frame   = CGRectMake(20, -20, (XKAppWidth-40), (XKAppWidth-40)*image.size.height /image.size.width);
                sportImageView.contentMode = UIViewContentModeScaleAspectFit;
                _headerImageH = sportImageView.height;
                rect.origin.y = _headerImageH;
    
                [weakself resetWebViewFrame];
            }
            
        }];
        
        NSString * temp = [entity.sportPic substringWithRange:NSMakeRange(entity.sportPic.length - 4, 4)];
        [self addSubview:sportHolederIm];
        
        if ([temp isEqualToString:@".gif"]) {
            UIImageView * gifV =[[UIImageView alloc] initWithFrame:CGRectMake(300 - 48,161, 48, 14)];
            [gifV setImage:[UIImage imageNamed:@"sportgif"]];
            [self addSubview:gifV];
        }
        
        
    }
    else{
        
    }
    if (!_webLoadV) {
        self.webLoadV = [[UIWebView alloc] initWithFrame:rect];
        _webLoadV.delegate = self;
        [self addSubview:_webLoadV];
        
    }
    rect.origin.x = 20;
    rect.size.width = XKAppWidth-40;
    _webLoadV.frame = rect;
    [self resetWebContents:entity];
    
}

- (void)resetWebViewFrame
{
    _webLoadV.frame = rect;
    [self resetWebContents:sportEntity];
}



#pragma mark 以html方式 显示
- (void) resetWebContents:(XKRWSportEntity *)entity {
    
    NSMutableString * htmlString =[NSMutableString stringWithString: @"<html><head><meta name=\"viewport\" \
                                   content=\" initial-scale=1, maximum-scale=1\"><style>\
                                   *{\
                                    font-size:14px;\
                                    color:#666666;\
                                   }\
                                   pre {\
                                       font-size:14px;\
                                   color:#666666;\
                                   white-space: pre-wrap; \
                                   white-space: -moz-pre-wrap;\
                                   white-space: -pre-wrap; \
                                   white-space: -o-pre-wrap;\
                                   word-wrap: break-word;\
                                   } </style></head><body body bgcolor='F4F4F4'>"];
    
    if ( entity.sportEffect && entity.sportEffect.length) {
        NSString * effect =[self getPartHtmlStringWithIM:nil andTitle:@"功效" andContents:entity.sportEffect];
        [htmlString appendString:effect];
    }
    if (entity.sportCareDesc && entity.sportCareDesc.length) {
        
        //
        [htmlString appendString:[self getPartHtmlStringWithIM:nil andTitle:@"注意事项" andContents: entity.sportCareDesc ]];
    }
    if (entity.sportActionDesc && entity.sportActionDesc.length) {
        [htmlString appendString:[self getPartHtmlStringWithIM:entity.sportActionPic andTitle:@"动作要领" andContents: entity.sportActionDesc]];
    }
    
    [htmlString appendString:@"</body><ml>"];
    [_webLoadV loadHTMLString:htmlString baseURL:nil];
    
}

-(NSString *)getPartHtmlStringWithIM:(NSString *)imUrl andTitle:(NSString *)title andContents:(NSString *)contents{
    NSMutableString * htmlString = [NSMutableString string];
    
    if (title && title.length) {
        [htmlString appendString:[NSString stringWithFormat:@" <br /><font style='font-size:16px \
                                  !important;color:#00b4b4 !important;' > %@ </font><hr color='#cccccc' size = 1>",title]];
    }

    if (contents && contents.length) {
        
        [htmlString appendString:[NSString stringWithFormat:@"<font>%@</font><p></p><br />",contents]];
    }
    
    return   [NSString stringWithFormat:@"%@",htmlString];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    XKLog(@"webview loadComplete");
    int scrollHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"] intValue];
    CGRect frame = webView.frame;
    frame.size.height = scrollHeight+20;
    webView.frame = frame;
    webView.userInteractionEnabled = NO;

    if (self.sportDelegate && [self.sportDelegate respondsToSelector:@selector(resetScrollViewContentsize:)]) {
        [self.sportDelegate resetScrollViewContentsize: scrollHeight + 100 + ( (sportEntity.sportActionPic && sportEntity.sportActionPic.length)? _headerImageH:0) ];
    }
    
}

- (void)pushPlayVC
{
    sportWebView.hidden = NO;
    sportHolederIm.hidden = YES;
    sportAction.hidden = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:sportEntity.iFrame]];
    [sportWebView loadRequest:request];
}


@end
