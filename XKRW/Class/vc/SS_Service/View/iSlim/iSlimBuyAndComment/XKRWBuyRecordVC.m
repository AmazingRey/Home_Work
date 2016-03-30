//
//  XKRWBuyRecordVC.m
//  XKRW
//
//  Created by y on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBuyRecordVC.h"
#import "XKRWStarView.h"
#import "XKRWOrderDetailCell.h"
#import "XKRWOrderNumCell.h"
#import "XKRWOrderEvaluateCell.h"
#import "XKRWDetailBuyRecordVC.h"
#import "XKRWHelpCenterVC.h"
#import "XKRWThinAssessVC.h"
#import "XKRWProfessionalShareVC.h"
#import "XKRWHabitStatusVC.h"
#import "XKRWOrderService.h"
#import "XKRWOrderRecordEntity.h"
#import "XKRWUserService.h"
#import "XKRWHelpCenterVC.h"
#import "XKRWServerPageService.h"

@interface XKRWBuyRecordVC ()
{
    NSInteger currentPageIndex;  //当前请求页面 标记
    UIImageView  *  noDataImageView;
    UILabel      *noDataLabel;
    BOOL _isShowPurchaseEntry;
}

@end

@implementation XKRWBuyRecordVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNaviBarBackButton];
    [self setTitle:@"服务记录"];
   
    self.buyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - 64) style:UITableViewStylePlain];
    self.buyTableView.delegate = self ;
    self.buyTableView.dataSource  =self ;
    self.buyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.buyTableView.backgroundView = [[UIView alloc]init];
    self.buyTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.buyTableView];

    noDataImageView =[[UIImageView alloc]initWithFrame:CGRectMake((XKAppWidth-90)/2, 120, 90, 90)];
    noDataImageView.image = [UIImage imageNamed:@"nothing_"];
    noDataImageView.hidden = YES;
    [self.view addSubview:noDataImageView];
    
    noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(noDataImageView.left-40, noDataImageView.bottom, noDataImageView.width+80, 30)];
    noDataLabel.textColor = XK_ASSIST_TEXT_COLOR;
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.numberOfLines = 0;
    noDataLabel.text = @"服务记录空空如也...";
    noDataLabel.font = XKDefaultFontWithSize(14.f);

    noDataLabel.hidden = YES;
    [self.view addSubview:noDataLabel];
    
    //从服务器  获取订单详情
    currentPageIndex = 0;
    [self getOrderRecordWithpage:currentPageIndex andSize:100000];
    
    if ([[XKRWServerPageService sharedService] needRequestStateOfSwitch]) {
        
        _isShowPurchaseEntry = NO;
        [self downloadWithTaskID:@"isShowPurchaseEntry" outputTask:^id{
            return @([[XKRWServerPageService sharedService] isShowPurchaseEntry_uploadVersion]);
        }];
    } else {
        _isShowPurchaseEntry = YES;
    }
    
    if (_isShowPurchaseEntry) {
        UIButton *helpButton = [UIButton buttonWithType: UIButtonTypeCustom];
        NSString *title = @"帮助";
        CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(XKAppWidth, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: XKDefaultFontWithSize(14)}
                                                 context:nil].size.width;
        helpButton.frame = CGRectMake(0, 0, titleWidth, 20);
        
        [helpButton setTitle:title forState:UIControlStateNormal];
        [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        helpButton.titleLabel.font = XKDefaultFontWithSize(14.f);
        [helpButton addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *helpItem =[[UIBarButtonItem alloc] initWithCustomView:helpButton];
        
        self.navigationItem.rightBarButtonItem = helpItem;
    }
}

- (void)getOrderRecordWithpage:(NSInteger)page andSize:(NSInteger)size
{
    if ([XKUtil isNetWorkAvailable]) {
        
        NSDictionary *pagams = [self getPagams:currentPageIndex andSize:size];
        
        [self downloadWithTaskID:@"getProductBuyRecord" outputTask:^id{
            return [[XKRWOrderService sharedService] getProductBuyRecord:pagams];
        }];
    }
}

