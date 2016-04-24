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
#import "XKRWRecordFood5_3View.h"
#import "XKRWRecordFood5_3Cell.h"
#import "XKRWPushMenu5_3Cell.h"
#import "XKRWAlgolHelper.h"
#import "XKRWRecordMore5_3View.h"
#import "XKRWPlan_5_3CollectionView.h"
#import "XKRWFatReasonService.h"

@interface XKRWRecordFood5_3View () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
{
    UITableView *recordTableView;
    UITableView *recommendedTableView;
}

@property (weak, nonatomic) IBOutlet UIView *testViewFrame;
@property (strong ,nonatomic) XKRWRecordMore5_3View *moreView;

@end

@implementation XKRWRecordFood5_3View

-(void)initSubViews{
    _scrollView.contentSize = CGSizeMake( XKAppWidth * 2, 184);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 184) style:UITableViewStylePlain];
    recordTableView.tag = 5031;
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recordTableView.delegate = self;
    recordTableView.backgroundColor = XK_BACKGROUND_COLOR;
    recordTableView.dataSource = self;
    [recordTableView registerNib:[UINib nibWithNibName:@"XKRWRecordFood5_3Cell" bundle:nil] forCellReuseIdentifier:@"recordFoodCell"];

    recommendedTableView = [[UITableView alloc] initWithFrame:CGRectMake(XKAppWidth, 0, XKAppWidth, 184) style:UITableViewStylePlain];
    recommendedTableView.tag = 5032;
    recommendedTableView.delegate = self;
    recommendedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recommendedTableView.dataSource = self;
    recommendedTableView.backgroundColor = XK_BACKGROUND_COLOR;
    [recommendedTableView registerNib:[UINib nibWithNibName:@"XKRWPushMenu5_3Cell" bundle:nil] forCellReuseIdentifier:@"pushMenuCell"];
    
    [_scrollView addSubview:recordTableView];
    [_scrollView addSubview:recommendedTableView];
  
    _nutritionAnalyzeButton.layer.cornerRadius = 5;
    _nutritionAnalyzeButton.layer.borderWidth = 1;
    _nutritionAnalyzeButton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    
    _recordFoodButton.layer.cornerRadius = 5;
    _recordFoodButton.layer.borderWidth = 1;
    _recordFoodButton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    
    _recordSportButton.layer.cornerRadius = 5;
    _recordSportButton.layer.borderWidth = 1;
    _recordSportButton.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    
    CGRect frame =  _shadowImageView.frame ;
    frame.origin.x += (_positionX - XKAppWidth /2);
    _shadowImageView.frame = frame;
}

-(void)setTitle{
    _labSeperate.hidden = YES;
    _habitLabel.hidden = YES;
    _recordTypeLabel.hidden = NO;
    _recommendedTypeLabel.hidden = NO;
    _recordCalorieLabel.hidden = NO;
    _recommendedCalorieLabel.hidden = NO;
    _recordFoodButton.hidden = YES;
    _nutritionAnalyzeButton.hidden = YES;
    _recordSportButton.hidden = YES;
    switch (_type) {
        case 1:
            _recordTypeLabel.text = @"记录饮食";
            _recommendedTypeLabel.text = @"推荐食谱";
            _recordCalorieLabel.text = @"1111kcal";
            _recommendedCalorieLabel.text = @"2222kcal";
            _recordTypeLabel.textColor = XKMainToneColor_29ccb1;
            _recommendedTypeLabel.textColor = XKMainToneColor_29ccb1;
            _labSeperate.hidden = NO;
            _recordFoodButton.hidden = NO;
            _nutritionAnalyzeButton.hidden = NO;
            break;
        case 2:
            _recordTypeLabel.text = @"记录运动";
            _recommendedTypeLabel.text = @"推荐方案";
            int cal = [XKRWAlgolHelper dailyConsumeSportEnergy];
            _recordCalorieLabel.text = [NSString stringWithFormat:@"%dkcal",cal];
            _recommendedCalorieLabel.text = @"4444kcal";
            _recordTypeLabel.textColor = XKMainToneColor_29ccb1;
            _recommendedTypeLabel.textColor = XKMainToneColor_29ccb1;
            _labSeperate.hidden = NO;
            _recordFoodButton.hidden = NO;
            _nutritionAnalyzeButton.hidden = NO;

            break;
        case 3:
            _recordTypeLabel.hidden = YES;
            _recommendedTypeLabel.hidden = YES;
            _recordCalorieLabel.hidden = YES;
            _recommendedCalorieLabel.hidden = YES;
            _habitLabel.hidden = NO;
             _recordSportButton.hidden = NO;
            break;
        default:
            break;
    }
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


-(void)scrollToPage:(NSInteger)page{
    if (_pageIndex == page) {
        return;
    }
    CGFloat offset = (page-1) * XKAppWidth;
    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    _pageIndex = page;
}




//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 5031) {
        return _reocrdArray.count;
    }else if (tableView.tag == 5032){
        return _schemeArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKRWRecordSchemeEntity *entity;
     if (tableView.tag == 5031) {
         entity = [_reocrdArray objectAtIndex:indexPath.row];
         XKRWRecordFood5_3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordFoodCell"];
         cell.frame = CGRectMake(0, 0, self.width, 59);
         cell.leftImage.image = [UIImage imageNamed:[self getImageNameWithType:entity.type]];
         cell.labMain.text = [self getNameWithType:entity.type];
         return  cell;
     }else if (tableView.tag == 5032){
        entity = [_schemeArray objectAtIndex:indexPath.row];
        XKRWPushMenu5_3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushMenuCell"];
        cell.frame = CGRectMake(0, 0, self.width, 59);
        cell.leftImage.image = [UIImage imageNamed:[self getImageNameWithType:entity.type]];
        cell.labMain.text = [self getNameWithType:entity.type];
         return  cell;
     }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)getImageNameWithType:(RecordType)type{
    NSString *imgName = @"";
    switch (type) {
        case RecordTypeSport:
            imgName = @"sports5_3";
            break;
        case RecordTypeBreakfirst:
            imgName = @"breakfast5_3";
            break;
        case RecordTypeLanch:
            imgName = @"lunch5_3";
            break;
        case RecordTypeDinner:
            imgName = @"dinner5_3";
            break;
        case RecordTypeSnack:
            imgName = @"addmeal5_3";
            break;
            
        default:
            break;
    }
    return imgName;
}

-(NSString *)getNameWithType:(RecordType)type{
    NSString *name = @"";
    switch (type) {
        case RecordTypeSport:
            name = @"运动";
            break;
        case RecordTypeBreakfirst:
            name = @"早餐";
            break;
        case RecordTypeLanch:
            name = @"午餐";
            break;
        case RecordTypeDinner:
            name = @"晚餐";
            break;
        case RecordTypeSnack:
            name = @"加餐";
            break;
            
        default:
            break;
    }
    return name;
}


//营养分析
- (IBAction)nutritionAnalyzeAction:(UIButton *)sender {
}

//记录运动
- (IBAction)recordSportAction:(UIButton *)sender {
}

//记录食物
- (IBAction)recordFoodAction:(UIButton *)sender {
}

//关闭
- (IBAction)cancleAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(RecordFoodViewpressCancle)]) {
        [self.delegate RecordFoodViewpressCancle];
    }
}

//点击记录按钮
- (IBAction)recordSeclctAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

//点击推荐按钮
- (IBAction)recommendedSelectAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(XKAppWidth, 0);
    }];
}

- (IBAction)actMore:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addMoreView)]) {
        [self.delegate addMoreView];
    }
}

@end