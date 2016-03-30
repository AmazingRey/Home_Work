//
//  XKRWPickerSheet.m
//  XKRW
//
//  Created by XiKang on 14-7-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWPickerSheet.h"



@interface XKRWPickerSheet ()<XKPickerControlDelegate>

@property (nonatomic, strong) UIButton * titleBtn;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * doneBtn;
//可点击背景
@property (nonatomic, strong) UIView *transparentView;


@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UILabel * unit;
@end


@implementation XKRWPickerSheet
-(id)init{
    self = [super init];
    if (self) {
        self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        self.transparentView.backgroundColor = [UIColor blackColor];
        self.transparentView.alpha = 0.3f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.numberOfTapsRequired = 1;
        [self.transparentView addGestureRecognizer:tap];
        [self setFrame:CGRectMake(0, 0, XKAppWidth, 280)];
        [self initViewWithShowReminder:nil];

        }
    return self;
}

- (id)initShowTransparentView:(BOOL) show reminder:(NSString *)reminder
{
    self = [super init];
    if (self) {
        if (show) {
            //处理背静
            self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
            self.transparentView.backgroundColor = [UIColor blackColor];
            self.transparentView.alpha = 0.3f;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
            tap.numberOfTapsRequired = 1;
            [self.transparentView addGestureRecognizer:tap];

        }
        [self setFrame:CGRectMake(0, 0, XKAppWidth, 280)];
        [self initViewWithShowReminder:reminder];
    }
    return self;
}

- (void)initViewWithShowReminder:(NSString *)reminder;
{
    //添加顶部条  和内容显示区
    
    if (reminder) {
        self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 60)];
        
        UILabel *reminderLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, XKAppWidth, 20)];
        reminderLable.backgroundColor = colorSecondary_f4f4f4;
        reminderLable.text = reminder;
        reminderLable.font = XKDefaultFontWithSize(13.f);
        reminderLable.textColor = colorSecondary_999999;
        reminderLable.textAlignment = NSTextAlignmentCenter;
        [self.toolBar addSubview:reminderLable];
    }else
    {
        self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 40)];
    }
    [_toolBar setBackgroundColor: [UIColor colorFromHexString:@"#52ccb8"]];
    UIImage * selected = nil;
    UIImage * normal = nil;
    
    self.titleBtn  = [self AddButtonWithTitle:nil andFrame:CGRectMake(70, 0, XKAppWidth - 140 , 40) andColor:[UIColor whiteColor] andSelect:[UIColor whiteColor] andBGnormaIM:normal andSelect:selected];
    
    self.cancelBtn  = [self AddButtonWithTitle:@"取消" andFrame:CGRectMake(0 , 0, 65, 40) andColor:[UIColor whiteColor] andSelect:[UIColor whiteColor] andBGnormaIM:normal andSelect:selected];
    [self.cancelBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    
    self.doneBtn  = [self AddButtonWithTitle:@"确定" andFrame:CGRectMake(XKAppWidth - 65, 0, 65, 40) andColor:[UIColor whiteColor] andSelect:[UIColor whiteColor] andBGnormaIM:normal andSelect:selected];
    [self.doneBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    
    self.center = CGPointMake(XKAppWidth/2, 200);
    
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolBar addSubview:_titleBtn];
    [_toolBar addSubview:_cancelBtn];
    [_toolBar addSubview:_doneBtn];
    
    [self addSubview:_toolBar];
    if (reminder) {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 60, XKAppWidth, 220)];
    }else
    {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, XKAppWidth, 240)];
    }
    
    _view.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_view];


}

