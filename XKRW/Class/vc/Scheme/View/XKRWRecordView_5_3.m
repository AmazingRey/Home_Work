//
//  XKRWRecordFood5_3View.m
//  XKRW
//
//  Created by ss on 16/4/13.
//  Copyright © 2016年 XiKang. All rights reserved.
//
#define labStatus_RecordWeight @"_labRecordWeight"
#define labStatus_PushMenu @"_labPushMenu"
#import "define.h"
#import "XKRWRecordView_5_3.h"
#import "XKRWRecordCell_5_3.h"
#import "XKRWRecommandedCell_5_3.h"
#import "XKRWAlgolHelper.h"
#import "XKRWRecordMore5_3View.h"
#import "XKRWPlan_5_3CollectionView.h"
#import "XKRWFatReasonService.h"
#import "XKRWRecordVC.h"
#import "XKRWUtil.h"
#import "XKRWAlgolHelper.h"
#import "XKRWUserService.h"
#import "XKRWRecordService4_0.h"
#import "XKRWSportEntity.h"
#import "XKRWFoodEntity.h"
#import "XKRWSportAddVC.h"
#import "XKRWAddFoodVC4_0.h"
#import "XKRW-Swift.h"
#import "XKRWHabitListView.h"
#import "XKRWRecordSchemeEntity.h"
#import "XKRWNavigationController.h"
#import "XKRWPlanService.h"

@interface XKRWRecordView_5_3 () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,XKRWSportAddVCDelegate,XKRWAddFoodVC4_0Delegate>
{
    UITableView *recordTableView;
    UIImageView *schemePastImageView ;
    XKRWRecordEntity4_0 *recordEntity;
    UITableView *recommendedTableView;
    XKRWHabitListView *habitView;
    NSArray  *recordTypeTitleArray;
    NSArray  *recordTypeImageArray;
    BOOL     isRecommended;     //判断当前是推荐状态 还是记录状态
    
    NSInteger  showDetailSection;
    
    NSArray  *recordArray;  //早午晚加
    RecordType myRecordType;
    NSArray  *detailRecordArray;
    
    NSDictionary *schemeDetail;  // 是否方案记录 以及 卡路里
    
    NSInteger breakfirstIntake;
    NSInteger lunchIntake;
    NSInteger dinnerIntake;
    NSInteger snackIntake;
    
    NSMutableArray *breakfirstArray;
    NSMutableArray *lunchArray;
    NSMutableArray *dinnerArray;
    NSMutableArray *snackArray;
    
    NSArray *intakeArray;
}

@property (weak, nonatomic) IBOutlet UIView *testViewFrame;
@property (strong ,nonatomic) XKRWRecordMore5_3View *moreView;

@end

