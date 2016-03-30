//
//  XKRWPhysicalAssessmentVC.h
//  XKRW
//
//  Created by 忘、 on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWIslimModel.h"

@interface XKRWPhysicalAssessmentVC : XKRWBaseVC <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView  *resultTableView;

@property (nonatomic,strong) XKRWIslimModel *model;
@end
