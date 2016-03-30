//
//  XKRWMoreCells.h
//  XKRW
//
//  Created by zhanaofan on 14-6-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SevenSwitch.h"

@interface XKRWMoreCells : NSObject


@end

#pragma mark - XKRWUserInfoCell


@protocol XKRWUserInfoDelegate <NSObject>
- (void)changeUserInfoHeadImage; //修改用户头像
@end

@interface XKRWUserInfoCell : UITableViewCell


@property (strong, nonatomic) UILabel         *nickNameLabel;
@property (strong, nonatomic) UILabel         *menifestoLabel;
@property (strong, nonatomic) UIView          *downLineView;
@property (strong, nonatomic) UIView          *upLineView;
@property (strong, nonatomic) UIButton        *headerButton;
@property (nonatomic, strong) UIImageView     *rightImg;

@property (nonatomic,assign) id <XKRWUserInfoDelegate> userinfoDelegate;
@end



#pragma mark - XKRWCommonCell
@interface XKRWCommonCell : UITableViewCell
@property (strong,nonatomic ) UIButton    *headerBtn;
@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UIView      *upLineView;
@property (strong, nonatomic) UIView      *downLineView;
@property (strong,nonatomic ) UIButton    *leftBtn;
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic ,strong) UIImageView *leftImg;
@property (nonatomic, strong) UIImageView *dotRed;
@property (nonatomic,strong)  UILabel     *descriptionLabel;

@end

#pragma mark --XKRWCommonCellNoImage
@interface XKRWNoImageCommonCell : UITableViewCell
@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UIView      *upLineView;
@property (strong, nonatomic) UIView      *downLineView;
@property (strong,nonatomic ) UIButton    *leftBtn;
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic ,strong) UIImageView *leftImg;
@property (nonatomic, strong) UIImageView *dotRed;
@property (nonatomic,strong)  UILabel     *descriptionLabel;

@end


#pragma mark - XKRWCommitCell
@interface XKRWCommitCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isHideArrow:(BOOL) isHidden;


@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *upLineView;

@end

#pragma mark - XKRWSwitchCell
@interface XKRWSwitchCell : UITableViewCell
@property (strong, nonatomic) SevenSwitch *passwordSwithBtn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *upLineView;
@property (nonatomic, strong) UIView *downLineView;

@end

#pragma mark - XKRWCacheCell
@interface XKRWCacheCell : UITableViewCell

@property (strong, nonatomic) UILabel *cacheLabel;
@property (strong, nonatomic) UIButton *clearCacheBtn;
@property (nonatomic, strong)UIView *downLineView;


-(void) upLoad;
@end


#pragma mark - XKRWFeedbackCell
@interface XKRWFeedbackCell : UITableViewCell
@property (nonatomic,strong)  UILabel     *descriptionLabel;
@property(strong,nonatomic) UIButton* headerBtn;
@property (nonatomic, strong) UIView *upLineView;
@property (strong, nonatomic) UIView          *downLineView;
@property (strong,nonatomic) UIImageView * moreRedDotView;
@end


