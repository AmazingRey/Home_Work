//
//  XKRWModifyNickNameViewController.m
//  XKRW
//
//  Created by Leng on 14-4-2.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@interface CityListViewController : XKRWBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray * sourceArray ;
@end
