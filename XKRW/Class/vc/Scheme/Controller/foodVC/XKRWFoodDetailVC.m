//
//  XKRWFoodDetailVC.m
//  XKRW
//
//  Created by zhanaofan on 14-2-7.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWFoodDetailVC.h"
#import "XKRWNaviRightBar.h"

#import "XKRWCui.h"

#import "XKRWAddFoodVC4_0.h"

#import "XKRWCollectionService.h"
#import "XKRWUserService.h"
#import "NSDate+XKUtil.h"

#import "KMPopoverView.h"
#import "XKRWWarningView.h"

#import "XKRWCollectionService.h"

const int FixedDisplayCount = 4;   //固定显示的个数

@interface XKRWFoodDetailVC ()<KMPopoverViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    BOOL         _isShowAll;                /**<能否展示全部的元素*/
    BOOL         _isExtend;                 /**<是否展示全部的元素*/
}
//顶部
@property (nonatomic, strong) XKRWFoodTopView *topView;
//营养列表
@property (nonatomic, strong) UITableView     *nutriTV;
//适合减肥
@property (nonatomic, strong) UILabel         *lbFit;
//更多按钮
@property (nonatomic, strong) UIButton        *btnMore;
@property (nonatomic, strong) UILabel         *lbFoodFit;
@property (nonatomic, strong) UILabel         *footerForMoreView;

//收藏按钮
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic) BOOL isSelected;

@property (nonatomic,strong) XKRWCollectionEntity *collectEntity;

//右边导航栏
@property (nonatomic,strong)XKRWNaviRightBar *rightBar;


@end

@implementation XKRWFoodDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isShowAll = NO;
        _isExtend = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.foodId) {
        self.foodId = self.foodEntity.foodId;
    }
    
    [self initData];
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([XKUtil isNetWorkAvailable]) {
        [self loadFoodDetail];
    }
}

#pragma mark - UI

- (void)initUI {
    self.navigationItem.title = @"食物详情";
    NSLog(@"%d",self.isNeedHideNaviBarWhenPoped);
//    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(checkNeedHideNaviBarWhenPoped)];
    self.forbidAutoAddCloseButton = YES;
    [self addNaviBarBackButton];
    
    if (self.needShowRecord) {
        [self addNaviBarRightButton];
    }
    [self drawSubviews];
}

- (void) reloadNutr
{
    NSInteger cnt = [self.foodEntity.foodNutri count];
    [_data removeAllObjects];
    if (cnt > 0) {
        for (int i=0; i<cnt; i++) {
            NSDictionary *nutri_item = [NSDictionary dictionaryWithDictionary:[self.foodEntity.foodNutri objectAtIndex:i]];
            [_data addObject:nutri_item];
        }
    }
    
    //营养列表
    if (!_nutriTV) {
        _nutriTV = [[UITableView alloc] initWithFrame:CGRectMake((XKAppWidth-275)/2, self.lbFoodFit.frame.origin.y+self.lbFoodFit.frame.size.height+1.f, 275.f, 32.f*(FixedDisplayCount+2))];
    }
    _nutriTV.delegate       = self;
    _nutriTV.dataSource     = self;
    _nutriTV.scrollEnabled  = NO;
    _nutriTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _nutriTV.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_nutriTV];
    
    if (cnt >= (FixedDisplayCount+1)) {
        _isShowAll = YES;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        if (_isExtend) {
            _scrollView.contentSize = CGSizeMake(XKAppWidth, 250+(self.foodEntity.foodNutri.count+2)*32.f);
            _nutriTV.frame = CGRectMake((XKAppWidth-275)/2, self.lbFoodFit.frame.origin.y+self.lbFoodFit.frame.size.height+1.f, 275.f, 32.f*(self.foodEntity.foodNutri.count+2));
        }else{
            _scrollView.contentSize = CGSizeMake(XKAppWidth, 250+(FixedDisplayCount+1)*32.f);
            _nutriTV.frame = CGRectMake((XKAppWidth-275)/2, self.lbFoodFit.frame.origin.y+self.lbFoodFit.frame.size.height+1.f, 275.f, 32.f*(FixedDisplayCount+2));
        }
    }];
    
    //收藏按钮
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(XKAppWidth-66-8, 0, 66, 75.f);
    _collectBtn.selected = _isSelected;
    [_collectBtn setImage:[UIImage imageNamed:@"fooddetails_collect_640"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"fooddetails_collect_c_640"] forState:UIControlStateSelected];
    [_collectBtn addTarget:self action:@selector(collectFood:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_collectBtn];
    
    [self initFooterForMoreView];
}