//添加按钮
-(UIButton *)AddButtonWithTitle:(NSString *) title andFrame:(CGRect) frame andColor:(UIColor *) titleColor andSelect:(UIColor *)select andBGnormaIM:(UIImage *) norm andSelect:(UIImage *) bgHight{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:(titleColor? titleColor: [UIColor colorFromHexString:@"#333333"]) forState:UIControlStateNormal];
    [btn setTitleColor:(select ? select : [UIColor colorFromHexString:@"#666666"]) forState:UIControlStateHighlighted];
    [btn setTitleColor:(select ? select : [UIColor colorFromHexString:@"#666666"]) forState:UIControlStateSelected];
    if(normal){
        [btn setBackgroundImage:norm forState:UIControlStateNormal];
    }else{
        [btn setBackgroundColor:XKClearColor];
    }
    if(bgHight)
    [btn setBackgroundImage:bgHight forState:UIControlStateSelected];
    if(bgHight)
    [btn setBackgroundImage:bgHight forState:UIControlStateHighlighted];
    
    [btn.titleLabel setFont:XKDefaultNumEnFontWithSize(16.f)];
    
    return btn;

}

-(void)setCancelTitle:(NSString *)title{
    [self.cancelBtn setTitle:title forState:UIControlStateNormal];
}

-(id)initWithSheetTitle:(NSString *)title AndUnit:(NSString *)unit
{
    self = [self init];
    if (self)
    {
        [self setSheetTtitle:title];
        
        self.pickerView = [[XKRWPickerControlView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 240)];
        _pickerView.delegate = self;
        [_pickerView setBackgroundColor:[UIColor clearColor]];
        [_view addSubview:_pickerView];
        
        self.unit= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _unit.backgroundColor = [UIColor clearColor];
        _unit.textAlignment = NSTextAlignmentCenter;
        _unit.text = unit;
        _unit.font = [UIFont systemFontOfSize:20];
        _unit.center = CGPointMake(XKAppWidth/2.0+130, 110);
        [_view addSubview:_unit];
    }
    return self;
}



-(id)initWithSheetTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle reminder:(NSString *)reminder
{
    self = [self initShowTransparentView:NO reminder:reminder];
    if (self)
    {
        [self setSheetTtitle:title];
        [self setSheetCancelTitle:cancelTitle];
        [self setSheetSureTitle:sureTitle];
        
        self.pickerView = [[XKRWPickerControlView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 240)];
        _pickerView.delegate = self;
        [_pickerView setBackgroundColor:[UIColor clearColor]];
        [_view addSubview:_pickerView];
        
        self.unit= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _unit.backgroundColor = [UIColor clearColor];
        _unit.textAlignment = NSTextAlignmentCenter;
        _unit.text = @"kg";
        _unit.font = [UIFont systemFontOfSize:20];
        _unit.center = CGPointMake(XKAppWidth/2.0+130, 110);
        [_view addSubview:_unit];
    }
    return self;
}

- (void) setPointHidden:(BOOL) status{
    self.unit.hidden = status;
}
- (void) setPickerSheetDelegate:(id<PickerSheetViewDelegate>)pickerSheetDelegate{
    _pickerSheetDelegate = pickerSheetDelegate;
    if (!K_iOS_System_Version_Gt_7) {
        [_pickerView setDelegate:self];
    }
}
-(void)setSheetTtitle:(NSString *)title {
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}



-(void)setSheetCancelTitle:(NSString *)title
{
    if (title.length == 0) {
        self.cancelBtn.hidden = YES;
    }else
    {
        [self.cancelBtn setTitle:title forState:UIControlStateNormal];
    }
}

-(void)setSheetSureTitle:(NSString *)title
{
     [self.doneBtn setTitle:title forState:UIControlStateNormal];
}

//取消点击
- (void) cancelBtnClick{
    [_pickerSheetDelegate pickerSheetCancelBackUserBtn:YES];
    [self removeFromView];
}
- (void) tap{

    [_pickerSheetDelegate pickerSheetCancelBackUserBtn:NO];
    [self removeFromView];

}
//保存点击
/* 代理执行结束后需回调*/
- (void) doneBtnClick{
    [_pickerSheetDelegate pickerSheetDoneBack:^{
        [self removeFromView];
    }];
}


//外部调用 初始化选中条目
-(void)pickerSelectRow:(NSInteger)row inCol:(NSInteger)colun{
    [_pickerView controlSelectRow:row andColum:colun];
}

