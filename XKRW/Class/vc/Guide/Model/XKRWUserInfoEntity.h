//
//  XKRWPersonEntity.h
//  XKRW
//
//  Created by Jiang Rui on 13-12-12.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWUserInfoEntity : NSObject

@property (strong,nonatomic) NSString *token;
@property (nonatomic) NSInteger slimID;
@property (strong,nonatomic) NSString *accountName;
@property (strong,nonatomic) NSString *nickName;

@property (nonatomic) BOOL userNickNameEnable;

@property (nonatomic, copy) NSString * address;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic) NSInteger starNum;
@property (nonatomic) NSInteger age;
@property (nonatomic) NSInteger birthDay;
@property (nonatomic) NSInteger weight;
@property (nonatomic) NSInteger height;
@property (nonatomic) XKSex sex;
@property (nonatomic) XKGroup crowd;
@property (nonatomic) NSInteger hipline;
@property (nonatomic) NSInteger waistline;
@property (nonatomic) NSInteger userid;
@property (nonatomic) NSString * userBackgroundImageUrl; // 背景图
//用户疾病史
@property (nonatomic,strong) NSMutableArray *disease;
//用户瘦身部位
@property (nonatomic,strong) NSString *slimParts;
//瘦身部位字符串
@property (nonatomic,strong) NSString *slimPartsString;

@property (nonatomic) XKPhysicalLabor labor;
@property (nonatomic,strong) NSString * manifesto;
//注册日期
@property (nonatomic) NSInteger date;

//用户计划
@property (nonatomic) NSInteger origWeight;
@property (nonatomic) NSInteger destWeight;

@property (nonatomic) XKReducePart reducePart;
@property (nonatomic) XKReducePosition reducePosition;

@property (nonatomic) XKDifficulty reduceDiffculty;
@property (nonatomic) NSInteger duration;

//体重曲线四个值
@property (nonatomic, strong) NSDictionary *weightCurveDic;



@property (nonatomic) BOOL isAddGroup; ///<  是否加入过小组
@end
