//
//  XKRWiSlimAssessmentPurchaseVC.m
//  XKRW
//
//  Created by XiKang on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWiSlimAssessmentPurchaseVC.h"
#import "PurchaseHeader.h"
#import "iSlimAssessmentCell.h"
#import "XKRWiSlimAssSuccessStoriesVC.h"
#import "XKRWiSlimAssessmentReferencesVC.h"
#import "XKRWiSlimExchangeVC.h"
#import "XKRWAllCommentVC.h"
#import "XKRWServerPageService.h"
#import "XKRWExcerciseAssResultVC.h"
#import "XKRWComprehensiveAssResultVC.h"
#import "XKRWiSlimAssessmentVC.h"

#import "XKRWPhysicalAssessmentVC.h"

#import "XKRWPayOrderVC.h"
#import "XKRWIslimCommentModel.h"
#import "XKRWCommentModel.h"


#import "XKRWPaymentResultVC.h"
#import "KMPopoverView.h"

#import "XKRW-Swift.h"
#import "XKRWOrderService.h"

@interface XKRWiSlimAssessmentPurchaseVC () <UITableViewDelegate, UITableViewDataSource, KMPopoverViewDelegate>

@property (nonatomic, strong) PurchaseHeader *header;
@property (nonatomic, strong) UITableView    *tableView;

@end

