//
//  XKRWAddFoodVC4_0.m
//  XKRW
//
//  Created by 忘、 on 14-11-20.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWAddFoodVC4_0.h"
#import "XKRWFoodTopView.h"
#import "XKRWSepLine.h"
#import "XKRWCui.h"
#import "XKRWRecordService4_0.h"

#import "XKRWUserService.h"
#import "XKRWUtil.h"
//XKRWEstimateWeightVC
#import <XKRW-Swift.h>
#define kSegmentWidth 214
#define kComponentViewHeight 44

@interface XKRWAddFoodVC4_0 ()
{
    XKRWFoodTopView  *topView;
    UIScrollView *scrollView;

    UISegmentedControl  *unitSegmentCtr;
    UISegmentedControl  *unitSecondSegmentCtr;//第二个
    UISegmentedControl  *unitThirdSegmentCtr;//第三个
    
    UISegmentedControl  *mealSegmentCtr;
    UISegmentedControl  *mealSecondSegmentCtr;
    UITextField *componentTextField;
    
    MetricUnit unitType;
    
    NSString *_unit_new;
    NSInteger _unit_new_to_gram;
    
    UILabel *kcalLabel;
    float _recordCalorie;
    
    //单位
    UILabel *selectUnitLabel;
    
    BOOL isRecord;
    
    //额外单位数组
    NSArray *unitOthersArray;
    //单位View
    UIView *unitView;
    //餐次View
    UIView *mealView;
}


@end

