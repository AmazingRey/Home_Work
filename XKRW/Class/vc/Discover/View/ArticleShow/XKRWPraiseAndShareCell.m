//
//  XKRWPraiseAndShareCell.m
//  XKRW
//
//  Created by Shoushou on 15/9/21.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWPraiseAndShareCell.h"
#import "define.h"

#import "WXApi.h"
#import <YouMeng/umeng_ios_social_sdk_4.2.5_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenAPI.framework/Headers/QQApiInterface.h>

@interface XKRWPraiseAndShareCell ()

@property (nonatomic, strong) UIView *likeView;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIButton *reportBtn;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation XKRWPraiseAndShareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initPraiseAndShareCell];
    }
    return self;
}

- (void)initPraiseAndShareCell {

    [self addLikeView];
    
    [self addShareView];
}

- (void)addLikeView {
    
    self.likeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 130)];
    [self.contentView addSubview:self.likeView];
    
    self.praisesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 15)];
    self.praisesLabel.center = CGPointMake(XKAppWidth/2, 15+15/2);
    self.praisesLabel.textAlignment = NSTextAlignmentCenter;
    self.praisesLabel.font = XKDefaultFontWithSize(12);
    self.praisesLabel.textColor = XK_ASSIST_TEXT_COLOR;
    [self.likeView addSubview:self.praisesLabel];
    
    self.reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reportBtn.frame = CGRectMake(XKAppWidth - 40, 15, 30, 15);
    [self.reportBtn setTitleColor:XK_ASSIST_TEXT_COLOR forState:UIControlStateNormal];
    self.reportBtn.titleLabel.font = XKDefaultFontWithSize(12);
    [self.reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [self.reportBtn addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
    [self.likeView addSubview:self.reportBtn];
    
    self.praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *likeImage = [UIImage imageNamed:@"like_"];
    self.praiseBtn.frame = CGRectMake(0, 0, likeImage.size.width, likeImage.size.height);
    self.praiseBtn.center = CGPointMake(XKAppWidth/2, _likeView.size.height/2);
    [self.likeView addSubview:self.praiseBtn];
    [self.praiseBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
    self.likeLabel.center = CGPointMake(XKAppWidth/2, _praiseBtn.bottom + 5 +_likeLabel.size.height/2);
    self.likeLabel.textAlignment = NSTextAlignmentCenter;
    self.likeLabel.textColor = XK_ASSIST_TEXT_COLOR;
    self.likeLabel.font = XKDefaultFontWithSize(12);
    [self.likeView addSubview:self.likeLabel];
    
    
}

- (void)addShareView {
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, XKAppWidth, 77)];
    [self.contentView insertSubview:self.shareView aboveSubview:self.likeView];
    
    UIView *lineViewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 15, (XKAppWidth-90)/2, 0.5)];
    lineViewLeft.backgroundColor = XK_ASSIST_LINE_COLOR;
    [self.shareView addSubview:lineViewLeft];
    
    UIView *lineViewRight = [[UIView alloc] initWithFrame:CGRectMake((XKAppWidth-90)/2+90, 15, (XKAppWidth-90)/2, 0.5)];
    lineViewRight.backgroundColor = XK_ASSIST_LINE_COLOR;
    [self.shareView addSubview:lineViewRight];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    shareLabel.center = CGPointMake(XKAppWidth/2, lineViewLeft.bottom);
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont systemFontOfSize:12];
    shareLabel.textColor = XK_ASSIST_TEXT_COLOR;
    shareLabel.text = @"分享到";
    [self.shareView addSubview:shareLabel];
    
    [self addShareBtn];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _shareView.size.height - 0.5, XKAppWidth, 0.5)];
    self.bottomLine.backgroundColor = XK_ASSIST_LINE_COLOR;
    [self.shareView addSubview:self.bottomLine];
}

- (void)addShareBtn {
    
    NSMutableArray *imageNameArr = [NSMutableArray array];
    NSArray *wimageNameArr = @[@"wweixin_",@"wpyq_",@"wqqzone_"];
    //判断是否安装微信、QQ
    if ([WXApi isWXAppInstalled]) {
        [imageNameArr addObject:@"weixin"];
        [imageNameArr addObject:@"weixinpengypou"];
    }else{
        [imageNameArr addObject:@"wweixin_"];
        [imageNameArr addObject:@"wpyq_"];
    }
    
    if ([QQApiInterface isQQInstalled]) {
        [imageNameArr addObject:@"qqzone"];
    }else{
        [imageNameArr addObject:@"wqqzone_"];
    }
    
    [imageNameArr addObject:@"weibo"];
    
    for (int i = 0; i < imageNameArr.count; i++) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setTitle:imageNameArr[i] forState:UIControlStateNormal];
        shareBtn.frame = CGRectMake(15+i*(XKAppWidth-30-40)/3, 25, 40, 40);
        
        [shareBtn setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
        
        [self.shareView addSubview:shareBtn];
        BOOL isCanShare = YES;
        for (NSString *temp in wimageNameArr) {
            if ([imageNameArr[i] isEqualToString:temp]) {
                isCanShare = NO;
            }
        }
        if (isCanShare) {
            [shareBtn addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)setHiddenLikePart:(BOOL)hiddenLikePart {
        
    _hiddenLikePart = hiddenLikePart;
    
    if (_hiddenLikePart) {
        self.shareView.frame = CGRectMake(0, 50, XKAppWidth, 77);
        self.likeLabel.hidden = YES;
        self.praiseBtn.hidden = YES;
        self.reportBtn.hidden = YES;
    }
}

#pragma mark - clickEvent
- (void)reportClick {
    if (_praiseAndShareDelegate && [_praiseAndShareDelegate respondsToSelector:@selector(postReport:)]) {
        [_praiseAndShareDelegate postReport:@"report"];
    }

}
- (void)shareArticle:(UIButton *)sender {
    if (_praiseAndShareDelegate && [_praiseAndShareDelegate respondsToSelector:@selector(postUMShareStr:)]) {
        [_praiseAndShareDelegate postUMShareStr:[sender titleForState:UIControlStateNormal]];
    }
}

- (void)praiseClick:(UIButton *)sender {
    if (_praiseAndShareDelegate && [_praiseAndShareDelegate respondsToSelector:@selector(postLikeStr:)]) {
        [_praiseAndShareDelegate postLikeStr:[sender titleForState:UIControlStateNormal]];
    }
}

@end
