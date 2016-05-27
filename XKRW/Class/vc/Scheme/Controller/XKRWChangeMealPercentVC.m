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
#import "XKRWAlgolHelper.h"

@interface XKRWChangeMealPercentVC () <XKRWMealPercentViewDelegate>
@property (strong, nonatomic) XKRWMealPercentView *breakFastView;
@property (strong, nonatomic) XKRWMealPercentView *lunchView;
@property (strong, nonatomic) XKRWMealPercentView *dinnerView;
@property (strong, nonatomic) XKRWMealPercentView *addmealView;
@property (strong, nonatomic) UILabel *labExplain;
@property (strong, nonatomic) UIButton *btnDefault;
@property (strong, nonatomic) UIScrollView *scrollView;

//已经锁定的字典（key：tag ，value：锁定的百分比）
@property (strong, nonatomic) NSMutableDictionary *dicLockTags;
//各个XKRWMealPercentView和他们的tag所对应的字典（key：tag ，value：view）
@property (strong, nonatomic) NSMutableDictionary *dicMealPercents;
//不同状态下的可滑动最大值
@property (assign, nonatomic) NSInteger currentMax;
@property (strong, nonatomic) NSArray *arrLockTags;
@end

@implementation XKRWChangeMealPercentVC
{
    //自动锁定XKRWMealPercentView
    XKRWMealPercentView *autoLockView;
    //自动解锁XKRWMealPercentView
    XKRWMealPercentView *autoUnLockView;
    NSInteger dailyMax;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviBarBackButton];
    [self addNaviBarRightButtonWithText:@"保存" action:@selector(saveData)];
    self.title = @"调整四餐比例";
    _arrLockTags = [self getTagOfLockStatusImage];
    
    _currentMax = 100;
    _dicMealPercents = [NSMutableDictionary dictionary];
    _dicLockTags = [NSMutableDictionary dictionary];
    
    dailyMax = [XKRWAlgolHelper dailyIntakeRecomEnergy];
    [self makeDicData];
}

/**
 *  当前可调节（未锁栏目）的总百分比
 *
 */
-(void)setCurrentMax:(NSInteger)currentMax{
    if (_currentMax != currentMax) {
        _currentMax = currentMax;
    }
    
    if (_currentMax < 0) {
        _currentMax = 0;
    }
    if (_currentMax > 100) {
        _currentMax = 100;
    }
}

#pragma mark DicData Method
/**
 *  获取数据，没有读取到数据给默认数据
 */
-(void)makeDicData{
    _arrMealRatio = [@[@3,@4,@1,@2] mutableCopy];
    
    _dicData = [NSMutableDictionary dictionary];
    NSDictionary *dic = [[XKRWUserService sharedService] getMealRatio];
    if (dic.count == 0) {
        [self makeDefaultDicData];
    }else{
        for (NSString *key in [dic allKeys]) {
            if ([key isEqualToString:@"breakfast"]) {
                 [_dicData setObject:[dic objectForKey:key] forKey:[NSNumber numberWithInteger:3001]];
            }else if ([key isEqualToString:@"lunch"]){
                [_dicData setObject:[dic objectForKey:key] forKey:[NSNumber numberWithInteger:3002]];
            }else if ([key isEqualToString:@"supper"]){
                [_dicData setObject:[dic objectForKey:key] forKey:[NSNumber numberWithInteger:3003]];
            }else if ([key isEqualToString:@"snack"]){
                [_dicData setObject:[dic objectForKey:key] forKey:[NSNumber numberWithInteger:3004]];
            }
        }
    }
    [self addChangeMealView];
}

-(void)makeDefaultDicData{
    [_dicData removeAllObjects];
    [_dicData setObject:[NSNumber numberWithInteger:30] forKey:[NSNumber numberWithInteger:3001]];
    [_dicData setObject:[NSNumber numberWithInteger:40] forKey:[NSNumber numberWithInteger:3002]];
    [_dicData setObject:[NSNumber numberWithInteger:10] forKey:[NSNumber numberWithInteger:3003]];
    [_dicData setObject:[NSNumber numberWithInteger:20] forKey:[NSNumber numberWithInteger:3004]];
}

