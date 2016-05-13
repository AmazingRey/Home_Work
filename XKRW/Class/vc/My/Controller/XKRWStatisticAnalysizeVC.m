//
//  XKRWStatisticAnalysizeVC.m
//  XKRW
//
//  Created by ss on 16/4/29.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#define ScrollViewHeight XKAppHeight-56

#import "XKRWStatisticAnalysizeVC.h"
#import "Masonry.h"
#import "XKRWStatiscHeadView.h"
#import "XKRWWeekAnalysisView.h"
#import "XKRWStatisAnalysisView.h"
#import "XKRWCustomPickerView.h"
#import "XKRWUserService.h"
#import "XKRWCui.h"
#import "KMHeaderTips.h"

@interface XKRWStatisticAnalysizeVC ()<XKRWStatisticAnalysisPickerViewDelegate,XKRWCustomPickerViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UISegmentedControl *segmentControl;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *emptyView;
@property (strong, nonatomic) XKRWWeekAnalysisView *weekAnalysisView;
@property (strong, nonatomic) UIButton *btnBack;
//@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) XKRWCustomPickerView *pickView;

@property (strong, nonatomic) XKRWStatisAnalysisView *statisAnalysisView;
@property (strong, nonatomic) XKRWStatiscBussiness5_3 *bussiness;
@property (assign, nonatomic) NSInteger segmentIndex;
@end

@implementation XKRWStatisticAnalysizeVC
{
    NSInteger pickerIndex;
    NSDictionary *pickerDic;
    NSInteger _pageTime;
    BOOL notEnoughOneWeek;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"统计分析";
    notEnoughOneWeek = ![self judgeTotalHasRecordDays];//不足7天

    [XKRWCui showProgressHud];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _bussiness = [[XKRWStatiscBussiness5_3 alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
                [self addMasonryLayout];
                [XKRWCui hideProgressHud];
                [self showTip];
            });
        });
}

-(BOOL)judgeTotalHasRecordDays{
    NSInteger resetTime = [[[XKRWUserService sharedService]getResetTime] integerValue];
    NSDate *crearDate  = [NSDate dateWithTimeIntervalSince1970:resetTime];
    NSInteger days = [NSDate daysBetweenDate:crearDate andDate:[NSDate date]];
    if (days < 7) {
        return NO;
    }
    return YES;
}

- (void)showTip {
    // 判断用户是否第一次进入此界面（是：显示提示tips 否：不显示tip）
    NSString *key = [NSString stringWithFormat:@"XKRWStatisticAnalysizeVC_%ld",(long)[XKRWUserDefaultService getCurrentUserId]];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:key]) {
        [defaults setValue:@YES forKey:key];
        [defaults synchronize];
        
        KMHeaderTips *tips = [[KMHeaderTips alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 64) text:@"纬度曲线转移至主页右上角\n菜单的\"查看曲线\"中" type:KMHeaderTipsTypeDefault];
        [self.view addSubview:tips];
        [tips startAnimationWithStartOrigin:CGPointMake(0, -tips.height) endOrigin:CGPointMake(0, 0)];
    }
}

#pragma mark getter Method

-(UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"周分析",@"计划统计"]];
        _segmentControl.frame = (CGRect){15, 13, XKAppWidth - 30, 30};
        _segmentControl.tintColor = XKMainSchemeColor;
        
        UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [_segmentControl setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
        
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(segmentControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setContentOffset: CGPointMake(XKAppWidth * _segmentIndex,scrollView.contentOffset.y)];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _segmentControl.bottom + 13, XKAppWidth , ScrollViewHeight)];
        _scrollView.backgroundColor = [UIColor colorFromHexString:@"f5f7f9"];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        
        CGFloat height = _scrollView.frame.size.height;
        if (XKAppHeight < 600){
            _scrollView.delegate = self;
            height += (600 - XKAppHeight);
            _scrollView.scrollEnabled = YES;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.showsHorizontalScrollIndicator = NO;
        }
        _scrollView.contentSize = CGSizeMake(XKAppWidth*2, height);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, ScrollViewHeight)];
        UIImageView *emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 162, 156)];
        CGPoint point = _emptyView.center;
        point.y -= 156;
        emptyImageView.center = point;
        
        emptyImageView.image = [UIImage imageNamed:@"empty_monkey"];
        [_emptyView addSubview:emptyImageView];
        
        UILabel *emptyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyImageView.frame.origin.y + emptyImageView.frame.size.height + 10, XKAppWidth, 80)];
        emptyLab.text = @"啊哦，小主，\n\n你我相遇还不够一周呢。";
        emptyLab.textColor = colorSecondary_666666;
        emptyLab.numberOfLines = 0;
        emptyLab.textAlignment = NSTextAlignmentCenter;
        emptyLab.font = [UIFont systemFontOfSize:17];
        [_emptyView addSubview:emptyLab];
        
        [self.scrollView addSubview:_emptyView];
    }
    return _emptyView;
}

