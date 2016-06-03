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
    UIImageView *logoIV;
    //单位View
    UIView *unitView;
    
    UITextField *componentTextField;
    //单位
    UILabel *selectUnitLabel;
    //
    UILabel *sportName;
    
    UISegmentedControl  *unitSegmentCtr;
    
}


@property (nonatomic, strong) UILabel           *lbTitle;   //标题s
@property (nonatomic, strong) UIScrollView      *lbTitleBG;  //作为背景
@property (nonatomic, strong) UILabel           *lbDesc;    //描述
@property (nonatomic, strong) UIView            *datePart; //日期选择  View
@property (nonatomic, strong) XKRWNaviRightBar   *rightBar;
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
    [super viewDidLoad];
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
    
    self.unit = 7;

    //logo背景
    logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 55.f, 55.f)];
    CALayer *layer  = logoIV.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.f];
    layer.shouldRasterize = YES;
    
    //设置食物Logo
    
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
    
    if (_sportEntity.sportMets != 0 || _recordSportEntity != nil ) {
        [self setDataToUI];
    }
}


- (void) setDataToUI {
    if (_recordSportEntity != nil) {
        [logoIV setImageWithURL:[NSURL URLWithString:_recordSportEntity.sportActionPic] placeholderImage:[UIImage imageNamed:@"default_pic"]];
        sportName.text = _recordSportEntity.sportName;
        if (_recordSportEntity) {//修改
            kcalLabel.text = [NSString stringWithFormat:@"%liKcal",(long)_recordSportEntity.calorie];
            componentTextField.text = [NSString stringWithFormat:@"%ld",(long)_recordSportEntity.number];
        }

    }else{
        [logoIV setImageWithURL:[NSURL URLWithString:_sportEntity.sportActionPic] placeholderImage:[UIImage imageNamed:@"default_pic"]];
        sportName.text = _sportEntity.sportName;
    }
}

-(void)initData{

    if (_sportEntity != nil && _sportEntity.sportId != 0) {
        _sportID = _sportEntity.sportId;
    }
    
    if (_recordSportEntity != nil && _recordSportEntity.sportId != 0) {
        _sportID = _recordSportEntity.sportId;
    }
    
    if (_recordSportEntity.sportMets == 0 || _sportEntity.sportMets == 0  ) {
        if([XKRWUtil isNetWorkAvailable]){
            [XKRWCui showProgressHud:@"加载中..."];
            [self downloadWithTaskID:@"getSportDetail" outputTask:^(){
                return [[XKRWSportService shareService] syncQuerySportWithId:_sportID];
            }];
        }else{
            [XKRWCui showInformationHudWithText:@"获取运动信息失败，请稍后尝试"];
        }
    }
}

#pragma mark - 触发事件
//  监听 TextField的改变
- (void) textFieldChange:(UITextField *)textField
{
    if (textField.text.length !=0) {
        NSInteger num = [textField.text integerValue];
        if (num == 0) {
            [XKRWCui showInformationHudWithText:@"消耗热量不能为0"];
            textField.text = @"1";
        }
        
        if (num >2880) {
            [XKRWCui showInformationHudWithText:@"超过记录值"];
            textField.text = @"2880";
        }
    
        float nearestWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:_recordDate];
        if (_recordSportEntity && _recordSportEntity.sportMets != 0) {//修改
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

- (void) addNaviBarRightButton
{
    self.rightBar = [[XKRWNaviRightBar alloc] initWithFrameAndTitle:CGRectMake(0.f, 0.f, 44.f, 44.f) title:@"保存"];
    [_rightBar addTarget:self action:@selector(rightNaviItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBar];
    
}

- (void) addNaviBarBackButton
{
    if (self.isPresent) {
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



#pragma mark 记录运动
/**
 *  执行保存记录
 */
- (void) rightNaviItemClicked:(UIButton *)button
{
    [MobClick event:@"clk_mark"];
    
    if (componentTextField.text.length == 0 && componentTextField.text.floatValue == 0) {
        [XKRWCui showInformationHudWithText:@"时间不能为空"];
        return ;
    }
    
    if (_recordSportEntity == nil) {
        _recordSportEntity = [[XKRWRecordSportEntity alloc] init];
        _recordSportEntity.imageURL = _sportEntity.sportPic;
        _recordSportEntity.sportMets = _sportEntity.sportMets;
        _recordSportEntity.sportName = _sportEntity.sportName;
        _recordSportEntity.unit = _sportEntity.sportUnit;
        _recordSportEntity.sportId = _sportEntity.sportId;
        _recordSportEntity.date = _recordDate;
    }
    _recordSportEntity.recordType = 0;
    _recordSportEntity.uid = (int)[[XKRWUserService sharedService] getUserId];
    _recordSportEntity.calorie = [kcalLabel.text intValue];
    _recordSportEntity.number = [componentTextField.text integerValue];
    _recordSportEntity.unit = self.unit;
    if (_recordSportEntity.serverid == 0) {
        _recordSportEntity.date = _recordDate ? _recordDate : (_recordSportEntity.date ? _recordSportEntity.date:[NSDate date]);
        NSInteger recordTimeStamp = [_recordSportEntity.date timeIntervalSince1970];
        NSInteger now = [[NSDate date] timeIntervalSince1970];
        
        NSInteger plus = (now - recordTimeStamp) % 86400;
        _recordSportEntity.serverid = (uint32_t)(recordTimeStamp + plus);
      
    }

    [self downloadWithTaskID:@"saveSportRecord" outputTask:^id{
        return @([[XKRWRecordService4_0 sharedService] saveRecord:_recordSportEntity ofType:XKRWRecordTypeSport]);
    }];
}

#pragma --mark  网络处理
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"saveSportRecord"]) {
        [XKRWRecordService4_0 setNeedUpdate:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectSportCircle];
         [self popView];
        if ([self.delegate respondsToSelector:@selector(refreshSportData)]) {
            [self.delegate refreshSportData];
        }
    }
    
    if ([taskID isEqualToString:@"getSportDetail"]) {
        _sportEntity = (XKRWSportEntity *)result;
        [self setDataToUI];
    }
    
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    [super handleDownloadProblem:problem withTaskID:taskID];
    if ([taskID isEqualToString:@"saveSportRecord"]) {
        XKLog(@"保存运动记录失败 exception at SportAddVC");
        [XKRWCui showInformationHudWithText:@"保存运动记录失败，请稍后再试"];
    }
    
    if ([taskID isEqualToString:@"getSportDetail"]) {
        [XKRWCui showInformationHudWithText:@"获取运动详情失败，请稍后再试"];
    }
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}


- (void)popView {
    [componentTextField resignFirstResponder];
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [super popView];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
