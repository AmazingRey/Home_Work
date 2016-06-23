//
//  XKRWRecordFeedbackShareView.m
//  XKRW
//
//  Created by ss on 16/6/22.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecordFeedbackShareView.h"
#import "Masonry.h"
#import "XKRWUserService.h"
#import "UIImageView+WebCache.h"
#import "XKRWRecordWeightFeedBackVC.h"

#import "XKRWShareActionSheet.h"
#import "WXApi.h"
#import <YouMeng/umeng_ios_social_sdk_4.2.5_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenAPI.framework/Headers/QQApiInterface.h>

@implementation XKRWRecordFeedbackShareView
{
    CGFloat curDecreaseWeight;
    CGFloat totalDecreaseWeight;
}

- (instancetype)initWithFrame:(CGRect)frame changeWeight:(CGFloat)changeWeight totalChangeWeight:(CGFloat)totalChangeWeight
{
    self = [super initWithFrame:frame];
    if (self) {
        curDecreaseWeight = changeWeight;
        totalDecreaseWeight = totalChangeWeight;
        NSString *launchImage = nil;
        NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        for (NSDictionary* dict in imagesDict)
        {
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            
            if (CGSizeEqualToSize(imageSize, self.frame.size) && [ @"Portrait"isEqualToString:dict[@"UILaunchImageOrientation"]])
            {
                launchImage = dict[@"UILaunchImageName"];
            }
        }
        
        UIImage *backImage = [UIImage imageNamed:launchImage];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:backImage];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = self.frame;
        [self addSubview:imageView];
        
        [self makeMasonryConstraints];
        self.screenShoot = [self pb_takeSnapshot];
    }
    return self;
}

- (UIImage *)pb_takeSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
        _topImageView.image = [UIImage imageNamed:@"sharetop"];
        [self addSubview:_topImageView];
    }
    return _topImageView;
}

- (UIImageView *)userHeadImageView{
    if (!_userHeadImageView) {
        _userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _userHeadImageView.layer.cornerRadius = 25;
        NSString *urlString = [[XKRWUserService sharedService] getUserAvatar];
        [_userHeadImageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"lead_nor"] options:SDWebImageRetryFailed];
        [self addSubview:_userHeadImageView];
    }
    return _userHeadImageView;
}

- (UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
        _userNameLabel.text = [[XKRWUserService sharedService] getUserNickName];
        _userNameLabel.font = [UIFont systemFontOfSize:14];
        _userNameLabel.textColor = XKMainToneColor_29ccb1;
        [self addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

- (UILabel *)shareTimeLabel{
    if (!_shareTimeLabel) {
        _shareTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
        _shareTimeLabel.font = [UIFont systemFontOfSize:14];
        _shareTimeLabel.textColor = colorSecondary_999999;
        NSDate *date = [NSDate date];
        NSString *amOrpm = [date stringWithFormat:@"a"];
        NSString *dateformat;
        if ([amOrpm isEqualToString:@"AM"]) {
            dateformat = @"yyyy年MM月dd日  上午kk:mm";
        }else{
            dateformat = @"yyyy年MM月dd日  下午kk:mm";
        }
        NSString *dateStr = [date stringWithFormat:dateformat];
        _shareTimeLabel.text = dateStr;
        [self addSubview:_shareTimeLabel];
    }
    return _shareTimeLabel;
}

- (UIImageView *)resultImageView{
    if (!_resultImageView) {
        UIImage *img = [UIImage imageNamed:@"qualified"];
        _resultImageView = [[UIImageView alloc] initWithImage:img];
        [self addSubview:_resultImageView];
    }
    return _resultImageView;
}

- (UILabel *)resultLabel1{
    if (!_resultLabel1) {
        _resultLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
        _resultLabel1.font = [UIFont systemFontOfSize:18];
        _resultLabel1.textColor = colorSecondary_333333;
        _resultLabel1.text = @"又瘦了";
        _resultLabel1.textAlignment = NSTextAlignmentCenter;
        [self.resultImageView addSubview:_resultLabel1];
    }
    return _resultLabel1;
}

- (UILabel *)resultLabel2{
    if (!_resultLabel2) {
        _resultLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
        _resultLabel2.font = [UIFont systemFontOfSize:25];
        _resultLabel2.textColor = colorSecondary_333333;
        _resultLabel2.text = [NSString stringWithFormat:@"%.1fkg",curDecreaseWeight];
        _resultLabel2.textAlignment = NSTextAlignmentCenter;
        [self.resultImageView addSubview:_resultLabel2];
    }
    return _resultLabel2;
}

- (UILabel *)resultLabel3{
    if (!_resultLabel3) {
        _resultLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
        _resultLabel3.font = [UIFont systemFontOfSize:14];
        _resultLabel3.textColor = colorSecondary_999999;
        _resultLabel3.text = @"瘦身至今共瘦了";
        _resultLabel3.textAlignment = NSTextAlignmentCenter;
        [self.resultImageView addSubview:_resultLabel3];
    }
    return _resultLabel3;
}

- (UILabel *)resultLabel4{
    if (!_resultLabel4) {
        _resultLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
        _resultLabel4.font = [UIFont systemFontOfSize:14];
        _resultLabel4.textColor = colorSecondary_999999;
        _resultLabel4.text = [NSString stringWithFormat:@"%.1fkg",totalDecreaseWeight];
        _resultLabel4.textAlignment = NSTextAlignmentCenter;
        [self.resultImageView addSubview:_resultLabel4];
    }
    return _resultLabel4;
}

- (UIImageView *)qrcodeImageView{
    if (!_qrcodeImageView) {
        _qrcodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrcode"]];
        [self addSubview:_qrcodeImageView];
    }
    return _qrcodeImageView;
}

- (UILabel *)qrcodeLabel{
    if (!_qrcodeLabel) {
        _qrcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
        _qrcodeLabel.text = @"长按图片识别二维码下载";
        _qrcodeLabel.font = [UIFont systemFontOfSize:14];
        _qrcodeLabel.textColor = colorSecondary_999999;
        _qrcodeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_qrcodeLabel];
    }
    return _qrcodeLabel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapFeedbackShareView)]) {
        [self.delegate tapFeedbackShareView];
    }
}