-(XKRWWeekAnalysisView *)weekAnalysisView{
    if (!_weekAnalysisView) {
        _weekAnalysisView = [[XKRWWeekAnalysisView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, ScrollViewHeight) withBussiness:_bussiness];
        _weekAnalysisView.headView.delegate = self;
        [self.scrollView addSubview:_weekAnalysisView];
    }
    return _weekAnalysisView;
}

-(XKRWStatisAnalysisView *)statisAnalysisView{
    if (!_statisAnalysisView) {
        _statisAnalysisView = [[XKRWStatisAnalysisView alloc] initWithFrame:CGRectMake(XKAppWidth, 0, XKAppWidth, ScrollViewHeight) withBussiness:_bussiness];
        _statisAnalysisView.headView.delegate = self;
        [self.scrollView addSubview:_statisAnalysisView];
    }
    return _statisAnalysisView;
}

-(UIButton *)btnBack{
    if (!_btnBack) {
        _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnBack.frame = self.view.bounds;
        _btnBack.backgroundColor = [UIColor lightGrayColor];
        [_btnBack addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btnBack];
    }
    return _btnBack;
}

-(XKRWCustomPickerView *)pickView{
    if (!_pickView) {
        CGRect frame = CGRectMake(0, XKAppHeight-300, XKAppWidth, 300);
        _pickView = [[XKRWCustomPickerView alloc] initWithFrame:frame withindex:pickerIndex withDicData:pickerDic];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.currentStr = [pickerDic objectForKey:[NSNumber numberWithInteger:pickerIndex]];
        _pickView.opaque = YES;
        _pickView.delegate = self;
        [self.view addSubview:_pickView];
    }
    return _pickView;
}

#pragma mark masonry Subviews
-(void)addMasonryLayout{
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(13);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(XKAppWidth - 30);
        make.height.mas_equalTo(30);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.segmentControl.mas_bottom).offset(13);
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(ScrollViewHeight);
    }];
    if (notEnoughOneWeek) {
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.mas_equalTo(_scrollView.left);
            make.width.mas_equalTo(_scrollView.width);
            make.height.mas_equalTo(_scrollView.height);
            make.bottom.mas_equalTo(_scrollView.bottom);
        }];
        [self.statisAnalysisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.mas_equalTo(_emptyView.mas_right);
            make.width.mas_equalTo(_scrollView.width);
            make.height.mas_equalTo(_scrollView.height);
            make.bottom.mas_equalTo(_scrollView.bottom);
        }];
    }else{
        [self.weekAnalysisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.mas_equalTo(_scrollView.left);
            make.width.mas_equalTo(_scrollView.width);
            make.height.mas_equalTo(_scrollView.height);
            make.bottom.mas_equalTo(_scrollView.bottom);
        }];
        [self.statisAnalysisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.mas_equalTo(_weekAnalysisView.mas_right);
            make.width.mas_equalTo(_scrollView.width);
            make.height.mas_equalTo(_scrollView.height);
            make.bottom.mas_equalTo(_scrollView.bottom);
        }];
    }
}

#pragma mark segementControl Method
-(void)segmentControlIndexChanged:(UISegmentedControl *)segement{
    _segmentIndex = segement.selectedSegmentIndex;
    _pageTime = 0;
    CGRect scrollRect = CGRectMake(XKAppWidth*_segmentIndex, 0, XKAppWidth, _scrollView.height);
    [self.scrollView scrollRectToVisible:scrollRect animated:YES];
}

#pragma mark XKRWStatisticAnalysisPickerViewDelegate Method
-(void)makeAnalysisPickerViewAppear:(NSInteger)index withDicData:(NSDictionary *)dic{
    pickerIndex = index;
    pickerDic = dic;
    self.btnBack.alpha = 0;
    self.pickView.alpha = 0;
    
    [UIView animateWithDuration:.5 animations:^{
        _btnBack.alpha = .5;
        _pickView.alpha = 1;
    }];
}

#pragma mark button Method
-(void)btnBackPressed:(UIButton *)btn{
    [UIView animateWithDuration:.5 animations:^{
        self.btnBack.alpha = 0;
        self.pickView.alpha = 0;
    } completion:^(BOOL finished) {
        [_pickView removeFromSuperview];
        _pickView = nil;
        [self.btnBack removeFromSuperview];
        self.btnBack = nil;
    }];
}

#pragma mark XKRWCustomPickerViewDelegate
-(void)pickerViewPressedDone:(NSInteger)currentIndex{
    [self btnBackPressed:nil];
    self.weekAnalysisView.headView.currentIndex = currentIndex;
    self.weekAnalysisView.eatDecreaseView.currentIndex = currentIndex;
    self.weekAnalysisView.sportDecreaseView.currentIndex = currentIndex;
    [self.weekAnalysisView refreshViews];
    [self.statisAnalysisView refreshViews];
}

-(void)pickerViewPressedCancle{
    [self btnBackPressed:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end