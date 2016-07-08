//
//  XKRWPayOrderVC.m
//  XKRW
//
//  Created by XiKang on 15-3-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWPayOrderVC.h"
#import "XKRWOrderService.h"
#import "XKRWPayOrderCell.h"
#import "XKRWPaymentResultVC.h"
#import "XKRWUtil.h"
#import "WXApi.h"

@interface XKRWPayOrderVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XKRWPayOrderVC
{
    NSMutableArray *_titleArray;
    NSMutableArray *_subtitleArray;
    NSMutableArray *_headImageArray;
    
    NSInteger _selecteIndex;
    
    XKRWOrderEntity *_order;
}
#pragma mark - System's functions

- (id)initWithPID:(NSString *)pid {
    
    self = [super init];
    if (self) {
        _pid = pid;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"in_iSlimPay"];
    // Do any additional setup after loading the view.
    self.title = @"支付订单";
    [self addNaviBarBackButton];
    
    [self initData];
    [self initSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentCallback:) name:kPaymentResultNotification object:nil];
}

- (void)popView {
    
    if (_isPopToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dealSystemTabbarShow" object:nil];
        return;
    }
    
    [super popView];
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)initSubviews {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = XK_BACKGROUND_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerNib:[UINib nibWithNibName:@"XKRWPayOrderCell" bundle:nil] forCellReuseIdentifier:@"payOrderCell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 70.f)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *pay = [[UIButton alloc] initWithFrame:CGRectMake(0, 20.f, XKAppWidth, 51.f)];
//    pay.layer.cornerRadius = 3.f;
    UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, .5)];
    UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, pay.height-.5, XKAppWidth, .5)];
    topLine.backgroundColor = XKSepDefaultColor;
    bottomLine.backgroundColor = XKSepDefaultColor;
    [pay addSubview:topLine];
    [pay addSubview:bottomLine];
    
    [pay setTitle:@"确认支付" forState:UIControlStateNormal];
    pay.titleLabel.font = XKDefaultFontWithSize(16.f);
    [pay setBackgroundColor:[UIColor whiteColor]];
    [pay setTitleColor:XK_STATUS_COLOR_FEW forState:UIControlStateNormal];
    [pay addTarget:self action:@selector(paySelectedOrder) forControlEvents:UIControlEventTouchUpInside];
    [pay setBackgroundImage:[UIImage createImageWithColor:RGB(217, 217, 217, 1)] forState:UIControlStateHighlighted];

    [footerView addSubview:pay];
    _tableView.tableFooterView = footerView;
    
    [self.view addSubview:_tableView];
}

- (void)initData {
    
    _selecteIndex = -1;
    
    _titleArray = [NSMutableArray array];
    _subtitleArray = [NSMutableArray array];
    _headImageArray = [NSMutableArray array];
    
    [XKRWCui showProgressHud:@"获取产品信息"];
    if (_product.pid) {
        _pid = _product.pid;
        [_titleArray addObjectsFromArray:@[@"支付宝支付", @"微信支付"]];
        [_subtitleArray addObjectsFromArray:@[@"推荐安装支付宝的用户使用", @"推荐安装微信的用户使用"]];
        [_headImageArray addObjectsFromArray:@[@"icon_AliPay", @"icon_WXPay"]];
        
        [_tableView reloadData];
        [XKRWCui hideProgressHud];
        return;
    } else {
        [self downloadWithTaskID:@"getProduct" outputTask:^id{
            
            return [[XKRWOrderService sharedService] getProductList];
        }];
    }
    
}

#pragma mark - Networking

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication {
    
    return YES;
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    [XKRWCui hideProgressHud];
    
    if ([taskID isEqualToString:@"getProduct"]) {
        
        for (XKRWProductEntity *product in result) {
            
            if ([product.pid isEqualToString:_pid]) {
                _product = product;
                break;
            }
        }
        [_titleArray addObjectsFromArray:@[@"支付宝支付", @"微信支付"]];
        [_subtitleArray addObjectsFromArray:@[@"推荐安装支付宝的用户使用", @"推荐安装微信的用户使用"]];
        [_headImageArray addObjectsFromArray:@[@"icon_AliPay", @"icon_WXPay"]];
        
        [_tableView reloadData];
        return;
    }
    if ([taskID isEqualToString:@"getOrder"]) {
        
        _order = result;
        [[XKRWOrderService sharedService] payOrder:_order];
        
        return;
    }
    
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    
    [XKRWCui hideProgressHud];

    if ([taskID isEqualToString:@"getProduct"]) {
        
        [XKRWCui showInformationHudWithText:@"获取产品信息失败"];
    }
    if ([taskID isEqualToString:@"getOrder"]) {
        
        [XKRWCui showInformationHudWithText:@"获取订单失败，请重试"];
    }
}

