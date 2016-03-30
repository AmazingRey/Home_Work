//
//  XKRWSportIntroductionModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWSportIntroductionModel : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSArray  *catsArray;

- (NSString *)getSportRecommendString;

@end
