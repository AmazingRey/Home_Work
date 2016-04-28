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

@interface XKRWRecordView_5_3 () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
{
    UITableView *recordTableView;
    UITableView *recommendedTableView;
    NSArray  *recordTypeTitleArray;
    NSArray  *recordTypeImageArray;
    BOOL     isRecommended;     //判断当前是推荐状态 还是记录状态
    
    NSInteger  showDetailSection;
    
    NSArray  *recordArray;  //早午晚加
    
    NSArray  *detailRecordArray;
}

@property (weak, nonatomic) IBOutlet UIView *testViewFrame;
@property (strong ,nonatomic) XKRWRecordMore5_3View *moreView;

@end

@implementation XKRWRecordView_5_3

-(void)initSubViews {
    _scrollView.delegate = self;
    showDetailSection = -1;
    _shadowImageView =[[UIImageView alloc]initWithFrame:CGRectMake((XKAppWidth - 800) /2 + (_positionX - XKAppWidth /2) , 0, 800, 10)];
    _shadowImageView.image = [UIImage imageNamed:@"shadow"];
    
    [self addSubview:_shadowImageView];

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
  
    _leftButton.layer.cornerRadius = 5;
    _leftButton.layer.borderWidth = 1;
    _leftButton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    
    _centerbutton.layer.cornerRadius = 5;
    _centerbutton.layer.borderWidth = 1;
    _centerbutton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    
    _rightButton.layer.cornerRadius = 5;
    _rightButton.layer.borderWidth = 1;
    _rightButton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
}

