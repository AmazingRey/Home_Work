//
//  XKRWSportEntity.m
//  XKRW
//
//  Created by zhanaofan on 14-3-3.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSportEntity.h"

@implementation XKRWSportEntity 


- (id) init
{
    self = [super init];
    if (self) {
        self.sportPic = @"";
        self.sportMets = 0.f;
        self.sportTime = 0;
        self.sportUnit = eSportUnitTime;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt32:_sportId forKey:@"sportId"];
    [encoder encodeObject:_sportName forKey:@"sportName"];
    [encoder encodeInt32:_sportUnit forKey:@"sportUnit"];
    [encoder encodeFloat:_sportMets forKey:@"sportMets"];
    [encoder encodeInt32:_cateId forKey:@"cateId"];
    [encoder encodeObject:_sportPic forKey:@"sportPic"];
    [encoder encodeObject:_vedioPic forKey:@"vedioPic"];
    [encoder encodeInt32:_sportTime forKey:@"sportTime"];
    [encoder encodeObject:_sportIntensity forKey:@"sportIntensity"];
    [encoder encodeObject:_sportVedio forKey:@"sportVedio"];
    [encoder encodeObject:_sportEffect forKey:@"sportEffect"];
    [encoder encodeObject:_sportCareTitle forKey:@"sportCareTitle"];
    [encoder encodeObject:_sportCareDesc forKey:@"sportCareDesc"];
    [encoder encodeObject:_sportActionPic forKey:@"sportActionPic"];
    [encoder encodeObject:_sportActionDesc forKey:@"sportActionDesc"];
    
    [encoder encodeObject:_iFrame forKey:@"iframe"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [self init]) {
        _sportId = [decoder decodeInt32ForKey:@"sportId"];
        _sportName  = [decoder decodeObjectForKey:@"sportName"];
        _sportMets  =   [decoder decodeFloatForKey:@"sportMets"];
        _sportUnit  =   [decoder decodeInt32ForKey:@"sportUnit"];
        _cateId     =   [decoder decodeInt32ForKey:@"cateId"];
        _sportTime  =   [decoder decodeInt32ForKey:@"sportTime"];
        _sportPic   =   [decoder decodeObjectForKey:@"sportPic"];
        _vedioPic   =   [decoder decodeObjectForKey:@"vedioPic"];
        _sportIntensity = [decoder decodeObjectForKey:@"sportIntensity"];
        _sportVedio = [decoder decodeObjectForKey:@"sportVedio"];
        _sportEffect = [decoder decodeObjectForKey:@"sportEffect"];
        _sportCareTitle = [decoder decodeObjectForKey:@"sportCareTitle"];
        _sportCareDesc = [decoder decodeObjectForKey:@"sportCareDesc"];
        _sportActionDesc = [decoder decodeObjectForKey:@"sportActionDesc"];
        _sportActionPic = [decoder decodeObjectForKey:@"sportActionPic"];
        
        _iFrame = [decoder decodeObjectForKey:@"iframe"];
    }
    return self;
}

- (uint32_t) consumeCaloriWithMinuts:(uint32_t)minute weight:(float)weight
{
    uint32_t calories = 0;
    calories = (uint32_t)(self.sportMets*minute*3.5/200*weight);
    return calories;
}
- (uint32_t) timesOfSport:(uint32_t)cal weight:(float)weight
{
    uint32_t times = 0;
    if (self.sportUnit == eSportUnitTime) {
        times = (uint32_t)cal*200/(self.sportMets*3.5*weight);
    }else{
        times = (uint32_t) cal*200*60/(self.sportMets*3.5*weight*1);
    }
    return times;
}
@end