@implementation XKRWRecordView_5_3
-(void)initSubViews {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashUIAndData:) name:EnergyCircleDataNotificationName object:nil];
    _scrollView.delegate = self;
    showDetailSection = -1;
    _shadowImageView =[[UIImageView alloc]initWithFrame:CGRectMake((XKAppWidth - 800) /2 + (_positionX - XKAppWidth /2) , 0, 800, 10)];
    _shadowImageView.image = [UIImage imageNamed:@"shadow"];
    [self addSubview:_shadowImageView];
    
    if (XKAppHeight == 480) {
        _scrollViewConstraint.constant = 134;
        _scrollView.frame = CGRectMake(0, 0, XKAppWidth, _scrollViewConstraint.constant);
    }
    
    _scrollView.contentSize = CGSizeMake( XKAppWidth * 2, _scrollView.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = XK_BACKGROUND_COLOR ;
    recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, _scrollView.height) style:UITableViewStylePlain];
    recordTableView.tag = 5031;
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recordTableView.delegate = self;
    recordTableView.backgroundColor = XK_BACKGROUND_COLOR;
    recordTableView.dataSource = self;
    [recordTableView registerNib:[UINib nibWithNibName:@"XKRWRecordCell_5_3" bundle:nil] forCellReuseIdentifier:@"recordCell"];
    
    recommendedTableView = [[UITableView alloc] initWithFrame:CGRectMake(XKAppWidth, 0, XKAppWidth, _scrollView.height) style:UITableViewStylePlain];
    recommendedTableView.tag = 5032;
    recommendedTableView.delegate = self;
    recommendedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recommendedTableView.dataSource = self;
    recommendedTableView.backgroundColor = XK_BACKGROUND_COLOR;
    [recommendedTableView registerNib:[UINib nibWithNibName:@"XKRWRecommandedCell_5_3" bundle:nil] forCellReuseIdentifier:@"recommendedCell"];
    [_scrollView addSubview:recordTableView];
    [_scrollView addSubview:recommendedTableView];
    
    
    habitView = [[XKRWHabitListView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, _scrollView.height)];
    
    [_scrollView addSubview:habitView];
    
    _leftButton.layer.cornerRadius = 5;
    _leftButton.layer.borderWidth = 1;
    _leftButton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    
    _centerbutton.layer.cornerRadius = 5;
    _centerbutton.layer.borderWidth = 1;
    _centerbutton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    
    _rightButton.layer.cornerRadius = 5;
    _rightButton.layer.borderWidth = 1;
    if (_revisionType == XKRWNotNeedRevision) {
        _rightButton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    }else if (_revisionType == XKRWCanRevision){
        _rightButton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
         [_rightButton setTitle:@"补记" forState:UIControlStateNormal];
    }else{
        _rightButton.layer.borderColor = colorSecondary_666666.CGColor;
        [_rightButton setTitleColor:colorSecondary_666666 forState:UIControlStateNormal];
        [_rightButton setTitle:@"不能补记" forState:UIControlStateNormal];
        _rightButton.enabled = NO;
    }
    
    schemePastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XKAppWidth, 0, _scrollView.width, _scrollView.height)];
    
    UILabel *schemePastLabel = [[UILabel alloc]initWithFrame:CGRectMake((_scrollView.width - 200)/2 , (_scrollView.height - 30)/2, 200, 30)];
    schemePastLabel.font = XKDefaultFontWithSize(14);
    schemePastLabel.textColor = colorSecondary_666666;
    schemePastLabel.textAlignment = NSTextAlignmentCenter;
    [schemePastImageView addSubview:schemePastLabel];
    if (_type == energyTypeEat) {
        schemePastImageView.image = [UIImage imageNamed:@"schemePast"];
        schemePastLabel.text = @"食谱已过期";
    }else if(_type == energyTypeSport) {
        schemePastImageView.image = [UIImage imageNamed:@"sportSchemePast"];
        schemePastLabel.text = @"运动已过期";
    }
    schemePastImageView.hidden = YES;
    
    
    [_scrollView addSubview:schemePastImageView];
    
    _scrollView.scrollEnabled = NO;
}

-(void)setsubViewUI {
    _labSeperate.hidden = YES;
    _habitLabel.hidden = YES;
    _recordTypeLabel.hidden = NO;
    _recommendedTypeLabel.hidden = NO;
    _leftButton.hidden = YES;
    _centerbutton.hidden = YES;
    _rightButton.hidden = YES;
    switch (_type) {
        case energyTypeEat:
            _recordTypeLabel.textColor = XKMainToneColor_29ccb1;
            _recommendedTypeLabel.textColor = XK_TEXT_COLOR;
            _labSeperate.hidden = NO;
            _leftButton.hidden = NO;
            _rightButton.hidden = NO;
            break;
        case energyTypeSport:
            _recordTypeLabel.textColor = XKMainToneColor_29ccb1;
            _recommendedTypeLabel.textColor = XK_TEXT_COLOR;
            _labSeperate.hidden = NO;
             habitView.hidden = YES;
            break;
        case energyTypeHabit:
            _recordTypeLabel.hidden = YES;
            _recommendedTypeLabel.hidden = YES;
            _habitLabel.hidden = NO;
            _actionView.hidden = YES;
            habitView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            _scrollviewHeight.constant = 243;
            _activeHeight.constant = 0;
            break;
        default:
            break;
    }
    [self setDataToUI];
}

- (void) setDataToUI {
    switch (_type) {
        case energyTypeEat:
            [self setFoodDataToUI];
            break;
        case energyTypeSport:
            [self setSportDataToUI];
            break;
        case energyTypeHabit:
            [self setHabitDataToUI];
            break;
        default:
            break;
    }
}

