//
//  XKRWFitnessShareVC.h
//  XKRW
//
//  Created by Shoushou on 15/9/14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

typedef NS_ENUM(NSInteger, XKRWDiscoverType) {
    XKRWFitnessShareType = 1,
    XKRWTopicType,
    XKRWMyShareType
};

@interface XKRWFitnessShareVC : XKRWBaseVC
@property (nonatomic, assign) XKRWDiscoverType myType;
@property (nonatomic, strong) NSMutableArray *dataMutArray;

@end
