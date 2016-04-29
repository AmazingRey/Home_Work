//
//  XKRWSportAddVC.m
//  XKRW
//
//  Created by zhanaofan on 14-3-3.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSportAddVC.h"
#import "XKRWNaviRightBar.h"
#import "XKRWSepLine.h"
#import "RulerView.h"
#import "XKRWSportService.h"
#import "XKRWUserService.h"
#import "XKRWCui.h"
#import "XKRWRecordService4_0.h"
#import "UIImageView+WebCache.h"

#define kSegmentWidth 214
@interface XKRWSportAddVC ()<UITextFieldDelegate>
{
    UIView *topView;
    UILabel *kcalLabel;
    
    //单位View
    UIView *unitView;
    
    UITextField *componentTextField;
    //单位
    UILabel *selectUnitLabel;
    //
    UILabel *sportName;
    
    UISegmentedControl  *unitSegmentCtr;
}
//当前值
@property (nonatomic, strong) UILabel           *lbCurrentValue;
//标尺尺寸
@property (nonatomic, assign) CGRect            dialFrame;
//当前值
@property (nonatomic, assign) uint32_t          currentValue;
//最小值
@property (nonatomic, assign) uint32_t          minValue;
//最大值
@property (nonatomic, assign) uint32_t          maxValue;
//标尺视图
@property (nonatomic, strong) RulerView         *rulerView;

@property (nonatomic, strong) UILabel           *lbTitle;   //标题s
@property (nonatomic, strong) UIScrollView      *lbTitleBG;  //作为背景
@property (nonatomic, strong) UILabel           *lbDesc;    //描述

@property (nonatomic, strong) UIView            *datePart; //日期选择  View

@property (nonatomic, assign) DayType            dayTemp;   //日期类型  用来注明 今天明天

@property (nonatomic, strong) XKRWNaviRightBar *rightBar;
@end

@implementation XKRWSportAddVC
@synthesize lbTitle;
@synthesize lbDesc;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    self.unit = eUnitMinutes;
    self.needHiddenDate = YES;
    [super viewDidLoad];
    self.forbidAutoAddCloseButton = YES;
    [self addNaviBarBackButton];
    //添加右边导航按钮
    [self addNaviBarRightButton];
    
    if (!_sportEntity) {
        _sportEntity = [[XKRWSportService shareService] sportDetailWithId:_sportID];
    }
    
    if (!_dayTemp) {
        _dayTemp = eToday;
    }
    self.navigationItem.title = @"运动记录";
    
    [self initView];
    [self initData];
}

