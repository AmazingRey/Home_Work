//
//  XKRWRecordWeightFeedBackVC.m
//  XKRW
//
//  Created by ss on 16/6/22.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecordWeightFeedBackVC.h"
#import <XKRW-Swift.h>
#import "XKRWRecordFeedbackShareView.h"
#import "Masonry.h"

@interface XKRWRecordWeightFeedBackVC ()<XKRWRecordFeedbackShareViewDelegate>
@property (nonatomic, strong) XKRWWeightGoalView          *weightGoalView;
@property (nonatomic, strong) UILabel                     *toplabel;
@property (nonatomic, strong) UIImageView                 *inspireView;
@property (nonatomic, strong) UILabel                     *resultlabel1;
@property (nonatomic, strong) UILabel                     *resultlabel2;
@property (nonatomic, strong) UIButton                    *firstBtn;
@property (nonatomic, strong) UIButton                    *closeBtn;
@property (nonatomic, strong) XKRWRecordFeedbackShareView *shareView;

@end

@implementation XKRWRecordWeightFeedBackVC
{
    CGFloat oriWeight;
    CGFloat destWeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    oriWeight = [[XKRWUserService sharedService ]getUserOrigWeight]/1000.0;
    destWeight = [[XKRWUserService sharedService ]getUserDestiWeight]/1000.0;
    [self makeMasonryAulayout];
}

- (UILabel *)toplabel{
    if (!_toplabel) {
        _toplabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
        _toplabel.text = @"体重已保存!";
        _toplabel.textAlignment = NSTextAlignmentCenter;
        _toplabel.textColor = colorSecondary_333333;
        _toplabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:_toplabel];
    }
    return _toplabel;
}

- (XKRWWeightGoalView *)weightGoalView{
    if (!_weightGoalView) {
        _weightGoalView = [[XKRWWeightGoalView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 116.5)];
        [_weightGoalView setOriginWeight:oriWeight curWeight:_curWeight destWeight:destWeight];
        [self.view addSubview:_weightGoalView];
    }
    return _weightGoalView;
}

- (UIImageView *)inspireView{
    if (!_inspireView) {
        _inspireView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppWidth/456*103)];
        NSString *imageName = _moreThanLastRecord ? @"fighting": @"congratulations";
        _inspireView.image = [UIImage imageNamed:imageName];
        _inspireView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_inspireView];
    }
    return _inspireView;
}

- (UILabel *)resultlabel1{
    if (!_resultlabel1) {
        _resultlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
        _resultlabel1.text = @"比上一次测量";
        _resultlabel1.font = [UIFont systemFontOfSize:18];
        _resultlabel1.textColor = colorSecondary_333333;
        _resultlabel1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_resultlabel1];
    }
    return _resultlabel1;
}

- (UILabel *)resultlabel2{
    if (!_resultlabel2) {
        _resultlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 30)];
        NSString *resultStr = _moreThanLastRecord ? [NSString stringWithFormat:@"胖了%.1fkg",_curWeight-_lastReocrdWeight] : [NSString stringWithFormat:@"瘦了%.1fkg",_lastReocrdWeight-_curWeight];
        _resultlabel2.text = resultStr;
        _resultlabel2.font = [UIFont systemFontOfSize:18];
        _resultlabel2.textColor = colorSecondary_333333;
        _resultlabel2.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_resultlabel2];
    }
    return _resultlabel2;
}

- (UIButton *)firstBtn{
    if (!_firstBtn) {
        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstBtn setFrame:CGRectMake(0, 0, 150, 40)];
        NSString *title = _moreThanLastRecord ? @"我会继续努力" : @"炫耀一下";
        [_firstBtn setTitle:title forState:UIControlStateNormal];
        [_firstBtn setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
        _firstBtn.layer.borderWidth = .5;
        _firstBtn.layer.cornerRadius = 10;
        _firstBtn.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
        [_firstBtn addTarget:self action:@selector(firstButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_firstBtn];
    }
    return _firstBtn;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectMake(0, 0, 150, 40)];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (void)makeMasonryAulayout{
    [self.toplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55 * XKRWScaleHeight);
        make.left.right.equalTo(@0);
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(30 * XKRWScaleHeight);
    }];
    [self.weightGoalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toplabel.mas_bottom).offset(27.5* XKRWScaleHeight);
        make.left.right.equalTo(@0);
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(116.5* XKRWScaleHeight);
    }];
    [self.inspireView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.weightGoalView.mas_bottom).offset(75 * XKRWScaleHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(XKAppWidth/3*2* XKRWScaleWidth);
        make.height.mas_equalTo(XKAppWidth/3*2/456*103* XKRWScaleHeight);
    }];
    [self.resultlabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inspireView.mas_bottom).offset(40);
        make.left.right.equalTo(@0);
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(30 * XKRWScaleHeight);
    }];
    [self.resultlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resultlabel1.mas_bottom);
        make.left.right.equalTo(@0);
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(30 * XKRWScaleHeight);
    }];
    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resultlabel2.mas_bottom).offset(60 * XKRWScaleHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(150* XKRWScaleWidth);
        make.height.mas_equalTo(40* XKRWScaleHeight);
    }];
    if (!_moreThanLastRecord) {
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstBtn.mas_bottom).offset(10 * XKRWScaleHeight);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(150 * XKRWScaleWidth);
            make.height.mas_equalTo(40 * XKRWScaleHeight);
        }];
    }
}

- (void)firstButtonPress:(UIButton *)button{
    if (_moreThanLastRecord) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        if (!_shareView) {
            _shareView = [[XKRWRecordFeedbackShareView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight) changeWeight:( _lastReocrdWeight-_curWeight) totalChangeWeight:(oriWeight - _curWeight)];
            _shareView.alpha = 0;
            _shareView.delegate = self;
        }
        [UIView animateWithDuration:.35 animations:^{
            [self.view addSubview:_shareView];
            _shareView.alpha = 1;
        }completion:^(BOOL finished) {
             [_shareView addShareActionsheet];
        }];
    }
}

- (void)closeButtonPress:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark XKRWRecordFeedbackShareView *shareView
- (void)tapFeedbackShareView{
    [UIView animateWithDuration:.35 animations:^{
        _shareView.alpha = 0;
    } completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end