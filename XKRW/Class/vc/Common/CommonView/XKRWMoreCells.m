//
//  XKRWMoreCells.m
//  XKRW
//
//  Created by zhanaofan on 14-6-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWMoreCells.h"
#import "XKRWUserService.h"

@implementation XKRWMoreCells

@end

@implementation XKRWUserInfoCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.frame=CGRectMake(0, 0, XKAppWidth, self.frame.size.height);
        //头像
        self.headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headerButton.frame = CGRectMake((XKAppWidth-80)/2, -60 , 80, 80);
        self.headerButton.layer.cornerRadius = 40;
        self.headerButton.clipsToBounds = YES;
        
        [self.headerButton addTarget:self action:@selector(changeUserHeadImageAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //昵称
        self.nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake((XKAppWidth-200)/2, 20, 200, 30)];
        self.nickNameLabel.numberOfLines=0;
        self.nickNameLabel.font = XKDefaultFontWithSize(16);
        self.nickNameLabel.textColor=[UIColor colorFromHexString:@"#333333"];
        self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
        
        //减肥宣言
        self.menifestoLabel = [[UILabel alloc] initWithFrame:CGRectMake((XKAppWidth-200)/2,self.nickNameLabel.bottom , 200, 20)];
        [self.menifestoLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [self.menifestoLabel setFont:XKDefaultFontWithSize(14)];
        self.menifestoLabel.textAlignment = NSTextAlignmentCenter;

        self.downLineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 83.5, XKAppWidth, 0.5)];
        [_downLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        
        self.upLineView =[[UIView alloc]initWithFrame:CGRectMake(0.f, 0, XKAppWidth, 0.5)];
        [_upLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        
        self.rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right5_3"]];
        self.rightImg.contentMode = UIViewContentModeScaleAspectFit;
        self.rightImg.right = XKAppWidth - 15;
        self.rightImg.top = (self.frame.size.height - self.rightImg.frame.size.height)/2;
        
        [self.contentView addSubview:_headerButton];
        [self.contentView addSubview: self.nickNameLabel];
        [self.contentView addSubview:_downLineView];
        [self.contentView addSubview:self.menifestoLabel];
        [self.contentView addSubview: self.rightImg];
    }
    return self;
}

- (void)changeUserHeadImageAction:(UIButton *)button
{
    if(self.userinfoDelegate && [self.userinfoDelegate respondsToSelector:@selector(changeUserInfoHeadImage)]){
    
        [self.userinfoDelegate changeUserInfoHeadImage];
    }

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        if (CGRectContainsPoint(self.headerButton.frame, point)) {
            view = self.headerButton;
        }
    }
    return view;
}




@end

@implementation XKRWCommonCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.headerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.headerBtn.frame=CGRectMake(15, (44-23)/2, 23, 23);
        [self.contentView addSubview:self.headerBtn];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,5,80,30)];
        [_titleLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        
        self.upLineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0, XKAppWidth, 0.5)];
        [_upLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        [_upLineView setHidden:YES];
        
        self.downLineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 43.5, XKAppWidth, 0.5)];
        [_downLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        
        self.rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right5_3"]];
        self.rightImg.contentMode = UIViewContentModeScaleAspectFit;
        self.rightImg.right = XKAppWidth - 15;
        self.rightImg.top = (self.frame.size.height - self.rightImg.frame.size.height)/2;
        
        self.leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, (44-29)/2, 29, 29)];
      
        self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.right, self.titleLabel.top, self.rightImg.left-self.titleLabel.right - 10, self.titleLabel.height)];
        self.descriptionLabel.font = XKDefaultFontWithSize(13.f);
        self.descriptionLabel.textAlignment = NSTextAlignmentRight;
        self.descriptionLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_upLineView];
        [self.contentView addSubview:_downLineView];
        [self.contentView addSubview:self.descriptionLabel];
        [self.contentView addSubview: _leftImg];
        [self.contentView addSubview: _rightImg];
        
        _dotRed = [[UIImageView alloc] initWithFrame:CGRectMake(160.f, 18, 6, 6)];
        _dotRed.image = [UIImage imageNamed:@"unread_red_dot"];
        [_dotRed setHidden:YES];
        [self.contentView addSubview:_dotRed];
        
    }
    
    return self;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    CGSize size = [XKRWCui SizeOfFont:[UIFont systemFontOfSize:16.0] Str:_titleLabel.text];
    _dotRed.frame = CGRectMake(_titleLabel.frame.origin.x +  size.width +5, 18, 6, 6);
    
}

@end


@implementation XKRWNoImageCommonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,5,150,30)];
        [_titleLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        
        self.upLineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0, XKAppWidth, 0.5)];
        [_upLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        [_upLineView setHidden:YES];
        
        self.downLineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 43.5, XKAppWidth, 0.5)];
        [_downLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        
        self.rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right5_3"]];
        self.rightImg.contentMode = UIViewContentModeScaleAspectFit;
        self.rightImg.right = XKAppWidth - 15;
        self.rightImg.top = (self.frame.size.height - self.rightImg.frame.size.height)/2;
        
        self.leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, (44-29)/2, 29, 29)];
        
        self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.right, self.titleLabel.top, self.rightImg.left-self.titleLabel.right - 10, self.titleLabel.height)];
        self.descriptionLabel.font = XKDefaultFontWithSize(13.f);
        self.descriptionLabel.textAlignment = NSTextAlignmentRight;
        self.descriptionLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_upLineView];
        [self.contentView addSubview:_downLineView];
        [self.contentView addSubview:self.descriptionLabel];
        [self.contentView addSubview: _leftImg];
        [self.contentView addSubview: _rightImg];
        
        _dotRed = [[UIImageView alloc] initWithFrame:CGRectMake(160.f, 18, 6, 6)];
        _dotRed.image = [UIImage imageNamed:@"unread_red_dot"];
        [_dotRed setHidden:YES];
        [self.contentView addSubview:_dotRed];
        
    }
    
    return self;
}


