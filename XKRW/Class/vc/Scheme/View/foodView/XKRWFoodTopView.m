//
//  XKRWFoodTopView.m
//  XKRW
//
//  Created by zhanaofan on 14-2-7.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWFoodTopView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "XKRWSepLine.h"

@implementation XKRWFoodTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrameAndFoodEntity:(CGRect)frame foodEntity:(id)entity linePosition:(BOOL)linePosition isDetail:(BOOL)isDetail
{
    self = [super initWithFrame:frame];
    if (self) {
        _foodEntity = entity;
        _linePosition = linePosition;
        self.backgroundColor = [UIColor whiteColor];
        UIImage *iv_bg = [[UIImage imageNamed:@"food_top_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.f,1.f,0.f,2.f)];
        UIImageView *bg_iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height)];
        _isDetail = isDetail;
        [bg_iv setImage:iv_bg];
    //    [self addSubview:bg_iv];
        [self drawSubviews];
    }
    return self;
}

- (void) setFoodEntity:(XKRWFoodEntity *)foodEntity{
    _foodEntity = foodEntity;
    [self reDrawSubViews];
}
-(XKRWFoodEntity *)getFoodEntity{
    return _foodEntity;
}
- (void) reDrawSubViews{
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    [self drawSubviews];
}

- (void) drawSubviews
{
    
    //背景
    UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 55.f, 55.f)];
    CALayer *layer  = logoIV.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.f];
    layer.shouldRasterize = YES;
    
    //设置食物Logo
    [logoIV setImageWithURL:[NSURL URLWithString:_foodEntity.foodLogo] placeholderImage:[UIImage imageNamed:@"food_default"]];

    [self addSubview:logoIV];
    
    //食物名称
    UILabel *lbFoodName = [[UILabel alloc] init];
    if (!_isDetail) {//记录
        lbFoodName.frame = CGRectMake(logoIV.frame.origin.x+logoIV.frame.size.width+21.f, 0.f, 160 * (XKAppWidth / 320.f), 75.f);
    }else{//详情
        lbFoodName.frame = CGRectMake(logoIV.frame.origin.x+logoIV.frame.size.width+10.f, 13.f, self.frame.size.width-90.f, 16.f);
    }
    
    lbFoodName.textAlignment = NSTextAlignmentLeft;
    lbFoodName.font = XKDefaultFontWithSize(14.f);
    lbFoodName.textColor  = XK_TITLE_COLOR;
    lbFoodName.text = _foodEntity.foodName;
    lbFoodName.backgroundColor = XKClearColor;
    [self addSubview:lbFoodName];
    
    
    if(!_isDetail){//记录 Kcal
        
    }else{//详情 食物能量值
        UILabel *lbEnergy = [[UILabel alloc] initWithFrame:CGRectMake(lbFoodName.frame.origin.x,lbFoodName.frame.origin.y+lbFoodName.frame.size.height+11.f, lbFoodName.frame.size.width, 14.f)];
        lbEnergy.textAlignment = NSTextAlignmentLeft;
        lbEnergy.font = XKDefaultFontWithSize(14.f);
        lbEnergy.textColor = XK_ASSIST_TEXT_COLOR;
        lbEnergy.text = [NSString stringWithFormat:@"%likcal/100克",(long)_foodEntity.foodEnergy];
        lbEnergy.backgroundColor = XKClearColor;
        [self addSubview:lbEnergy];
        
    }
    
    
    XKRWSepLine *sepline = [[XKRWSepLine alloc ]init];
    if (_linePosition) {
        sepline.frame = CGRectMake(15,self.frame.size.height-1.f, self.frame.size.width, 1.f);
    }else
    {
        sepline.frame = CGRectMake(0.f,self.frame.size.height-1.f, self.frame.size.width, 1.f);
    }
    [self addSubview:sepline];
    
  
}


@end
