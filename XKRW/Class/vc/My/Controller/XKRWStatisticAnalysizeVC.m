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

@interface XKRWStatisticAnalysizeVC ()<XKRWStatisticAnalysisPickerViewDelegate,XKRWCustomPickerViewDelegate>
@property (strong, nonatomic) UISegmentedControl *segmentControl;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) XKRWWeekAnalysisView *weekAnalysisView;
@property (strong, nonatomic) UIButton *btnBack;
//@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) XKRWCustomPickerView *pickView;

@property (strong, nonatomic) XKRWStatisAnalysisView *statisAnalysisView;
@end

@implementation XKRWStatisticAnalysizeVC
{
     NSInteger _currentIndex;
     NSInteger _pageTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"统计分析";
    [self addMasonryToLayout];
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

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _segmentControl.bottom + 13, XKAppWidth , ScrollViewHeight)];
        _scrollView.backgroundColor = [UIColor colorFromHexString:@"f5f7f9"];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(XKAppWidth*2, _scrollView.frame.size.height);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(XKRWWeekAnalysisView *)weekAnalysisView{
    if (!_weekAnalysisView) {
        _weekAnalysisView = [[XKRWWeekAnalysisView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, ScrollViewHeight)];
        _weekAnalysisView.headView.delegate = self;
        [self.scrollView addSubview:_weekAnalysisView];
    }
    return _weekAnalysisView;
}

-(XKRWStatisAnalysisView *)statisAnalysisView{
    if (!_statisAnalysisView) {
        _statisAnalysisView = [[XKRWStatisAnalysisView alloc] initWithFrame:CGRectMake(XKAppWidth, 0, XKAppWidth, ScrollViewHeight)];
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
    }
    return _btnBack;
}

//-(UIPickerView *)pickerView{
//    if (!_pickerView){
//        CGRect frame = CGRectMake(0, self.view.frame.size.height-200, XKAppWidth, 200);
//        _pickerView = [[UIPickerView alloc] initWithFrame:frame];
//        _pickerView.backgroundColor = [UIColor whiteColor];
//        _pickerView.opaque = YES;
//        _pickerView.delegate = self;
//        _pickerView.dataSource = self;
//    }
//    return _pickerView;
//}

-(XKRWCustomPickerView *)pickView{
    if (!_pickView) {
        CGRect frame = CGRectMake(0, self.view.frame.size.height-200, XKAppWidth, 200);
        _pickView = [[XKRWCustomPickerView alloc] initWithFrame:frame];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.opaque = YES;
        _pickView.delegate = self;
    }
    return _pickView;
}

#pragma mark masonry Subviews
-(void)addMasonryToLayout{
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

#pragma mark segementControl Method
-(void)segmentControlIndexChanged:(UISegmentedControl *)segement{
    _currentIndex = segement.selectedSegmentIndex;
    _pageTime = 0;
    CGRect scrollRect = CGRectMake(XKAppWidth*_currentIndex, 0, XKAppWidth, _scrollView.height);
    [self.scrollView scrollRectToVisible:scrollRect animated:YES];
}

#pragma mark XKRWStatisticAnalysisPickerViewDelegate Method
-(void)makeAnalysisPickerViewAppear{
    self.btnBack.alpha = 0;
    [self.view addSubview:_btnBack];
    self.pickView.alpha = 0;
    [self.view addSubview:self.pickView];
    
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
-(void)pickerViewPressedDone:(NSString *)singleStr{
    [self btnBackPressed:nil];
    [self.weekAnalysisView.headView lab1ReloadText:singleStr];
}
-(void)pickerViewPressedCancle{
    [self btnBackPressed:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end