- (void) layoutSubviews{
    [super layoutSubviews];
    CGSize size = [XKRWCui SizeOfFont:[UIFont systemFontOfSize:16.0] Str:_titleLabel.text];
    _dotRed.frame = CGRectMake(_titleLabel.frame.origin.x +  size.width +5, 18, 6, 6);
    
}

@end

@implementation XKRWCommitCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isHideArrow:(BOOL) isHidden
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 150, 30)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        
        self.upLineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0, XKAppWidth, 0.5)];
        [_upLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        
        [self.contentView addSubview:_titleLabel];
        //        [self.contentView addSubview:arrowImageV];
        [self.contentView addSubview:_upLineView];
        
        if (!isHidden) {
            UIImageView *rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right5_3"]];
            rightImg.contentMode = UIViewContentModeScaleAspectFit;
            rightImg.right = XKAppWidth - 15;
            rightImg.top = (self.frame.size.height - rightImg.frame.size.height)/2;
       
            [self.contentView addSubview: rightImg];
        }
    }
    return self;
}


@end


@implementation XKRWSwitchCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 150, 30)];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [_label setFont:[UIFont systemFontOfSize:16.0]];
       
        
        self.passwordSwithBtn = [[SevenSwitch alloc] initWithFrame:CGRectMake(XKAppWidth-67.f, 6, 52.f, 32.f)];
        _passwordSwithBtn.onColor = XKMainToneColor_29ccb1;
        _passwordSwithBtn.inactiveColor = [UIColor whiteColor];
        
        self.upLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        [_upLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        
        self.downLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, XKAppWidth, 0.5)];
        [self.downLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_passwordSwithBtn];
        [self.contentView addSubview:_upLineView];
        [self.contentView addSubview:self.downLineView];
    }
    
    return self;
}

@end


@implementation XKRWCacheCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 40, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [label setFont:[UIFont systemFontOfSize:16.0]];
        [label setText:@"缓存"];
        
        self.cacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 140, 30)];
        [_cacheLabel setBackgroundColor:[UIColor clearColor]];
        [_cacheLabel setTextColor:XKMainSchemeColor];
        [_cacheLabel setFont:XKDefaultNumEnFontWithSize(16.f)];
        
        self.clearCacheBtn = [[UIButton alloc] initWithFrame:CGRectMake(XKAppWidth-82,(44-26)/2, 70, 26)];
        [self.clearCacheBtn setTitle:@"清除缓存" forState:UIControlStateNormal];
        [self.clearCacheBtn setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
        [self.clearCacheBtn setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
        [self.clearCacheBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.clearCacheBtn.titleLabel.font = XKDefaultFontWithSize(14);
        self.clearCacheBtn.layer.cornerRadius = 1.5;
        self.clearCacheBtn.layer.borderWidth = 1;
        self.clearCacheBtn.layer.borderColor = XKMainSchemeColor.CGColor;
        self.downLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, XKAppWidth, 0.5)];
        [_downLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        [self.contentView addSubview:_downLineView];
        
        [self.contentView addSubview:label];
        [self.contentView addSubview:_cacheLabel];
        [self.contentView addSubview:_clearCacheBtn];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        topLine.backgroundColor = XK_ASSIST_LINE_COLOR;
        
        [self.contentView addSubview:topLine];
    }
    
    return self;
}

-(void) upLoad{
    _downLineView.hidden = YES;
}

@end

@implementation XKRWFeedbackCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 85, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [label setFont:[UIFont systemFontOfSize:16.0]];
        [label setText:@"帮助与反馈"];
        
        self.upLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        [_upLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        [self.contentView addSubview:_upLineView];
        
        self.downLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44-0.5, XKAppWidth, 0.5)];
        [_downLineView setBackgroundColor:XK_ASSIST_LINE_COLOR];
        
        [self.contentView addSubview:label];
        [self.contentView addSubview:_downLineView];
        
        UIImageView *rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right5_3"]];
        rightImg.contentMode = UIViewContentModeScaleAspectFit;
        rightImg.right = XKAppWidth - 15;
        rightImg.top = (self.frame.size.height - rightImg.frame.size.height)/2;
         [self.contentView addSubview: rightImg];
        
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right, label.top, rightImg.left-label.right,label.height)];
        _descriptionLabel.font = XKDefaultFontWithSize(13.f);
        _descriptionLabel.textAlignment = NSTextAlignmentRight;
        _descriptionLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        [self.contentView addSubview:_descriptionLabel];
        
        UIImage *redDot = [UIImage imageNamed:@"unread_red_dot"];
        _moreRedDotView = [[UIImageView alloc] initWithImage:redDot];
        CGRect rect = CGRectMake(label.right, label.top+13, 6, 6 );
        _moreRedDotView.frame = rect;
        _moreRedDotView.hidden = YES;
        [self.contentView addSubview:_moreRedDotView];
    }
    return self;
}


@end

