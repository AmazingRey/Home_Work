//
//  XKRWSportDetailVC.m
//  XKRW
//
//  Created by Leng on 14-4-15.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSportDetailVC.h"
#import "XKRWNaviRightBar.h"
#import "XKRWSportAddVC.h"
#import "UIImageView+WebCache.h"
#import "XKRWUtil.h"
#import "XKRWUserService.h"
#import "XKRWAlgolHelper.h"

#import "UIButton+WebCache.h"
#import "XKRWCui.h"
#import "XKRWWeightService.h"
#import "XKRWRecordService4_0.h"

#import "XKRWSportdetailView.h"

#import "XKRWCollectionService.h"

#define ColorFromHexString(a) [UIColor colorFromHexString:a]
#define ColorClear [UIColor clearColor]
#define ColorBlack [UIColor blackColor]
#define useHtml 1

#define LINENUM 20    //每行字数
#define LINEHEIGHT 30 //行高

//5.0 new Add

@interface XKRWSportDetailVC ()<UIWebViewDelegate,XKRWSportdetailViewDelegate>
{
    UIView *sHeaderPart;
    UIScrollView *sportScrollView;
    XKRWSportdetailView *sportDetailView;
}
@property (nonatomic, strong) UILabel * sportTitle;
@property (nonatomic, strong) UIScrollView * titleBG;
@property (nonatomic, strong) UILabel * sportDecription;
@property (nonatomic, strong) UILabel * sportStrongDecription;
@property (nonatomic, strong) UILabel * netReload;

@property (nonatomic, strong) UIScrollView * sportContents;

@property (nonatomic, assign) float scrollContentsSet;//滚动视图 contenetsset
@property (nonatomic, assign) float contentsStart;

@property (nonatomic, copy)   NSString * unitDesc;
@property (nonatomic, strong) UITapGestureRecognizer * tapReg;
@property (nonatomic, assign) float headerImageH;
@property (nonatomic, assign) RequestStatus requestStatus;
@property (nonatomic ,strong) XKRWNaviRightBar *rightBar;

//收藏按钮
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic) BOOL isSelected;

@property (nonatomic,strong) XKRWCollectionEntity *collectEntity;

@end

@implementation XKRWSportDetailVC

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
    [self initUI];
    [self initData];
//    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(checkNeedHideNaviBarWhenPoped)];
    [self resetContents];
}



- (void)initData{
    _sportEntity = [[XKRWSportService shareService] sportDetailWithId:_sportID];
    if(!_sportEntity.sportMets){
        self.requestStatus = eRequestStart;
        [self loadData];
    }else{
        [self showSportInfo];
    }
    
    if(!_sportName){
        _sportName = _sportEntity.sportName;
    }
    
    if([[XKRWCollectionService sharedService] queryCollectionWithCollectType:2 andNid:_sportID]){
        _isSelected = YES;
    }else{
        _isSelected = NO;
    }
    _collectBtn.selected = _isSelected;
    if(!self.collectEntity){
        self.collectEntity = [[XKRWCollectionEntity alloc] init];
    }
    
    self.headerImageH = 210;
    _unitDesc = @"分钟";
    _contentsStart = 20;
}

- (void)initUI{
    self.forbidAutoAddCloseButton = YES;
    
    if (self.isPresent) {
        [self addNaviBarLeftButtonWithNormalImageName:@"close" highlightedImageName:@"close" selector:@selector(popView)];
    } else {
        [self addNaviBarBackButton];
    }
    self.title = @"运动详情";
    
    sportScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75, XKAppWidth, XKAppHeight-75-15) ];
    sportScrollView.backgroundColor =  XK_BACKGROUND_COLOR;
    self.view.backgroundColor = XK_BACKGROUND_COLOR;
    [self.view addSubview:sportScrollView];

    sHeaderPart =[[UIView alloc] initWithFrame:CGRectMake(0, 15, XKAppWidth, 75)];
    sHeaderPart.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sHeaderPart];
    
    self.sportTitle  =[[UILabel alloc] initWithFrame:CGRectMake(15, 15, 280, 16)];
    _sportTitle.textColor = XK_TITLE_COLOR;
    _sportTitle.backgroundColor = [UIColor clearColor];
    _sportTitle.text = @"运动";
    _sportTitle.font = XKDefaultFontWithSize(14);
    [sHeaderPart addSubview:_sportTitle];
    
    self.sportDecription =[[UILabel alloc] initWithFrame:CGRectMake(15, 35, 210, 15)];
    _sportDecription.backgroundColor = ColorClear;
    _sportDecription.textColor = XK_TEXT_COLOR;
    _sportDecription.text = @"- kcal / 60 分钟  低强度";
    _sportDecription.font =XKDefaultFontWithSize(14);
    [sHeaderPart addSubview:_sportDecription];
    
    self.sportStrongDecription = [[UILabel alloc] initWithFrame:CGRectMake(15, _sportDecription.bottom+3, 100, 15)];
    _sportStrongDecription.backgroundColor = ColorClear;
    _sportStrongDecription.textColor = XK_TEXT_COLOR;
    _sportStrongDecription.text = @"燃脂0克";
    _sportStrongDecription.textAlignment = NSTextAlignmentLeft;
    _sportStrongDecription.font = XKDefaultFontWithSize(14);
    [sHeaderPart addSubview:_sportStrongDecription];
    
    
    UIView *sHeaderSep =[[UIView alloc] initWithFrame:CGRectMake(0, sHeaderPart.height-0.5, XKAppWidth, .5)];
    sHeaderSep.backgroundColor = ColorFromHexString(@"#cccccc");
    [sHeaderPart addSubview:sHeaderSep];
    
    //收藏按钮
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(XKAppWidth-66-8, 0, 66, 75.f);
    
    [_collectBtn setImage:[UIImage imageNamed:@"fooddetails_collect_640"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"fooddetails_collect_c_640"] forState:UIControlStateSelected];
    _collectBtn.selected = _isSelected;
    [_collectBtn addTarget:self action:@selector(collectSport:) forControlEvents:UIControlEventTouchUpInside];
    [sHeaderPart addSubview:_collectBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)popView
{
    if (self.isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [super popView];
    }
}

