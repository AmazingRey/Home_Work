//
//  XKRWRecordFeedbackShareView.h
//  XKRW
//
//  Created by ss on 16/6/22.
//  Copyright © 2016年 XiKang. All rights reserved.
//
@protocol XKRWRecordFeedbackShareViewDelegate <NSObject>
@optional

@end

#import <UIKit/UIKit.h>

@interface XKRWRecordFeedbackShareView : UIView

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *userHeadImageView;
@property (nonatomic, strong) UILabel     *userNameLabel;
@property (nonatomic, strong) UILabel     *shareTimeLabel;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UIImageView *qrcodeImageView;
@property (nonatomic, strong) UILabel     *qrcodeLabel;
@property (nonatomic, strong) UIView      *bottomImageView;

@end