-(void)initView{
    self.forbidAutoAddCloseButton = YES;
    [self addNaviBarBackButton];
    
    [self addNaviBarRightButton];
    
    self.title = @"记录运动";
    self.view.backgroundColor = XK_BACKGROUND_COLOR;
    topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 15, XKAppWidth, 75);
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    kcalLabel = [[UILabel alloc] init];
    kcalLabel.frame = CGRectMake(XKAppWidth-15-80, 0, 80, 75);
    kcalLabel.textAlignment = NSTextAlignmentRight;
    kcalLabel.font = XKDefaultFontWithSize(14.f);
    kcalLabel.textColor = XKMainSchemeColor;
    kcalLabel.backgroundColor = XKClearColor;
    kcalLabel.text = [NSString stringWithFormat:@"0Kcal"];
    [topView addSubview:kcalLabel];
    
    //logo背景
    UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 55.f, 55.f)];
    CALayer *layer  = logoIV.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.f];
    layer.shouldRasterize = YES;
    
    //设置食物Logo
    [logoIV setImageWithURL:[NSURL URLWithString:_sportEntity.sportActionPic] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    [topView addSubview:logoIV];

    
    sportName = [[UILabel alloc] init];
    sportName.frame = CGRectMake(logoIV.right + 21, 0, 150, 75);
    sportName.font = XKDefaultFontWithSize(14);
    sportName.text = @"跑步";
    sportName.textColor = [UIColor blackColor];
    [topView addSubview:sportName];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, topView.height-1, XKAppWidth, 1);
    lineView.backgroundColor = XK_ASSIST_LINE_COLOR;
    [topView addSubview:lineView];
    
    //单位
    unitView = [[UIView alloc]init];
    unitView.frame = CGRectMake(0, topView.bottom+15, XKAppWidth, 44);
    unitView.backgroundColor = [UIColor whiteColor];
    
    UILabel *unitLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 44)];
    unitLable .textColor = [UIColor blackColor];
    unitLable.font = XKDefaultFontWithSize(14.0f);
    unitLable.text = @"单位：";
    [unitView addSubview:unitLable];
    
    UIView *unitLine = [[UIView alloc] init];
    unitLine.frame = CGRectMake(0.f, 44-0.5, XKAppWidth, 0.5);
    unitLine.backgroundColor =  colorSecondary_e0e0e0;
    [unitView addSubview:unitLine];
    [self.view addSubview:unitView];
    //添加选择器
    
    NSArray *unitArrays = @[@"分钟"];
    unitSegmentCtr = [[UISegmentedControl alloc]initWithItems:unitArrays];
    unitSegmentCtr.frame = CGRectMake(XKAppWidth-kSegmentWidth-15, 7, kSegmentWidth/3, 30);
    unitSegmentCtr.tintColor = XKMainToneColor_29ccb1;
    [unitSegmentCtr addTarget:self action:@selector(unitSegmentAction:) forControlEvents:UIControlEventValueChanged];
    [unitView addSubview:unitSegmentCtr];
    unitSegmentCtr.selectedSegmentIndex = 0;
    
    //份量
    UIView  *componentView = [[UIView alloc]initWithFrame:CGRectMake(0, unitView.bottom, XKAppWidth, 44)];
    componentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:componentView];
    
    UIView *componentLine = [[UIView alloc] initWithFrame:CGRectMake(0.f, 44-0.5, XKAppWidth, 0.5)];
    componentLine.backgroundColor =  colorSecondary_e0e0e0;
    [componentView addSubview:componentLine];
    
    UILabel *componentLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    componentLable.textColor = [UIColor blackColor];
    componentLable.font = XKDefaultFontWithSize(14.0f);
    componentLable.text = @"时间：";
    [componentView addSubview:componentLable];
    
    //编辑View
    UIView *editView = [[UIView alloc] init];
    editView.frame = CGRectMake(XKAppWidth-kSegmentWidth-15, 0, kSegmentWidth, 44);
    editView.backgroundColor = [UIColor clearColor];
    [componentView addSubview:editView];
    
    componentTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 7, 50, 30)];
    componentTextField.textColor = XKMainToneColor_29ccb1;
    componentTextField.tintColor = XKMainToneColor_29ccb1;
//    [componentTextField becomeFirstResponder];
    componentTextField.placeholder =@"0";

    componentTextField.keyboardType = UIKeyboardTypeNumberPad;
    componentTextField.delegate = self;
    componentTextField.font = XKDefaultFontWithSize(14.f);
    componentTextField.textAlignment = NSTextAlignmentRight;
    [componentTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [editView addSubview:componentTextField];
    
    
    //下线
    UIView *editBottomLine = [[UIView alloc] init];
    editBottomLine.frame = CGRectMake(0.f, componentTextField.bottom, componentTextField.width, 0.5);
    editBottomLine.backgroundColor =  [UIColor blackColor];
    [editView addSubview:editBottomLine];
    
    //分钟
    selectUnitLabel = [[UILabel alloc] init];
    selectUnitLabel.frame = CGRectMake(componentTextField.right+5, 0.f, 100,44);
    selectUnitLabel.textColor = [UIColor blackColor];
    selectUnitLabel.font = XKDefaultFontWithSize(14);
    selectUnitLabel.text = @"分钟";
    [editView addSubview:selectUnitLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)initData{
    if(!_recordSportEntity){
        sportName.text = _sportEntity.sportName;
        _recordSportEntity = [[XKRWRecordSportEntity alloc] init];
        _recordSportEntity.date = self.recordEneity.date;
    }else{
        sportName.text = _recordSportEntity.sportName;
        componentTextField.text = [NSString stringWithFormat:@"%ld",(long)_recordSportEntity.number];
        kcalLabel.text = [NSString stringWithFormat:@"%ldKcal",(long)_recordSportEntity.calorie];
    }
    if (_sportID) {
        _recordSportEntity.sportId = _sportID;
    } else if (_sportEntity) {
        _recordSportEntity.sportId = _sportEntity.sportId;
    }
}

#pragma --mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

#pragma mark - 触发事件
/**
 *  监听 TextField的改变
 *
 *  @param textField
 */
- (void) textFieldChange:(UITextField *)textField
{
    if (textField.text.length !=0) {
        NSInteger num = [textField.text integerValue];
        if (num == 0) {
            [XKRWCui showInformationHudWithText:@"消耗热量不能为0"];
            textField.text = @"1";
        }
        
        if (num >1440) {
            [XKRWCui showInformationHudWithText:@"超过记录值"];
            textField.text = @"1440";
        }
        
        if (!self.date) {
            self.date = _recordSportEntity.date ? _recordSportEntity.date : [NSDate date];
        }
        float nearestWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:self.date];
        if (_isModify) {//修改
            uint32_t cal = [_recordSportEntity consumeCaloriWithMinuts:[componentTextField.text intValue] weight:nearestWeight];
            kcalLabel.text = [NSString stringWithFormat:@"%iKcal",cal];
        }else{//记录
            uint32_t cal = [_sportEntity consumeCaloriWithMinuts:[componentTextField.text intValue] weight:nearestWeight];
            kcalLabel.text = [NSString stringWithFormat:@"%iKcal",cal];
        }
    }else{
        kcalLabel.text = [NSString stringWithFormat:@"%iKcal",0];
    }
    
    
}