- (void) drawSubviews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight);
    _scrollView.backgroundColor = XKBGDefaultColor;
    [self.view addSubview:_scrollView];
    
    _topView = [[XKRWFoodTopView alloc] initWithFrameAndFoodEntity:CGRectMake(0.f, 15.f, XKAppWidth, 75.f) foodEntity:_foodEntity linePosition:NO isDetail:YES];
    [_scrollView addSubview:_topView];
    
    //中间部分，是否适合减肥吃
    self.lbFoodFit = [[UILabel alloc] initWithFrame:CGRectMake((XKAppWidth-275)/2, _topView.frame.origin.y+_topView.frame.size.height+25.f, 275.f, 32.f)];
    [self setFitLabel];
    
    [_scrollView addSubview:self.lbFoodFit];
}

- (void)initFooterForMoreView {
    
    NSString * extendStr;
    if (!_isExtend) {
        extendStr = @"查看更多";
    }else{
        extendStr = @"收起";
    }
    
    if (!self.footerForMoreView) {
        self.footerForMoreView =
        ({
            UILabel *footerView = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, 275.f, 32.f)];
            footerView.userInteractionEnabled = YES;
            [footerView setBackgroundColor:[UIColor colorFromHexString:@"#F4F4F4"]];
            footerView.font = XKDefaultFontWithSize(14.f);
            footerView.textColor = XKMainSchemeColor;
            footerView.textAlignment = NSTextAlignmentCenter;
            UITapGestureRecognizer * moreTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForMore:)];
            [footerView addGestureRecognizer:moreTap];
            footerView;
        });
    }
    self.footerForMoreView.text = extendStr;
    
    if (_isShowAll) {
        _nutriTV.tableFooterView = self.footerForMoreView;
    }else{
        _nutriTV.tableFooterView = nil;
    }
}

- (void) setFitLabel
{
    UIColor *bgcolor = XKClearColor, *fontColor= nil;//[UIColor colorFromHexString:@"#d9eff"];
    NSString *title = @"";
    fontColor = [UIColor whiteColor];
    switch (_foodEntity.fitSlim) {
        case eFitLevel1:
        case eFitLevel2 :
            bgcolor = XKMainToneColor_29ccb1;
            title = @"适合减肥吃";
            break;
        case eFitLevel3 :
            bgcolor = [UIColor colorFromHexString:@"#65CCCC"];
            title = @"减肥勉强可以吃";
            break;
        case eFitLevel4 :
        case eFitLevel5 :
            bgcolor = [UIColor colorFromHexString:@"#999999"];
            title = @"减肥不能吃";
            break;
            
        default:
            
            break;
    }
    if (bgcolor) {
        self.lbFoodFit.backgroundColor = bgcolor;
    }
    if (fontColor) {
        self.lbFoodFit.textColor = fontColor;
    }
    self.lbFoodFit.textAlignment = NSTextAlignmentCenter;
    self.lbFoodFit.font = XKDefaultFontWithSize(14.f);
    self.lbFoodFit.text = title;
}

- (void)addNaviBarBackButton {
    if (self.isPresent) {
        //
        UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftItemButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        leftItemButton.frame = CGRectMake(0, 0, 28, 44);
        [leftItemButton setTitleColor:[UIColor colorWithRed:247/255.f green:106/255.f blue:8/255.f alpha:1.0] forState:UIControlStateNormal];
        [leftItemButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemButton];
    } else {
        [super addNaviBarBackButton];
    }
}