-(NSDictionary*)getPagams:(NSInteger)currentPage andSize:(NSInteger)size
{
    NSString *page = [NSString stringWithFormat:@"%ld",(long)currentPage];
    NSString *pageSize = [NSString stringWithFormat:@"%ld",(long)size];
//    NSString *token = NEW_TOKEN;
    NSDictionary *pagePagams = @{@"page": page,@"size":pageSize};
    return pagePagams;
    
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID{
    
    if ([taskID isEqualToString:@"getProductBuyRecord"])
    {
        
        NSDictionary *data = [result objectForKey:@"data"];
        NSArray *listRecord = [data objectForKey:@"list"];
        
     
        for (int i = 0; i < listRecord.count; i++)
        {
            XKRWOrderRecordEntity *entity = [[XKRWOrderRecordEntity alloc ]init];
            entity.orderNo =  [listRecord[i] objectForKey:@"out_trade_no"];
            entity.orderCount = [listRecord[i] objectForKey:@"quantity"];
            entity.evaluateScore = [listRecord[i] objectForKey:@"score"];
            entity.evaluateDate = [listRecord[i] objectForKey:@"time"];
            entity.content =  [listRecord[i] objectForKey:@"content"];
            entity.uid  = [[XKRWUserService sharedService]getUserId];
            entity.recordId = [[listRecord[i] objectForKey:@"id"] integerValue];
            entity.orderDate = [listRecord[i] objectForKey:@"date_add"];
            entity.money = [listRecord[i] objectForKey:@"total_fee"];
            entity.orderProductName = [listRecord[i] objectForKey:@"product"];
                //存储当前    购买记录
            [[XKRWOrderService sharedService]saveTheRecord:entity];
        }

            NSInteger uid = [[XKRWUserService sharedService]getUserId];
            _mainArr  = [[XKRWOrderService sharedService]readUserOrderRecordByUid:uid];
        
        if (_mainArr.count == 0) {
            self.buyTableView.hidden = YES;
            noDataImageView.hidden = NO;
            noDataLabel.hidden = NO;
        }else{
            self.buyTableView.hidden = NO;
            noDataImageView.hidden = YES;
            noDataLabel.hidden = YES;
            [self.buyTableView reloadData];
        }
        
        
    } else if ([taskID isEqualToString:@"isShowPurchaseEntry"]) {
        
        _isShowPurchaseEntry = [result boolValue];
    }
}


- (void)helpAction:(UIButton *)button
{
    XKRWHelpCenterVC *helpVC = [[XKRWHelpCenterVC alloc]init];
    [self.navigationController pushViewController:helpVC animated:YES];
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    
}

    

-(void)pressRight:(UIButton *)sender
{
    XKRWHelpCenterVC *help = [[XKRWHelpCenterVC alloc]initWithNibName:@"XKRWHelpCenterVC" bundle:nil];
    [self.navigationController pushViewController:help animated:YES];
    
}

-(void)initData
{
    self.mainArr = [[NSMutableArray alloc]init];
    
    NSInteger uid = [[XKRWUserService sharedService]getUserId];
    //从本地读取购买记录变化
    self.mainArr  = [[XKRWOrderService sharedService]readUserOrderRecordByUid:uid];
    if ([self.mainArr count] > 0) {
         [_buyTableView reloadData];
    }
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mainArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *identifier = @"orderDeatilCell";
    XKRWOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell )
    {
        if (XKAppWidth == 320) {
             cell =  LOAD_VIEW_FROM_BUNDLE(@"XKRWOrderDetailCell");
        }else
        {
            cell = LOAD_VIEW_FROM_BUNDLE(@"XKRW6POrderDetailCell");
        }
       
        cell.selectionStyle  =  UITableViewCellSelectionStyleNone;
            
    }
    cell.orderNumLabel.text = [[self.mainArr objectAtIndex:indexPath.section] orderNo];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[[[self.mainArr objectAtIndex:indexPath.section] money] integerValue]/100.f];
    cell.dateLabel.text = [[self.mainArr objectAtIndex:indexPath.section] orderDate];
    cell.dateLabel.text = [cell.dateLabel.text substringToIndex:10];
    cell.productNameLabel.text = [[self.mainArr objectAtIndex:indexPath.section] orderProductName];
    NSInteger starNum = [[[self.mainArr objectAtIndex:indexPath.section] evaluateScore] integerValue];
    if (starNum == 0) {
        cell.UnEvaluate.text = @"未评价";
        cell.UnEvaluate.textAlignment =  NSTextAlignmentRight;
    }
    else
    {
        cell.UnEvaluate.hidden  = YES ;
    }
    [cell.star loadStarCount:starNum];
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (XKAppWidth == 320) {
        return 188;
    }else
    {
        return 170;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"in_PayAddReview"];
    XKRWDetailBuyRecordVC * detail = [[XKRWDetailBuyRecordVC alloc]init];
    detail.orderRecordEntity =  [self.mainArr objectAtIndex:indexPath.section];
    [self.navigationController  pushViewController:detail animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
