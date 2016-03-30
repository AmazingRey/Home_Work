//
//  XKRWMoreSearchResultVC.h
//  XKRW
//
//  Created by Jack on 15/7/15.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@interface XKRWMoreSearchResultVC : XKRWBaseVC
// foodEntity 的数组
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSMutableArray *dataMutArray;
// key 搜索的关键词
@property (nonatomic,strong) NSString *searchKey;
//type 1 食物 0 运动  
@property (nonatomic) NSInteger searchType;

@end
