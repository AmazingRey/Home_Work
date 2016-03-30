//
//  XKRWSportCell.m
//  XKRW
//
//  Created by zhanaofan on 14-3-4.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSportCell.h"
//#import "XKRWSepLine.h"

@implementation XKRWSportCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
//        self.contentView.backgroundColor = [UIColor colorFromHexString:@"##FEF7F2"];
        self.textLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        //右边的图片
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"enter.png"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(XKAppWidth-44.f, 0.f, 44.f, 44.f)];
        [btn setUserInteractionEnabled:NO];
        [self.contentView addSubview:btn];
        
//        XKRWSepLine *sepLine = [[XKRWSepLine alloc] initWithFrame:CGRectMake(0.f, self.frame.size.height-1.f, self.frame.size.width, 1.f)];
        
        UIView *sep_line = [[UIView alloc] initWithFrame:CGRectMake(15.f, 44-0.5f, XKAppWidth-15.f, .5f)];
        [sep_line setBackgroundColor:[UIColor colorFromHexString:@"#cccccc"]];
        [self.contentView addSubview:sep_line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//自定义布局
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect titleFrame =  CGRectMake(30.f, 8.f, 240.f, 28.f);
    self.textLabel.frame = titleFrame;
    self.textLabel.font = XKDefaultFontWithSize(14.f);
    self.textLabel.textColor = [UIColor colorFromHexString:@"#333333"];
}

@end