- (void) setFoodDataToUI {
    recordEntity = [[XKRWPlanService shareService] getAllRecordOfDay:_date];
    //每日饮食推荐值
    CGFloat totalFoodCalories = [XKRWAlgolHelper dailyIntakeRecomEnergy];
    //获取就餐比例的 百分比
    NSDictionary *mealRatioDic =[[XKRWUserService sharedService] getMealRatio];
    CGFloat breakfast = totalFoodCalories * [[mealRatioDic objectForKey:@"breakfast"] floatValue] /100.f;
    CGFloat lunch = totalFoodCalories *[[mealRatioDic objectForKey:@"lunch"] floatValue] /100.f;
    CGFloat supper = totalFoodCalories* [[mealRatioDic objectForKey:@"supper"] floatValue] /100.f;
    CGFloat snack = totalFoodCalories *[[mealRatioDic objectForKey:@"snack"] floatValue] /100.f;

    breakfirstIntake = 0;
    lunchIntake = 0;
    dinnerIntake = 0;
    snackIntake = 0;
    
    breakfirstArray = [NSMutableArray array];
    lunchArray = [NSMutableArray array];
    dinnerArray = [NSMutableArray array];
    snackArray = [NSMutableArray array];
    
    for (XKRWRecordFoodEntity *foodEntity in recordEntity.FoodArray) {
        if (foodEntity.recordType == RecordTypeBreakfirst) {
            [breakfirstArray addObject:foodEntity];
            breakfirstIntake += foodEntity.calorie;
        } else if (foodEntity.recordType == RecordTypeLanch) {
            [lunchArray addObject:foodEntity];
            lunchIntake += foodEntity.calorie;
        } else if (foodEntity.recordType == RecordTypeDinner) {
            [dinnerArray addObject:foodEntity];
            dinnerIntake += foodEntity.calorie;
        } else if (foodEntity.recordType == RecordTypeSnack) {
            [snackArray addObject:foodEntity];
            snackIntake += foodEntity.calorie;
        }
    }

    recordTypeTitleArray = @[@"早餐",@"午餐",@"晚餐",@"加餐"];
    recordTypeImageArray = @[@"breakfast5_3",@"lunch5_3",@"dinner5_3",@"addmeal5_3"];
    detailRecordArray = @[breakfirstArray,lunchArray,dinnerArray,snackArray];
    recordArray =@[[NSNumber numberWithFloat:breakfast],[NSNumber numberWithFloat:lunch],[NSNumber numberWithFloat:supper],[NSNumber numberWithFloat:snack]];
    habitView.hidden = YES;
    schemeDetail =[[XKRWRecordService4_0 sharedService] getSchemeRecordWithDate:_date andType:6];
    
    if (schemeDetail != nil) {
        XKRWRecordSchemeEntity *entity = [schemeDetail objectForKey:@"schemeEntity"];
        _recommendedTypeLabel.text = [NSString stringWithFormat:@"推荐食谱\n%ldKcal",(long)entity.calorie];
    }else{
        _recommendedTypeLabel.text = @"推荐食谱";
    }
    
    [self dealCenterButtonShowAndAction];
    
    CGFloat recordFoodColories = breakfirstIntake + lunchIntake + dinnerIntake + snackIntake ;
    intakeArray = @[@(breakfirstIntake),@(lunchIntake),@(dinnerIntake),@(snackIntake)];
    
    if (recordFoodColories > 0) {
        _recordTypeLabel.text = [NSString stringWithFormat:@"记录饮食\n%.0fKcal",recordFoodColories];
    }else{
        _recordTypeLabel.text = @"记录饮食";
    }
    [recordTableView reloadData];
    [recommendedTableView reloadData];

}


