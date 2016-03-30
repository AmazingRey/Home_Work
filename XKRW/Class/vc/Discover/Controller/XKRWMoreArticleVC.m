 //
//  XKRWMoreArticleVC.m
//  XKRW
//
//  Created by Jack on 15/6/8.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWMoreArticleVC.h"
#import "XKRWArticleVC.h"
#import "XKRWManagementService5_0.h"
#import "MJRefresh.h"
#import "XKRW-Swift.h"
#import "XKHudHelper.h"

#import "XKRWPKVC.h"

@interface XKRWMoreArticleVC ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
@property (nonatomic,strong) UITableView *articleTableView;
//数据源
@property (nonatomic,strong) NSMutableArray *dataMutArray;

//@property (nonatomic,strong) MJRefreshHeaderView *headerView;

@property (nonatomic,strong) MJRefreshFooterView *footerView;
//页
@property (nonatomic) NSInteger page;
//完成
@property (nonatomic, assign) BOOL  isAllComplete;
@end

@implementation XKRWMoreArticleVC
static NSString *indentifer0 = @"indentifer0";
static NSString *indentifer1 = @"indentifer1";
static NSString *indentifer2 = @"indentifer2";
#pragma mark - UI生命周期
- (void)viewDidLoad {
    
    [MobClick event:@"clk_more"];
    
    [super viewDidLoad];
    //UI
    [self initUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //数据源
    self.dataMutArray = [[NSMutableArray alloc] init];
    self.dataMutArray = [[XKRWManagementService5_0 sharedService] getMoreArticleFromDBByCategory:_module];
    [_articleTableView reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.dataMutArray count] == 0) {
        [[XKHudHelper instance] showProgressHudAnimationInView:self.view];
        _page = 1;
        [self getDataFromRemote];
    }else{
        _page = [self.dataMutArray count]/10 + 1;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//UI
-(void)initUI{
    self.title = _naviTitle;

    [self addNaviBarBackButton];
    
    
    self.articleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)];
    self.articleTableView.delegate = self;
    self.articleTableView.dataSource = self;
    self.articleTableView.backgroundColor = XK_BACKGROUND_COLOR;
    self.articleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.articleTableView];
    [self.articleTableView registerNib:[UINib nibWithNibName:@"XKRWmoreArticleTitleCell" bundle:nil]
                forCellReuseIdentifier:indentifer1];
    
    self.footerView = [[MJRefreshFooterView alloc]init];
    _footerView.scrollView = _articleTableView;
    _footerView.delegate = self;
    
    [self.view addSubview:_articleTableView];
}


#pragma mark - tableViewDelegate And tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataMutArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKRWmoreArticleTitleCell *lhyyCell = [tableView dequeueReusableCellWithIdentifier:indentifer1];
    XKRWArticleDetailEntity *entity = self.dataMutArray[indexPath.row];
    if(!entity.date){
        lhyyCell.timeLabel.text = @"0";
    }else{
        lhyyCell.timeLabel.text = entity.date;
    }
    
    lhyyCell.readNumLabel.hidden = YES;
    lhyyCell.readImage.hidden = YES;
    
    lhyyCell.titleLabel.text = entity.title;
    NSAttributedString *text =
    [XKRWUtil createAttributeStringWithString:entity.title
                                         font:XKDefaultFontWithSize(17)
                                        color:XK_TITLE_COLOR
                                  lineSpacing:8.5 alignment:NSTextAlignmentLeft];
    lhyyCell.titleLabel.attributedText = text;
    lhyyCell.titleLabel.numberOfLines = 0;

    //阅读过 字体变灰
    if(entity.read){
        lhyyCell.titleLabel.textColor = XK_ASSIST_TEXT_COLOR;
    }
    
    lhyyCell.selectionStyle = UITableViewCellSelectionStyleNone;
     return lhyyCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(_module == eOperationPK){//push到PK界面
        XKRWArticleDetailEntity *entity = self.dataMutArray[indexPath.row];
        [[XKRWManagementService5_0 sharedService] setArticleDetailReadStatusToDB:entity andModule:_module];
        XKRWPKVC *pkvc = [[XKRWPKVC alloc]initWithNibName:@"XKRWPKVC" bundle:nil];
        pkvc.nid = entity.nid;
        [self.navigationController pushViewController:pkvc animated:YES];
        
    }else{//详情页面
        XKRWArticleVC *avc = [[XKRWArticleVC alloc]init];
        XKRWArticleDetailEntity *entity = self.dataMutArray[indexPath.row];
        [[XKRWManagementService5_0 sharedService] setArticleDetailReadStatusToDB:entity andModule:_module];
        avc.contentURL = entity.url;
        avc.naviTitle = entity.title;
        avc.nid = entity.nid;
        avc.source = eFromHistory;
        [self.navigationController pushViewController:avc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XKRWArticleDetailEntity *entity = self.dataMutArray[indexPath.row];
    NSAttributedString *text =
    [XKRWUtil createAttributeStringWithString:entity.title
                                         font:XKDefaultFontWithSize(17)
                                        color:XK_TITLE_COLOR
                                  lineSpacing:8.5 alignment:NSTextAlignmentLeft];
    CGRect tRect =[text boundingRectWithSize:CGSizeMake(XKAppWidth-30.0, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                     context:nil];
    
    return 85-25+7+tRect.size.height;
    
}


#pragma mark --MJRefreshDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _page = 1;
        [self getDataFromRemote];
    }else{
        _page = [self.dataMutArray count]/10 + 1;
        [self getDataFromRemote];
    }
    
}

- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    XKLog(@"%@----刷新完毕", refreshView.class);
}


- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateNormal:
            XKLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            XKLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            XKLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
}
#pragma mark - 网络处理
-(void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    
    if ([taskID isEqualToString:@"getMoreArticle"]) {
        self.dataMutArray = [[XKRWManagementService5_0 sharedService] getMoreArticleFromDBByCategory:_module];

        [_footerView endRefreshing];
        
        [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
        [_articleTableView reloadData];
    }
    
}


- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID{
        [_footerView endRefreshing];
}

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName{
    return YES;
}

#pragma mark - 请求数据
-(void)getDataFromRemote{

    if ([XKUtil isNetWorkAvailable]){
        
        [self downloadWithTaskID:@"getMoreArticle" task:^{
            [[XKRWManagementService5_0 sharedService] getMoreArticleInfoFromServerType:_module andPage:_page needLong:NO];
        }];
        

    }else{
        [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
        [XKRWCui showInformationHudWithText:@"请检查网络后尝试"];
    }
    
}

-(void)loadDataToView {
    self.dataMutArray = [[XKRWManagementService5_0 sharedService] getMoreArticleFromDBByCategory:_module];
    _page = [_dataMutArray count] / 10 + 1;
    [_articleTableView reloadData];
}

-(void)dealloc {
    [_footerView free];
    _footerView = nil;
}

@end
