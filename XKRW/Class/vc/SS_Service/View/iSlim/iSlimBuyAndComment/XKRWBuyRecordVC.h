//
//  XKRWBuyRecordVC.h
//  XKRW
//
//  Created by y on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@interface XKRWBuyRecordVC : XKRWBaseVC<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *buyTableView;
@property(nonatomic,strong)NSMutableArray *mainArr;

@end