- (void) setSportDataToUI{
    recordEntity = [[XKRWPlanService shareService] getAllRecordOfDay:_date];
    //每日运动消耗推荐值
    recordTypeTitleArray = @[@"运动"];
    recordTypeImageArray =@[@"sports5_3"];
    detailRecordArray = recordEntity.SportArray;
    
    CGFloat totalSportCalories = [XKRWAlgolHelper dailyConsumeSportEnergy];
    recordArray = @[[NSNumber numberWithFloat:totalSportCalories]];
    
    CGFloat intakeSportCalories = 0;
    for (XKRWRecordSportEntity *sportEntity in recordEntity.SportArray){
        intakeSportCalories += sportEntity.calorie;
    }
    intakeArray = @[[NSNumber numberWithFloat:intakeSportCalories]];

    schemeDetail =[[XKRWRecordService4_0 sharedService] getSchemeRecordWithDate:_date andType:5];
    if (schemeDetail != nil) {
        XKRWRecordSchemeEntity *entity = [schemeDetail objectForKey:@"schemeEntity"];
        _recommendedTypeLabel.text = [NSString stringWithFormat:@"推荐运动\n%ldKcal",(long)entity.calorie];
    }else{
        _recommendedTypeLabel.text = @"推荐运动";
    }
    
    [self dealCenterButtonShowAndAction];

    CGFloat recordSportColories = 0 ;
    for (XKRWRecordSportEntity *sportEntity in recordEntity.SportArray) {
        recordSportColories += sportEntity.calorie;
    }
    if (recordSportColories > 0) {
        _recordTypeLabel.text = [NSString stringWithFormat:@"记录运动\n%.0fKcal",recordSportColories];
    }else{
        _recordTypeLabel.text = @"记录运动";
    }
    [recordTableView reloadData];
    [recommendedTableView reloadData];
}

- (void)setHabitDataToUI {
    recordEntity = [[XKRWPlanService shareService] getAllRecordOfDay:_date];
    __weak typeof(self) weakSelf = self;
    __block NSInteger currectHabitCount = 0;
    for (XKRWHabbitEntity *habitEntity in recordEntity.habitArray) {
        currectHabitCount += habitEntity.situation;
    }
    
    _habitLabel.text = [NSString stringWithFormat:@"改正了%ld个不良习惯",(long)currectHabitCount];
    habitView.entity = recordEntity;
    habitView.changeHabit = ^(NSInteger habitIndex,BOOL abool) {
        
        weakSelf.habitLabel.text = [NSString stringWithFormat:@"改正了%ld个不良习惯",(long)(abool ? ++currectHabitCount:--currectHabitCount)];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(fixHabitAt:isCurrect:)]) {
            [weakSelf.delegate fixHabitAt:habitIndex isCurrect:abool];
        }
    };

}


