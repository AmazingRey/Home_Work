//
//  XKRWThinAssessVC.h
//  XKRW
//
//  Created by y on 15-1-22.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWIslimSportModel.h"

#import "XKRWIslimModel.h"

@interface XKRWThinAssessVC : XKRWBaseVC <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) XKRWIslimModel *model;

@end