-(void)setTitle {
    _labSeperate.hidden = YES;
    _habitLabel.hidden = YES;
    _recordTypeLabel.hidden = NO;
    _recommendedTypeLabel.hidden = NO;

    _leftButton.hidden = YES;
    _centerbutton.hidden = YES;
    _rightButton.hidden = YES;
    
    //每日饮食推荐值
    CGFloat totalFoodCalories = [XKRWAlgolHelper dailyIntakeRecomEnergy];
    //每日运动消耗推荐值
    CGFloat totalSportCalories = [XKRWAlgolHelper dailyConsumeSportEnergy];
    
    //获取就餐比例的 百分比
    NSDictionary *mealRatioDic =[[XKRWUserService sharedService] getMealRatio];
    
    CGFloat breakfast = totalFoodCalories * [[mealRatioDic objectForKey:@"breakfast"] floatValue] /100.f;
    CGFloat lunch = totalFoodCalories *[[mealRatioDic objectForKey:@"lunch"] floatValue] /100.f;
    CGFloat supper = totalFoodCalories* [[mealRatioDic objectForKey:@"supper"] floatValue] /100.f;
    CGFloat snack = totalFoodCalories *[[mealRatioDic objectForKey:@"snack"] floatValue] /100.f;
    
    _date =[NSDate date];
    
    NSDictionary *sportDetail =  [[XKRWRecordService4_0 sharedService] getTotalCalorieOfDay:_date andRecordType:eSport];
    NSDictionary *breakDetail = [[XKRWRecordService4_0 sharedService] getTotalCalorieOfDay:_date andRecordType:eMealBreakfast];
    NSDictionary *LunchDetail = [[XKRWRecordService4_0 sharedService] getTotalCalorieOfDay:_date andRecordType:eMealLunch];
    NSDictionary *dinnerDetail = [[XKRWRecordService4_0 sharedService] getTotalCalorieOfDay:_date andRecordType:eMealDinner];
    NSDictionary *mealDetail = [[XKRWRecordService4_0 sharedService] getTotalCalorieOfDay:_date andRecordType:eMealSnack];
    
    switch (_type) {
        case energyTypeEat:
            _recordTypeLabel.text = @"记录饮食";
            _recommendedTypeLabel.text = @"推荐食谱";
            _recordTypeLabel.textColor = XKMainToneColor_29ccb1;
            _recommendedTypeLabel.textColor = XK_TEXT_COLOR;
            _labSeperate.hidden = NO;
            _leftButton.hidden = NO;
            _rightButton.hidden = NO;
            recordTypeTitleArray = @[@"早餐",@"午餐",@"晚餐",@"加餐"];
            recordTypeImageArray = @[@"breakfast5_3",@"lunch5_3",@"dinner5_3",@"addmeal5_3"];
            detailRecordArray = @[breakDetail,LunchDetail,dinnerDetail,mealDetail];
            recordArray =@[[NSNumber numberWithFloat:breakfast],[NSNumber numberWithFloat:lunch],[NSNumber numberWithFloat:supper],[NSNumber numberWithFloat:snack]];
            break;
        case energyTypeSport:
            _recordTypeLabel.text = @"记录运动";
            _recommendedTypeLabel.text = @"推荐运动";
            _recordTypeLabel.textColor = XKMainToneColor_29ccb1;
            _recommendedTypeLabel.textColor = XK_TEXT_COLOR;
            _labSeperate.hidden = NO;
            _centerbutton.hidden = NO;
            recordTypeTitleArray = @[@"运动"];
            recordTypeImageArray =@[@"sports5_3"];
            detailRecordArray = @[sportDetail];
            recordArray = @[[NSNumber numberWithFloat:totalSportCalories]];
            break;
        case energyTypeHabit:
            _recordTypeLabel.hidden = YES;
            _recommendedTypeLabel.hidden = YES;
            _habitLabel.hidden = NO;
            _actionView.hidden = YES;
            break;
        default:
            break;
    }
    
    [recordTableView reloadData];
    [recommendedTableView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

-(void)setType:(energyType)type{
    if (_type != type) {
        _type = type;
    }
    [self setTitle];
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
            return [[[detailRecordArray objectAtIndex:section] objectForKey:@"allRecord"] count];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
     if (tableView.tag == 5031) {
        XKRWRecordCell_5_3 *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
       
         if (indexPath.section == showDetailSection){
             id temp = [[[detailRecordArray objectAtIndex:indexPath.section] objectForKey:@"allRecord"] objectAtIndex:indexPath.row];
             
             if (![temp isKindOfClass:[XKRWFoodEntity class]] && ![temp isKindOfClass:[XKRWSportEntity class]]) {
                 cell.recordDetailTitle.text = [temp objectForKey:@"title"];
                 cell.recordDetailCalories.text =[temp objectForKey:@"calorie"];
                 cell.recordArrowImageView.hidden = YES;
             }else if ([temp isKindOfClass:[XKRWFoodEntity class]]){
                 cell.recordArrowImageView.hidden = NO;
                 cell.recordDetailTitle.text = ((XKRWFoodEntity *)temp).foodName;
                 cell.recordDetailCalories.text = [NSString stringWithFormat:@"%@Kcal",[[detailRecordArray objectAtIndex:indexPath.section] objectForKey:@"calorie"]];
             }else{
                 cell.recordArrowImageView.hidden = NO;
                 cell.recordDetailTitle.text = ((XKRWSportEntity *)temp).sportName;
                 cell.recordDetailCalories.text = [NSString stringWithFormat:@"%@Kcal",[[detailRecordArray objectAtIndex:indexPath.section] objectForKey:@"calorie"]];
             }
         }
        [XKRWUtil addViewUpLineAndDownLine:cell.contentView andUpLineHidden:YES DownLineHidden:NO];
        return cell;
     }else if (tableView.tag == 5032){
        XKRWSchemeEntity_5_0 *entity = [_schemeArray objectAtIndex:indexPath.row];
        XKRWRecommandedCell_5_3 *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendedCell"];
        cell.frame = CGRectMake(0, 0, self.width, 59);
        cell.mealImageView.image = [UIImage imageNamed:[self getImageNameWithType:entity.schemeType]];
         NSMutableString *schemeDetail =[NSMutableString string];
         for (XKRWFoodCategoryEntity *foodEntity in entity.foodCategories ) {
             if (schemeDetail.length == 0) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                  [schemeDetail appendString:foodEntity.categoryName];
             }else{
                 [schemeDetail appendString:[NSString stringWithFormat:@"+%@",foodEntity.categoryName]];
             }
         }
         
        cell.mealLabel.text = entity.schemeName;
        cell.mealDetailLabel.text = schemeDetail;
        [XKRWUtil addViewUpLineAndDownLine:cell.contentView andUpLineHidden:YES DownLineHidden:NO];
        return  cell;
     }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 5031) {
            id temp = [[[detailRecordArray objectAtIndex:indexPath.section] objectForKey:@"allRecord"] objectAtIndex:indexPath.row];
            
            if (![temp isKindOfClass:[XKRWFoodEntity class]] && ![temp isKindOfClass:[XKRWSportEntity class]]) {
                return;
            }else if ([temp isKindOfClass:[XKRWFoodEntity class]]){
                XKRWAddFoodVC4_0 *addFoodVC = [[XKRWAddFoodVC4_0 alloc] init];
                XKRWRecordFoodEntity *recordFoodEntity = [[XKRWRecordFoodEntity alloc] init];
                recordFoodEntity.date = _date;
                recordFoodEntity.foodId = ((XKRWFoodEntity *)temp).foodId;
                recordFoodEntity.foodLogo = ((XKRWFoodEntity *)temp).foodLogo;
                recordFoodEntity.foodName = ((XKRWFoodEntity *)temp).foodName;
                recordFoodEntity.foodNutri = ((XKRWFoodEntity *)temp).foodNutri;
                recordFoodEntity.foodEnergy = ((XKRWFoodEntity *)temp).foodEnergy;
                recordFoodEntity.foodUnit = ((XKRWFoodEntity *)temp).foodUnit;
                addFoodVC.foodRecordEntity = recordFoodEntity;
                [XKRWAddFoodVC4_0 presentAddFoodVC:addFoodVC onViewController:_vc];

            }else{
                XKRWSportAddVC *addVC = [[XKRWSportAddVC alloc] init];
                addVC.sportEntity = ((XKRWSportEntity *)temp);
                addVC.passMealTypeTemp = eSport;
                addVC.needHiddenDate = YES;
                addVC.isPresent = YES;
                [_vc.navigationController presentViewController:addVC animated:YES completion:nil];
            }

    }else if (tableView.tag == 5032){
    
    
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
        calorieLabel.textColor = colorSecondary_333333;
        calorieLabel.textAlignment = NSTextAlignmentRight;
        [headerView addSubview:calorieLabel];
        
        //推荐卡路里
        CGFloat recommendedCalorie = [[recordArray objectAtIndex:section] floatValue];
        //当前已经记录的卡路里
        CGFloat sumCalorie = [[[detailRecordArray objectAtIndex:section] objectForKey:@"calorie"] floatValue];
        
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
            _recordTypeLabel.textColor = XK_TEXT_COLOR;
            _recommendedTypeLabel.textColor = XKMainToneColor_29ccb1;
        }else{
            _recordTypeLabel.textColor = XKMainToneColor_29ccb1;
            _recommendedTypeLabel.textColor = XK_TEXT_COLOR;
        }
    }else{
        CGFloat sectionHeaderHeight = 59;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}



#pragma --mark Action
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
        _centerbutton.hidden = YES;
        _rightButton.hidden = NO;
    }else if (_type == energyTypeSport){
        _leftButton.hidden = YES;
        _centerbutton.hidden = NO;
        [_centerbutton setTitle:@"记录运动" forState:UIControlStateNormal];
        _rightButton.hidden = YES;
    }

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
        _centerbutton.hidden = NO;
        [_centerbutton setTitle:@"记录" forState:UIControlStateNormal];
        _rightButton.hidden = YES;
    }else if (_type == energyTypeSport){
        _leftButton.hidden = YES;
        _centerbutton.hidden = NO;
        [_centerbutton setTitle:@"记录" forState:UIControlStateNormal];
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
    
}

- (IBAction)centerButtonAction:(UIButton *)sender {
    //用来处理记录推荐运动
    if (isRecommended == YES && _type == energyTypeSport) {
        
        
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
      
        return;
    }
    
    
}

// 用来处理记录自定义饮食
- (IBAction)rightButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(entryRecordVCWith:)]) {
        [self.delegate entryRecordVCWith:eSchemeFood];
    }
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