#pragma mark getter Method
/**
 *  各种View的getter Method
 *
 *  @return 实例
 */
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(XKAppWidth, XKAppHeight);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(XKRWMealPercentView *)breakFastView{
    if (_breakFastView == nil) {
        _breakFastView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, 0, SlideViewWidth, SlideViewHeight) currentValue:[_dicData objectForKey:[NSNumber numberWithInteger:3001]] totalKcal:dailyMax];
        _breakFastView.slider.tag = 3001;
        
        _breakFastView.imgHead.image = [UIImage imageNamed:@"breakfast5_3"];
        _breakFastView.labTitle.text = @"早餐";
        _breakFastView.delegate = self;
        [self.scrollView addSubview:_breakFastView];
        [_dicMealPercents setObject:_breakFastView forKey:[NSNumber numberWithInteger:3001]];
        if ([_arrLockTags containsObject:[NSNumber numberWithInteger:3001]]) {
            [_breakFastView actBtnLock];
        }
    }
    return _breakFastView;
}

-(XKRWMealPercentView *)lunchView{
    if (_lunchView == nil) {
        _lunchView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, SlideViewHeight, SlideViewWidth, SlideViewHeight) currentValue:[_dicData objectForKey:[NSNumber numberWithInteger:3002]] totalKcal:dailyMax];
        _lunchView.slider.tag = 3002;
        _lunchView.imgHead.image = [UIImage imageNamed:@"lunch5_3"];
        _lunchView.labTitle.text = @"午餐";
        _lunchView.delegate = self;
        [self.scrollView addSubview:_lunchView];
        [_dicMealPercents setObject:_lunchView forKey:[NSNumber numberWithInteger:3002]];
        if ([_arrLockTags containsObject:[NSNumber numberWithInteger:3002]]) {
            [_lunchView actBtnLock];
        }
    }
    return _lunchView;
}

-(XKRWMealPercentView *)dinnerView{
    if (_dinnerView == nil) {
        _dinnerView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, SlideViewHeight*2, SlideViewWidth, SlideViewHeight) currentValue:[_dicData objectForKey:[NSNumber numberWithInteger:3003]] totalKcal:dailyMax];
        _dinnerView.slider.tag = 3003;
        _dinnerView.imgHead.image = [UIImage imageNamed:@"dinner5_3"];
        _dinnerView.labTitle.text = @"晚餐";
        _dinnerView.delegate = self;
        [self.scrollView addSubview:_dinnerView];
        [_dicMealPercents setObject:_dinnerView forKey:[NSNumber numberWithInteger:3003]];
        if ([_arrLockTags containsObject:[NSNumber numberWithInteger:3003]]) {
            [_dinnerView actBtnLock];
        }
    }
    
    return _dinnerView;
}

-(XKRWMealPercentView *)addmealView{
    if (_addmealView == nil) {
        _addmealView = [[XKRWMealPercentView alloc] initWithFrame:CGRectMake(SlideViewLeading, SlideViewHeight*3, SlideViewWidth, SlideViewHeight) currentValue:[_dicData objectForKey:[NSNumber numberWithInteger:3004]] totalKcal:dailyMax];
        _addmealView.slider.tag = 3004;
        _addmealView.imgHead.image = [UIImage imageNamed:@"addmeal5_3"];
        _addmealView.labTitle.text = @"加餐";
        _addmealView.delegate = self;
        [self.scrollView addSubview:_addmealView];
        [_dicMealPercents setObject:_addmealView forKey:[NSNumber numberWithInteger:3004]];
        if ([_arrLockTags containsObject:[NSNumber numberWithInteger:3003]]) {
            [_addmealView actBtnLock];
        }
    }
    
    return _addmealView;
}

-(UILabel *)labExplain{
    if (_labExplain == nil) {
        _labExplain = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _labExplain.numberOfLines = 0;
        _labExplain.textAlignment = NSTextAlignmentLeft;
        _labExplain.textColor = colorSecondary_999999;
        _labExplain.font = [UIFont systemFontOfSize:15];
        _labExplain.text = @"调节四餐比例来将每日摄入总热量按比例分配给四餐，默认推荐比例为：3:4:1:2。在调节时，锁定的餐次比例将固定不变，只调节其他餐次比例。";
        [self.scrollView addSubview:_labExplain];
    }
    return _labExplain;
}