- (void) loadData
{
    if([XKRWUtil isNetWorkAvailable]){
        if (!self.sportEntity.sportMets) {
            XKDispatcherOutputTask block = ^(){
                return [[XKRWSportService shareService] syncQuerySportWithId:_sportID];
            };
            [self downloadWithTaskID:@"getSportDetail" outputTask:block];
        }
        [XKRWCui showProgressHud:@"加载中..."];
    }else{
        [self showRequestArticleNetworkFailedWarningShow];
    }
}


- (void)reLoadDataFromNetwork:(UIButton *)button
{
    [self loadData];
}

#pragma mark - 网络处理
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"getSportDetail"]) {
        [self  hiddenRequestArticleNetworkFailedWarningShow];
        if (result) {
            self.requestStatus = eRequestEnd;
            self.sportEntity = (XKRWSportEntity*)result;
            if(!_sportName){
                _sportName = _sportEntity.sportName;
            }
            [self resetContents];
            [self showSportInfo];
        }
    }
    else if ([taskID isEqualToString:@"saveSportCollection"])
    {
        if([[result objectForKey:@"isSuccess"] isEqualToString:@"success"]){
           BOOL  collection =  [[XKRWCollectionService sharedService] collectToDB:self.collectEntity];
            if (collection) {
                [XKRWCui showInformationHudWithText:@"收藏成功"];
                _isSelected = YES;
                _collectBtn.selected = _isSelected;
            }
        }else{
            [XKRWCui showInformationHudWithText:@"收藏失败"];
        }
    }else if ([taskID isEqualToString:@"deleteCollection"]){
       BOOL deleteCollection = [[XKRWCollectionService sharedService] deleteCollectionInDB:self.collectEntity];
        if (deleteCollection) {
            _isSelected = NO;
            _collectBtn.selected = _isSelected;
            [XKRWCui showInformationHudWithText:@"删除收藏"];
        }
    }
}


- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"getSportDetail"]) {
        self.requestStatus = eRequestEnd;
        [XKRWCui hideProgressHud];
   
    }else if([taskID isEqualToString:@"saveSportCollection"]){
        [XKRWCui showInformationHudWithText:@"收藏失败"];
    }else if ([taskID isEqualToString:@"deleteCollection"]){
        [XKRWCui showInformationHudWithText:@"删除收藏失败"];
    }
}

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName{
    return YES;
}

-(void)clear{
    
    [self.sportContents removeGestureRecognizer:_tapReg];
    [_netReload removeFromSuperview];
    [self resetContents];
}

-(void)didUpload{
    [self clear];
}


/**设置运动标题*/
- (void) setSportTitleName :(NSString *) sportTitle{

    CGSize size = [XKRWUtil sizeOfStringWithFont:sportTitle withFont:_sportTitle.font ];
    _sportTitle.text = sportTitle ;
    _sportTitle.frame = CGRectMake(15, 10, size.width, 16);
    _titleBG.contentSize = CGSizeMake(size.width, 0);
    
}

/**运动详情页初始化*/
-(void) resetContents{
    if (self.sportEntity.sportMets > 0) {
        sportDetailView = [[XKRWSportdetailView alloc]initWithFrame:CGRectMake(0, 15, XKAppWidth, sportScrollView.height-15) andEntity:self.sportEntity];
        sportDetailView.sportDelegate = self;
        [sportScrollView addSubview:sportDetailView];
    }
    
    if (_netReload) {
        [_netReload removeFromSuperview];
    }
    if (_tapReg) {
        [self.sportContents removeGestureRecognizer:_tapReg];
    }
}

