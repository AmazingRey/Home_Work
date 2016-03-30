//
//  XKRWNeedLoginAgain.h
//  XKRW
//
//  Created by Leng on 14-4-23.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBusinessException.h"

@interface XKRWNeedLoginAgain : XKRWBusinessException
@property (nonatomic, copy) NSString * msg;
@end
