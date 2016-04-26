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
#import "XKRWUserService.h"

@interface XKRWChangeMealPercentVC () <XKRWMealPercentViewDelegate>
@property (strong, nonatomic) XKRWMealPercentView *breakFastView;
@property (strong, nonatomic) XKRWMealPercentView *lunchView;
@property (strong, nonatomic) XKRWMealPercentView *dinnerView;
@property (strong, nonatomic) XKRWMealPercentView *addmealView;
@property (strong, nonatomic) NSMutableDictionary *dicLockTags;
@property (assign, nonatomic) NSInteger currentMax;
@property (strong, nonatomic) UILabel *labExplain;
@property (strong, nonatomic) UIButton *btnDefault;
//@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation XKRWChangeMealPercentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviBarBackButton];
    [self addNaviBarRightButtonWithText:@"保存" action:@selector(saveData)];
    self.title = @"调整四餐比例";
    _currentMax = 100;
    _dicLockTags = [NSMutableDictionary dictionary];
    [self makeDicData];
}

-(void)setCurrentMax:(NSInteger)currentMax{
    if (_currentMax != currentMax) {
        _currentMax = currentMax;
    }
    
    if (_currentMax < 0) {
        _currentMax = 0;
    }
}

-(void)makeDicData{
    _arrMealRatio = [@[@3,@4,@1,@2] mutableCopy];
    
    _dicData = [NSMutableDictionary dictionary];
    NSDictionary *dic = [[XKRWUserService sharedService] getMealRatio];
    [_dicData addEntriesFromDictionary:dic];
    
    [_dicData setObject:[NSNumber numberWithFloat:.3] forKey:@"早餐"];
    [_dicData setObject:[NSNumber numberWithFloat:.4] forKey:@"午餐"];
    [_dicData setObject:[NSNumber numberWithFloat:.1] forKey:@"晚餐"];
    [_dicData setObject:[NSNumber numberWithFloat:.2] forKey:@"加餐"];
    [self addChangeMealView];
}

-(void)saveData{
    [[XKRWUserService sharedService] saveMealRatioWithBreakfast:[[_dicData objectForKey:@"早餐"] integerValue] andLunch:[[_dicData objectForKey:@"午餐"] integerValue] andSnack:[[_dicData objectForKey:@"晚餐"] integerValue] andSupper:[[_dicData objectForKey:@"加餐"] integerValue]];
}

-(void)addChangeMealView{
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.bottom.equalTo(@0);
//        make.leading.equalTo(@0);
//        make.trailing.equalTo(@0);
//    }];
    
    [self.breakFastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@SlideViewLeading);
        make.width.mas_equalTo(SlideViewWidth);
        make.height.equalTo(@SlideViewHeight);
    }];
    
    [self.lunchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SlideViewWidth);
        make.height.mas_equalTo(@SlideViewHeight);
        make.leading.mas_equalTo(self.breakFastView.mas_leading);
        make.top.mas_equalTo(self.breakFastView.mas_bottom);
    }];

    [self.dinnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SlideViewWidth);
        make.height.mas_equalTo(@SlideViewHeight);
        make.leading.mas_equalTo(self.lunchView.mas_leading);
        make.top.mas_equalTo(self.lunchView.mas_bottom);
    }];
    
    [self.addmealView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SlideViewWidth);
        make.height.mas_equalTo(@SlideViewHeight);
        make.leading.mas_equalTo(self.dinnerView.mas_leading);
        make.top.mas_equalTo(self.dinnerView.mas_bottom);
    }];

    [self.labExplain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SlideViewWidth);
//        make.height.mas_equalTo(@SlideViewHeight);
        make.leading.mas_equalTo(self.dinnerView.mas_leading);
        make.top.mas_equalTo(self.addmealView.mas_bottom).offset(30);
    }];
    
    [self.btnDefault mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.labExplain.mas_centerX);
        make.top.mas_equalTo(self.labExplain.mas_bottom).offset(30);
    }];
    
    [self makeSliderMasonry:self.breakFastView];
    [self makeSliderMasonry:self.lunchView];
    [self makeSliderMasonry:self.dinnerView];
    [self makeSliderMasonry:self.addmealView];
    
//    CGFloat screenH = XKAppHeight;
//    CGFloat totalHeight = self.labExplain.frame.origin.y + self.labExplain.frame.size.height + 4*SlideViewHeight + self.btnDefault.frame.size.height + 30 + 50;
//    if (totalHeight > screenH) {
//        NSLog(@"高度超了");
//        _scrollView.scrollEnabled = YES;
//    }
//        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//        scrollView.contentSize = CGSizeMake(XKAppWidth, totalHeight);
}

