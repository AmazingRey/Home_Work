//
//  XKRWHabitStatusVC.h
//  XKRW
//
//  Created by y on 15-1-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//
//习惯情况

#import "XKRWBaseVC.h"
#import "XKRWHabitHeadView.h"

#import "XKRWHabitModel.h"


@interface XKRWHabitStatusVC : XKRWBaseVC<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView  *mianTableView;

@property(nonatomic,strong)NSMutableArray *array;

@property(nonatomic,strong)XKRWHabitHeadView *headView;


@property(nonatomic,strong)XKRWHabitModel  *habitModel;


@property(nonatomic,strong)NSMutableArray  *dataArray;

@property(nonatomic,strong)NSMutableArray  *headDataArray;
@end