- (void) tapAction:(UITapGestureRecognizer *)tap
{
    if ([componentTextField isFirstResponder]) {
        [componentTextField resignFirstResponder];
    }
}


- (void) unitSegmentAction:(UISegmentedControl *)segment
{
    if ([componentTextField isFirstResponder]) {
        [componentTextField resignFirstResponder];
    }
    
    int textNum = [componentTextField.text intValue];
    if (segment.selectedSegmentIndex == 0){
        if (textNum >100) {
            componentTextField.placeholder = @"0";
            componentTextField.text = @"";
        }
        selectUnitLabel.text = @"分钟";
    }
}

#pragma mark - 

- (void)drawSubviews
{
    UIView * decriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 64)];
    decriptionView.backgroundColor = [UIColor whiteColor];
    self.lbTitle= [[UILabel alloc] initWithFrame:CGRectMake(0.f, 10.f, 290.f, 20.f)];
    lbTitle.font = [UIFont boldSystemFontOfSize:15.f];
    lbTitle.textAlignment = NSTextAlignmentLeft;
    lbTitle.textColor = [UIColor colorFromHexString:@"#333333"];
    lbTitle.text = @"运动";
    lbTitle.backgroundColor =[UIColor clearColor];
    
    self.lbTitleBG = [[UIScrollView alloc] initWithFrame:CGRectMake(15.f, 0.f, 290.f, 64.f)];
    _lbTitleBG.showsHorizontalScrollIndicator = NO;
    _lbTitleBG.showsVerticalScrollIndicator = NO;
    
    [_lbTitleBG addSubview:lbTitle];
    [decriptionView addSubview:_lbTitleBG];
    //运动的介绍
    lbDesc= [[UILabel alloc] initWithFrame:CGRectMake(15.f, 40, 120.f, 20.f)];
    lbDesc.font = XKDefaultFontWithSize(14.f);
    lbDesc.backgroundColor = [UIColor clearColor];
    lbDesc.textColor = [UIColor colorFromHexString:@"#666666"];
    //体重测试的适合，需要改成实际的
    lbDesc.text = [NSString stringWithFormat:@"320 kcal/60分钟"];
    [decriptionView addSubview:lbDesc];
    [self.view addSubview:decriptionView];
    
    XKRWSepLine *sepline = [[XKRWSepLine alloc] initWithFrame:CGRectMake(15.f,decriptionView.frame.size.height-1, XKAppWidth-15, 1.f)];
    [decriptionView addSubview:sepline];
    
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, decriptionView.bottom, XKAppWidth, 140)];
    timeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:timeView];
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 20)];
    timeLable.text = @"时间选择";
    timeLable.textColor = [UIColor colorFromHexString:@"#333333"];
    timeLable.font = XKDefaultFontWithSize(15.0f);
    
    [timeView addSubview:timeLable];
    
    _lbCurrentValue = [[UILabel alloc] initWithFrame:CGRectMake(0.f,0,160.f, 16.f)];
    _lbCurrentValue.textColor = XKMainToneColor_00b4b4;
    _lbCurrentValue.backgroundColor = XKClearColor;
    _lbCurrentValue.font = XKDefaultFontWithSize(14.f);
    _lbCurrentValue.textAlignment = NSTextAlignmentCenter;
    _lbCurrentValue.text = [NSString stringWithFormat:@"%i%@",60,_unitDescription];
    [_lbCurrentValue setCenter:CGPointMake(self.view.frame.size.width/2.f,10 + sepline.frame.size.height + 25)];
    [timeView addSubview:_lbCurrentValue];
    
    _dialFrame = CGRectMake(15.f, _lbCurrentValue.bottom+20, XKAppWidth-30, 44.f);
    self.rulerView = [[RulerView alloc] initWithFrame:_dialFrame];
    
    _rulerView.currentValue = 60;
    [_rulerView setMaxInterValue:120];
    __block XKRWSportAddVC * weakSelf = self;
    _rulerView.ScaleValue = ^(int integerValue,int decimal){
        weakSelf.lbCurrentValue.text = [NSString stringWithFormat:@"%i分钟",integerValue];
    };
    
    [timeView addSubview:_rulerView];
    
    //中间的指示标
    UIImageView *sign_uv = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 5.f, 5.f)];
    [sign_uv setCenter:CGPointMake(self.view.frame.size.width/2.f, _lbCurrentValue.center.y + 15)];
    [sign_uv setImage:[UIImage imageNamed:@"circle_icon.png"]];
    [timeView addSubview:sign_uv];
    
    
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _dialFrame.origin.y + _dialFrame.size.height + 25 + 90, 40, 16)];
    tipLabel.textColor = [UIColor colorFromHexString:@"#666666"];
    tipLabel.text = @"Tip:";
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
    
    XKRWSepLine *sepl = [[XKRWSepLine alloc] initWithFrame:CGRectMake(20, _dialFrame.origin.y + _dialFrame.size.height + 50 + 90, self.view.frame.size.width - 40, 1.f)];
    [self.view addSubview:sepl];
    
    UILabel * tipDeciption = [[UILabel alloc] initWithFrame:CGRectMake(20, _dialFrame.origin.y + _dialFrame.size.height + 55 + 90, self.view.frame.size.width - 40, 44)];
    tipDeciption.numberOfLines = 2;
    tipDeciption.textColor = [UIColor colorFromHexString:@"#333333"];
    tipDeciption.text = @"        不同的人，运动时间相同，消耗的能量也不同，瘦瘦会为你科学计算";
    tipDeciption.font = [UIFont systemFontOfSize:13.0];
    tipDeciption.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipDeciption];
    
    [self addDatePartToUIWitgFrame:CGRectMake(0,_dialFrame.origin.y + _dialFrame.size.height + 10, XKAppWidth, 100)];
    
    [self resetValue];
}

