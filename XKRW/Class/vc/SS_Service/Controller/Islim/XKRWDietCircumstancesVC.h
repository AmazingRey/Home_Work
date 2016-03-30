//
//  XKRWDietCircumstancesVC.h
//  XKRW
//
//  Created by 忘、 on 15-1-27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWIslimDietCell.h"
#import "XKRWIslimDietHeaderCell.h"
#import "XKRWDietModel.h"
@interface XKRWDietCircumstancesVC : XKRWBaseVC
{
    UITableView  *dietCircumstancesTableView;
}

@property (nonatomic,strong) NSArray  *dietArray;

@property (nonatomic,strong) XKRWDietModel *dietModel;

@end
