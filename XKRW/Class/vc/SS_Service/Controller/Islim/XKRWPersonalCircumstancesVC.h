//
//  XKRWPersonalCircumstancesVC.h
//  XKRW
//
//  Created by 忘、 on 15-1-19.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWBodyModel.h"
@interface XKRWPersonalCircumstancesVC : XKRWBaseVC
{
    UITableView  *circumstanceTableView;
}

@property (nonatomic,strong) XKRWBodyModel *bodyModel;

@end