/**
 *  记录日期
 *
 *  @param rect
 */
-(void) addDatePartToUIWitgFrame:(CGRect) rect{
    if (_needHiddenDate) {
        return;
    }
    self.datePart = [[UIView alloc] initWithFrame:rect];
    _datePart.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_datePart];
    
    UILabel *lbCal = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 10.f, 100.f, 16.f)];
    lbCal.backgroundColor = XKClearColor;
    [lbCal setTextColor:[UIColor colorFromHexString:@"#666666"]];
    lbCal.text = @"日期选择";
    [_datePart addSubview:lbCal];
    
    //背景线
    UIImageView *sep_line1 = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, lbCal.frame.origin.y+lbCal.frame.size.height+4.f, 280, 0.5f)];
    UIImage *img = [UIImage imageNamed:@"sep_line.png"];
    [sep_line1 setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 1.f, 0.f, 2.f)]];
    [_datePart  addSubview:sep_line1];
    
    UIButton * btnToday = [self createBtn];
    [btnToday setFrame:CGRectMake(68.5f,sep_line1.frame.origin.y+sep_line1.frame.size.height+15.f, 64.f, 32.f)];
    [btnToday setTitle:@"今天" forState:UIControlStateNormal];
    btnToday.selected = YES;
    btnToday.tag = 5555;
    [btnToday addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    [_datePart addSubview:btnToday];
    //明天
    UIButton *btnTomorrow = [self createBtn];
    [btnTomorrow setFrame:CGRectMake(btnToday.frame.origin.x+btnToday.frame.size.width+55.f, btnToday.frame.origin.y, 64.f, 32.f)];
    [btnTomorrow setTitle:@"明天" forState:UIControlStateNormal];
    btnTomorrow.tag = 5556;
    [btnTomorrow addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    [_datePart addSubview:btnTomorrow];
    
    if (!_passDayTemp) {
        return;
    }
    
    NSDate *date = [NSDate date];
    if (_dayTemp == eTomorrow) {
        date = [date dateByAddingTimeInterval:86400];
    }
    
    NSString *day = [NSDate stringFromDate:date withFormat:@"yyyy-MM-dd"];
    
    if (![day isEqualToString:_passDayTemp]) {
        btnToday.selected = NO;
        btnTomorrow.selected = YES;
    }
    
}

/**
 *  选择日期
 *
 *  @param sender <#sender description#>
 */
-(void)chooseDate:(UIButton *)sender{
    if (sender.tag == 5555) {
        _dayTemp = eToday;
        
        ((UIButton *) [_datePart viewWithTag:5556]).selected = NO;
    }else{
        _dayTemp = eTomorrow;
        ((UIButton *) [_datePart viewWithTag:5555]).selected = NO;
        
    }
    sender.selected = YES;
    
}

-(UIButton *) createBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"day_btn_bg.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"day_btn_bg_h.png"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorFromHexString:@"#9C9C9C" ] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor ] forState:UIControlStateSelected];
    btn.titleLabel.font = XKDefaultFontWithSize(14.f);
    return btn;
}

