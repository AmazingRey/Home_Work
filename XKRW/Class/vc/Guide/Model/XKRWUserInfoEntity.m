//
//  XKRWPersonEntity.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-12.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWUserInfoEntity.h"

@implementation XKRWUserInfoEntity

- (id)init
{
    self = [super init];
    if (self) {
        self.crowd = eGroupUnsel;
        self.sex = eSexFemale;
        self.waistline = 0;
        self.hipline = 0;
        self.birthDay = 567964800;
        self.disease = nil;
        self.labor = eLight;
        self.height = 0;
        self.avatar = nil;
        self.nickName = nil;
        self.slimID = 0;
        self.userid = 0;
        self.reducePosition =eArm;
        self.reducePart = eWhole;
        self.reduceDiffculty = eEasy;
    }
    return self;
}

-(void)setData:(int32_t)date{

}

-(int32_t)getDate{
    return [[NSDate date] timeIntervalSince1970];
}
-(NSString *)description {
    return [NSString stringWithFormat:@"\n nick name:%@\n birthday:%li\n sex:%i\n stature:%li \n currentHeight:%0.1f",_nickName,(long)_birthDay,_sex,(long)_height,_weight/1000.f];
}

@end