- (void) addNaviBarRightButton{
    self.rightBar = [[XKRWNaviRightBar alloc] initWithFrameAndTitle:CGRectMake(0.f, 0.f, 44.f, 44.f) title:@"记录"];
    [_rightBar addTarget:self action:@selector(rightNaviItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBar];
    
}


-(void)rightNaviItemClicked:(UIButton *)btn{
    XKRWAddFoodVC4_0 *addVC = [[XKRWAddFoodVC4_0 alloc] init];
    XKRWRecordFoodEntity *foodEntity = [[XKRWRecordFoodEntity alloc]init];
    foodEntity.foodId = _foodEntity.foodId;
    foodEntity.foodLogo = _foodEntity.foodLogo;
    foodEntity.foodName = _foodEntity.foodName;
    foodEntity.foodNutri = _foodEntity.foodNutri;
    foodEntity.foodEnergy = _foodEntity.foodEnergy;
    foodEntity.foodUnit = _foodEntity.foodUnit;
    foodEntity.date = [NSDate date];
    addVC.foodRecordEntity = foodEntity;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - data
-(void)initData{
    
    if([[XKRWCollectionService sharedService] queryCollectionWithCollectType:1 andNid:self.foodId]){
        _isSelected = YES;
    }else{
        _isSelected = NO;
    }
    
    self.collectEntity = [[XKRWCollectionEntity alloc] init];
    if (self.foodId) {
        [self initFoodDetail:(uint32_t)self.foodId];
    }
    
}

- (void) loadFoodDetail
{
    [XKRWCui showProgressHud:@"数据加载中..." InView:self.view];
    
    @try {
        XKDispatcherOutputTask block = ^(){
            XKLog(@"%ld",(long)self.foodId);
            return [[XKRWFoodService shareService] syncQueryFoodWithId:(uint32_t)self.foodId];
        };
        [self downloadWithTaskID:@"getFoodDetail" outputTask:block];
    }
    @catch (NSException *exception) {
        [XKRWCui showInformationHudWithText:@"请求失败，请重试！"];
    }
    @finally {
        
    }
    
}


- (id) initWithFoodId:(uint32_t)food_id
{
    self = [super init];
    if (self) {
        _foodEntity = [[XKRWFoodEntity alloc] init];
        [self initFoodDetail:food_id];
    }
    return self;
}

- (void) initFoodDetail:(uint32_t)foodId
{
    _data = [[NSMutableArray alloc] init];
    XKRWFoodService *service = [XKRWFoodService shareService];
    self.foodEntity = [service getFoodWithId:foodId];
    if (self.foodName) {
        self.foodEntity.foodName = self.foodName;
    }
    
    NSInteger cnt = [self.foodEntity.foodNutri count];
    
    if (cnt > 1) {
        for (int i=1; i<cnt; ++i) {
            NSDictionary *nutri_item = [NSDictionary dictionaryWithDictionary:[self.foodEntity.foodNutri objectAtIndex:i]];
            [_data addObject:nutri_item];
        }
    }
    
}


#pragma mark - 网络处理

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"getFoodDetail"]) {
        if (result) {
            XKRWFoodEntity *foodEntity = (XKRWFoodEntity*)result;
            NSMutableArray *array = [NSMutableArray array];
            // 剔除热量元素
            NSRange range;
            for (NSDictionary * key in foodEntity.foodNutri) {
//                containsString   NS_AVAILABLE(10_10, 8_0)
                range = [key[@"nutr"] rangeOfString:@"热量"];
                if (range.location == NSNotFound) {
                    [array addObject:key];
                }
            }
            foodEntity.foodNutri = array;
            
            self.foodEntity = foodEntity;
            [_topView setFoodEntity:self.foodEntity];
            [self setFitLabel];
            [self reloadNutr];
        }
    }
    else if ([taskID isEqualToString:@"saveFoodCollection"])
    {
        if([[result objectForKey:@"isSuccess"] isEqualToString:@"success"]){
            BOOL collection  = [[XKRWCollectionService sharedService] collectToDB:self.collectEntity];
            if (collection) {
                [XKRWCui showInformationHudWithText:@"收藏成功"];
                _isSelected = YES;
                
            }
        }else{
            [XKRWCui showInformationHudWithText:@"收藏失败"];
            _isSelected = NO;
            
        }
    }else if([taskID isEqualToString:@"deleteCollection"]){
        
        BOOL deleteCollection =  [[XKRWCollectionService sharedService] deleteCollectionInDB:self.collectEntity];
        
        if (deleteCollection) {
            _isSelected = NO;
            [XKRWCui showInformationHudWithText:@"删除收藏"];
        }
    }
    
    _collectBtn.selected = _isSelected;
}


- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
}

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName
{
    return YES;
}


-(BOOL) checkFoodInfoComplete {
    BOOL canUse = NO;
    if (_foodEntity.foodId) {
        canUse = YES;
    }
    return canUse;
}

- (void)popView {
    
    if (self.isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        
        [super popView];
    }
}


