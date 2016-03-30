//
//  XKRWSlimPartView.m
//  XKRW
//
//  Created by 忘、 on 14-9-3.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSlimPartView.h"
#import "XKRWUserService.h"


@interface XKRWSlimPartView ()<XKRWSlimPartViewDelegate>
@property (nonatomic, strong) UIButton * titleBtn;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * doneBtn;
//可点击背景
@property (nonatomic, strong) UIView *transparentView;
@property (nonatomic, strong)UILabel *lab;
@property (nonatomic, strong) UILabel * unit;
@end

@implementation XKRWSlimPartView
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


- (id )initWithNOBackground
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
    [_toolBar setBackgroundColor: [UIColor colorFromHexString:@"#52ccb8"]];
    UIImage * selected = nil;
    UIImage * normal = nil;
    
    self.titleBtn  = [self AddButtonWithTitle:nil andFrame:CGRectMake(70, 0, XKAppWidth - 140 , 40) andColor:[UIColor whiteColor] andSelect:[UIColor whiteColor] andBGnormaIM:normal andSelect:selected];

    self.cancelBtn  = [self AddButtonWithTitle:@"取消" andFrame:CGRectMake(0 , 0, 65, 40) andColor:[UIColor whiteColor] andSelect:[UIColor whiteColor] andBGnormaIM:normal andSelect:selected];
    
    self.doneBtn  = [self AddButtonWithTitle:@"确定" andFrame:CGRectMake(XKAppWidth - 65, 0, 65, 40) andColor:[UIColor whiteColor] andSelect:[UIColor whiteColor] andBGnormaIM:normal andSelect:selected];
    
    self.center = CGPointMake(160, 200);
    
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
    
    [btn.titleLabel setFont:XKDefaultNumEnFontWithSize(16.f)];
    
    return btn;
}
-(void)setCancelTitle:(NSString *)title{
    [self.cancelBtn setTitle:title forState:UIControlStateNormal];
}


-(id)initWithSheetTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle
{

    self = [self initWithNOBackground];
    if (self)
    {
        [self setSheetTtitle:title];
        [self setCancelTitle:cancelTitle];
        [self setsureTitle:sureTitle];
       
        
        self.choiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 280)];
        
        [self.choiceView setBackgroundColor:[UIColor clearColor]];
        [self resetIllnessView];
        [_view addSubview:self.choiceView];
    }
    return self;

}


-(id)initWithSheetTitle:(NSString *)title

{
    self = [self init];
    if (self)
    {
        [self setSheetTtitle:title];
        
      
        
        self.choiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 280)];
        
        [self.choiceView setBackgroundColor:[UIColor clearColor]];
        [self resetIllnessView];
        [_view addSubview:self.choiceView];
    }
    return self;
}



