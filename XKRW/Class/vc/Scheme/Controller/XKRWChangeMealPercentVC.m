//
//  XKRWChangeMealPercentVC.m
//  XKRW
//
//  Created by 刘睿璞 on 16/4/24.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWChangeMealPercentVC.h"
#import "XKRWMealPercentView.h"
#import "masonry.h"

@interface XKRWChangeMealPercentVC () <XKRWMealPercentViewDelegate>
@property (strong, nonatomic) XKRWMealPercentView *breakFastView;
@property (strong, nonatomic) XKRWMealPercentView *launchView;
@property (strong, nonatomic) XKRWMealPercentView *dinnerView;
@property (strong, nonatomic) XKRWMealPercentView *addmealView;
@end

@implementation XKRWChangeMealPercentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviBarBackButton];
    self.title = @"调整四餐比例";
    [self makeDicData];
    
}

-(void)makeDicData{
    _dicData = [NSMutableDictionary dictionary];
    
    [_dicData setObject:[NSNumber numberWithFloat:.3] forKey:@"早餐"];
    [_dicData setObject:[NSNumber numberWithFloat:.4] forKey:@"午餐"];
    [_dicData setObject:[NSNumber numberWithFloat:.1] forKey:@"晚餐"];
    [_dicData setObject:[NSNumber numberWithFloat:.2] forKey:@"加餐"];
    [self addChangeMealView];
}

-(void)addChangeMealView{
    [self.breakFastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@SlideViewLeading);
        make.width.mas_equalTo(SlideViewWidth);
        make.height.equalTo(@SlideViewHeight);
    }];
    
    [self.launchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SlideViewWidth);
        make.height.mas_equalTo(@SlideViewHeight);
        make.leading.mas_equalTo(self.breakFastView.mas_leading);
        make.top.mas_equalTo(self.breakFastView.mas_bottom);
    }];
    
    [self.dinnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SlideViewWidth);
        make.height.mas_equalTo(@SlideViewHeight);
        make.leading.mas_equalTo(self.launchView.mas_leading);
        make.top.mas_equalTo(self.launchView.mas_bottom);
    }];
    
    [self.addmealView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SlideViewWidth);
        make.height.mas_equalTo(@SlideViewHeight);
        make.leading.mas_equalTo(self.dinnerView.mas_leading);
        make.top.mas_equalTo(self.dinnerView.mas_bottom);
    }];
    
    [self makeSliderMasonry:self.breakFastView];
    [self makeSliderMasonry:self.launchView];
    [self makeSliderMasonry:self.dinnerView];
    [self makeSliderMasonry:self.addmealView];
}

-(XKRWMealPercentView *)breakFastView{
    if (_breakFastView == nil) {
        _breakFastView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, 0, SlideViewWidth, SlideViewHeight) currentValue:.3];
        _breakFastView.slider.tag = 3001;
        _breakFastView.delegate = self;
        _breakFastView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_breakFastView];
    }
    
    return _breakFastView;
}

-(XKRWMealPercentView *)launchView{
    if (_launchView == nil) {
        _launchView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, SlideViewHeight, SlideViewWidth, SlideViewHeight) currentValue:.4];
        _launchView.slider.tag = 3002;
        _launchView.delegate = self;
        _launchView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_launchView];
    }
    
    return _launchView;
}

-(XKRWMealPercentView *)dinnerView{
    if (_dinnerView == nil) {
        _dinnerView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, SlideViewHeight*2, SlideViewWidth, SlideViewHeight) currentValue:.1];
        _dinnerView.slider.tag = 3003;
        _dinnerView.delegate = self;
        _dinnerView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:_dinnerView];
    }
    
    return _dinnerView;
}

-(XKRWMealPercentView *)addmealView{
    if (_addmealView == nil) {
        _addmealView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, SlideViewHeight*3, SlideViewWidth, SlideViewHeight) currentValue:.2];
        _addmealView.slider.tag = 3004;
        _addmealView.delegate = self;
        _addmealView.backgroundColor = [UIColor pinkColor];
        [self.view addSubview:_addmealView];
    }
    
    return _addmealView;
}

-(void)makeSliderMasonry:(XKRWMealPercentView *)obj{
    [obj.slider mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.mas_equalTo(SlideWidth);
        make.height.mas_equalTo(SlideHeight);
        make.left.mas_equalTo(SlideLeading+ImageHeadWidth+LabTitleWidth);
        make.top.mas_equalTo(SlideTop);
    }];
    [obj.labPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabPercentWidth);
        make.height.mas_equalTo(LabPercentHeight);
        make.left.mas_equalTo(obj.slider.mas_right).offset(SlideLeading);
        make.centerY.mas_equalTo(obj.slider.mas_centerY);
    }];
}

-(void)slideDidScroll:(NSInteger)tag currentPercent:(NSInteger)percent{
    CGFloat currentPercent = percent/100;
    CGFloat otherPercent = (1 - currentPercent)/3;
    
    NSLog(@"当前的百分比为：%f , 其他为：%f",currentPercent,otherPercent);
    switch (tag) {
        case 3001:
            [self.launchView.slider setValue:otherPercent animated:YES];
            [self.dinnerView.slider setValue:otherPercent animated:YES];
            [self.addmealView.slider setValue:otherPercent animated:YES];
            break;
        case 3002:
            [self.breakFastView.slider setValue:otherPercent animated:YES];
            [self.dinnerView.slider setValue:otherPercent animated:YES];
            [self.addmealView.slider setValue:otherPercent animated:YES];
            break;
        case 3003:
            [self.launchView.slider setValue:otherPercent animated:YES];
            [self.breakFastView.slider setValue:otherPercent animated:YES];
            [self.addmealView.slider setValue:otherPercent animated:YES];
            break;
        case 3004:
            [self.launchView.slider setValue:otherPercent animated:YES];
            [self.dinnerView.slider setValue:otherPercent animated:YES];
            [self.breakFastView.slider setValue:otherPercent animated:YES];
            break;
        default:
            break;
    }
    
//    [UIView animateWithDuration:1 animations:^{
//        [self.launchView.slider setValue:otherPercent animated:YES];
//        [self.dinnerView.slider setValue:otherPercent animated:YES];
//        [self.addmealView.slider setValue:otherPercent animated:YES];
    
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end