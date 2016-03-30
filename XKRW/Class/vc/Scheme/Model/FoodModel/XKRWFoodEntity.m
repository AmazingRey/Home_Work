//
//  XKRWFoodEntity.m
//  XKRW
//
//  Created by zhanaofan on 14-2-7.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWFoodEntity.h"

@implementation XKRWFoodEntity

- (id) init
{
    if (self = [super init]) {
      
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:_foodId forKey:@"foodId"];
    [encoder encodeObject:_foodName forKey:@"foodName"];
    [encoder encodeObject:_foodLogo forKey:@"foodLogo"];
    [encoder encodeObject:_foodNutri forKey:@"foodNutri"];
    [encoder encodeInteger:_foodEnergy forKey:@"foodEnergy"];
    [encoder encodeInteger:_fitSlim forKey:@"fitSlim"];
//    encoder en
    [encoder encodeObject:_foodUnit forKey:@"foodUnit"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _foodId = [decoder decodeInt32ForKey:@"foodId"];
        _foodName = [decoder decodeObjectForKey:@"foodName"];
        _foodEnergy = [decoder decodeInt32ForKey:@"foodEnergy"];
        _fitSlim = [decoder decodeInt32ForKey:@"fitSlim"];
        _foodLogo = [decoder decodeObjectForKey:@"foodLogo"];
        _foodNutri = [decoder decodeObjectForKey:@"foodNutri"];
        _foodUnit = [decoder decodeObjectForKey:@"foodUnit"];
        
    }
    return self;
}

@end
