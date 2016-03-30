//
//  XKRWPickerViewVC.m
//  XKRW
//
//  Created by 忘、 on 14-9-2.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWPickerViewVC.h"
#import "XKRWUserService.h"
@interface XKRWPickerViewVC ()<XKRWPickerViewVCDelegate>
@property (nonatomic, strong) UIButton * titleBtn;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * doneBtn;
//可点击背景
@property (nonatomic, strong) UIView *transparentView;


@property (nonatomic, strong)UILabel *lab;
@property (nonatomic, strong) UILabel * unit;
@end

@implementation XKRWPickerViewVC

-(id)init{
    self = [super init];
    if (self) {
        self.isIllnessView=YES;
        [self setFrame:CGRectMake(0, 0, XKAppWidth, 320)];
        //处理背静
        self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        self.transparentView.backgroundColor = [UIColor blackColor];
        self.transparentView.alpha = 0.0f;
        [self initView];
        
    }
    return self;
}

- (id) initWithNoBackground
{
    self = [super init];
    if (self) {
        self.isIllnessView=YES;
        [self setFrame:CGRectMake(0, 0, XKAppWidth, 320)];
        //处理背静
        [self initView];
        
    }
    return self;
}


- (void)initView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.numberOfTapsRequired = 1;
    [self.transparentView addGestureRecognizer:tap];
    
    //添加顶部条  和内容显示区
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 40)];
    [_toolBar setBackgroundColor:  [UIColor colorFromHexString:@"#52ccb8"]];
    UIImage * selected = nil;
    UIImage * normal = nil;
    
    self.titleBtn  = [self AddButtonWithTitle:nil andFrame:CGRectMake(70, 0, XKAppWidth - 140 , 40) andColor:[UIColor whiteColor] andSelect:[UIColor whiteColor] andBGnormaIM:normal andSelect:selected];
    
    self.cancelBtn  = [self AddButtonWithTitle:@"取消" andFrame:CGRectMake(0 , 0, 65, 40) andColor:[UIColor whiteColor] andSelect:[UIColor whiteColor] andBGnormaIM:normal andSelect:selected];
    
    self.doneBtn  = [self AddButtonWithTitle:@"确定" andFrame:CGRectMake(XKAppWidth - 65, 0, 65, 40) andColor:[UIColor whiteColor]  andSelect:[UIColor whiteColor] andBGnormaIM:normal andSelect:selected];
    
    self.center = CGPointMake(XKAppWidth/2.0, 200);
    
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolBar addSubview:_titleBtn];
    [_toolBar addSubview:_cancelBtn];
    [_toolBar addSubview:_doneBtn];
    
    [self addSubview:_toolBar];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, XKAppWidth, 280)];
    
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
    
    [btn.titleLabel setFont:XKDefaultFontWithSize(16.f)];
    
    return btn;
}


-(void)setCancelTitle:(NSString *)title{
    [self.cancelBtn setTitle:title forState:UIControlStateNormal];
}

- (void)setSureTitle:(NSString *)title
{
     [self.doneBtn setTitle:title forState:UIControlStateNormal];
}


- (id)initWithSheetTitle:(NSString *)title cancelTitle:(NSString *)cancle sureTitle:(NSString *)sureTitle
{
    self = [self initWithNoBackground];
    if (self)
    {
        [self setSheetTtitle:title];
        [self setCancelTitle:cancle];
        [self setSureTitle:sureTitle];
        
        self.choiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 280)];
        [self resetIllnessView];
        [self.choiceView setBackgroundColor:[UIColor clearColor]];
        [_view addSubview:self.choiceView];
        
    }
    return self;

}


-(id)initWithSheetTitle:(NSString *)title ;

{
    self = [self init];
    if (self)
    {
        [self setSheetTtitle:title];
        
        self.choiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 280)];

        [self resetIllnessView];
        
        [self.choiceView setBackgroundColor:[UIColor clearColor]];
        [_view addSubview:self.choiceView];

    }
    return self;
}