-(void)setType:(energyType)type{
    if (_type != type) {
        _type = type;
    }
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 5031) {
        return recordTypeTitleArray.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 5031) {
        if (section == showDetailSection) {
            if (_type == energyTypeSport) {
                return detailRecordArray.count;
            }else if(_type == energyTypeEat){
                return [[detailRecordArray objectAtIndex:section] count];
            }
        }else{
            return 0;
        }
        
    }else if (tableView.tag == 5032){
        return _schemeArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 5031){
        return 44;
    }else if (tableView.tag == 5032){
        return 59;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 5031) {
        id temp;
        
        if (_type == energyTypeSport) {
            temp =[detailRecordArray objectAtIndex:indexPath.row];
            if([self.delegate respondsToSelector:@selector(deleteSchemeRecord:andType:andEntryType:)]) {
                [self.delegate deleteSchemeRecord:temp andType:XKRWRecordTypeSport andEntryType:_type];
            }
        }else if (_type == energyTypeEat){
            switch (indexPath.section) {
                case 0:
                    temp = breakfirstArray[indexPath.row];
                    break;
                case 1:
                    temp = lunchArray[indexPath.row];
                    break;
                case 2:
                    temp = dinnerArray[indexPath.row];
                    break;
                case 3:
                    temp = snackArray[indexPath.row];
                    break;
                default:
                    temp = nil;
                    break;
            }
            
            if([self.delegate respondsToSelector:@selector(deleteSchemeRecord:andType:andEntryType:)]) {
                [self.delegate deleteSchemeRecord:temp andType:XKRWRecordTypeFood andEntryType:_type];
            }
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 5031) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 5031) {
        XKRWRecordCell_5_3 *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
        
        if (indexPath.section == showDetailSection){
            id temp;
            if (_type == energyTypeSport) {
                temp = [detailRecordArray objectAtIndex:indexPath.row];
            }else if (_type == energyTypeEat){
                temp = [[detailRecordArray objectAtIndex:indexPath.section]  objectAtIndex:indexPath.row];
            }
            if (![temp isKindOfClass:[XKRWRecordFoodEntity class]] && ![temp isKindOfClass:[XKRWRecordSportEntity class]]) {
                cell.recordDetailTitle.text = [temp objectForKey:@"title"];
                cell.recordDetailCalories.text =[temp objectForKey:@"calorie"];
                cell.recordArrowImageView.hidden = YES;
            }else if ([temp isKindOfClass:[XKRWRecordFoodEntity class]]){
                cell.recordArrowImageView.hidden = NO;
                cell.recordDetailTitle.text = ((XKRWRecordFoodEntity *)temp).foodName;
                cell.recordDetailCalories.text = [NSString stringWithFormat:@"%dKcal",(int)((XKRWRecordFoodEntity *)temp).calorie];
            }else{
                cell.recordArrowImageView.hidden = NO;
                cell.recordDetailTitle.text = ((XKRWRecordSportEntity *)temp).sportName;
                cell.recordDetailCalories.text = [NSString stringWithFormat:@"%dKcal",(int)((XKRWRecordSportEntity *)temp).calorie];
            }
        }
        [XKRWUtil addViewUpLineAndDownLine:cell.contentView andUpLineHidden:YES DownLineHidden:NO];
        return cell;
    }else if (tableView.tag == 5032){
        XKRWSchemeEntity_5_0 *entity = [_schemeArray objectAtIndex:indexPath.row];
        XKRWRecommandedCell_5_3 *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendedCell"];
        cell.frame = CGRectMake(0, 0, self.width, 59);
        cell.mealImageView.image = [UIImage imageNamed:[self getImageNameWithType:entity.schemeType]];
        NSMutableString *schemeDetailStr =[NSMutableString string];
        if (_type == energyTypeEat) {
            for (XKRWFoodCategoryEntity *foodEntity in entity.foodCategories ) {
                if (schemeDetailStr.length == 0) {
                    [schemeDetailStr appendString:foodEntity.categoryName];
                }else{
                    [schemeDetailStr appendString:[NSString stringWithFormat:@"+%@",foodEntity.categoryName]];
                }
            }
        }else if (_type == energyTypeSport){
            for (XKRWSportEntity *sportEntity in [[XKRWSchemeService_5_0 sharedService] getCurrentSchemeSportEntities]) {
                if (schemeDetailStr.length == 0) {
                    [schemeDetailStr appendString:sportEntity.sportName];
                }else{
                    [schemeDetailStr appendString:[NSString stringWithFormat:@"+%@",sportEntity.sportName]];
                }
            }
        }
        cell.mealLabel.text = entity.schemeName;
        cell.mealDetailLabel.text = schemeDetailStr;
        [XKRWUtil addViewUpLineAndDownLine:cell.contentView andUpLineHidden:YES DownLineHidden:NO];
        return  cell;
    }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 5031) {
        id temp;
        
        if (_type == energyTypeSport) {
                temp =[detailRecordArray objectAtIndex:indexPath.row];
        }else if (_type == energyTypeEat){
            switch (indexPath.section) {
                case 0:
                    temp = breakfirstArray[indexPath.row];
                    break;
                case 1:
                    temp = lunchArray[indexPath.row];
                    break;
                case 2:
                    temp = dinnerArray[indexPath.row];
                    break;
                case 3:
                    temp = snackArray[indexPath.row];
                    break;
                default:
                    temp = nil;
                    break;
            }
        }
        
        if (![temp isKindOfClass:[XKRWRecordFoodEntity class]] && ![temp isKindOfClass:[XKRWRecordSportEntity class]]) {
            return;
        }else if ([temp isKindOfClass:[XKRWRecordFoodEntity class]]){
            XKRWAddFoodVC4_0 *addFoodVC = [[XKRWAddFoodVC4_0 alloc] init];
            addFoodVC.foodRecordEntity = temp;
            addFoodVC.delegate = self;
            [XKRWAddFoodVC4_0 presentAddFoodVC:addFoodVC onViewController:_vc];
            
        }else{
            XKRWSportAddVC *addVC = [[XKRWSportAddVC alloc] init];
            XKRWNavigationController *nav = [[XKRWNavigationController alloc] initWithRootViewController:addVC withNavigationBarType:NavigationBarTypeDefault];
            addVC.sportID = ((XKRWRecordSportEntity *)temp).sportId;
            addVC.recordSportEntity = ((XKRWRecordSportEntity *)temp);
            addVC.isPresent = YES;
            addVC.delegate = self;
            [_vc presentViewController:nav animated:YES completion:nil];
        }
        
    }else if (tableView.tag == 5032){
        XKRWSchemeEntity_5_0 *entity = [_schemeArray objectAtIndex:indexPath.row];
        XKRWSchemeDetailVC *schemeDetailVC = [[XKRWSchemeDetailVC alloc] init];
        schemeDetailVC.schemeEntity = entity;
        schemeDetailVC.hidesBottomBarWhenPushed = YES;
        [_vc.navigationController pushViewController:schemeDetailVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView.tag == 5031){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 44)];
        headerView.backgroundColor = XK_BACKGROUND_COLOR;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (44-29)/2, 29, 29)];
        
        imageView.image = [UIImage imageNamed:[recordTypeImageArray objectAtIndex:section]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 10, 0, 100, 44)];
        label.text = [recordTypeTitleArray objectAtIndex:section];
        label.font = XKDefaultFontWithSize(15.f);
        label.textColor = colorSecondary_333333;
        [headerView addSubview:imageView];
        [headerView addSubview:label];
        
        UIImageView *arrowImageView = [[UIImageView alloc]init];
        arrowImageView.frame = CGRectMake(XKAppWidth-15-8, (44-6)/2, 8, 6);
        if(showDetailSection == section){
            arrowImageView.image = [UIImage imageNamed:@"upmenu"];
        }else{
            arrowImageView.image = [UIImage imageNamed:@"dropdown menu"];
        }
        [headerView addSubview:arrowImageView];
        
        UILabel *calorieLabel = [[UILabel alloc]initWithFrame:CGRectMake(XKAppWidth-150-15-15, 0, 150, 44)];
        calorieLabel.font = XKDefaultFontWithSize(15.f);
       
        calorieLabel.textAlignment = NSTextAlignmentRight;
        [headerView addSubview:calorieLabel];
        
        //推荐卡路里
        CGFloat recommendedCalorie = [[recordArray objectAtIndex:section] floatValue];
        //当前已经记录的卡路里
        CGFloat sumCalorie = [intakeArray[section] floatValue];
        
        if (_type == energyTypeEat && recommendedCalorie < sumCalorie) {
            calorieLabel.textColor = XKWarningColorDeep;
        }else{
             calorieLabel.textColor = colorSecondary_333333;
        }
        
        calorieLabel.text =[NSString stringWithFormat:@"%.0f/%.0f",sumCalorie,recommendedCalorie];
        
        UIButton *showDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 44)];
        showDetailButton.tag = 100 + section;
        [showDetailButton addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:showDetailButton];
        
        [XKRWUtil addViewUpLineAndDownLine:headerView andUpLineHidden:YES DownLineHidden:NO];
        return headerView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 5031) {
        return 44;
    }
    return 0;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.tag == 1005){
        if (scrollView.contentOffset.x >= XKAppWidth) {
            isRecommended = YES;
            _recordTypeLabel.textColor = XK_TEXT_COLOR;
            _recommendedTypeLabel.textColor = XKMainToneColor_29ccb1;
            if (_type == energyTypeEat) {
                _leftButton.hidden = YES;
                _rightButton.hidden = YES;
                [self dealCenterButtonShowAndAction];
            }else if (_type == energyTypeSport){
                _leftButton.hidden = YES;
                _rightButton.hidden = YES;
                [self dealCenterButtonShowAndAction];
            }
        }else{
            isRecommended = NO;
            _recordTypeLabel.textColor = XKMainToneColor_29ccb1;
            _recommendedTypeLabel.textColor = XK_TEXT_COLOR;
            if (_type == energyTypeEat) {
                _leftButton.hidden = NO;
                _rightButton.hidden = NO;
            }else if (_type == energyTypeSport) {
                _leftButton.hidden = YES;
                _rightButton.hidden = YES;
            }
        }
        
        [self dealCenterButtonShowAndAction];
    }else{
        CGFloat sectionHeaderHeight = 59;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)refreshFoodData{
    [self setFoodDataToUI];
}

