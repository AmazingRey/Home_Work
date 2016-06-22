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

@implementation XKRWRecordFeedbackShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeMasonryConstraints];
    }
    return self;
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
        _userHeadImageView.image = [UIImage imageWithContentsOfURL:[NSURL URLWithString:urlString]];
//        [_userHeadImageView setImageWithURL:[NSURL URLWithString:urlString]
//                                        forState:UIControlStateNormal
//                                placeholderImage:[UIImage imageNamed:@"lead_nor"]
//                                         options:SDWebImageRetryFailed];
        [self addSubview:_userHeadImageView];
    }
    return _userHeadImageView;
}

- (UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
    }
    return _userNameLabel;
}

- (UILabel *)shareTimeLabel{
    if (!_shareTimeLabel) {
        _shareTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
    }
    return _shareTimeLabel;
}

- (UIImageView *)resultImageView{
    if (!_resultImageView) {
        _resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
    }
    return _resultImageView;
}

- (UIImageView *)qrcodeImageView{
    if (!_qrcodeImageView) {
        _qrcodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
    }
    return _qrcodeImageView;
}

- (UILabel *)qrcodeLabel{
    if (!_qrcodeLabel) {
        _qrcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
    }
    return _qrcodeLabel;
}

- (UIView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100)];
    }
    return _bottomImageView;
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
        make.top.mas_equalTo(self.topImageView.mas_bottom);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.height.equalTo(@40);
    }];
}
@end