- (void) setUnit:(MetricUnit)unit{
    _unit = unit;

    switch (unit) {
        case eUnitGram:
            _unitDescription = @"克";
            break;
        case eUnitKilojoules:
            _unitDescription = @"千焦";
            break;
        case eUnitKiloCalories:
            _unitDescription = @"kcal";
            break;
        case eUnitBox:
            _unitDescription = @"盒";
            break;
        case eUnitBlock:
            _unitDescription = @"块";
            break;
        case eUnitMilliliter:
            _unitDescription = @"毫升";
            break;
        case eUnitMinutes:
            _unitDescription = @"分钟";
        default:
            break;
    }
}




- (void) setSportTitleName :(NSString *) sportTitle{
    //设置标题
    CGSize size = [XKRWUtil sizeOfStringWithFont:sportTitle withFont:lbTitle.font ];
    
    lbTitle.text = sportTitle ;
    lbTitle.frame = CGRectMake(0, 10, size.width, 20);
    _lbTitleBG.contentSize = CGSizeMake(size.width, 0);
    
}

/**
 *  为decriptionView上的数据赋值
 */
-(void) resetValue {
    
    
    if (!_sportEntity.sportMets) {
        if (_recordSportEntity.sportName) {
            _sportEntity.sportName = _recordSportEntity.sportName;
        }
    }else{
        self.rightBar.hidden = NO;
    }
    
    [self setSportTitleName:_sportEntity.sportName];
    
    if (self.recordSportEntity) {
        _lbCurrentValue.text = [NSString stringWithFormat:@"%li%@",(long)self.recordSportEntity.number,_unitDescription];
        [self.rulerView setCurrentValue:self.recordSportEntity.number];
    }else{
        _lbCurrentValue.text = [NSString stringWithFormat:@"%i%@",60,_unitDescription];
        [self.rulerView setCurrentValue:60];
    }
    if (!self.date) {
        self.date = _recordSportEntity.date ? _recordSportEntity.date : [NSDate date];
    }
    float nearestWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:self.date];
    
    uint32_t cal = [_sportEntity consumeCaloriWithMinuts:60 weight:nearestWeight];
    lbDesc.text = [NSString stringWithFormat:@"%i kcal/60分钟",cal];
    
}