- (void)refreshSportData{
    [self setSportDataToUI];
}


- (void)dealCenterButtonShowAndAction
{
    _centerbutton.hidden =  NO;
    if (schemeDetail !=nil) {
        if (_type == energyTypeEat && isRecommended == NO){
            _centerbutton.hidden = YES;
        }else{
            [_centerbutton setTitle:@"已记录" forState:UIControlStateNormal];
            if (_revisionType == XKRWCanNotRevision) {
                _centerbutton.layer.borderColor = colorSecondary_666666.CGColor;
                [_centerbutton setTitleColor:colorSecondary_666666 forState:UIControlStateNormal];
                _centerbutton.enabled = NO;
                schemePastImageView.hidden = NO;
            }else if (_revisionType == XKRWCanRevision){
                schemePastImageView.hidden = NO;
            }
        }
        
    }else{
        if (_revisionType == XKRWNotNeedRevision) {
            if( _type == energyTypeSport && isRecommended == NO){
                [_centerbutton setTitle:@"记录运动" forState:UIControlStateNormal];
            }else if (_type == energyTypeEat && isRecommended == NO){
                _centerbutton.hidden = YES;
            }
            else if (_type == energyTypeSport || _type == energyTypeEat  ){
                
                [_centerbutton setTitle:@"记录" forState:UIControlStateNormal];
            }
        }else if (_revisionType == XKRWCanRevision){
            if (_type == energyTypeEat && isRecommended == NO){
                _centerbutton.hidden = YES;
            
            }else{
                [_centerbutton setTitle:@"补记" forState:UIControlStateNormal];
                schemePastImageView.hidden = NO;
            }
        }
        else{
            if (_type == energyTypeEat && isRecommended == NO){
                _centerbutton.hidden = YES;
            }else{
                [_centerbutton setTitle:@"不能补记" forState:UIControlStateNormal];
                _centerbutton.enabled = NO;
                _centerbutton.layer.borderColor = colorSecondary_666666.CGColor;
                [_centerbutton setTitleColor:colorSecondary_666666 forState:UIControlStateNormal];
                schemePastImageView.hidden = NO;
            }
        }
    }
}


