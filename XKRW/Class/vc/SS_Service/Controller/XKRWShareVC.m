//
//  XKRWShareVC.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-11.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWShareVC.h"
#import "WXApi.h"
#import "XKRWServiceCell.h"
#import "XKRWMoreCells.h"
#import "XKRWEnumDefine.h"
#import "XKRWFatReasonService.h"
#import "XKRWBuyRecordVC.h"
#import "XKRWAttentionWechatVC.h"
#import "XKRWiSlimAssessmentPurchaseVC.h"
#import "XKRWPhysicalAssessmentVC.h"
#import "XKRWPersonalCircumstancesVC.h"
#import "XKRWDietCircumstancesVC.h"
#import "XKRWUserDefaultService.h"
#import "XKRWDietModel.h"
#import "XKRWServerPageService.h"
#import "XKRWRecordService4_0.h"
#import "XKRWServerPageService.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
//#import "XKRW-Swift.h"
#import "XKRWNavigationController.h"
#import "XKRWServiceIslimADDCell.h"
#import "XKRWUtil.h"
#import "XKRWIslimModel.h"
#import "XKRWNewWebView.h"
#import "XKRWUserService.h"

@interface XKRWShareVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray  *cellIconImageArrays;
    NSArray  *titleArrays ;
    NSArray  *describeArrays;
    NSString *weChatNum;  // 关注微信的人数
    NSString *buyServerNum; //购买服务的人数
    NSMutableArray  *testArray;
    
    NSMutableArray  * islimAddArray;    ///< islim 广告
    BOOL _isShowiSlim;
}
@end


@implementation XKRWShareVC
{
    BOOL _isShowRedHot;    //是否显示红色的热键
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self reloadData];
    
    [MobClick event:@"in_Service"];
}

- (void)viewDidLoad
{
    self.forbidAutoAddCloseButton = YES;
    [super viewDidLoad];
    self.title = @"服务";
    weChatNum = @"";
    buyServerNum =@"";

    [self initView];
    
    if ([[XKRWServerPageService sharedService] needRequestStateOfSwitch]) {
        _isShowiSlim = NO;
        [self downloadWithTaskID:@"requestState" outputTask:^{
            return @([[XKRWServerPageService sharedService] isShowPurchaseEntry_uploadVersion]);
        }];
    } else {
        _isShowiSlim = YES;
    }
    
    [self downloadWithTaskID:@"islimDataForAdd" outputTask:^id{
        return [[XKRWServerPageService sharedService] requestIslimDataForAdd];
    }];
    
    [self loadDataFromRemote];

}


/**
 *  初始化子视图
 */
- (void)initView
{
    _serviceTableView = [[XKRWUITableViewBase alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64 -49) style:UITableViewStylePlain];
    _serviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _serviceTableView.delegate = self;
    _serviceTableView.dataSource = self;
    _serviceTableView.backgroundColor = colorSecondary_f4f4f4;
    [_serviceTableView registerNib:[UINib nibWithNibName:@"XKRWServiceIslimADDCell" bundle:nil] forCellReuseIdentifier:@"islimADDCell"];
    [self.view addSubview:_serviceTableView];
    self.navigationItem.leftBarButtonItem = nil;
    
    [self addNaviBarRightButtonWithText:@"服务记录" action:@selector(servicerecordAction:)];
}
/**
 *  初始化数据
 */
- (void)reloadData {
    
    if (_isShowiSlim) {
        
        cellIconImageArrays = @[@"serviceIcon_01",@"icon_02_"];
        titleArrays = @[@"iSlim专业瘦身评估",@"咨询私人顾问"];
        describeArrays = @[@"让减肥从困难变容易",@"最专业的瘦身指导"];
    } else {
        cellIconImageArrays = @[@"icon_02_"];
        titleArrays = @[@"咨询私人顾问"];
        describeArrays = @[@"最专业的瘦身指导"];
    }
}


- (void)servicerecordAction:(UIButton *)button
{
    XKRWBuyRecordVC *buyRecordVc = [[XKRWBuyRecordVC alloc]init];
    buyRecordVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:buyRecordVc animated:YES];
}

//远程加载  系统推荐方案数据
- (void) loadDataFromRemote
{
    if (![XKUtil isNetWorkAvailable]) {
        [XKRWCui hideProgressHud];
        [XKRWCui showInformationHudWithText:@"没有网络，请检查网络设置"];
        return;
    }
    
    [self downloadWithTaskID:@"getServerData" outputTask:^id{
        return [[XKRWServerPageService sharedService] getServerDataFromNetwork];
    }];

}