-(UIButton *)btnDefault{
    if (_btnDefault == nil) {
        _btnDefault = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDefault.frame = CGRectMake(0, 0, 116, 33);
        [_btnDefault setTitle:@"恢复默认" forState:UIControlStateNormal];
        [_btnDefault setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
        _btnDefault.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnDefault.layer.cornerRadius = 5;
        _btnDefault.layer.borderWidth = 1;
        _btnDefault.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
        
        _btnDefault.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnDefault addTarget:self action:@selector(actDefault:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_btnDefault];
    }
    return _btnDefault;
}

#pragma mark make & add mealView with Masonry
/**
 *  当前VC的上XKRWMealPercentView的masonry以及scrollview
 */
-(void)addChangeMealView{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
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
        make.width.equalTo(@116);
        make.height.equalTo(@33);
        make.centerX.mas_equalTo(self.labExplain.mas_centerX);
        make.top.mas_equalTo(self.labExplain.mas_bottom).offset(30);
    }];
    
    [self makeSliderMasonry:self.breakFastView];
    [self makeSliderMasonry:self.lunchView];
    [self makeSliderMasonry:self.dinnerView];
    [self makeSliderMasonry:self.addmealView];
    
    
    CGFloat screenH = XKAppHeight;
    CGFloat totalHeight = self.labExplain.frame.size.height + 4*SlideViewHeight + self.btnDefault.frame.size.height + 30 + 50;
    if (totalHeight > screenH) {
        NSLog(@"高度超了");
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(XKAppWidth, totalHeight);
    }
}

#pragma mark mealView subviews Masonry
/**
 *  特定XKRWMealPercentView上Subviews的masonry设置
 *
 *  @param obj 当前XKRWMealPercentView
 */
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
        make.left.mas_equalTo(obj.labTitle.mas_right);
        make.right.mas_equalTo(obj.labPercent.mas_left).offset(-SlideLeading);
        make.centerY.mas_equalTo(obj.imgHead.mas_centerY);
    }];
    [obj.labSeperate mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@1);
        make.left.mas_equalTo(obj.imgHead.mas_left);
        make.right.mas_equalTo(obj.btnLock.mas_right);
        make.bottom.equalTo(@1);
    }];
    [obj.labNum mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(LabNumHeight);
        make.width.mas_equalTo(LabNumWidth);
        make.bottom.mas_equalTo(obj.labSeperate.top).offset(-15);
        make.centerX.mas_equalTo(obj.slider.mas_centerX);
    }];
}

#pragma mark XKRWMealPercentViewDelegate Method
/**
 *  点击锁头的代理方法
 *
 *  @param tag     点击的锁头按钮的slider属性的tag(本module通用tag)
 *  @param percent 当前点击餐次分类所占百分比
 *  @param lock    是否上锁状态（若上锁，进入解锁逻辑后return）
 */
-(void)lockpercentView:(NSInteger)tag withPercent:(NSInteger)percent lock:(BOOL)lock{
    if (lock) {
        [self unlockPercentView:tag];
        return;
    }
    self.currentMax -= percent;
    if (_dicLockTags.count == _dicData.count - 2) {
        autoUnLockView = [_dicMealPercents objectForKey:[NSNumber numberWithInteger:tag]];
    }
    [_dicLockTags setObject:[NSNumber numberWithInteger:percent] forKey:[NSNumber numberWithInteger:tag]];
    if (autoUnLockView && _dicLockTags.count == _dicData.count - 1) {
        for (NSNumber *num in [_dicData allKeys]) {
            if (![[_dicLockTags allKeys] containsObject:num]) {
                autoLockView = [_dicMealPercents objectForKey:num];
                [autoLockView actBtnLock];
            }
        }
    }
}

/**
 *  解锁逻辑
 *
 *  @param tag 需要解锁的tag
 */
