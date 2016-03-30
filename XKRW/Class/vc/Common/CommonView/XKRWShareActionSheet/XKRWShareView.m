//
//  XKRWShareView.m
//  XKRW
//
//  Created by Shoushou on 16/1/5.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWShareView.h"
#import "WXApi.h"
#import <YouMeng/umeng_ios_social_sdk_4.2.5_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenAPI.framework/Headers/QQApiInterface.h>

@implementation XKRWShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    if (![WXApi isWXAppInstalled]) {
        [self.wxBtn setImage:[UIImage imageNamed:@"wweixin_"] forState:UIControlStateNormal];
        [self.pyqBtn setImage:[UIImage imageNamed:@"wpyq_"] forState:UIControlStateNormal];
        
        self.wxBtn.userInteractionEnabled = NO;
        self.pyqBtn.userInteractionEnabled = NO;
    } else {
        self.wxBtn.tag = 1;
        self.pyqBtn.tag = 2;
        [self.wxBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.pyqBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (![QQApiInterface isQQInstalled]) {
        [self.qqBtn setImage:[UIImage imageNamed:@"wqqzone_"] forState:UIControlStateNormal];
        self.qqBtn.userInteractionEnabled = NO;
    } else {
        self.qqBtn.tag = 4;
        [self.qqBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.wbBtn.tag = 3;
    [self.wbBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)share:(UIButton *)button {
    if (self.clickBlock) {
        self.clickBlock(button.tag);
    }
}


@end