#pragma mark - Net Data
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    
    if([taskID isEqualToString:@"getServerData"])
    {
        if([[result objectForKey:@"EvaluateTotal"] integerValue] !=0)
        {
            buyServerNum = [NSString stringWithFormat:@"%ld在用", (long)[[result objectForKey:@"EvaluateTotal"] integerValue]];
            
            [[NSUserDefaults standardUserDefaults] setObject:buyServerNum forKey:BUYSERVERNUM];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        weChatNum =[result objectForKey:@"AttentionTotal"];
        [_serviceTableView reloadData];
        return;
    }
    
    if ([taskID isEqualToString:@"requestState"]) {
        _isShowiSlim = [result boolValue];
//        if (_isShowiSlim) {
            [self reloadData];
            [_serviceTableView reloadData];
//        }
        return;
    }
    
    if ([taskID isEqualToString:@"islimDataForAdd"]){
        
        islimAddArray = [NSMutableArray arrayWithArray:(NSMutableArray *)result];
        [_serviceTableView reloadData];
        return;
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
    [super handleDownloadProblem:problem withTaskID:taskID];
    if ([taskID isEqualToString:@"getServerData"]) {
        XKLog(@"网络请求失败");
    }
}


- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

#pragma tabDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isShowiSlim) {
        return 2 + islimAddArray.count;
    }
    
    return 1 + islimAddArray.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    [view setBackgroundColor:XKClearColor];
    
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_isShowiSlim) {
        if (indexPath.section == 0 ) {
            
            XKRWServiceCell *cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWServiceCell");
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:BUYSERVERNUM]){
                buyServerNum = [[NSUserDefaults standardUserDefaults] objectForKey:BUYSERVERNUM];
            }
            
            [cell initSubViewsWithIconImageName:[cellIconImageArrays objectAtIndex:indexPath.section] Title:[titleArrays objectAtIndex:indexPath.section] Describe:[describeArrays objectAtIndex:indexPath.section] tip:buyServerNum isShowHotImageView:NO isShowRedDot:NO];
            
            return cell;
            
        } else if (indexPath.section == 1) {
            XKRWServiceCell *cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWServiceCell");
            [cell initSubViewsWithIconImageName:[cellIconImageArrays objectAtIndex:indexPath.section] Title:[titleArrays objectAtIndex:indexPath.section] Describe:[describeArrays objectAtIndex:indexPath.section] tip:weChatNum isShowHotImageView:NO isShowRedDot:NO];
            
            return cell;
        }else{
            
            XKRWIslimAddModel * model = islimAddArray[indexPath.section - 2];
            XKRWServiceCell *cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWServiceCell");
            [cell initSubViewsWithIconImageName:model.image Title:model.name Describe:model.detail1 tip:model.detail2 isShowHotImageView:NO isShowRedDot:NO];
            
            return cell;
            
        }
    }
    else{
        
        if (indexPath.section == 0 ) {
          
            XKRWServiceCell *cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWServiceCell");
            [cell initSubViewsWithIconImageName:[cellIconImageArrays objectAtIndex:indexPath.section] Title:[titleArrays objectAtIndex:indexPath.section] Describe:[describeArrays objectAtIndex:indexPath.section] tip:weChatNum isShowHotImageView:NO isShowRedDot:NO];
            
            return cell;
            
        }else{
            
            XKRWIslimAddModel * model = islimAddArray[indexPath.section - 1];
            
            XKRWServiceCell *cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWServiceCell");
            [cell initSubViewsWithIconImageName:model.image Title:model.name Describe:model.detail1 tip:model.detail2 isShowHotImageView:NO isShowRedDot:NO];
            
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_isShowiSlim)
    {
        if (indexPath.section == 0) {
            [MobClick event:@"in_iSlim"];
            XKRWiSlimAssessmentPurchaseVC  *slimVC = [[XKRWiSlimAssessmentPurchaseVC alloc]init];
            slimVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:slimVC animated:YES];
            
        } else if (indexPath.section == 1) {
            [MobClick event:@"in_WcSvc"];
            XKRWAttentionWechatVC *attentionWechatVC = [[XKRWAttentionWechatVC alloc]init];
            attentionWechatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:attentionWechatVC animated:YES];
            
        } else {
            XKRWNewWebView * adVC = [XKRWNewWebView new];
            adVC.hidesBottomBarWhenPushed = YES;
            if([[islimAddArray[indexPath.section - 1] addr] rangeOfString:@"ssbuy.xikang.com"].location != NSNotFound){
                adVC.contentUrl = [NSString stringWithFormat:@"%@&ios=%d",[islimAddArray[indexPath.section - 1] addr],[[[UIDevice currentDevice] systemVersion] integerValue]];
            }else{
                adVC.contentUrl = [islimAddArray[indexPath.section - 1] addr];
            }
            adVC.contentUrl = [islimAddArray[indexPath.section - 2] addr];
            adVC.webTitle = [islimAddArray[indexPath.section - 2] name];
            adVC.showType = NO;
            [self.navigationController pushViewController:adVC animated:YES];
        }
        
    }else{
        if (indexPath.section == 0)
        {
            [MobClick event:@"in_WcSvc"];
            XKRWAttentionWechatVC *attentionWechatVC = [[XKRWAttentionWechatVC alloc]init];
            attentionWechatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:attentionWechatVC animated:YES];
            
        } else {
            XKRWNewWebView * adVC = [XKRWNewWebView new];
            adVC.hidesBottomBarWhenPushed = YES;
            if([[islimAddArray[indexPath.section - 1] addr] rangeOfString:@"ssbuy.xikang.com"].location != NSNotFound){
                adVC.contentUrl = [NSString stringWithFormat:@"%@&ios=%d",[islimAddArray[indexPath.section - 1] addr],[[[UIDevice currentDevice] systemVersion] integerValue]];
            }else{
                adVC.contentUrl = [islimAddArray[indexPath.section - 1] addr];
            }
            adVC.webTitle = [islimAddArray[indexPath.section - 1] name];
            adVC.showType = NO;
            [self.navigationController pushViewController:adVC animated:YES];
            
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
