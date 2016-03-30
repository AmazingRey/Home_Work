//
//  XKRWSchemeDetailCell.m
//  XKRW
//
//  Created by zhanaofan on 14-3-9.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSchemeDetailCell.h"

@interface XKRWSchemeDetailCell ()

@end
@implementation XKRWSchemeDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor colorFromHexString:@"#FEF7F2"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = XKDefaultFontWithSize(14.f);
        self.detailTextLabel.font = XKDefaultFontWithSize(13.f);
        self.detailTextLabel.textColor = colorSecondary_666666;
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(XKAppWidth-36, (64-44)/2, 36, 44)];
        arrowImageView.image = [UIImage imageNamed:@"arrow"];
        
        [self.contentView addSubview:arrowImageView];
        
        _sep_line = [[UIView alloc] initWithFrame:CGRectMake(15.f, 63.5f, XKAppWidth-15.f, .5f)];
        [_sep_line setBackgroundColor:[UIColor colorFromHexString:@"#cccccc"]];
        [self.contentView addSubview:_sep_line];
        
    //    [self.contentView addSubview:self.lbSubTitle];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//自定义布局
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel setFrame:CGRectMake(20.f, 10.f, 200.f, 20.f)];
    [self.detailTextLabel setFrame:CGRectMake(20.f, 40.f, 200.f, 14.f)];
//    [self.lbSubTitle setFrame:CGRectMake(220.f, 40.f, 80.f, 14.f)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