/***  显示运动信息*/
- (void)showSportInfo{
    [self setSportTitleName:(_sportEntity.sportIntensity && _sportEntity.sportIntensity.length)?[[[_sportEntity.sportName stringByAppendingString:@"("] stringByAppendingString:_sportEntity.sportIntensity] stringByAppendingString:@")"]:_sportEntity.sportName];
    _sportDecription.text = [self getSportDesString];
    
    if(self.sportEntity.sportMets > 0){
        if (self.isSecheme && self.cal > 0) {
            NSInteger fWeight = [XKRWAlgolHelper fatWithCalorie:self.cal];
            _sportStrongDecription.text = [NSString stringWithFormat:@"燃脂%ld克",(long)fWeight];
        }else{
            //获得距离date最近日期的体重（含当日）
            float nearestWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:self.date];
            int cals = [_sportEntity consumeCaloriWithMinuts:60 weight:nearestWeight];
            NSInteger fWeight = [XKRWAlgolHelper fatWithCalorie:cals];
            _sportStrongDecription.text = [NSString stringWithFormat:@"燃脂%ld克",(long)fWeight];
        }
    }

}


/** 显示运动信息*/
-(NSString *) getSportDesString{
    NSString * des = nil;
    if (self.sportEntity.sportMets > 0) {
        //    强度等级：根据后台获得的MET值显示强度。规则：MET＜4.7 的为低强度       MET＞7.2为高强度           4.7≤MET≤7.2 为中强度
        NSString* strDes = @"低强度";
        if (_sportEntity.sportMets < 4.7) {
            
        }else if (_sportEntity.sportMets>7.2){
            strDes = @"高强度";
        }else{
            strDes = @"中强度";
        }
        
        //当为方案时 显示的多
        if (self.isSecheme && self.cal > 0) {
            float curWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:self.date];
            
            if (self.sportEntity.sportTime > 0 ||  self.sportEntity.sportUnit == eSportUnitNumber) {
                int  nums = (int)((self.cal*200.f*60.f)/(self.sportEntity.sportMets*3.5*curWeight*self.sportEntity.sportTime)+0.5f);
                des= [NSString stringWithFormat:@"%ldkcal | %i个  %@",(long)self.cal,nums,strDes];
            }else if(self.sportEntity.sportUnit == eSportUnitTime){
                int  miutes = (int)((self.cal*200.f)/(self.sportEntity.sportMets*3.5*curWeight)+0.5f);
                des= [NSString stringWithFormat:@"%dkcal | %i分钟  %@",self.cal,miutes,strDes];
            }
            
        }else{
            //获得距离date最近日期的体重（含当日）
            float nearestWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:self.date];
            int cals = [_sportEntity consumeCaloriWithMinuts:60 weight:nearestWeight];
            des= [NSString stringWithFormat:@"%dkcal | 60分钟  %@",cals,strDes];
        }
        
    }else {
        des = @"0kcal | 0分钟  低强度";
    }
    return des;
}


-(void)collectSport:(UIButton *)btn{
    if(!_isSelected){
        [XKRWCui showProgressHud];
        [self colletSport];
    }else{
        [XKRWCui showProgressHud];
        [self deleteSportCollection];
    }
}

/** 添加收藏*/
-(void)colletSport{
    if (![XKUtil isNetWorkAvailable]){
        [XKRWCui showInformationHudWithText:kNetWorkDisable];
        return;
    }
    
    XKRWCollectionEntity *entity = [[XKRWCollectionEntity alloc] init];
    entity.originalId     = _sportID;
    entity.collectName   = _sportName;
    entity.collectType = 2;
    entity.uid = [[XKRWUserService sharedService] getUserId];
    entity.date = [NSDate date];
    self.collectEntity = entity;
    XKDispatcherOutputTask block = ^(){
        return  [[XKRWCollectionService sharedService] saveCollectionToRemote:entity];
    };
    if([XKRWUtil isNetWorkAvailable]){
        [self downloadWithTaskID:@"saveSportCollection" outputTask:block];
    }else{
        [XKRWCui showInformationHudWithText:@"网络连接有问题,请稍后再试"];
    }
    
}

/** 取消收藏*/
-(void)deleteSportCollection{
    NSDictionary *dic = [[XKRWCollectionService sharedService] queryByCollectType:2 andNid:_sportID];
    NSDate *queryDate = [dic objectForKey:@"date"];
    self.collectEntity.date = queryDate;
    self.collectEntity.originalId = [[dic objectForKey:@"original_id"] integerValue];
    
    if([XKRWUtil isNetWorkAvailable] == FALSE)
    {
        [XKRWCui showInformationHudWithText:@"网络连接有问题,请稍后再试"];
        return;
    }else{
        [self downloadWithTaskID:@"deleteCollection" task:^{
            [[XKRWCollectionService sharedService] deleteFromRemoteWithCollecType:2 date:queryDate];
        }];
    }
}


- (void)resetScrollViewContentsize:(CGFloat) height;
{
    @try {
        sportScrollView.contentSize = CGSizeMake(0,height);
    }
    @catch (NSException *exception) {
        XKLog(@"+++++%@",exception.description);
    }
    @finally {
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
