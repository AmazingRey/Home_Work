//
//  XKRWCollectVC.m
//  XKRW
//
//  Created by 忘、 on 15/9/7.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWCollectVC.h"
#import "XKRWCollectionService.h"
#import "XKRWArticleVC.h"
#import "XKRWFoodDetailVC.h"
#import "XKRWSportDetailVC.h"
#import "XKRWSportCell.h"
#import "XKRWFoodCell.h"

#import "XKRWArticleWebView.h"

@interface XKRWCollectVC ()

//文章
@property (nonatomic,assign) uint32_t curNid;
@property (nonatomic,strong) NSString *curNavTitle;
@property (nonatomic,strong) NSString *curContentUrl;
//文章类型：减肥知识、灵活运营等七类  1. 减肥知识 2. 运动推荐
@property (nonatomic,assign) uint32_t curCategory;
//食物
@property (nonatomic,assign) uint32_t curFoodId;
@property (nonatomic,strong) NSString *curFoodName;
//运动
@property (nonatomic,assign) uint32_t curSportId;
@property (nonatomic,strong) NSString *curSportName;


@end

@implementation XKRWCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    
    
    _collectTableView.delegate = self;
    _collectTableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)initView
{
    [self addNaviBarBackButton];
    self.title = @"我的收藏";
    _collectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImage *noCollectionImage = [UIImage imageNamed:@"me_none_640"];
    noCollectionImageView = [[UIImageView alloc]initWithImage:noCollectionImage];
    noCollectionImageView.frame = CGRectMake((XKAppWidth-noCollectionImage.size.width)/2, (XKAppHeight-noCollectionImage.size.height)/2, noCollectionImage.size.width, noCollectionImage.size.height);
    noCollectionImageView.hidden = YES;
    [self.view addSubview:noCollectionImageView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dealCollectData];
}


//处理收藏数据
- (void)dealCollectData
{
    if (dataArray == nil) {
        dataArray = [NSMutableArray array];
    }
    dataArray =  [[XKRWCollectionService sharedService] queryCollectionWithType:segmentedSelectIndex];
    
    if (dataArray.count == 0) {
        noCollectionImageView.hidden = NO;
    }
    [_collectTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    noCollectionImageView.hidden = YES;
    segmentedSelectIndex = sender.selectedSegmentIndex;
    [dataArray removeAllObjects];
    [_collectTableView reloadData];
    [self dealCollectData];
}

#pragma --mark Network

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    if([taskID isEqualToString:@"deleteCollection"]){
        //数据库删除操作
        entity.originalId = [dataArray[deleteIndexPath.row] originalId];
        [[XKRWCollectionService sharedService] deleteCollectionInDB:entity];
        [self dealCollectData];
        [_collectTableView reloadData];
    }
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    [_collectTableView reloadData];
    [super handleDownloadProblem:problem withTaskID:taskID];
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

#pragma  --mark Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifer0 = @"indentifer0";
    static NSString *indentifer1 = @"indentifer1";
    static NSString *indentifer2 = @"indentifer2";
    if(segmentedSelectIndex == 0){
        XKRWSportCell *articleCell = [tableView dequeueReusableCellWithIdentifier:indentifer0];
        if (articleCell == nil) {
            articleCell = [[XKRWSportCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifer0];
        }
        XKRWCollectionEntity *sportEntity = [dataArray objectAtIndex:indexPath.row];
        articleCell.textLabel.text = sportEntity.collectName;
        return articleCell;
        
    }else if (segmentedSelectIndex == 1){
        
        XKRWFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer1];
        if (cell == nil) {
            cell = [[XKRWFoodCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifer1];
            
        }
        if ([dataArray count] > indexPath.row) {
            XKRWCollectionEntity *collectionEntity = [dataArray objectAtIndex:indexPath.row];
            [cell setCollectCellValue:collectionEntity];
        }
        
        return cell;
    }
    else if (segmentedSelectIndex == 2)
    {
        XKRWSportCell *sportCell = [tableView dequeueReusableCellWithIdentifier:indentifer2];
        if (sportCell == nil) {
            sportCell = [[XKRWSportCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifer2];
        }
        XKRWCollectionEntity *SportEntity_2 = [dataArray objectAtIndex:indexPath.row];
        sportCell.textLabel.text = SportEntity_2.collectName;
        return sportCell;
        
    }
    return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_collectTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (segmentedSelectIndex == 0)
    {
        if ([dataArray count] > indexPath.row) {
            XKRWCollectionEntity * articleEntity = [dataArray objectAtIndex:indexPath.row];
            self.curNid = (int)articleEntity.originalId;
            self.curNavTitle = articleEntity.collectName;
            self.curCategory = articleEntity.categoryType;
            self.curContentUrl = articleEntity.contentUrl;
            if(!self.curCategory)
            {
                self.curCategory = 7;
            }
            
            XKRWArticleWebView *vc = [[XKRWArticleWebView alloc] init];
            vc.nid = [NSString stringWithFormat:@"%i",self.curNid];
            vc.navTitle = self.curNavTitle;
            vc.requestUrl = self.curContentUrl;
            vc.category = self.curCategory;
            vc.source = eFromCollection;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        NSLog(@"跳到文章详情页面");
    }
    else if (segmentedSelectIndex == 1)
    {
        if ([dataArray count] > indexPath.row) {
            XKRWCollectionEntity *foodEntity = [dataArray objectAtIndex:indexPath.row];
            self.curFoodId = (int)foodEntity.originalId;
            self.curFoodName = foodEntity.collectName;
            
            XKRWFoodDetailVC *vc = [[XKRWFoodDetailVC alloc ]init];
            vc.foodId = self.curFoodId;
            vc.foodName = self.curFoodName;
            
            vc.date = [NSDate date];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        NSLog(@"跳到食物详情页面");
    }
    else if (segmentedSelectIndex == 2)
    {
        if ([dataArray count] > indexPath.row) {
            XKRWCollectionEntity * sportEntity = [dataArray objectAtIndex:indexPath.row];
            
            self.curSportId = (int)sportEntity.originalId;
            self.curSportName = sportEntity.collectName;
            XKRWSportDetailVC *vc = [[XKRWSportDetailVC alloc]init];
            vc.sportID = self.curSportId;
            vc.sportName = self.curSportName;
            vc.date = [NSDate date];
            vc.needHiddenDate = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        NSLog(@"跳到运动详情页面");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(segmentedSelectIndex == 0 || segmentedSelectIndex == 2){
        return 44.f;
    }
    else
    {
        return 64.f;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ([XKRWUtil isNetWorkAvailable] == FALSE) {
            [XKRWCui showInformationHudWithText:@"网络连接有问题,请稍后再试"];
            return ;
        }
        entity = [[XKRWCollectionEntity alloc] init];
        if (segmentedSelectIndex == 2) {
            entity.collectType = [dataArray[indexPath.row] collectType];
        }
        entity.date = [dataArray[indexPath.row] date] ;
        
        [XKRWCui showProgressHud];
        
        [self downloadWithTaskID:@"deleteCollection" task:^{
            [[XKRWCollectionService sharedService] deleteFromRemoteWithCollecType:entity.collectType date:entity.date];
        }];
        
        deleteIndexPath = indexPath;
 
    }
}


@end