@implementation XKRWAddFoodVC4_0

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    scrollView = [[UIScrollView alloc] initWithFrame:XKScreenBounds];
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.contentSize = CGSizeMake(XKAppWidth, XKAppHeight);
    scrollView.scrollEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    
    _unit_new = _foodRecordEntity.unit_new;
    
    if(!_foodRecordEntity.foodEnergy || !_foodRecordEntity.foodNutri) {
        
        __block XKRWFoodEntity *foodEntity = [[XKRWFoodService shareService] getFoodDetailFromDBWithFoodId:_foodRecordEntity.foodId];
        
        if (!foodEntity) {
            
            [XKRWCui showProgressHud:@""];
            [self downloadWithTaskID:@"downloadFoodDetail" outputTask:^id {
                
                foodEntity = [[XKRWFoodService shareService] getFoodDetailByFoodId:_foodRecordEntity.foodId];
                [[NSDictionary dictionaryWithPropertiesFromObject:foodEntity] setPropertiesToObject:_foodRecordEntity];
                return @YES;
            }];
        } else {
            
            [[NSDictionary dictionaryWithPropertiesFromObject:foodEntity] setPropertiesToObject:_foodRecordEntity];
            
            [self initView];
            [self initData];
        }
    } else {
        
        [self initView];
        [self initData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
}

//初始化视图
- (void)initView
{
    self.forbidAutoAddCloseButton = YES;
    [self addNaviBarBackButton];
    
    [self addNaviBarRightButtonWithText:@"保存" action:@selector(rightNaviItemClicked:)];
    
    self.title = @"记录食物";
    
    topView = [[XKRWFoodTopView alloc] initWithFrameAndFoodEntity:CGRectMake(0.f, 15.f,XKAppWidth, 75.f) foodEntity:_foodRecordEntity linePosition:NO isDetail:NO] ;
    [scrollView addSubview:topView];
    
    kcalLabel = [[UILabel alloc] init];
    kcalLabel.frame = CGRectMake(XKAppWidth-15-80, 0, 80, 75);
    kcalLabel.textAlignment = NSTextAlignmentRight;
    kcalLabel.font = XKDefaultFontWithSize(14.f);
    kcalLabel.textColor = XKMainSchemeColor;
    kcalLabel.backgroundColor = XKClearColor;
    kcalLabel.text = [NSString stringWithFormat:@"0kcal"];
    [topView addSubview:kcalLabel];
    
    // meals
    mealView = [[UIView alloc] initWithFrame:CGRectMake(0.f, topView.bottom + 15, XKAppWidth, 88)];
    mealView.backgroundColor = [UIColor whiteColor];
    UILabel *mealLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    mealLabel.textColor = [UIColor blackColor];
    mealLabel.font = XKDefaultFontWithSize(14.f);
    mealLabel.text = @"餐别：";
    [mealView addSubview:mealLabel];
    UIView *mealLine = [[UIView alloc] initWithFrame:CGRectMake(0.f, 88 - 0.5, XKAppWidth, 0.5)];
    mealLine.backgroundColor = XK_ASSIST_LINE_COLOR;
    [mealView addSubview:mealLine];
    [scrollView addSubview:mealView];
    
    NSArray *mealArrays = @[@"早餐",@"午餐",@"晚餐"];
    mealSegmentCtr = [[UISegmentedControl alloc] initWithItems:mealArrays];
    mealSegmentCtr.frame = CGRectMake(XKAppWidth-kSegmentWidth-15, 7, kSegmentWidth, 30);
    mealSegmentCtr.tintColor = XKMainToneColor_29ccb1;
    [mealSegmentCtr addTarget:self action:@selector(mealSegmentAction:) forControlEvents:UIControlEventValueChanged];
    [mealView addSubview:mealSegmentCtr];
    
    mealSecondSegmentCtr = [[UISegmentedControl alloc] initWithItems:@[@"加餐"]];
    mealSecondSegmentCtr.frame = CGRectMake(XKAppWidth-kSegmentWidth-15,44+7, kSegmentWidth / 3, 30);
    mealSecondSegmentCtr.tintColor = XKMainToneColor_29ccb1;
    [mealSecondSegmentCtr addTarget:self action:@selector(mealSegmentAction:) forControlEvents:UIControlEventValueChanged];
    [mealView addSubview:mealSecondSegmentCtr];
 
    isRecord = YES;
    switch (_foodRecordEntity.recordType) {
        case RecordTypeBreakfirst:
            mealSegmentCtr.selectedSegmentIndex = 0;
            break;
        case RecordTypeLanch:
            mealSegmentCtr.selectedSegmentIndex = 1;
            break;
        case RecordTypeDinner:
            mealSegmentCtr.selectedSegmentIndex = 2;
            break;
        case RecordTypeSnack:
            mealSecondSegmentCtr.selectedSegmentIndex = 0;
            break;
        default:
            mealSecondSegmentCtr.selectedSegmentIndex = 0;
            _foodRecordEntity.recordType = RecordTypeSnack;
            isRecord = NO;
            break;
    }

    //传入 额外单位
    NSMutableArray *keys = [NSMutableArray arrayWithArray:[_foodRecordEntity.foodUnit allKeys]];
    
    unsigned long i = keys.count/3;
    unitOthersArray = keys;
    if (keys.count % 3) {
        i = i + 1;
    }
    
    //单位
    unitView = [[UIView alloc] init];
    unitView.frame = CGRectMake(0.f, mealView.bottom, XKAppWidth, 44*(i+1));

    unitView.backgroundColor = [UIColor whiteColor];
    
    UILabel *unitLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    unitLable .textColor = [UIColor blackColor];
    unitLable.font = XKDefaultFontWithSize(14.0f);
    unitLable.text = @"单位：";
    [unitView addSubview:unitLable];
    
    UIView *unitLine = [[UIView alloc] init];
    if(!_foodRecordEntity.foodUnit.count){
        unitLine.frame = CGRectMake(0.f, 44-0.5, XKAppWidth, 0.5);
    }else{
        unitLine.frame = CGRectMake(0.f, 44*(i+1) - 0.5, XKAppWidth, 0.5);
    }
    unitLine.backgroundColor =  colorSecondary_e0e0e0;
    [unitView addSubview:unitLine];
    
    //分段选择器
    [self loadUnitSegment];
    
    [self loadSecondUnitSegment];
    
    [scrollView addSubview:unitView];
    
    
    //份量
    UIView  *componentView = [[UIView alloc]initWithFrame:CGRectMake(0, unitView.bottom, XKAppWidth, 44)];
    componentView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:componentView];
    
    UIView *componentLine = [[UIView alloc] initWithFrame:CGRectMake(0.f, 44-0.5, XKAppWidth, 0.5)];
    componentLine.backgroundColor =  colorSecondary_e0e0e0;
    [componentView addSubview:componentLine];
    
    UILabel *componentLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    componentLable.textColor = [UIColor blackColor];
    componentLable.font = XKDefaultFontWithSize(14.0f);
    componentLable.text = @"份量：";
    [componentView addSubview:componentLable];
    
    //编辑View
    UIView *editView = [[UIView alloc] init];
    editView.frame = CGRectMake(XKAppWidth-kSegmentWidth-15, 0, kSegmentWidth, 44);
    editView.backgroundColor = [UIColor clearColor];
    [componentView addSubview:editView];
    
    componentTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 7, 50, 30)];
    componentTextField.textColor = XKMainToneColor_29ccb1;
    componentTextField.tintColor = XKMainToneColor_29ccb1;
    
    componentTextField.keyboardType = UIKeyboardTypeNumberPad;
    componentTextField.delegate = self;
    componentTextField.font = XKDefaultFontWithSize(14.f);
    componentTextField.textAlignment = NSTextAlignmentRight;
    [componentTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
   
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (!_foodRecordEntity.unit_new || _foodRecordEntity.unit_new.length == 0) {
        
    } else {
        
    }
    
    [editView addSubview:componentTextField];
    
    
    //下线
    UIView *editBottomLine = [[UIView alloc] init];
    editBottomLine.frame = CGRectMake(0.f, componentTextField.bottom, componentTextField.width, 0.5);
    editBottomLine.backgroundColor =  [UIColor blackColor];
    [editView addSubview:editBottomLine];
    
    //克 个
    selectUnitLabel = [[UILabel alloc] init];
    selectUnitLabel.frame = CGRectMake(componentTextField.right+5, 0.f, 60,44);
    selectUnitLabel.textColor = [UIColor blackColor];
    selectUnitLabel.text = @"克";
    [editView addSubview:selectUnitLabel];
    
    //如何估算克数？
    UIButton *estimate = [UIButton buttonWithType:UIButtonTypeCustom];
    estimate.frame = CGRectMake(XKAppWidth-150-15, 0, 150, 44);
    estimate.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [estimate setTitle:@"如何估算克数？" forState:UIControlStateNormal];
    [estimate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [estimate addTarget:self action:@selector(pushToEstimateVC) forControlEvents:UIControlEventTouchUpInside];
    [componentView addSubview:estimate];
    
    //添加手势 释放键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [scrollView addGestureRecognizer:tapGesture];
    
}


- (void)addNaviBarBackButton {
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


-(void)initData{
    
    
    if(!_foodRecordEntity.unit)
    {
        unitSegmentCtr.selectedSegmentIndex = 0;
        unitType = eUnitGram;
    } else {
        
        for (int i=0; i<unitOthersArray.count; i++) {
            if([_foodRecordEntity.unit_new isEqualToString:unitOthersArray[i]]){
                unitSecondSegmentCtr.selectedSegmentIndex = i;
                unitType = 0;
            }
        }
        if (_foodRecordEntity.number) {
            componentTextField.text = [NSString stringWithFormat:@"%ld",(long)_foodRecordEntity.number];
        }else{
            componentTextField.placeholder =@"";
        }
        selectUnitLabel.text = _foodRecordEntity.unit_new;
        
        NSUInteger unitWeight = [[_foodRecordEntity.foodUnit objectForKey:selectUnitLabel.text] integerValue];
        
        NSUInteger totalWeight = [componentTextField.text integerValue]*unitWeight;
        
        NSUInteger calorie = [XKRWUtil weightToCalorie:totalWeight foodEntity:_foodRecordEntity];
        
        kcalLabel.text = [NSString stringWithFormat:@"%lukcal",(unsigned long)calorie];
        
        if(unitSecondSegmentCtr.selectedSegmentIndex > 2){
            [XKRWCui showInformationHudWithText:@"超出范围"];
        }
        if (_foodRecordEntity.calorie) {
            kcalLabel.text = [NSString stringWithFormat:@"%lukcal",(unsigned long)_foodRecordEntity.calorie];
        }
        [componentTextField becomeFirstResponder];
    }
    
    
    
}

- (void)loadUnitSegment {
        
    NSArray *unitArrays = @[@"克",@"kcal",@"千焦"];
    
    unitSegmentCtr = [[UISegmentedControl alloc]initWithItems:unitArrays];
    unitSegmentCtr.frame = CGRectMake(XKAppWidth-kSegmentWidth-15, 7, kSegmentWidth, 30);
    unitSegmentCtr.tintColor = XKMainToneColor_29ccb1;
    
    if (_foodRecordEntity.unit && (!_foodRecordEntity.unit_new || _foodRecordEntity.unit_new.length == 0)) {
        if (_foodRecordEntity.unit == 1) {
            unitSegmentCtr.selectedSegmentIndex = 0;
            unitType = eUnitGram;
        }else if (_foodRecordEntity.unit == 2){
            unitSegmentCtr.selectedSegmentIndex = 2;
            unitType = eUnitKilojoules;
        }else if (_foodRecordEntity.unit == 3){
            unitSegmentCtr.selectedSegmentIndex = 1;
            unitType = eUnitKiloCalories;
        }
    }
    [unitSegmentCtr addTarget:self action:@selector(unitSegmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [unitView addSubview:unitSegmentCtr];
}

-(void)loadSecondUnitSegment{
    
    if(unitOthersArray.count <= 3){//存在 个 半个 只单位 添加多个选择器
        unitSecondSegmentCtr = [[UISegmentedControl alloc]initWithItems:unitOthersArray];
        unitSecondSegmentCtr.frame = CGRectMake(XKAppWidth-kSegmentWidth-15,44+7, kSegmentWidth * unitOthersArray.count/3, 30);
        unitSecondSegmentCtr.tintColor = XKMainToneColor_29ccb1;
        
        [unitSecondSegmentCtr addTarget:self action:@selector(unitSecondSegmentAction:) forControlEvents:UIControlEventValueChanged];
        [unitView addSubview:unitSecondSegmentCtr];
        
    } else if ( 3 < unitOthersArray.count && unitOthersArray.count <= 6) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:unitOthersArray[0]];
        [arr addObject:unitOthersArray[1]];
        [arr addObject:unitOthersArray[2]];
        
        unitSecondSegmentCtr = [[UISegmentedControl alloc]initWithItems:arr];
        unitSecondSegmentCtr.frame = CGRectMake(XKAppWidth-kSegmentWidth-15,44+7, kSegmentWidth * unitOthersArray.count/3, 30);
        unitSecondSegmentCtr.tintColor = XKMainToneColor_29ccb1;
        
        [unitSecondSegmentCtr addTarget:self action:@selector(unitSecondSegmentAction:) forControlEvents:UIControlEventValueChanged];
        [unitView addSubview:unitSecondSegmentCtr];
        
        
        NSArray *secondArr = [[NSArray alloc] init];
        NSRange theRange;
        theRange.location = 3;
        theRange.length = unitOthersArray.count-3;
        secondArr = [unitOthersArray subarrayWithRange:theRange];
        
        unitThirdSegmentCtr = [[UISegmentedControl alloc]initWithItems:secondArr];
        unitThirdSegmentCtr.frame = CGRectMake(XKAppWidth-kSegmentWidth-15,88+7, kSegmentWidth, 30);
        unitThirdSegmentCtr.tintColor = XKMainToneColor_29ccb1;
        
        [unitThirdSegmentCtr addTarget:self action:@selector(unitThirdSegmentAction:) forControlEvents:UIControlEventValueChanged];
        [unitView addSubview:unitThirdSegmentCtr];
    }
    
}

#pragma mark - 网络处理
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    [XKRWCui hideProgressHud];
    
    if ([taskID isEqualToString:@"saveFoodRecord"]) {
        [XKRWRecordService4_0 setNeedUpdate:YES];
        [self popView];
        [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectFoodCircle];
    } else if ([taskID isEqualToString:@"downloadFoodDetail"]) {
        
        [self initView];
        [self initData];
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
    
}


- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}


#pragma --mark  Action
//保存
- (void) rightNaviItemClicked:(UIButton *)button
{
    
    if (componentTextField.text.length == 0 && componentTextField.text.floatValue < 1) {
        [XKRWCui showInformationHudWithText:@"分量不能为空"];
        return ;
    }
    
    _foodRecordEntity.uid = [[XKRWUserService sharedService] getUserId];
    
    if(unitType == eUnitGram ||
       unitType == eUnitKiloCalories ||
       unitType == eUnitKilojoules){
        
        if (unitType == eUnitGram) {
            
            NSUInteger calorie = [XKRWUtil weightToCalorie:[componentTextField.text integerValue] foodEntity:_foodRecordEntity];
            
            if (calorie == 0) {
                calorie = 1;
            }
            _foodRecordEntity.calorie = calorie;
        } else if (unitType == eUnitKiloCalories) {
            
            NSUInteger calorie = [componentTextField.text integerValue];
            if (calorie == 0) {
                calorie = 1;
            }
            
            _foodRecordEntity.calorie = calorie;
        } else if (unitType == eUnitKilojoules) {
            NSUInteger calorie = [XKRWUtil JouleToCalorie:[componentTextField.text integerValue]];
            if (calorie == 0) {
                calorie = 1;
            }
            _foodRecordEntity.calorie = calorie;
        }
        _foodRecordEntity.number = [componentTextField.text integerValue];
        
        if (_foodRecordEntity.serverid == 0) {
            NSInteger recordTimeStamp = [_foodRecordEntity.date timeIntervalSince1970];
            NSInteger now = [[NSDate date] timeIntervalSince1970];
            
            NSInteger plus = (now - recordTimeStamp) % 86400;
            _foodRecordEntity.serverid = recordTimeStamp + plus;
        }
        
        _foodRecordEntity.unit = unitType;
        _foodRecordEntity.unit_new = @"";
        
    } else {//其它单位的 处理
        
        _foodRecordEntity.unit_new = selectUnitLabel.text;
        _foodRecordEntity.number_new = [componentTextField.text integerValue];
        
    }
    [XKRWCui showProgressHud:@""];
    
    [MobClick event:@"clk_mark"];
    _foodRecordEntity.date = [NSDate today];
    [self downloadWithTaskID:@"saveFoodRecord" outputTask:^id{
        return @([[XKRWRecordService4_0 sharedService] saveRecord:_foodRecordEntity ofType:XKRWRecordTypeFood]);
    }];
    
}
//监听键盘移动
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat viewHeight = unitView.frame.origin.y + unitView.frame.size.height + kComponentViewHeight + keyboardFrame.size.height + 44 + 20 - XKAppHeight;
    
    if (viewHeight > 0) {
        if (keyboardFrame.origin.y == XKAppHeight) {
            
            [UIView animateWithDuration:duration animations:^{
                scrollView.contentSize = CGSizeMake(XKAppWidth, XKAppHeight + viewHeight + 20);
                scrollView.contentOffset = CGPointMake(0, viewHeight + 20);
            }];
        }else {
            
            [UIView animateWithDuration:duration animations:^{
                scrollView.contentSize = CGSizeMake(XKAppWidth, XKAppHeight);
                scrollView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
}

- (void)mealSegmentAction:(UISegmentedControl *)segmentCtl {
    
    if ([componentTextField isFirstResponder]) {
        [componentTextField resignFirstResponder];
    }
    
    if ([segmentCtl isEqual:mealSegmentCtr]) {
        [mealSecondSegmentCtr setSelectedSegmentIndex:UISegmentedControlNoSegment];
        switch (mealSegmentCtr.selectedSegmentIndex) {
            case 0:
                _foodRecordEntity.recordType = eMealBreakfast;
                break;
                
            case 1:
                _foodRecordEntity.recordType = eMealLunch;
                break;
                
            case 2:
                _foodRecordEntity.recordType = eMealDinner;
                break;
                
            default:
                break;
        }
        
    } else if ([segmentCtl isEqual:mealSecondSegmentCtr]) {
        [mealSegmentCtr setSelectedSegmentIndex:UISegmentedControlNoSegment];
        _foodRecordEntity.recordType = eMealSnack;
    }
}

- (void) unitSegmentAction:(UISegmentedControl *)segment
{
    _unit_new = nil;
    
    if ([componentTextField isFirstResponder]) {
        [componentTextField resignFirstResponder];
    }
    
    if(unitSecondSegmentCtr){
        [unitSecondSegmentCtr setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [unitThirdSegmentCtr setSelectedSegmentIndex:UISegmentedControlNoSegment];
    }
    
    int textNum = [componentTextField.text intValue];
    
    if (segment.selectedSegmentIndex == 0)
    {
        unitType = eUnitGram;
        if (textNum > 1000) {
            componentTextField.placeholder = @"0";
            componentTextField.text = @"";
            textNum = 0;
        }
        selectUnitLabel.text = @"克";
        NSUInteger calorie = [XKRWUtil weightToCalorie:textNum foodEntity:_foodRecordEntity];
        kcalLabel.text = [NSString stringWithFormat:@"%lukcal",(unsigned long)calorie];
        
    } else if (segment.selectedSegmentIndex == 1) {
        
        unitType = eUnitKiloCalories;
        if (textNum > 5000) {
            componentTextField.placeholder = @"0";
            componentTextField.text = @"";
            textNum = 0;
        }
        selectUnitLabel.text = @"kcal";
        kcalLabel.text = [NSString stringWithFormat:@"%dkcal",textNum];
    } else {
        unitType = eUnitKilojoules;
        if (textNum >20000) {
            componentTextField.placeholder = @"0";
            componentTextField.text = @"";
            textNum = 0;
        }
        selectUnitLabel.text = @"千焦";
        NSUInteger calorie = [XKRWUtil JouleToCalorie:textNum];
        kcalLabel.text = [NSString stringWithFormat:@"%lukcal",(unsigned long)calorie];
    }
}


-(void)unitSecondSegmentAction:(UISegmentedControl *)segment
{
    if ([componentTextField isFirstResponder]) {
        [componentTextField resignFirstResponder];
    }
    
    if(unitSegmentCtr){
        [unitSegmentCtr setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [unitThirdSegmentCtr setSelectedSegmentIndex:UISegmentedControlNoSegment];
    }
    
    int textNum = [componentTextField.text intValue];
    if (textNum >50) {
        componentTextField.placeholder = @"0";
        componentTextField.text = @"";
    }
    if (segment.selectedSegmentIndex == 0){
        
        selectUnitLabel.text = unitOthersArray[0];
        
    }else if (segment.selectedSegmentIndex == 1){
        
        selectUnitLabel.text = unitOthersArray[1];
    }else{

        selectUnitLabel.text = unitOthersArray[2];
    }
    unitType = 0;
    _unit_new = selectUnitLabel.text;
    
    _unit_new_to_gram = [[_foodRecordEntity.foodUnit objectForKey:selectUnitLabel.text] integerValue];
    
    kcalLabel.text = [NSString stringWithFormat:@"0kcal"];
    componentTextField.text = [NSString stringWithFormat:@""];
}

-(void)unitThirdSegmentAction:(UISegmentedControl *)segment{

    if ([componentTextField isFirstResponder]) {
        [componentTextField resignFirstResponder];
    }
    //设置其他单位不被选中
    if(unitSegmentCtr){
        [unitSegmentCtr setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [unitSecondSegmentCtr setSelectedSegmentIndex:UISegmentedControlNoSegment];
        //        [self loadUnitSegment];
    }
    
    int textNum = [componentTextField.text intValue];
    if (textNum >50) {
        componentTextField.placeholder = @"0";
        componentTextField.text = @"";
    }
    if (segment.selectedSegmentIndex == 0){
        
        selectUnitLabel.text = unitOthersArray[3+0];
        
    }else if (segment.selectedSegmentIndex == 1){
        
        selectUnitLabel.text = unitOthersArray[3+1];
    }else{
        
        selectUnitLabel.text = unitOthersArray[3+2];
    }
    unitType = 0;
    _unit_new = selectUnitLabel.text;
    
    _unit_new_to_gram = [[_foodRecordEntity.foodUnit objectForKey:selectUnitLabel.text] integerValue];
    
    kcalLabel.text = [NSString stringWithFormat:@"0kcal"];
    componentTextField.text = [NSString stringWithFormat:@""];
}

- (void) tapAction:(UITapGestureRecognizer *)tap
{
    if ([componentTextField isFirstResponder]) {
        [componentTextField resignFirstResponder];
    }
}

- (void)popView {
    
    [componentTextField resignFirstResponder];
    if (_isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        [super popView];
//        if (self.isNeedHideNaviBarWhenPoped) {
//            [self.navigationController setNavigationBarHidden:YES animated:NO];
//        }
    }
}

-(void)pushToEstimateVC{
    [componentTextField resignFirstResponder];
    XKRWEstimateWeightVC *vc = [[XKRWEstimateWeightVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma --mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (void)textFieldChange:(UITextField *)textField
{
    int textNum = [textField.text intValue];
    
    if(!_unit_new || _unit_new.length == 0) {
        
        if (unitType == eUnitGram) {
            if(textNum > 1000){
                [XKRWCui showInformationHudWithText:@"超出记录范围"];
                textField.text = @"1000";
            }
            
        }else if (unitType == eUnitKiloCalories)
        {
            if(textNum > 5000){
                [XKRWCui showInformationHudWithText:@"超出记录范围"];
                textField.text = @"5000";
            }
        }else if(unitType == eUnitKilojoules){
            if(textNum >20000){
                [XKRWCui showInformationHudWithText:@"超出记录范围"];
                textField.text = @"20000";
            }
        }
        
        
        int textNum = [textField.text intValue];
        if (unitType == eUnitGram){
            NSUInteger calorie = [XKRWUtil weightToCalorie:textNum foodEntity:_foodRecordEntity];
            kcalLabel.text = [NSString stringWithFormat:@"%lukcal",(unsigned long)calorie];
            
        }else if (unitType == eUnitKiloCalories){
            kcalLabel.text = [NSString stringWithFormat:@"%dkcal",textNum];
        }else if(unitType == eUnitKilojoules){
            NSUInteger calorie = [XKRWUtil JouleToCalorie:textNum];
            kcalLabel.text = [NSString stringWithFormat:@"%lukcal",(unsigned long)calorie];
        }else{
            NSUInteger unitWeight = [[_foodRecordEntity.foodUnit objectForKey:selectUnitLabel.text] integerValue];
            
            NSUInteger totalWeight = [textField.text integerValue] * unitWeight;
            
            NSUInteger calorie = [XKRWUtil weightToCalorie:totalWeight foodEntity:_foodRecordEntity];
            
            kcalLabel.text = [NSString stringWithFormat:@"%lukcal",(unsigned long)calorie];
        }
    } else {
        
        if (textNum > 50) {
            [XKRWCui showInformationHudWithText:@"超出记录范围"];
            textField.text = @"50";
            textNum = 50;
        }
        NSInteger gram = _unit_new_to_gram * textNum;
        NSUInteger calorie = [XKRWUtil weightToCalorie:gram foodEntity:_foodRecordEntity];
        kcalLabel.text = [NSString stringWithFormat:@"%lukcal",(unsigned long)calorie];
        _recordCalorie = calorie;
    }
    if (textNum == 0) {
        textField.text = @"";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (void)presentAddFoodVC:(XKRWAddFoodVC4_0 *)vc onViewController:(UIViewController *)onvc {

    XKRWNavigationController *nav = [[XKRWNavigationController alloc] initWithRootViewController:vc];
    vc.isPresent = YES;
    [onvc presentViewController:nav animated:YES completion:nil];
}

@end
