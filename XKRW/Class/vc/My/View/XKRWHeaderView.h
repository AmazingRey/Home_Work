//
//  XKRWHeaderView.h
//  XKRW
//
//  Created by 忘、 on 15/7/8.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XKRWHeaderViewDelegate <NSObject>

- (void)changeUserInfoHeadImage; //修改用户头像
- (void)entryUserInfo;
- (void)changeBackgroundImage;
@end


@interface XKRWHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *insistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerArcImageView;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIImageView *degreeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowConstraint;

@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNamelabel;

@property (weak, nonatomic) IBOutlet UILabel *menifestoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@property (nonatomic,assign) id <XKRWHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)changeBackgroundImageAction:(UIButton *)sender;

+ (instancetype)instance;

@end
