//
//  XKRWStatiscHeadView.m
//  XKRW
//
//  Created by ss on 16/4/29.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWStatiscHeadView.h"
#import "Masonry.h"

#define LabLength XKAppWidth/4 - 10

@implementation XKRWStatiscHeadView
- (instancetype)initWithFrame:(CGRect)frame type:(StatisticType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self makeMasonryLayout];
    }
    return self;
}

#pragma getter Method
-(UILabel *)lab1{
    if (!_lab1) {
        _lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
        if (_type == 1) {
            [self lab1ReloadText:@"第1周"];
        }else{
            _lab1.text = @"2015年5月12日－至今";
        }
        _lab1.textAlignment = NSTextAlignmentCenter;
        _lab1.font = [UIFont systemFontOfSize:15];
        [self addSubview:_lab1];
    }
    return _lab1;
}

-(void)lab1ReloadText:(NSString *)week{
    NSString *weightTarget = @"90kg";
    NSString *string = [NSString stringWithFormat:@"目标%@%@",weightTarget,week];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName value:colorSecondary_333333 range:NSMakeRange(0, 2)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:XKMainToneColor_29ccb1 range:[string rangeOfString:weightTarget]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:colorSecondary_333333 range:[string rangeOfString:week]];
    //        NSTextAttachment *textAttachment = [NSTextAttachment new];
    //        textAttachment.image = [UIImage imageNamed:@"dropdown menu"];
    //        NSAttributedString *imgString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //        [attributeStr replaceCharactersInRange:[string rangeOfString:@"*"] withAttributedString:imgString];
    _lab1.attributedText = attributeStr;
}

-(UIButton *)btnDown{
    if (!_btnDown) {
        _btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDown setImage:[UIImage imageNamed:@"dropdown menu"] forState:UIControlStateNormal];
        [_btnDown addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnDown];
    }
    return _btnDown;
}

-(UILabel *)lab2{
    if (!_lab2) {
        NSString *startDate = @"2016年5月12日";
        NSString *endDate = @"2016年5月18日";
        _lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
        NSString *dateRangeStr = [NSString stringWithFormat:@"%@-%@",startDate,endDate];
        _lab2.text = dateRangeStr;
        _lab2.textAlignment = NSTextAlignmentCenter;
        _lab2.textColor = colorSecondary_999999;
        _lab2.font = [UIFont systemFontOfSize:12];
        [self addSubview:_lab2];
    }
    return _lab2;
}

-(UIView *)view1{
    if (!_view1) {
        _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, .5)];
        _view1.backgroundColor = colorSecondary_999999;
        [self addSubview:_view1];
    }
    return _view1;
}

-(UILabel *)lab3{
    if (!_lab3) {
        NSString *str = @"体重";
        _lab3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth/4, 25)];
        _lab3.text = str;
        _lab3.textAlignment = NSTextAlignmentCenter;
        _lab3.textColor = colorSecondary_333333;
        _lab3.font = [UIFont systemFontOfSize:12];
        [self addSubview:_lab3];
    }
    return _lab3;
}

-(UILabel *)subLab3{
    if (!_subLab3) {
        _subLab3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth/4, 25)];
        _subLab3.text = @"98kg";
        _subLab3.textAlignment = NSTextAlignmentCenter;
        _subLab3.textColor = colorSecondary_333333;
        _subLab3.font = [UIFont systemFontOfSize:12];
        [self addSubview:_subLab3];
    }
    return _subLab3;
}

-(UIView *)view2{
    if (!_view2) {
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, .5,11)];
        _view2.backgroundColor = colorSecondary_999999;
        [self addSubview:_view2];
    }
    return _view2;
}

-(UILabel *)lab4{
    if (!_lab4) {
        NSString *str = @"体重变化";
        _lab4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
        _lab4.text = str;
        _lab4.textAlignment = NSTextAlignmentCenter;
        _lab4.font = [UIFont systemFontOfSize:12];
        _lab4.textColor = colorSecondary_333333;
        [self addSubview:_lab4];
    }
    return _lab4;
}

-(UILabel *)subLab4{
    if (!_subLab4) {
        _subLab4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth/4, 25)];
        _subLab4.text = @"减重2.1kg";
        _subLab4.textAlignment = NSTextAlignmentCenter;
        _subLab4.font = [UIFont systemFontOfSize:12];
        _subLab4.textColor = XKMainToneColor_29ccb1;
        [self addSubview:_subLab4];
    }
    return _subLab4;
}