@implementation XKRWiSlimAssessmentPurchaseVC
{
    PurchaseState _purchaseState;
    iSlimAssessmentCell *contentView;
    
    CGFloat _cellHeight;
    
    NSInteger _num;
    PurchaseState _state;
    
    int _flag;
    BOOL _success;
    BOOL _isShowPurchaseEntry;
}
#pragma mark - System funtions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDatasource];
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![XKRWUtil isNetWorkAvailable]) {
        
        [XKRWCui showInformationHudWithText:@"你的网络有点不给力哦, 请检查网络设置"];
        NSString *identifier = [NSString stringWithFormat:@"%ld.islim", (long)UID];
        
        if ([[XKRWServerPageService sharedService] isUsed:identifier]) {
            
            [self.header setToState:PurchaseStateDone numberOfChances:0];
            
        } else {
            [self.header setDisable];
        }
        
        return;
    }
    
    _flag --;
    
    [self.header loading];
    _num = 0;
    _success = NO;
    [self downloadWithTaskID:@"getPurchaseState"
                  outputTask:^id{
                      return [[XKRWServerPageService sharedService] getUserPurchaseState];
                  }];
    [self downloadWithTaskID:@"getProduct" outputTask:^id{
        
        return [[XKRWOrderService sharedService] getProductList];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initialize

- (void)initSubviews {
    
    self.title = @"iSlim专业瘦身评估";
    [self addNaviBarBackButton];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight - statusBarHeight) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = XK_BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizesSubviews = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIImageView *tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purchase_tableview_header"]];
    float radio = XKAppWidth / tableHeaderView.width;
    tableHeaderView.width = XKAppWidth;
    tableHeaderView.height = tableHeaderView.height * radio;
    
    self.tableView.tableHeaderView = tableHeaderView;
    
    
    [self.view addSubview:self.tableView];
    
    contentView = LOAD_VIEW_FROM_BUNDLE(@"iSlimAssessmentCell");
    
    
    __weak XKRWiSlimAssessmentPurchaseVC *weakSelf = self;
    [contentView initSubviewsWithObject];
    
    [contentView setClickExchangeButton:^{
        XKRWiSlimExchangeVC *vc = [[XKRWiSlimExchangeVC alloc] initWithNibName:@"XKRWiSlimExchangeVC"
                                                                        bundle:nil];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    } clickViewTeamDetailButton:^{
        XKRWiSlimAssessmentReferencesVC *vc = [[XKRWiSlimAssessmentReferencesVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    } clickCommentButton:^{
        
        XKRWAllCommentVC *allCommentVC = [[XKRWAllCommentVC alloc] init];
        
        [weakSelf.navigationController pushViewController:allCommentVC animated:YES];
        
        
    } clickSuccessStoriesButton:^{
        XKRWiSlimAssSuccessStoriesVC *vc = [[XKRWiSlimAssSuccessStoriesVC alloc] initWithNibName:nil bundle:nil];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    _cellHeight = contentView.height;
    
    self.header = LOAD_VIEW_FROM_BUNDLE(@"PurchaseHeader");
    
    [self.header initSubviewsWithState:_purchaseState
                           clickButton:^{
                               if (self.header.state == PurchaseStateNotYet) {
                                   //还未购买
                                   //pid = 10000 : iSlim瘦身评估
                                   XKRWPayOrderVC *vc = [[XKRWPayOrderVC alloc] initWithPID:10000];
                                   [weakSelf.navigationController pushViewController:vc animated:YES];
                                   
                               } else if (self.header.state == PurchaseStatePurchased) {
                                   //已经付款
                                   XKRWiSlimAssessmentVC *vc = [[XKRWiSlimAssessmentVC alloc] init];
                                   [weakSelf.navigationController pushViewController:vc animated:YES];
                                   
                               } else {
                                   //完成评估
                                   XKRWPhysicalAssessmentVC *vc = [[XKRWPhysicalAssessmentVC alloc] init];
                                   vc.model = [[XKRWServerPageService sharedService] getIslimModelFromLocalFile];
                                   
                                   [weakSelf.navigationController pushViewController:vc animated:YES];
                               }
                           }];
}

- (void)initDatasource {
    
    if ([[XKRWServerPageService sharedService] needRequestStateOfSwitch]) {
        
        _isShowPurchaseEntry = NO;
        [self downloadWithTaskID:@"isShowPurchaseEntry" outputTask:^id{
            return @([[XKRWServerPageService sharedService] isShowPurchaseEntry_uploadVersion]);
        }];
    } else {
        
        _isShowPurchaseEntry = YES;
    }
    if (![XKRWUtil isNetWorkAvailable]) {
        return;
    }
    _flag = 1;
    [self downloadWithTaskID:@"getUserComment" outputTask:^id{
        return [[XKRWServerPageService sharedService] getCommentDataFromNetworkWithCommentID:nil
                                                                                 commentType:nil];
    }];
    [self downloadWithTaskID:@"getiSlimReport" outputTask:^id{
        
        return [[XKRWServerPageService sharedService] getiSlimReportFromRemote];
    }];
    
}

#pragma mark - Networking 

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    if ([taskID isEqualToString:@"getPurchaseState"]) {
        _flag ++;
        _success = NO;
        
        [XKRWCui showInformationHudWithText:@"获取状态失败，请稍后再试"];
        if (_flag == 2) {
            [self handleStateWithFlag:_success];
        }
        return;
    }
    if ([taskID isEqualToString:@"getUserComment"]) {
        return;
    }
    if ([taskID isEqualToString:@"getiSlimReport"]) {
        _flag ++;
        
        if (_flag == 2) {
            [self handleStateWithFlag:_success];
        }
        return;
    }
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    if ([taskID isEqualToString:@"getPurchaseState"]) {
        
        _flag ++;
        _success = YES;
        _num = [result[@"data"] integerValue];
//        _state = [result[@"state"] intValue];
        
        if (_flag == 2) {
            [self handleStateWithFlag:_success];
        }
    } else if ([taskID isEqualToString:@"getiSlimReport"]) {
      
        _flag ++;
        
        if (_flag == 2) {
            [self handleStateWithFlag:_success];
        }
        
    } else if ([taskID isEqualToString:@"getUserComment"]) {
        
        NSLog(@"%@",result);
        
        XKRWIslimCommentModel *islimCommentModel = (XKRWIslimCommentModel *)result;
        
        NSArray *array = islimCommentModel.commentArray;
        NSMutableArray  *userNameArray = [NSMutableArray arrayWithCapacity:4];
        NSMutableArray  *commentArray = [NSMutableArray arrayWithCapacity:4];
        
        for (int i = 0; i < 4; i ++) {
            
            if (array.count >= 4) {

                XKRWCommentModel *commentModel  = [array objectAtIndex:i];
                NSString *userName = commentModel.account;
                NSString *commentContent = commentModel.commentContent;
                
                [userNameArray addObject:userName];
                
                [commentArray addObject:commentContent];
            }
        }
        [contentView setUserCommentWithUserNameArray:userNameArray commentNameArray:commentArray totalComment:islimCommentModel.commentTotal];
        
    } else if ([taskID isEqualToString:@"isShowPurchaseEntry"]) {
        
        _isShowPurchaseEntry = [result boolValue];
        [self.tableView reloadData];
    } else {
        if ([taskID isEqualToString:@"getProduct"]) {
            
            for (XKRWProductEntity *product in result) {
                
                if (product.pid == 10000) {
                    self.header.curretPriceLabel.text = XKSTR(@"%@",(XKRWProductEntity *)product.price);
                    break;
                }
            }
            return;
        }
    }
}

#pragma mark - TableView's datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"service_purchase_cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"service_purchase_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.autoresizesSubviews = NO;
        
        [cell.contentView addSubview:contentView];
    }
    if (_isShowPurchaseEntry) {
        contentView.hiddenLabel.hidden = NO;
    } else {
        contentView.hiddenLabel.hidden = YES;
    }
//    for (UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"content: %f", contentView.height);
    return _cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_isShowPurchaseEntry) {
        return 54.f;
    } else {
        return 0.f;
    }
}


#pragma mark - TableView's delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_isShowPurchaseEntry) {
        
        if (self.header) {
            return self.header;
        }
        
        __weak XKRWiSlimAssessmentPurchaseVC *weakSelf = self;
        
        self.header = LOAD_VIEW_FROM_BUNDLE(@"PurchaseHeader");
        [self.header initSubviewsWithState:_purchaseState
                               clickButton:^{
                                   if (self.header.state == PurchaseStateNotYet) {
                                       //还未购买
                                       //pid = 10000 : iSlim瘦身评估
                                       XKRWPayOrderVC *vc = [[XKRWPayOrderVC alloc] initWithPID:10000];
                                       [weakSelf.navigationController pushViewController:vc animated:YES];
                                       
                                   } else if (self.header.state == PurchaseStatePurchased) {
                                       //已经付款
                                       XKRWiSlimAssessmentVC *vc = [[XKRWiSlimAssessmentVC alloc] init];
                                       [weakSelf.navigationController pushViewController:vc animated:YES];
                                       
                                   } else {
                                       //完成评估
                                       XKRWPhysicalAssessmentVC *vc = [[XKRWPhysicalAssessmentVC alloc] init];
                                       vc.model = [[XKRWServerPageService sharedService] getIslimModelFromLocalFile];
                                       
                                       [weakSelf.navigationController pushViewController:vc animated:YES];
                                   }
                               }];
        return self.header;
    } else {
        return nil;
    }
}

#pragma mark - Other functions

- (CGFloat)getViewHeight:(UIView *)view {
    [view layoutIfNeeded];
    [view updateConstraintsIfNeeded];
    
    CGFloat height = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (void)handleStateWithFlag:(BOOL)flag {
    
    NSString *identifier = [NSString stringWithFormat:@"%ld.islim", (long)UID];
    if ([[XKRWServerPageService sharedService] isUsed:identifier]) {
        
        _state = PurchaseStateDone;
    } else {
        if (!flag) {
            [self.header setDisable];
            return;
        }
        if (_num) {
            _state = PurchaseStatePurchased;
        } else {
            _state = PurchaseStateNotYet;
        }
    }
    [self.header setToState:_state numberOfChances:_num];
}

- (void)KMPopoverView:(KMPopoverView *)KMPopoverView clickButtonAtIndex:(NSInteger)index {
    
    NSLog(@"点击了Index：%d", (int)index);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