#pragma mark - UITableView's delegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section) {
        
        XKRWPayOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payOrderCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setTitle:_titleArray[indexPath.row]
              subtitle:_subtitleArray[indexPath.row]
             headImage:_headImageArray[indexPath.row]];
        
        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0.f, 0.f, XKAppWidth, 44.f)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, 240.f, 44.f)];
            title.tag = 1;
            title.font = XKDefaultFontWithSize(16.f);
            title.textColor = XK_TITLE_COLOR;
            title.text = _product.title;
            
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(XKAppWidth - 15.f - 60.f, 0, 60.f, 44.f)];
            price.tag = 2;
            price.text = [NSString stringWithFormat:@"%@元", _product.price];
            price.font = XKDefaultNumEnFontWithSize(16.f);
            price.textAlignment = NSTextAlignmentRight;
            price.textColor = XK_STATUS_COLOR_FEW;
            
            [cell addSubview:title];
            [cell addSubview:price];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section) {
        return 45.f;
    } else {
        return 10.f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return _titleArray.count;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 45.f)];
        view.backgroundColor = XK_BACKGROUND_COLOR;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, 200.f, 45.f)];
        label.font = XKDefaultFontWithSize(16.f);
        label.textColor = XK_TEXT_COLOR;
        label.text = @"选择支付方式";
        
        [view addSubview:label];
        
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section) {
        return 64;
    } else {
        return 44.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section) {
        
        _selecteIndex = indexPath.row;
    }
}

#pragma mark - Other Funtions

- (void)paySelectedOrder {
    
    if (_selecteIndex == -1) {
        
        [XKRWCui showInformationHudWithText:@"请选择支付方式"];
        return;
    }
    if (_selecteIndex == 0) {
        
    }
    if (_selecteIndex == 1) {
        
        if (![WXApi isWXAppInstalled]) {
            [XKRWCui showInformationHudWithText:@"您还未安装微信客户端"];
            return;
        }
        if (![WXApi isWXAppSupportApi]) {
            [XKRWCui showInformationHudWithText:@"当前的微信版本过低"];
            return;
        }
    }
    
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"网络不给力，请稍后重试~"];
        return;
    }
    
    [XKRWCui showProgressHud:@"获取订单中"];
    if ([_product.pid isEqualToString:@"10000"]) {
        [self downloadWithTaskID:@"getOrder" outputTask:^id{
            
            if (_selecteIndex == 0) {
                
                return [[XKRWOrderService sharedService] getAliPayOrderInfoByProductId:_product.pid.integerValue];
            } else {
                
                return [[XKRWOrderService sharedService] getWXPayOrderInfoByProductId:_product.pid.integerValue];
            }
        }];

    } else {
        NSString *type;
        if (_selecteIndex == 0) {
            type = @"ali";
        } else {
            type = @"wx";
        }
        _order = [[XKRWOrderService sharedService] getSSBuyOrderInfoByType:type outTradeNo:_product.pid title:_product.title price:_product.price.floatValue];

        if (!_order) {
            [XKRWCui hideProgressHud];
            [XKRWCui showInformationHudWithText:@"订单信息错误，请重试~"];
        }
        
        [XKRWCui hideProgressHud];
        [[XKRWOrderService sharedService] payOrder:_order];
    }
}
/**
 *  支付结果通知回调
 *
 *  @param notification post通知
 */
- (void)paymentCallback:(NSNotification *)notification {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:notification.object];
    [result setObject:_order forKey:@"orderEntity"];
    
    XKRWPaymentResultVC *vc = [[XKRWPaymentResultVC alloc] initWithFlag:[result[@"success"] boolValue]
                                                                 andObj:result];
    if ([_product.pid isEqualToString:@"10000"]) {
        vc.isHidenIslimResult = NO;
    } else {
        vc.isHidenIslimResult = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
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