-(UIView *)view3{
    if (!_view3) {
        _view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, .5,11)];
        _view3.backgroundColor = colorSecondary_999999;
        [self addSubview:_view3];
    }
    return _view3;
}

-(UILabel *)lab5{
    if (!_lab5) {
        NSString *str = @"记录";
        _lab5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
        _lab5.text = str;
        _lab5.textAlignment = NSTextAlignmentCenter;
        _lab5.font = [UIFont systemFontOfSize:12];
        _lab5.textColor = colorSecondary_333333;
        [self addSubview:_lab5];
    }
    return _lab5;
}

-(UILabel *)subLab5{
    if (!_subLab5) {
        _subLab5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth/4, 25)];
        _subLab5.text = @"2天";
        _subLab5.textAlignment = NSTextAlignmentCenter;
        _subLab5.font = [UIFont systemFontOfSize:12];
        _subLab5.textColor = XKWarningColor;
        [self addSubview:_subLab5];
    }
    return _subLab5;
}

-(UIView *)view4{
    if (!_view4) {
        _view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, .5,11)];
        _view4.backgroundColor = colorSecondary_999999;
        [self addSubview:_view4];
    }
    return _view4;
}

-(UILabel *)lab6{
    if (!_lab6) {
        NSString *str = @"完成";
        _lab6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
        _lab6.text = str;
        _lab6.textAlignment = NSTextAlignmentCenter;
        _lab6.textColor = colorSecondary_333333;
        _lab6.font = [UIFont systemFontOfSize:12];
        [self addSubview:_lab6];
    }
    return _lab6;
}

-(UILabel *)subLab6{
    if (!_subLab6) {
        _subLab6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth/4, 25)];
        _subLab6.text = @"2天";
        _subLab6.textAlignment = NSTextAlignmentCenter;
        _subLab6.textColor = XKWarningColor;
        _subLab6.font = [UIFont systemFontOfSize:12];
        [self addSubview:_subLab6];
    }
    return _subLab6;
}

#pragma mark masonry 
-(void)makeMasonryLayout{
    if (_type == 1){
        [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(110);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(11);
        }];
        [self.btnDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_lab1.mas_right).offset(0);
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(18);
            make.centerY.mas_equalTo(self.lab1.mas_centerY);
        }];
        [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(XKAppWidth);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(self.lab1.mas_bottom).offset(4);
        }];

    }else{
        [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(220);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(25);
        }];
    }
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@.5);
        make.left.right.equalTo(@0);
        make.top.mas_equalTo(self.lab1.mas_bottom).offset(30);
    }];
    
    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@.5);
        make.height.equalTo(@11);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.lab1.mas_bottom).offset(55);
    }];
    
    [self.lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabLength);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.view3.mas_right);
        make.centerY.mas_equalTo(self.view3.mas_centerY).offset(-10);
    }];
    
    [self.subLab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabLength);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.view3.mas_right);
        make.centerY.mas_equalTo(self.view3.mas_centerY).offset(10);
    }];
    
    [self.view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@.5);
        make.height.equalTo(@11);
        make.left.mas_equalTo(self.lab5.mas_right);
        make.top.mas_equalTo(self.lab1.mas_bottom).offset(55);
    }];
    
    [self.lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabLength);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.view3.mas_left);
        make.centerY.mas_equalTo(self.view3.mas_centerY).offset(-10);
    }];
    [self.subLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabLength);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.view3.mas_left);
        make.centerY.mas_equalTo(self.view3.mas_centerY).offset(10);
    }];
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@.5);
        make.height.equalTo(@11);
        make.right.mas_equalTo(self.subLab4.mas_left);
        make.top.mas_equalTo(self.lab1.mas_bottom).offset(55);
    }];
    [self.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabLength);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.view2.mas_left);
        make.centerY.mas_equalTo(self.view2.mas_centerY).offset(-10);
    }];
    [self.subLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabLength);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.view2.mas_left);
        make.centerY.mas_equalTo(self.view2.mas_centerY).offset(10);
    }];
    [self.lab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabLength);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.view4.mas_right);
        make.centerY.mas_equalTo(self.view4.mas_centerY).offset(-10);
    }];
    [self.subLab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabLength);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.view4.mas_right);
        make.centerY.mas_equalTo(self.view4.mas_centerY).offset(10);
    }];
}

-(void)btnDownPressed:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(makeAnalysisPickerViewAppear)]) {
        [self.delegate makeAnalysisPickerViewAppear];
    }
}
@end
