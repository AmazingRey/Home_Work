//
//  XKRWsportAdvise.h
//  XKRW
//
//  Created by 忘、 on 15-2-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWsportAdviseModel : NSObject

@property (nonatomic,strong) NSString *guide1;
@property (nonatomic,strong) NSString *guide2;

@property (nonatomic,strong) NSString *introduction;
@property (nonatomic,strong) NSString *aerobics;
@property (nonatomic,strong) NSString *strength;

- (NSArray *)getAdviseArray;

@end
