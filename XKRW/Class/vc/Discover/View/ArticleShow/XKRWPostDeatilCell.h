//
//  XKRWPostDeatilCell.h
//  XKRW
//
//  Created by 忘、 on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRW-Swift.h"
#import "RTLabel.h"
@interface XKRWPostDeatilCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
//
////@property (weak, nonatomic) IBOutlet TYAttributedLabel *postContentLabel;
//@property (weak, nonatomic) IBOutlet UIWebView *postContentWebView;
@property (weak, nonatomic) IBOutlet RTLabel *postContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postContentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postImageViewConstraint;

@property (weak, nonatomic) IBOutlet UILabel *personLikeNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeStateButton;
@property (weak, nonatomic) IBOutlet UILabel *likeStateLabel;
@property (weak, nonatomic) IBOutlet UIView *postImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personLikeNumLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personLikeNumAndLikeButtonIntervalHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeButtonAndLikeLabelIntervalHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeLabelHeight;
@property (assign,nonatomic) BOOL showLikeButton;

@end