#pragma --mark Action

- (void)reflashUIAndData:(NSNotification *)notification {
    if ([[notification object] isEqualToString:EffectFoodCircle]) {
        [self setFoodDataToUI];
    }else if ([[notification object] isEqualToString:EffectSportCircle]){
        [self setSportDataToUI];
    }
}

//点击展示 早餐 午餐 晚餐 加餐 的详细情况
- (void)showDetail:(UIButton *)button {
    
    if (showDetailSection == button.tag -100) {
        showDetailSection = -1;
    }else{
        showDetailSection = button.tag -100;
    }
    [recordTableView reloadData];
}

//关闭
- (IBAction)cancleAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(RecordFoodViewpressCancle)]) {
        [self.delegate RecordFoodViewpressCancle];
    }
}

//点击记录按钮
- (IBAction)recordSeclctAction:(UIButton *)sender {
    isRecommended = NO;
    _recordTypeLabel.textColor = XKMainToneColor_29ccb1;
    _recommendedTypeLabel.textColor = XK_TEXT_COLOR;
    if (_type == energyTypeEat) {
        _leftButton.hidden = NO;
        _rightButton.hidden = NO;
    }else if (_type == energyTypeSport){
        _leftButton.hidden = YES;
        _rightButton.hidden = YES;
    }
    [self dealCenterButtonShowAndAction];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

//点击推荐按钮
- (IBAction)recommendedSelectAction:(UIButton *)sender {
    
    isRecommended = YES;
    _recordTypeLabel.textColor = XK_TEXT_COLOR;
    _recommendedTypeLabel.textColor = XKMainToneColor_29ccb1;
    
    if (_type == energyTypeEat) {
        _leftButton.hidden = YES;

        
        [self dealCenterButtonShowAndAction];
        _rightButton.hidden = YES;
    }else if (_type == energyTypeSport){
        _leftButton.hidden = YES;
  
        
       [self dealCenterButtonShowAndAction];
        _rightButton.hidden = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(XKAppWidth, 0);
    }];
    
}


- (IBAction)actMore:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addMoreView)]) {
        [self.delegate addMoreView];
    }
}

