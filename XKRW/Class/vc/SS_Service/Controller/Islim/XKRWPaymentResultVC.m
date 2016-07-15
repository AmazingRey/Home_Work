//
//  XKRWPaymentResultVC.m
//  XKRW
//
//  Created by XiKang on 15-3-26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWPaymentResultVC.h"
#import "XKRWiSlimAssessmentVC.h"

#import "XKRWOrderService.h"

#define FAILED_MSG @"失败原因：\n        1.请检查网络是否通畅;\n        2.请检查帐户余额是否充足;"

@interface XKRWPaymentResultVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XKRWPaymentResultVC
{
    NSArray *_datasource;
    BOOL _flag;
    
    NSDictionary *_obj;
    NSInteger _popTofloor;
}

#pragma mark - System's Function

- (instancetype)initWithFlag:(BOOL)isSuccess andObj:(id)obj {
    if (self = [super init]) {
        _flag = isSuccess;
        _obj = obj;
        
        _popTofloor = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付结果";
    
    [self loadOrRefreshData];
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize and refresh

- (void)loadOrRefreshData {
    
    if (_flag) {
        
        if ([_obj[@"orderEntity"] isKindOfClass:[XKRWOrderEntity class]]) {
            
            XKRWOrderEntity *order = _obj[@"orderEntity"];
            
            if ([order.identity isEqualToString:@"wx"]) {
                
                _datasource = @[@{@"title": @"详情",
                                  @"content": order.orderTitle},
                                @{@"title": @"订单号",
                                  @"content": order.orderNO}];
            } else if ([order.identity isEqualToString:@"ali"]) {
                
                _datasource = @[@{@"title": @"详情",
                                  @"content": order.orderTitle},
                                @{@"title": @"订单号",
                                  @"content": order.orderNO}];
            }
        }
    }
}

- (void)initSubviews {
    
    [self addNaviBarBackButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = XK_BACKGROUND_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    if (_flag) {
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 60.f)];
        footerView.backgroundColor = [UIColor clearColor];
        
        
        UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, 50.5, XKAppWidth, 0.5)];
        topline.backgroundColor = XKSepDefaultColor;
        bottomline.backgroundColor = XKSepDefaultColor;
    
        UIButton *begin = [[UIButton alloc] initWithFrame:CGRectMake(XKAppWidth / 2 - 125, 20.f, 250.f, 40.f)];
        [begin setTitle:@"开始评估" forState:UIControlStateNormal];
        [begin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [begin addSubview:topline];
        [begin addSubview:bottomline];
        [begin setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
         begin.backgroundColor = [UIColor whiteColor];
        
        begin.layer.cornerRadius = 3.f;
        begin.layer.masksToBounds = YES;
        
        if (_isHidenIslimResult) {
            [begin removeFromSuperview];
    
        } else {
            [footerView addSubview:begin];
            [begin addTarget:self action:@selector(clickBeginButton) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        _tableView.tableFooterView = footerView;
        
    } else {
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 100.f)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UILabel *attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.f, XKAppWidth - 30.f, 30.f)];
        attentionLabel.font = XKDefaultFontWithSize(14.f);
        attentionLabel.textColor = XK_ASSIST_TEXT_COLOR;
        attentionLabel.text = @"如果已经发生扣款，即购买成功。请勿重新支付，点击左上角返回即可。";
        attentionLabel.numberOfLines = 0;
        
        [footerView addSubview:attentionLabel];
        
        UIButton *begin = [[UIButton alloc] initWithFrame:CGRectMake(XKAppWidth / 2 - 125, 60.f, 250.f, 40.f)];
        [begin setTitle:@"重试" forState:UIControlStateNormal];
        [begin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        begin.backgroundColor = XKMainSchemeColor;
        
        begin.layer.cornerRadius = 3.f;
        begin.layer.masksToBounds = YES;
        
        [footerView addSubview:begin];
        
        [begin addTarget:self action:@selector(clickBeginButton) forControlEvents:UIControlEventTouchUpInside];
        
        _tableView.tableFooterView = footerView;
    }
}

- (void)clickBeginButton {
    
    if (_flag) {
        
        XKRWiSlimAssessmentVC *vc = [[XKRWiSlimAssessmentVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)popView {
    if (_isHidenIslimResult) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dealSystemTabbarShow" object:nil];
        return;
    }
    [self.navigationController popToViewController:self.navigationController.viewControllers[_popTofloor] animated:YES];
}
#pragma mark - UITableView's delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        if (_flag) {
            
            return 2;
        } else {
            
            return 1;
        }
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section) {
        
        if (_flag) {
            
            return 44.f;
        } else {
            
            NSMutableAttributedString *string = [XKRWUtil createAttributeStringWithString:FAILED_MSG font:XKDefaultNumEnFontWithSize(16.f) color:XK_TEXT_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
            CGRect rect = [string boundingRectWithSize:CGSizeMake(XKAppWidth - 30.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            return rect.size.height + 20.f;
        }
    } else {
        
        return 60.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.section) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            if (_flag) {
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
                line.backgroundColor = XK_ASSIST_LINE_COLOR;
                line.tag = 1;
                
                [cell addSubview:line];
                
                if (indexPath.row == 1) {
                    
                    line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, XKAppWidth, 0.5)];
                    line.backgroundColor = XK_ASSIST_LINE_COLOR;
                    line.tag = 2;
                    
                    [cell addSubview:line];
                }
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, 50.f, 44.f)];
                titleLabel.font = XKDefaultFontWithSize(16.f);
                titleLabel.textColor = XK_TEXT_COLOR;
                titleLabel.tag = 3;
                
                [cell addSubview:titleLabel];
                
                UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right, 0, XKAppWidth - 30 - 50.f, 44.f)];
                contentLabel.font = XKDefaultFontWithSize(16.f);
                contentLabel.textColor = XK_TITLE_COLOR;
                contentLabel.textAlignment = NSTextAlignmentRight;
                contentLabel.tag = 4;
                
                [cell addSubview:contentLabel];
                
            } else {

                NSMutableAttributedString *string = [XKRWUtil createAttributeStringWithString:FAILED_MSG font:XKDefaultNumEnFontWithSize(16.f) color:XK_TEXT_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
                CGRect rect = [string boundingRectWithSize:CGSizeMake(XKAppWidth - 30.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                
                UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, XKAppWidth - 30, rect.size.height + 20.f)];
                contentLabel.numberOfLines = 0;
                contentLabel.font = XKDefaultNumEnFontWithSize(16.f);
                contentLabel.textColor = XK_TITLE_COLOR;
                contentLabel.textAlignment = NSTextAlignmentRight;
                contentLabel.tag = 4;
                
                contentLabel.attributedText = string;
                
                [cell addSubview:contentLabel];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
                line.backgroundColor = XK_ASSIST_LINE_COLOR;
                line.tag = 1;
                
                [cell addSubview:line];
                
                line = [[UIView alloc] initWithFrame:CGRectMake(0, contentLabel.height - 0.5, XKAppWidth, 0.5)];
                line.backgroundColor = XK_ASSIST_LINE_COLOR;
                line.tag = 2;
                
                [cell addSubview:line];
            }
        }
        
        if (_flag) {
            
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:3];
            titleLabel.text = _datasource[indexPath.row][@"title"];
            
            UILabel *contentLabel = (UILabel *)[cell viewWithTag:4];
            contentLabel.text = _datasource[indexPath.row][@"content"];
        }
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.height = 60.f;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
            line.backgroundColor = XK_ASSIST_LINE_COLOR;
            line.tag = 1;
            
            [cell addSubview:line];
            
            line = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, XKAppWidth, 0.5)];
            line.backgroundColor = XK_ASSIST_LINE_COLOR;
            line.tag = 2;
            
            [cell addSubview:line];
            
            UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 60.f)];
            resultLabel.textAlignment = NSTextAlignmentCenter;
            resultLabel.font = XKDefaultFontWithSize(20.f);
            
            [cell addSubview:resultLabel];
            
            if (_flag) {
                resultLabel.textColor = XKMainSchemeColor;
                resultLabel.text = @"购买成功!";
                [MobClick event:@"in_iSlimPayOK"];
            } else {
                resultLabel.textColor = XK_STATUS_COLOR_FEW;
                resultLabel.text = @"购买失败!";
                [MobClick event:@"in_iSlimPayErr"];
            }
        }
    }
    return cell;
}


#pragma mark - Other functions

- (void)setPopToViewControllerWithFloor:(NSInteger)floor {
    
    if (floor >= 0) {
        
        _popTofloor = floor;
    }
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
