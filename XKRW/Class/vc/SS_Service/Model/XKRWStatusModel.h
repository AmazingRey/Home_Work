//
//  XKRWStatusModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWStatusModel : NSObject

@property (nonatomic,strong) NSString *desc;

@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger score;
@property (nonatomic,strong) NSString *word;

@end