// 用来处理营养分析
- (IBAction)leftButtonAction:(UIButton *)sender {
    XKRWHPMealAnalysisVC * mealAnalysisVC = [[XKRWHPMealAnalysisVC alloc]initWithNibName:@"XKRWHPMealAnalysisVC" bundle:nil];
    mealAnalysisVC.recordDate = _date;
    mealAnalysisVC.hidesBottomBarWhenPushed = YES;
    [_vc.navigationController pushViewController:mealAnalysisVC animated:YES];
}

- (IBAction)centerButtonAction:(UIButton *)sender {
    //用来处理记录推荐运动
    if (isRecommended == YES && _type == energyTypeSport) {
        if (schemeDetail !=nil){
            if ([self.delegate respondsToSelector:@selector(deleteSchemeRecord:andType:andEntryType:)]) {
                [self.delegate deleteSchemeRecord:[schemeDetail objectForKey:@"schemeEntity"] andType:XKRWRecordTypeScheme andEntryType:energyTypeSport];
            }
        }else{
            XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
            entity.create_time = [_date timeIntervalSince1970];
            entity.record_value = 2;
            entity.sid = 0;
            entity.type = 5;
            entity.uid =[[XKRWUserService sharedService] getUserId];
            entity.calorie = [XKRWAlgolHelper dailyConsumeSportEnergy];
            if ([self.delegate respondsToSelector:@selector(saveSchemeRecord:andType:andEntryType:)]) {
                [self.delegate saveSchemeRecord:entity andType:XKRWRecordTypeScheme andEntryType:energyTypeSport];
            }
        }
        return;
    }
    //用来处理记录自定义运动
    if (isRecommended == NO && _type == energyTypeSport) {
        if ([self.delegate respondsToSelector:@selector(entryRecordVCWith:)]) {
            [self.delegate entryRecordVCWith:eSchemeSport];
        }
        return;
    }
    //用来处理记录推荐饮食
    if (isRecommended == YES && _type == energyTypeEat) {
        if (schemeDetail != nil){
            if ([self.delegate respondsToSelector:@selector(deleteSchemeRecord:andType:andEntryType:)]) {
                [self.delegate deleteSchemeRecord:[schemeDetail objectForKey:@"schemeEntity"] andType:XKRWRecordTypeScheme andEntryType:energyTypeEat];
            }
        }else{
            XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
            entity.create_time = [_date timeIntervalSince1970];
            entity.record_value = 2;
            entity.sid = 0;
            entity.type = 6;
            entity.calorie = [XKRWAlgolHelper dailyIntakeRecomEnergy];
            entity.uid =[[XKRWUserService sharedService] getUserId];
            if ([self.delegate respondsToSelector:@selector(saveSchemeRecord:andType:andEntryType:)]) {
                [self.delegate saveSchemeRecord:entity andType:XKRWRecordTypeScheme andEntryType:energyTypeEat];
            }
        }
        return;
    }
}

// 用来处理记录自定义饮食
- (IBAction)rightButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(entryRecordVCWith:)]) {
        [self.delegate entryRecordVCWith:eSchemeFood];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(NSString *)getImageNameWithType:(XKRWSchemeType)type{
    NSString *imgName ;
    switch (type) {
        case XKRWSchemeTypeSport:
            imgName = @"sports5_3";
            break;
        case XKRWSchemeTypeBreakfast:
            imgName = @"breakfast5_3";
            break;
        case XKRWSchemeTypeLunch:
            imgName = @"lunch5_3";
            break;
        case XKRWSchemeTypeDinner:
            imgName = @"dinner5_3";
            break;
        case XKRWSchemeTypeSnack:
            imgName = @"addmeal5_3";
            break;
            
        default:
            break;
    }
    return imgName;
}

-(NSString *)getNameWithType:(XKRWSchemeType)type{
    NSString *name ;
    switch (type) {
        case XKRWSchemeTypeSport:
            name = @"运动";
            break;
        case XKRWSchemeTypeBreakfast:
            name = @"早餐";
            break;
        case XKRWSchemeTypeLunch:
            name = @"午餐";
            break;
        case XKRWSchemeTypeDinner:
            name = @"晚餐";
            break;
        case XKRWSchemeTypeSnack:
            name = @"加餐";
            break;
            
        default:
            break;
    }
    return name;
}


@end