#pragma mark ----------------------------------------
#pragma mark picker协议方法
-(NSInteger)controlGetNumberOfColum{
    
    XKLog(@"%ld", (long)[_pickerSheetDelegate pickerSheetNumberOfColumns]);
    
  return [_pickerSheetDelegate pickerSheetNumberOfColumns];
}
-(NSInteger)controlGetRowsInColum:(NSInteger)colum{
    return [_pickerSheetDelegate pickerSheetNumberOfRowsInColumn:colum];
}
-(NSString *)controlGetTitleAtRow:(NSInteger)row InColum:(NSInteger)colum{
    return [_pickerSheetDelegate pickerSheetTitleInRow:row andColum:colum];
}
-(void)controlDidSelectedRow:(NSInteger)row andColum:(NSInteger)colum{
    [_pickerSheetDelegate pickerSheet:_pickerView DidSelectRowAtRow:row AndCloum:colum];
}

#pragma mark ----------------------------------------
//pickersheet 的方法
//显示和消除方法
- (void)showInView:(UIView *)theView {
    
    [theView addSubview:self];
    [theView insertSubview:self.transparentView belowSubview:self];
    
    CGRect theScreenRect = [UIScreen mainScreen].bounds;
    
    float height;
    float x;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        height = CGRectGetHeight(theScreenRect);
        x = CGRectGetWidth(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetWidth(theScreenRect), CGRectGetHeight(theScreenRect));
    } else {
        height = CGRectGetWidth(theScreenRect);
        x = CGRectGetHeight(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetHeight(theScreenRect), CGRectGetWidth(theScreenRect));
    }
    
    self.center = CGPointMake(x, height + CGRectGetHeight(self.frame) / 2.0 - 50) ;
    self.transparentView.center = CGPointMake(x, height / 2.0);
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         self.transparentView.alpha = 0.4f;
                         if (!K_iOS_System_Version_Gt_7){
                             self.center = CGPointMake(x, (height - 20) - CGRectGetHeight(self.frame) / 2.0);
                         } else {
                             self.center = CGPointMake(x, height - CGRectGetHeight(self.frame) / 2.0 - 40);
                         }
                         
                     } completion:^(BOOL finished) {
                     }];
}

- (void)showInViewNoAnimaton:(UIView *)theView
{
    [theView addSubview:self];
    [theView insertSubview:self.transparentView belowSubview:self];
    
    CGRect theScreenRect = [UIScreen mainScreen].bounds;
    
    float height;
    float x;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        height = CGRectGetHeight(theScreenRect);
        x = CGRectGetWidth(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetWidth(theScreenRect), CGRectGetHeight(theScreenRect));
    } else {
        height = CGRectGetWidth(theScreenRect);
        x = CGRectGetHeight(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetHeight(theScreenRect), CGRectGetWidth(theScreenRect));
    }
    
    self.center = CGPointMake(x, height + CGRectGetHeight(self.frame) / 2.0 - 50) ;
    self.transparentView.center = CGPointMake(x, height / 2.0);
    
    [UIView animateWithDuration:0.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         self.transparentView.alpha = 0.4f;
                         if (!K_iOS_System_Version_Gt_7){
                             self.center = CGPointMake(x, (height - 20) - CGRectGetHeight(self.frame) / 2.0);
                         } else {
                             self.center = CGPointMake(x, height - CGRectGetHeight(self.frame) / 2.0 - 40);
                         }
                         
                     } completion:^(BOOL finished) {
                     }];


}


- (void)removeFromViewNOAnimation
{
 
    self.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.frame) / 2.0);
 //   [self removeFromSuperview];
}

- (void)removeFromView {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^() {
                             self.transparentView.alpha = 0.0f;
                             self.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.frame) / 2.0);
                         } completion:^(BOOL finished) {
                             [self.transparentView removeFromSuperview];
                             [self removeFromSuperview];
                         }];

}

@end