#pragma mark-  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //左边的label
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 275.f, 32.f)];
    [headerView setBackgroundColor:[UIColor colorFromHexString:@"#F4F4F4"]];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 8.f, 120.f, 14.f)];
    lbTitle.font = XKDefaultFontWithSize(14.f);
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textColor = XKMainSchemeColor;
    lbTitle.text = @"营养元素参考值";
    [headerView addSubview:lbTitle];
    //右边的Label
    UILabel *lbUnit = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width-70.f, lbTitle.frame.origin.y, 60.f,14.f)];
    lbUnit.font = XKDefaultFontWithSize(13.f);
    lbUnit.textColor = XKMainSchemeColor;
    lbUnit.textAlignment = NSTextAlignmentRight;
    lbUnit.text = @"每100克";
    lbUnit.backgroundColor = [UIColor clearColor];
    [headerView addSubview:lbUnit];
    
    //添加分隔线
    UIView *sep_line = [[UIView alloc] initWithFrame:CGRectMake(0.f, 31.f, 275.f, .5f)];
    [sep_line setBackgroundColor: colorSecondary_e0e0e0];
    
    [headerView addSubview:sep_line];
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.f;
}

#pragma mark-  UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifierForNuri"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellIdentifierForNuri"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFrame:CGRectMake(15.f, 9.f,180.f, 14.f)];
        cell.textLabel.font = XKDefaultFontWithSize(13.f);
        cell.textLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        [cell.detailTextLabel setFrame:CGRectMake(181.f,0.f,50.f,14.f)];
        cell.detailTextLabel.font = XKDefaultFontWithSize(13.f);
        cell.detailTextLabel.textColor = [UIColor colorFromHexString:@"#4D4D4D"];
        
        UIView *sep_line = [[UIView alloc] initWithFrame:CGRectMake(0.f, 31.f, 275.f,.5f)];
        [sep_line setBackgroundColor: colorSecondary_e0e0e0];
        [cell.contentView addSubview:sep_line];
        [cell setBackgroundColor:[UIColor colorFromHexString:@"#F4F4F4" ]];
    }
    
    NSDictionary *value = [_data objectAtIndex:indexPath.row];
    if (indexPath.row == 0 ) {
        UILabel *lb = (UILabel*)[cell.contentView viewWithTag:3006];// viewWith
        if (lb) {
            [lb removeFromSuperview];
        }
    }
    cell.textLabel.text = [value objectForKey:@"nutr"];
    cell.detailTextLabel.text = [[value objectForKey:@"quantity"] floatValue] !=0 ?[NSString stringWithFormat:@"%.2f",[[value objectForKey:@"quantity"] floatValue]]:@"--";
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XKLog(@"%ld",(unsigned long)[_data count]);
    if (!_isExtend) {
        return FixedDisplayCount;
    }else{
        return [_data count];
    }
}

#pragma mark - 触发事件

- (void)tapForMore:(UITapGestureRecognizer *)sender
{
    if (_isShowAll) {
        _isExtend = !_isExtend;
    }
    
    [self.nutriTV reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self reloadNutr];
    });
}

-(void)collectFood:(UIButton *)btn{
    if(!_isSelected){
        [self colletFood];
    }else{
        [self deleteFoodCollection];
    }
}

-(void)colletFood{
    if (![XKUtil isNetWorkAvailable]){
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        return;
    }
    
    [MobClick event:@"clk_collection1"];
    
    if(![self checkFoodInfoComplete]){
        [XKRWCui showInformationHudWithText:@"数据加载中,请稍候..."];
        return;
    }
    
    XKRWCollectionEntity *entity = [[XKRWCollectionEntity alloc] init];
    entity.originalId     = _foodEntity.foodId;
    entity.collectName   = _foodEntity.foodName;
    entity.foodEnergy = _foodEntity.foodEnergy;
    entity.imageUrl   = _foodEntity.foodLogo;
    entity.collectType = 1;
    entity.uid = [[XKRWUserService sharedService] getUserId];
    entity.date = [NSDate date];
    self.collectEntity = entity;
    
    //还需要同步到服务器
    XKDispatcherOutputTask block = ^(){
        return  [[XKRWCollectionService sharedService] saveCollectionToRemote:entity];
    };
    [self downloadWithTaskID:@"saveFoodCollection" outputTask:block];
    
}

-(void)deleteFoodCollection{
    
    if (![XKUtil isNetWorkAvailable]){
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        return;
    }
    NSDictionary *dic = [[XKRWCollectionService sharedService] queryByCollectType:1 andNid:self.foodId];
    NSDate *queryDate = [dic objectForKey:@"date"];
    self.collectEntity.date = queryDate;
    self.collectEntity.originalId = [[dic objectForKey:@"original_id"] integerValue];
    
    [self downloadWithTaskID:@"deleteCollection" task:^{
        [[XKRWCollectionService sharedService] deleteFromRemoteWithCollecType:1 date:queryDate];
    }];
    
}

//- (void)checkNeedHideNaviBarWhenPoped
//{
//    if (self.isNeedHideNaviBarWhenPoped) {
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//    }else{
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//    }
//}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