- (void) resetIllnessView
{
    if (self.isIllnessView) {
        NSArray *titleArray = @[@"全身",@"手臂",@"腰腹部",@"臀部",@"大腿",@"小腿",@"胸部"];
        self.checkBoxArray = [[NSMutableArray alloc]initWithCapacity:11];
        self.slimPartsSet = [[NSMutableSet alloc]initWithCapacity:0];
        self.view.backgroundColor =XKBGDefaultColor;
        
        for (int i = 0;i < 4; i++) {
            for (int j=0; j<2; j++) {
                if ((2*i+j)==7 ) {
                    break;
                }
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:titleArray[ 2*i+j] forState:UIControlStateNormal];
                //               状态
                [button setTitleColor:[UIColor colorFromHexString:@"#52ccb8"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                //               安静
                [button setBackgroundImage:[UIImage imageNamed:@"buttonShot_s"] forState:UIControlStateSelected];
                [button setBackgroundImage:[UIImage imageNamed:@"buttonShot"] forState:UIControlStateHighlighted];
                [button setBackgroundImage:[UIImage imageNamed:@"buttonShot"] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor colorFromHexString:@"52ccb8"] forState:UIControlStateNormal];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                
                button.frame = CGRectMake((XKAppWidth-200)/2+j*120, 40+52*i, 80, 32);
                
                button.titleLabel.font = [UIFont systemFontOfSize:14.f];
                
                [button addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 2*i+j;
                [_choiceView  addSubview:button];
                [_checkBoxArray addObject:button];
            }
        }
        NSArray *slimParts =  [[XKRWUserService sharedService] getUserSlimPartsArray];
        if (!slimParts) {
            slimParts = [[NSArray alloc] init];
        }
        if ([slimParts count]==6) {
            ((UIButton *)_checkBoxArray[0]).selected = YES;
            ((UIButton*)_checkBoxArray[0]).titleLabel.font=[UIFont boldSystemFontOfSize:14];
            for (int i=1; i<=6; i++) {
                ((UIButton *)_checkBoxArray[i]).selected = NO;
                ((UIButton*)_checkBoxArray[i]).titleLabel.font=[UIFont systemFontOfSize:14.f];
            }
            [_slimPartsSet removeAllObjects];
            [_slimPartsSet addObjectsFromArray:@[@"1", @"2", @"3", @"4", @"5", @"6"]];
        }
        else if ([slimParts count]==0)
        {
            for (int i=0; i<=6; i++) {
                ((UIButton *)_checkBoxArray[i]).selected = NO;
                ((UIButton*)_checkBoxArray[i]).titleLabel.font=[UIFont systemFontOfSize:14.f];
            }
        }
        else{
            for (int i=0; i<6; i++) {
                ((UIButton *)_checkBoxArray[i]).selected = NO;
                ((UIButton*)_checkBoxArray[i]).titleLabel.font=[UIFont systemFontOfSize:14.f];
            }
            [_slimPartsSet removeAllObjects];
            

            for (NSString *str in slimParts) {
                if (str.intValue > 6) {
                    continue;
                }
                ((UIButton *)_checkBoxArray[str.intValue ]).selected = YES;
                ((UIButton *)_checkBoxArray[str.intValue ]).titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
                [_slimPartsSet addObject:str];
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

- (void)setsureTitle:(NSString *)title
{
    [self.doneBtn setTitle:title forState:UIControlStateNormal];
}



//取消点击
- (void) cancelBtnClick{
    [_XKRWSlimPartViewDelegate pickerSheetCancelBackUserBtn:YES];
    [self removeFromView];
}
- (void) tap{
    [_XKRWSlimPartViewDelegate pickerSheetCancelBackUserBtn:NO];
    [self removeFromView];
}
//保存点击
/* 代理执行结束后需回调*/
- (void) doneBtnClick{
    [_XKRWSlimPartViewDelegate pickerSheetDoneBack:^{
        [self removeFromView];
    }];
}

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
       if (btn.tag == 0 && btn.selected == YES) {
               btn.selected = !btn.selected;
               if (btn.selected==NO) {
                   btn.titleLabel.font=[UIFont systemFontOfSize:14.f];
               }
       }
       else {
            ((UIButton *)_checkBoxArray[0]).selected = NO;
            ((UIButton *)_checkBoxArray[0]).titleLabel.font = [UIFont systemFontOfSize:14.f];

            btn.selected = !btn.selected;

            if (btn.selected) {
                NSString *illString = [NSString stringWithFormat:@"%li",(long)btn.tag ];
                if ([_slimPartsSet containsObject:illString]) {
                    [_slimPartsSet removeAllObjects];
                    [_slimPartsSet addObject:illString];
                }
                else {
                    [_slimPartsSet addObject:illString];
                }
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
            }
            else {
                if ([_slimPartsSet containsObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]]) {
                    [_slimPartsSet removeObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
                }
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
        ((UIButton *)_checkBoxArray[0]).selected = NO;
    }
    //当第一个被选时候 其他btn重置  集合+6;
    if (btn.tag==0 && btn.selected) {
        [_slimPartsSet removeAllObjects];
        for (int i=0; i<6; i++) {
            ((UIButton *)_checkBoxArray[1+i]).selected = NO;
            ((UIButton *)_checkBoxArray[1+i]).titleLabel.font = [UIFont systemFontOfSize:14.f];
        }
        [_slimPartsSet addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6"]];
    }
    //第一个按钮取消选择时候 集合为0
    if (btn.tag==0 &&! btn.selected) {
        [_slimPartsSet removeAllObjects];
    }
    
    
    if (self.XKRWSlimPartViewDelegate && [self.XKRWSlimPartViewDelegate respondsToSelector:@selector(getCurrentBodylose:)]) {
        [self.XKRWSlimPartViewDelegate getCurrentBodylose:_slimPartsSet];
    }
    
//    XKLog(@"......%d",_slimPartsSet.count);
}
@end