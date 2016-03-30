//
//  XKRWMoreSearchResultVC.m
//  XKRW
//
//  Created by Jack on 15/7/15.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWMoreSearchResultVC.h"
#import "MJRefreshFooterView.h"
#import "XKRWFoodDetailVC.h"
#import "XKRWSportDetailVC.h"
#import <XKRw-Swift.h>

@interface XKRWMoreSearchResultVC ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    
}
@property (nonatomic,strong) MJRefreshFooterView *footerView;
//页 还没设置
@property (nonatomic) NSInteger page;
//是否加载完成
@property (nonatomic, assign) BOOL  isAllComplete;

@property (nonatomic,assign) uint32_t curFoodId;
@property (nonatomic,strong) NSString *curFoodName;

@end


@implementation XKRWMoreSearchResultVC
static NSString *identifier1= @"searchCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.isNeedHideNaviBarWhenPoped = false;
}

-(void)initData{
    _dataMutArray = [[NSMutableArray alloc] init];
    [_dataMutArray addObjectsFromArray:_dataArray];
    NSLog(@"searchType = %ld",(long)_searchType);
    _page = 1;
}

-(void)initUI{
    
    [self addNaviBarBackButton];
    
    self.title = _searchKey;
    self.view.backgroundColor = XK_BACKGROUND_COLOR;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)
                                        style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.alwaysBounceVertical = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"XKRWSearchResultCell" bundle:nil]
     forCellReuseIdentifier:identifier1];
    
    //刷新控件
    _footerView = [[MJRefreshFooterView alloc]init];
    _footerView.scrollView = _tableView;
    _footerView.delegate = self;
    
//    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(checkNeedHideNaviBarWhenPoped)];

}

#pragma mark - tableViewDelegate&&dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataMutArray.count;//_dataMutArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 79;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XKRWSearchResultCell *searchCell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (searchCell == nil) {
        searchCell = [[XKRWSearchResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1];
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(!_searchType){
        XKRWSportEntity *entity = _dataMutArray[indexPath.row];
        [searchCell.logoImageView setImageWithURL:[NSURL URLWithString:entity.sportActionPic] placeholderImage:[UIImage imageNamed:@"food_default"]];
        searchCell.title.text = entity.sportName;
        searchCell.subtitle.text = [NSString stringWithFormat:@"METS = %ld",(long)entity.sportMets];

    }else{
        XKRWFoodEntity *entity = _dataMutArray[indexPath.row];
        [searchCell.logoImageView setImageWithURL:[NSURL URLWithString:entity.foodLogo] placeholderImage:[UIImage imageNamed:@"food_default"]];
        searchCell.title.text = entity.foodName;
        searchCell.subtitle.text = [NSString stringWithFormat:@"%ldkcal/100g",(long)entity.foodEnergy];
        
    }
    return searchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!_searchType){
        XKRWSportDetailVC *svc = [[XKRWSportDetailVC alloc] init];
        XKRWSportEntity *sportEntity = _dataMutArray[indexPath.row];
        svc.sportID = sportEntity.sportId;
        svc.sportName = sportEntity.sportName;
        svc.date = [NSDate date];
        svc.needHiddenDate = YES;
        svc.isNeedHideNaviBarWhenPoped = NO;
//        self.isNeedHideNaviBarWhenPoped = NO;
        [self.navigationController pushViewController:svc animated:YES];
        
    }else{
        XKRWFoodDetailVC *fvc = [[XKRWFoodDetailVC alloc] init];

        XKRWFoodEntity *foodEntity = _dataMutArray[indexPath.row];
        fvc.foodId = foodEntity.foodId;
        fvc.foodName = foodEntity.foodName;
        fvc.isNeedHideNaviBarWhenPoped = NO;
        fvc.date = [NSDate date];
        [self.navigationController pushViewController:fvc animated:YES];

    }
    
}


#pragma mark --MJRefreshDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //下拉刷新page置为1
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        [self loadDataToView];
    }
}

- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----刷新完毕", refreshView.class);
}


- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateNormal:
            NSLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
}


#pragma mark - 网络处理
-(void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    NSLog(@"result = %@",result);
    
    if([taskID isEqualToString:@"downloadMoreFood"]){
        if(!_searchType){
            [_dataMutArray addObjectsFromArray:result[@"sport"]];
        }else{
            [_dataMutArray addObjectsFromArray:result[@"food"]];
        }
        _isAllComplete = YES;
        NSLog(@"%lu",(unsigned long)self.dataMutArray.count);
        
        if(_page>1){
            [_footerView endRefreshing];
        }
        
        [_tableView reloadData];
    }

}


- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [_footerView endRefreshing];
}

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName
{
    return YES;
}

#pragma mark - 数据加载
-(void)loadDataToView{
    XKDispatcherOutputTask block = ^(){
        _page++;
        return [[XKRWSearchService sharedService] searchWithKey:_searchKey type:_searchType page:_page  pageSize:30];
    };
    [self downloadWithTaskID:@"downloadMoreFood" outputTask:block];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.footerView free];
    self.footerView = nil;
}

- (void)popView
{
    [super popViewWithCheckNeedHideNaviBarWhenPoped];
}
@end