/**
 *  设置保存按钮
 */
- (void) addNaviBarRightButton
{
    self.rightBar = [[XKRWNaviRightBar alloc] initWithFrameAndTitle:CGRectMake(0.f, 0.f, 44.f, 44.f) title:@"保存"];
    [_rightBar addTarget:self action:@selector(rightNaviItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBar];
    
}

- (void) addNaviBarBackButton
{
    if (self.isPresent) {
        //
        UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftItemButton setImage:[UIImage imageNamed:@"off_n5_3"] forState:UIControlStateNormal];
        [leftItemButton setImage:[UIImage imageNamed:@"off_p5_3"] forState:UIControlStateHighlighted];
        leftItemButton.frame = CGRectMake(0, 0, 30, 30);
        [leftItemButton setTitleColor:[UIColor colorWithRed:247/255.f green:106/255.f blue:8/255.f alpha:1.0] forState:UIControlStateNormal];
        [leftItemButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemButton];
    } else {
        [super addNaviBarBackButton];
    }
}

- (void) refreshCurrentValue
{
    int  value = (int) _rulerView.currentValue;
    _lbCurrentValue.text = [NSString stringWithFormat:@"%i%@",value,_unitDescription];
}

#pragma mark 记录运动
/**
 *  执行保存记录
 */
- (void) rightNaviItemClicked:(UIButton *)button
{
    if (componentTextField.text.length == 0 && componentTextField.text.floatValue == 0) {
        [XKRWCui showInformationHudWithText:@"时间不能为空"];
        return ;
    }
    NSDate *todayDate = [NSDate today];
    if (!_recordEneity.date || [_recordEneity.date compare:[todayDate offsetDay:-2]] == NSOrderedAscending) {
        _recordEneity.date = todayDate;
    }
    
    _recordSportEntity.uid = (int)[[XKRWUserService sharedService] getUserId];
    
    _recordSportEntity.calorie = [kcalLabel.text intValue];
    
    _recordSportEntity.number = [componentTextField.text integerValue];
    
    _recordSportEntity.unit = self.unit;
    
    if (_recordSportEntity.serverid == 0) {
        
        NSInteger recordTimeStamp = [_recordEneity.date timeIntervalSince1970];
        NSInteger now = [[NSDate date] timeIntervalSince1970];
        
        NSInteger plus = (now - recordTimeStamp) % 86400;
        _recordSportEntity.serverid = (uint32_t)(recordTimeStamp + plus);
        _recordSportEntity.date = _recordEneity.date;
    }
    
    if (!_isModify) {//新记录
        _recordSportEntity.imageURL = _sportEntity.sportPic;
        _recordSportEntity.sportName = _sportEntity.sportName;
        _recordSportEntity.sportMets = _sportEntity.sportMets;
        
    }else{//修改
        
    }
    
    [XKRWCui showProgressHud:@""];
    
    [MobClick event:@"clk_mark"];
    
    [self downloadWithTaskID:@"saveSportRecord" outputTask:^id{
        return @([[XKRWRecordService4_0 sharedService] saveRecord:_recordSportEntity ofType:XKRWRecordTypeSport]);
    }];
}

/**
 *  网络服务请求
 *
 *  @param result  网络服务请求成功返回的值
 *  @param taskID
 */
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"saveSportRecord"]) {
        [XKRWRecordService4_0 setNeedUpdate:YES];
        [self.recordEneity.SportArray addObject:_recordSportEntity];
        [self popView];
    }
}

/**
 *  方案网络请求失败后 处理数据
 *
 *  @param problem
 *  @param taskID
 */
- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"saveSportRecord"]) {
        XKLog(@"保存运动记录失败 exception at SportAddVC");;
//        [self.recordEneity.SportArray addObject:_recordSportEntity];
        [self popView];
    }
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}


- (void)popView {
    [componentTextField resignFirstResponder];
    if (self.isPresent) {
        //
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [super popView];
    }
    
//    if (self.isNeedHideNaviBarWhenPoped) {
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
