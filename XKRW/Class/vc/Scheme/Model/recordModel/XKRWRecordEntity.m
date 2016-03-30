//
//  XKRWRecordEntity.m
//  XKRW
//
//  Created by zhanaofan on 14-3-5.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWRecordEntity.h"
#import "NSDate+Helper.h"
#import "XKRWBaseService.h"
#import "XKRWAlgolHelper.h"
#import "XKRWWeightService.h"
#import "XKRWUserService.h"
@implementation XKRWRecordEntity

- (id) init
{
    if (self = [super init]) {
        self.calorie = 0;
        self.weight = 0;
        self.interval = 0;
        self.recordId = 0;
        self.day = [NSDate stringFromDate:[NSDate date] withFormat:[NSDate dateFormatString]];
        self.uid = [XKRWUserDefaultService getCurrentUserId];
        self.unit = eUnitGram;
    }
    return self;
}
-(NSString *) getUnitDescription{
    NSString *_str_unit = nil;
    switch (_unit) {
        case eUnitGram :
        {
            _str_unit = @"克";
        }
            break;
        case eUnitKilojoules :
        {
            _str_unit = @"千焦";
        }
            break;
        case eUnitKiloCalories :
        {
            _str_unit = @"kcal";
        }
            break;
        case eUnitBox :
        {
            _str_unit = @"盒";
        }
            break;
        case eUnitBlock :
        {
            _str_unit = @"块";
        }
            break;
        case eUnitMilliliter :
        {
            _str_unit = @"毫升";
        }
            break;
        case eUnitMinutes:{
            _str_unit = @"分钟";
        }
        default:
            break;
    }
    return _str_unit;
}
@end

@implementation XKRWForecastEntity

- (id) init
{
    if (self = [super init]) {
            NSInteger curWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]] * 1000;
            NSInteger targetWeight = [[XKRWUserService sharedService] getUserDestiWeight];
        self.uid = [XKRWUserDefaultService getCurrentUserId];
        self.day = [NSDate stringFromDate:[NSDate date] withFormat:[NSDate dateFormatString]];
        self.diet_suggest = [XKRWAlgolHelper dailyIntakeRecomEnergy];//当日推荐值
        self.sport_suggest = [XKRWAlgolHelper dailyConsumeSportEnergy];//当日运动推荐值
        self.diet_control = [XKRWAlgolHelper limitOfEnergywithCurWeight:curWeight andTargetWeight:targetWeight];  //当天的饮食控制值
        self.r_id = 0;
        self.diet_record = 0;
        self.sport_record = 0;
        self.forecast = 0;
        self.local_id = 0;
    }
    return self;
}


@end