-(void)unlockPercentView:(NSInteger)tag{
    NSNumber *numTag = [NSNumber numberWithInteger:tag];
    NSNumber *autoLockTag = [NSNumber numberWithInteger:autoLockView.slider.tag];
    NSNumber *autoUnLockTag = [NSNumber numberWithInteger:autoUnLockView.slider.tag];
    self.currentMax += [[_dicLockTags objectForKey:numTag] integerValue];
    
    if (autoLockView && autoLockView.slider.tag == tag && [[_dicLockTags allKeys] containsObject:autoLockTag]){
        [_dicLockTags removeObjectForKey:autoLockTag];
        [autoLockView cancleBtnLockWithoutDelegate];
        autoLockView = nil;
        [autoUnLockView cancleBtnLockWithoutDelegate];
        self.currentMax += [[_dicLockTags objectForKey:autoUnLockTag] integerValue];
         [_dicLockTags removeObjectForKey:autoUnLockTag];
        autoUnLockView = nil;
    }else{
        [_dicLockTags removeObjectForKey:numTag];
        [[_dicMealPercents objectForKey:numTag] cancleBtnLockWithoutDelegate];
        if ([[_dicLockTags allKeys] containsObject:autoLockTag]) {
            self.currentMax += [[_dicLockTags objectForKey:autoLockTag] integerValue];
            [autoLockView cancleBtnLockWithoutDelegate];
            [_dicLockTags removeObjectForKey:autoLockTag];
            autoLockView = nil;
            autoUnLockView = nil;
        }
    }
}

/**
 *  滑动的代理方法
 *
 *  @param tag     正在滑动到mealview的tag
 *  @param percent 滑动到的百分比
 */
-(void)slideDidScroll:(NSInteger)tag currentPercent:(NSInteger)percent{
    if (percent > _currentMax) {
        percent = _currentMax;
        XKRWMealPercentView *View = [_dicMealPercents objectForKey:[NSNumber numberWithInteger:tag]];
        View.currentPerCent = [NSNumber numberWithInteger:percent];
    }
    if (_dicLockTags.count == _dicData.count - 1){
        return;
    }
    NSDictionary *dic = [self calculateData:tag Percent:percent];
    [_dicData removeAllObjects];
    [_dicData addEntriesFromDictionary:dic];
    [_dicData addEntriesFromDictionary:_dicLockTags];
    
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

/**
 *  设置非正在滑动的，需要自己变动的百分比
 *
 *  @param view    需要变动的view
 *  @param percent 需要变动到的百分比
 *  @param value   需要滚动到的value
 */
-(void)setCurrentOtherSliderView:(XKRWMealPercentView *)view Percent:(NSInteger)percent Value:(float)value{
    if (!view.lock) {
        view.currentPerCent = [NSNumber numberWithInteger:percent];
        view.labPercent.text = [NSString stringWithFormat:@"%ld%%",(long)percent];
        view.labNum.text = [NSString stringWithFormat:@"%.0fkcal",ceilf(dailyMax *percent/100)];
        [view.slider setValue:value animated:YES];
    }
}

/**
 *  计算所有未锁定View的数值
 *
 *  @param tag      正在滑动的view的tag
 *  @param percent  正在滑动的view已经滑动到的百分比
 *
 *  @return 返回字典（key：tag，value：百分比）
 */
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
            
            if (dicRatio.count == _arrMealRatio.count - _dicLockTags.count - 1) {
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

#pragma mark SaveData Method
/**
 *  右上保存按钮点击方法
 */
-(void)saveData{
    BOOL res = [[XKRWUserService sharedService] saveMealRatioWithBreakfast:[[_dicData objectForKey:[NSNumber numberWithInteger:3001]] integerValue] andLunch:[[_dicData objectForKey:[NSNumber numberWithInteger:3002]] integerValue] andSnack:[[_dicData objectForKey:[NSNumber numberWithInteger:3004]] integerValue] andSupper:[[_dicData objectForKey:[NSNumber numberWithInteger:3003]] integerValue]];
    if (res) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self setTagOfLockImageStatus:[_dicLockTags allKeys]];
}

- (void)setTagOfLockImageStatus:(NSArray *)dic{
    [[NSUserDefaults standardUserDefaults] setObject:dic
                                              forKey:[NSString stringWithFormat:@"tagOfLockImageStatus_%ld",(long)UID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getTagOfLockStatusImage {
    NSArray *dicLock = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"tagOfLockImageStatus_%ld",(long)UID]];
    return dicLock;
}

#pragma mark BackDefault Method
/**
 *  恢复默认按钮点击方法
 *
 *  @param button 恢复默认
 */
-(void)actDefault:(UIButton *)button{
    [self makeDefaultDicData];
    
    [self.breakFastView removeFromSuperview];
    self.breakFastView = nil;
    [self.lunchView removeFromSuperview];
    self.lunchView = nil;
    [self.dinnerView removeFromSuperview];
    self.dinnerView = nil;
    [self.addmealView removeFromSuperview];
    self.addmealView = nil;
    
    [self addChangeMealView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end