//
//  XKRWFoodCell.m
//  XKRW
//
//  Created by zhanaofan on 14-2-14.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWFoodCell.h"
#import "UIImageView+WebCache.h"

@implementation XKRWFoodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
//        self.contentView.backgroundColor = XKClearColor;
        
        //右边的图片
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"enter.png"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(XKAppWidth-44.f, 10.f, 44.f, 44.f)];
        [btn setUserInteractionEnabled:NO];
        [self.contentView addSubview:btn];
        
        
        
        self.textLabel.font = XKBoldFontWithSize(13.f);
        self.textLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        [self.textLabel setBackgroundColor:XKClearColor];
        
        self.detailTextLabel.font = XKDefaultFontWithSize(12.f);
        self.detailTextLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        [self.detailTextLabel setBackgroundColor:XKClearColor];
        
        UIView *sep_line = [[UIView alloc] initWithFrame:CGRectMake(0.f, 63.5f, XKAppWidth, .5f)];
        [sep_line setBackgroundColor:[UIColor colorFromHexString:@"#cccccc"]];

//        self.contentView.backgroundColor = XKBGDefaultColor;
        [self.contentView addSubview:sep_line];

    }
    return self;
}

//设置cell 值
- (void) setCellValue:(NSDictionary *)value
{
    self.textLabel.text = [value objectForKey:@"foodName"];
    uint32_t  energy = [[value objectForKey:@"foodEnergy"] intValue];
    NSString *detailText = [NSString stringWithFormat:@"%ikcal/100克",energy];
    self.detailTextLabel.text = detailText;
    NSString *logoImgUrl = [value objectForKey:@"foodLogo"];
    [self.imageView setImageWithURL: [NSURL URLWithString:logoImgUrl] placeholderImage:[UIImage imageNamed:@"food_default.png"]];
    CALayer *layer  = self.imageView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.f];
    layer.shouldRasterize = YES;
}
//设置 收藏食物cell 值
- (void) setCollectCellValue:(NSDictionary *)value
{
    self.textLabel.text = [value objectForKey:@"collect_name"];
    uint32_t  energy = [[value objectForKey:@"food_energy"] intValue];
    NSString *detailText = [NSString stringWithFormat:@"%ikcal/100克",energy];
    self.detailTextLabel.text = detailText;
    NSString *logoImgUrl = [value objectForKey:@"image_url"];
    [self.imageView setImageWithURL: [NSURL URLWithString:logoImgUrl] placeholderImage:[UIImage imageNamed:@"food_default.png"]];
    CALayer *layer  = self.imageView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.f];
    layer.shouldRasterize = YES;
}

//自定义布局
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(15.f, 7.f, 50.f, 50.f)];
    CGRect titleFrame =  CGRectMake(75.f, 8.f, XKAppWidth-75-44-10, 28.f);
    self.textLabel.frame = titleFrame;
    
    CGRect detailFrame = CGRectMake(75.f, self.frame.size.height-25.f, XKAppWidth-75-44-10, 20.f);
    self.detailTextLabel.frame = detailFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