//-(UIScrollView *)scrollView{
//    if (_scrollView == nil) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview:_scrollView];
//    }
//    return _scrollView;
//}

-(XKRWMealPercentView *)breakFastView{
    if (_breakFastView == nil) {
        _breakFastView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, 0, SlideViewWidth, SlideViewHeight) currentValue:[_dicData objectForKey:@"早餐"]];
        _breakFastView.slider.tag = 3001;
        _breakFastView.imgHead.image = [UIImage imageNamed:@"breakfast5_3"];
        _breakFastView.labTitle.text = @"早餐";
        _breakFastView.delegate = self;
        [self.view addSubview:_breakFastView];
    }
    return _breakFastView;
}

-(XKRWMealPercentView *)lunchView{
    if (_lunchView == nil) {
        _lunchView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, SlideViewHeight, SlideViewWidth, SlideViewHeight) currentValue:[_dicData objectForKey:@"午餐"]];
        _lunchView.slider.tag = 3002;
        _lunchView.imgHead.image = [UIImage imageNamed:@"lunch5_3"];
        _lunchView.labTitle.text = @"午餐";
        _lunchView.delegate = self;
        [self.view addSubview:_lunchView];
    }
    return _lunchView;
}

-(XKRWMealPercentView *)dinnerView{
    if (_dinnerView == nil) {
        _dinnerView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, SlideViewHeight*2, SlideViewWidth, SlideViewHeight) currentValue:[_dicData objectForKey:@"晚餐"]];
        _dinnerView.slider.tag = 3003;
        _dinnerView.imgHead.image = [UIImage imageNamed:@"dinner5_3"];
        _dinnerView.labTitle.text = @"晚餐";
        _dinnerView.delegate = self;
        [self.view addSubview:_dinnerView];
    }
    
    return _dinnerView;
}

-(XKRWMealPercentView *)addmealView{
    if (_addmealView == nil) {
        _addmealView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, SlideViewHeight*3, SlideViewWidth, SlideViewHeight) currentValue:[_dicData objectForKey:@"加餐"]];
        _addmealView.slider.tag = 3004;
        _addmealView.imgHead.image = [UIImage imageNamed:@"addmeal5_3"];
        _addmealView.labTitle.text = @"加餐";
        _addmealView.delegate = self;
        [self.view addSubview:_addmealView];
    }
    
    return _addmealView;
}

-(UILabel *)labExplain{
    if (_labExplain == nil) {
        _labExplain = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _labExplain.numberOfLines = 0;
        _labExplain.textAlignment = NSTextAlignmentLeft;
        _labExplain.textColor = colorSecondary_999999;
        _labExplain.font = [UIFont systemFontOfSize:17];
        _labExplain.text = @"调节四餐比例来将每日摄入总热量按比例分配给四餐，默认推荐比例为：3:4:1:2。在调节时，锁定的餐次比例将固定不变，只调节其他餐次比例。";
        [self.view addSubview:_labExplain];
         }
    return _labExplain;
}

-(UIButton *)btnDefault{
    if (_btnDefault == nil) {
        _btnDefault = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDefault.frame = CGRectMake(0, 0, 136, 33);
        [_btnDefault setTitle:@"恢复默认" forState:UIControlStateNormal];
        [_btnDefault setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
        _btnDefault.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnDefault.layer.borderWidth = 1.0;
        _btnDefault.layer.cornerRadius = 8;
        _btnDefault.titleLabel.font = [UIFont systemFontOfSize:17];
        _btnDefault.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
        [_btnDefault addTarget:self action:@selector(actDefault:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnDefault];
    }
    return _btnDefault;
}

-(void)makeSliderMasonry:(XKRWMealPercentView *)obj{
    
    [obj.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ImageHeadWidth);
        make.height.mas_equalTo(ImageHeadHeight);
        make.left.equalTo(@0);
        make.top.mas_equalTo(SlideTop);
    }];
    [obj.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabTitleWidth);
        make.height.mas_equalTo(LabTitleHeight);
        make.left.mas_equalTo(obj.imgHead.mas_right).offset(SlideLeading);
        make.centerY.mas_equalTo(obj.imgHead.mas_centerY);
    }];
    
    [obj.btnLock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ButtonLockWidth);
        make.height.mas_equalTo(ButtonLockHeight);
        make.right.equalTo(@0);
        make.centerY.mas_equalTo(obj.imgHead.mas_centerY);
    }];
    [obj.labPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LabPercentWidth);
        make.height.mas_equalTo(LabPercentHeight);
        make.right.mas_equalTo(obj.btnLock.mas_left);
        make.centerY.mas_equalTo(obj.imgHead.mas_centerY);
    }];
    [obj.slider mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(SlideHeight);
        make.left.mas_equalTo(obj.labTitle.mas_right).offset(SlideLeading);
        make.right.mas_equalTo(obj.labPercent.mas_left).offset(-SlideLeading*2);
        make.centerY.mas_equalTo(obj.imgHead.mas_centerY);
    }];
    [obj.labSeperate mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@1);
        make.left.mas_equalTo(obj.imgHead.mas_left);
        make.right.mas_equalTo(obj.btnLock.mas_right);
        make.bottom.equalTo(@1);
    }];
}

