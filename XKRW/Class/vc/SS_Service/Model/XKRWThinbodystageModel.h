//
//  XKRWThinbodystageModel.h
//  XKRW
//
//  Created by y on 15-3-5.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWThinbodystageModel : NSObject


@property(nonatomic,strong)NSString  *stages;

@property(nonatomic,strong)NSString  *stagesDescribe; //阶段秒速

@property(nonatomic,strong)NSString  *weightGogal;   //目标体重

@property(nonatomic,strong)NSString  *firstStageWeight;

@property(nonatomic,strong)NSString  *secondStageWeight;

@property(nonatomic,strong)NSString  *thirdSatgeWeight;

@property(nonatomic,strong)NSString  *kcal;   //平均每日热量摄入

@property(nonatomic,strong)NSString  *powerSport;   //力量运动

@property(nonatomic,strong)NSString  *aerobicSport;  //有氧运动


@property(nonatomic,strong)UIImage   *image;


@end