- (void)addShareActionsheet{
    
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
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
            [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = self.screenShoot;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession]
                                                               content:nil
                                                                 image:nil
                                                              location:nil
                                                           urlResource:nil
                                                   presentedController:(XKRWRecordWeightFeedBackVC *)self.delegate
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
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
            [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = self.screenShoot;
            
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline]
                                                               content:nil
                                                                 image:nil
                                                              location:nil
                                                           urlResource:nil
                                                   presentedController:(XKRWRecordWeightFeedBackVC *)self.delegate
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
            [UMSocialData defaultData].extConfig.qzoneData.shareImage = self.screenShoot;
            
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone]
                                                               content:nil
                                                                 image:nil
                                                              location:nil
                                                           urlResource:nil
                                                   presentedController:(XKRWRecordWeightFeedBackVC *)self.delegate
                                                            completion:^(UMSocialResponseEntity *response){
                                                                if (response.responseCode == UMSResponseCodeSuccess) {
                                                                    XKLog(@"分享成功！");
                                                                }
                                                            }];
        }
        else if ([name isEqualToString:@"weibo"]) {
            //weibo
            [[UMSocialControllerService defaultControllerService] setShareText:nil
                                                                    shareImage:self.screenShoot
                                                              socialUIDelegate:(id)self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler((XKRWRecordWeightFeedBackVC *)self.delegate,[UMSocialControllerService defaultControllerService],YES);
        }
    }];
    [sheet show];
    
}

#pragma mark masonry
- (void)makeMasonryConstraints{
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(XKAppWidth);
        make.height.equalTo(@30);
    }];
    [self.userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImageView.mas_bottom).offset(25);
        make.left.equalTo(@15);
        make.width.height.equalTo(@50);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userHeadImageView.mas_top).offset(5);
        make.left.mas_equalTo(self.userHeadImageView.mas_right).offset(15);
        make.width.mas_greaterThanOrEqualTo(200);
        make.right.equalTo(@15);
    }];
    [self.shareTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.userNameLabel.mas_left);
        make.width.mas_greaterThanOrEqualTo(200);
        make.right.equalTo(@15);
    }];
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shareTimeLabel.mas_bottom).offset(44);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    if (totalDecreaseWeight > 0) {
        [self.resultLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
            make.top.mas_equalTo(self.resultImageView.mas_top).offset(35);
            make.centerX.mas_equalTo(self.resultImageView.mas_centerX);
        }];
        [self.resultLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.top.mas_equalTo(self.resultLabel1.mas_bottom);
            make.centerX.mas_equalTo(self.resultImageView.mas_centerX);
        }];
        [self.resultLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.top.mas_equalTo(self.resultLabel2.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self.resultImageView.mas_centerX);
        }];
        [self.resultLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.top.mas_equalTo(self.resultLabel3.mas_bottom);
            make.centerX.mas_equalTo(self.resultImageView.mas_centerX);
        }];
    }else{
        [self.resultLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
            make.top.mas_equalTo(self.resultImageView.mas_top).offset(60);
            make.centerX.mas_equalTo(self.resultImageView.mas_centerX);
        }];
        [self.resultLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.top.mas_equalTo(self.resultLabel1.mas_bottom);
            make.centerX.mas_equalTo(self.resultImageView.mas_centerX);
        }];
    }
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resultImageView.mas_bottom).offset(44);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.qrcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XKAppWidth);
        make.height.equalTo(@30);
        make.top.mas_equalTo(self.qrcodeImageView.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}
@end