-(void)lockMealPercentView:(NSInteger)tag withPercent:(NSInteger)percent lock:(BOOL)lock{
    self.currentMax += lock?(-percent):percent;
    if (lock) {
        [_dicLockTags setObject:[NSNumber numberWithInteger:percent] forKey:[NSNumber numberWithInteger:tag]];
    }else{
        [_dicLockTags removeObjectForKey:[NSNumber numberWithInteger:tag]];
    }
}

-(void)slideDidScroll:(NSInteger)tag currentPercent:(NSInteger)percent{
    if (percent > _currentMax) {
        percent = _currentMax;
    }
    NSDictionary *dic = [self calculateData:tag Percent:percent];
    NSInteger percent1 = [[dic objectForKey:[NSNumber numberWithInteger:3001]] integerValue];
    NSInteger percent2 = [[dic objectForKey:[NSNumber numberWithInteger:3002]] integerValue];
    NSInteger percent3 = [[dic objectForKey:[NSNumber numberWithInteger:3003]] integerValue];
    NSInteger percent4 = [[dic objectForKey:[NSNumber numberWithInteger:3004]] integerValue];
    
    float value1 = percent1 / 100.0f;
    float value2 = percent2 / 100.0f;
    float value3 = percent3 / 100.0f;
    float value4 = percent4 / 100.0f;
    
    [self setCurrentOtherSliderView:self.breakFastView Percent:percent1 Value:value1];
    [self setCurrentOtherSliderView:self.lunchView Percent:percent2 Value:value2];
    [self setCurrentOtherSliderView:self.dinnerView Percent:percent3 Value:value3];
    [self setCurrentOtherSliderView:self.addmealView Percent:percent4 Value:value4];
}

-(void)setCurrentOtherSliderView:(XKRWMealPercentView *)view Percent:(NSInteger)percent Value:(float)value{
    if (!view.lock) {
        view.labPercent.text = [NSString stringWithFormat:@"%ld%%",(long)percent];
        [view.slider setValue:value animated:YES];
    }
}

-(NSDictionary *)calculateData:(NSInteger)tag Percent:(NSInteger)percent{
    CGFloat total = 0.0;
    NSMutableDictionary *dicRatio = [NSMutableDictionary dictionary];
    [dicRatio setObject:[NSNumber numberWithInteger:percent] forKey:[NSNumber numberWithInteger:tag]];
    
    for (NSNumber *num2 in _arrMealRatio) {
        NSInteger curTag2 = [_arrMealRatio indexOfObject:num2] + 3001;
        if (curTag2 != tag && ![[_dicLockTags allKeys] containsObject:[NSNumber numberWithInteger:curTag2]]) {
            total += [num2 floatValue];
        }
    }
    
    for (NSNumber *num3 in _arrMealRatio) {
        NSInteger curTag3 = [_arrMealRatio indexOfObject:num3] + 3001;
        if (curTag3 != tag  && ![[_dicLockTags allKeys] containsObject:[NSNumber numberWithInteger:curTag3]]) {
            NSInteger ratio = (NSInteger)((CGFloat)(_currentMax-percent)*[num3 floatValue]/total);
            
            if (dicRatio.count == _arrMealRatio.count - 1) {
                NSInteger existTotal = 0;
                for (NSNumber *existNum in [dicRatio allValues]) {
                    existTotal += [existNum integerValue];
                }
                ratio = _currentMax - existTotal;
            }
            [dicRatio setObject:[NSNumber numberWithInteger:ratio] forKey:[NSNumber numberWithInteger:curTag3]];
        }
    }
    return dicRatio;
}

-(void)actDefault:(UIButton *)button{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end