- (void) resetIllnessView
{
    if (self.isIllnessView) {
        NSArray *titleArray = @[@"高血压",@"糖尿病",@"心脏疾病",@"腰部受过伤",@"内分泌疾病",@"以上都没有"];
        self.checkBoxArray = [[NSMutableArray alloc]initWithCapacity:11];
        self.illnessResultSet = [[NSMutableSet alloc]initWithCapacity:0];
        self.view.backgroundColor =XKBGDefaultColor;
        
        for (int i = 0;i < 6; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //                button.titleLabel.font = [UIFont systemFontOfSize: 5];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitle:titleArray[i] forState:UIControlStateSelected];
            [button setTitle:titleArray[i] forState:UIControlStateHighlighted];
            //               状态
            [button setTitleColor:[UIColor colorFromHexString:@"#52ccb8"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            //               安静
            [button setBackgroundImage:[UIImage imageNamed:@"buttonShot_s"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"buttonShot"] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageNamed:@"buttonShot"] forState:UIControlStateNormal];
            //
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.frame = CGRectMake((XKAppWidth-200)/2+((i%2)*120), 40+(i/2)*52, 80, 32);
            //
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [button addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            //默认选中没有以上疾病
            if (i == 5) {
                button.selected = YES;
            }
            [self.choiceView  addSubview:button];
            [self.checkBoxArray addObject:button];
        }
        NSArray *illArray = [[XKRWUserService sharedService] getUserDisease];
        if ([illArray count] > 0) {
            for (NSString *ill in illArray) {
                if ([ill isEqualToString:@"0"]) {
                    ((UIButton *)_checkBoxArray[5]).selected = YES;
                    //                    _noticeButton.hidden = YES;
                }
                else {
                    ((UIButton *)_checkBoxArray[5]).selected = NO;
                    ((UIButton *)_checkBoxArray[ill.intValue - 1]).selected = YES;
                    ((UIButton *)_checkBoxArray[ill.intValue - 1]).titleLabel.font = [UIFont systemFontOfSize:14.f];
                    [_illnessResultSet addObject:ill];
                    _noticeButton.hidden = NO;
                }
            }
        }
    }
}


- (void) setPointHidden:(BOOL) status{

    self.unit.hidden = status;
}

-(void)setSheetTtitle:(NSString *)title{
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}



//取消点击
- (void) cancelBtnClick{
    [_PickerViewVCDelegate pickerSheetCancelBackUserBtn:YES];
    [self removeFromView];
}
- (void) tap{
    
    [_PickerViewVCDelegate pickerSheetCancelBackUserBtn:NO];
    [self removeFromView];
    
}
//保存点击
/* 代理执行结束后需回调*/
- (void) doneBtnClick{
    [_PickerViewVCDelegate pickerSheetDoneBack:^{
        [self removeFromView];
    }];
}
////外部调用 初始化选中条目
//-(void)pickerSelectRow:(NSInteger)row inCol:(NSInteger)colun{
//    [_pickerView controlSelectRow:row andColum:colun];
//}

#pragma mark ----------------------------------------
#pragma mark picker协议方法
//-(NSInteger)controlGetNumberOfColum{
//    return [_PickerViewVCDelegate pickerSheetNumberOfColumns];
//}
//-(NSInteger)controlGetRowsInColum:(NSInteger)colum{
//    return [_PickerViewVCDelegate pickerSheetNumberOfRowsInColumn:colum];
//}
//-(NSString *)controlGetTitleAtRow:(NSInteger)row InColum:(NSInteger)colum{
//    return [_PickerViewVCDelegate pickerSheetTitleInRow:row andColum:colum];
//}
//-(void)controlDidSelectedRow:(NSInteger)row andColum:(NSInteger)colum{
//    [_PickerViewVCDelegate pickerSheet:self.choiceView DidSelectRowAtRow:row AndCloum:colum];
//}

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
    
    [UIView animateWithDuration:0.2f
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

- (void)showInViewNoAnimation:(UIView *)theView {
    
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

- (void)removeFromViewNoAnimation
{
    self.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.frame) / 2.0);
//    [self removeFromSuperview];
}

#pragma remove from other VC
-(void)check:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 5 && btn.selected == NO) {
        for (UIButton *checkButton in _checkBoxArray) {
            checkButton.selected = NO;
            checkButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [_illnessResultSet removeAllObjects];
            //            _noticeButton.hidden = YES;
        }
        btn.selected = YES;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    }
    else if (btn.tag == 5 && btn.selected == YES) {
        //NOP
    }
    else {
        ((UIButton *)_checkBoxArray[5]).selected = NO;
        ((UIButton *)_checkBoxArray[5]).titleLabel.font = [UIFont systemFontOfSize:14.f];
        NSString *illString = [NSString stringWithFormat:@"%d",(int)btn.tag + 1];
        if ([_illnessResultSet containsObject:illString]) {
            [_illnessResultSet removeObject:illString];
        }
        else {
            [_illnessResultSet addObject:illString];
        }
        btn.selected = !btn.selected;
        if (btn.selected) {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        }
        else {
            btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        }
        _noticeButton.hidden = NO;
    }
    //当取消所有选中的时候 自动选择以上都没有选项
    BOOL selectAtLeastOneBox = NO;
    for (UIButton *btn in _checkBoxArray) {
        if (btn.selected) {
            selectAtLeastOneBox = YES;
        }
    }
    if (!selectAtLeastOneBox) {
        ((UIButton *)_checkBoxArray[5]).selected = YES;
    }
    
    if (self.PickerViewVCDelegate && [self.PickerViewVCDelegate respondsToSelector:@selector(getCurrentIllNum:)]) {
        [self.PickerViewVCDelegate getCurrentIllNum:_illnessResultSet];
    }
    
}



@end
