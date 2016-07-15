//
//  XKRWRecordFeedbackShareView.h
//  XKRW
//
//  Created by ss on 16/6/22.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWShareActionSheet.h"

@interface XKRWRecordFeedbackShareView : UIView

@property (nonatomic, strong) XKRWShareActionSheet *sheet;
@property (nonatomic, strong) UIImageView          *topImageView;
@property (nonatomic, strong) UIImageView          *userHeadImageView;
@property (nonatomic, strong) UILabel              *userNameLabel;
@property (nonatomic, strong) UILabel              *shareTimeLabel;
@property (nonatomic, strong) UIImageView          *resultImageView;
@property (nonatomic, strong) UILabel              *resultLabel1;
@property (nonatomic, strong) UILabel              *resultLabel2;
@property (nonatomic, strong) UILabel              *resultLabel3;
@property (nonatomic, strong) UILabel              *resultLabel4;
@property (nonatomic, strong) UIImageView          *qrcodeImageView;
@property (nonatomic, strong) UILabel              *qrcodeLabel;
@property (nonatomic, strong) UIImageView          *launchImageView;

- (instancetype)initWithFrame:(CGRect)frame changeWeight:(CGFloat)changeWeight totalChangeWeight:(CGFloat)totalChangeWeight;

- (void)addShareActionsheet;

@end