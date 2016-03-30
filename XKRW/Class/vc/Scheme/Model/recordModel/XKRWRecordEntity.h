//
//  XKRWRecordEntity.h
//  XKRW
//
//  Created by zhanaofan on 14-3-5.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWRecordEntity : NSObject

@property (nonatomic, assign) NSInteger rid;
//用户UID
@property (nonatomic,assign ) NSInteger uid;
//食物id
@property (nonatomic,assign ) NSInteger foodId;
//食物名
@property (nonatomic,strong ) NSString *foodName;
//记录类型
@property (nonatomic,assign ) MealType recordType;
//记录日期
@property (nonatomic,strong ) NSString *day;
//服务器返回的id
@property (nonatomic,assign ) NSInteger recordId;
//总共的大卡
@property (nonatomic,assign ) NSInteger calorie;
@property (nonatomic,assign ) NSInteger weight;
@property (nonatomic,assign ) NSInteger interval;
@property (nonatomic,assign ) MetricUnit unit;
-(NSString *) getUnitDescription;
@end

/*方案预测*/
@interface XKRWForecastEntity : NSObject
@property (nonatomic,assign) NSInteger   uid;    //用户uid
@property (nonatomic,copy) NSString *day;     //日期
@property (nonatomic,assign) NSInteger diet_record; //饮食记录值
@property (nonatomic,assign) NSInteger diet_suggest;//饮食推荐值
@property (nonatomic,assign) NSInteger diet_control;//饮食控制值
@property (nonatomic,assign) NSInteger sport_suggest;//运动建议值
@property (nonatomic,assign) NSInteger sport_record; //运动记录值
@property (nonatomic,assign) NSInteger r_id; //远程返回记录值
@property (nonatomic,assign ) NSInteger local_id;//本地id
@property (nonatomic,assign) NSInteger  forecast;//预测值

@end