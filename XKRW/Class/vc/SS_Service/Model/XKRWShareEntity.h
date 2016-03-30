//
//  XKRWShareEntity.h
//  XKRW
//
//  Created by zhanaofan on 13-12-18.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _eShareType{
    //自定义的分享
    shareTypeOfCustom = 0,
    //指定的应用知识内容分享
    shareTypeSpecialKnowledge,
    //励志分享
    shareTypeSpecialEncourage,
    //运动推荐
    shareTypeSpecialSportsRecom,
    //名人瘦身
    shareTypeSpecialSotables,
    //大家来PK
    shareTypeSpecialPK
}eShareType;

@interface XKRWShareEntity : NSObject

//发分享的人UID
@property (nonatomic,assign) NSUInteger     uid;
//用户昵称
@property (nonatomic,strong) NSString       *nickName;
//用户头像
@property (nonatomic,strong) NSString       *avator;
//性别
@property (nonatomic,assign) NSInteger      gender;
//当前一共坚持的天数
@property (nonatomic,assign) NSUInteger     totalDays;
//减肥的公斤数
@property (nonatomic,assign) float          reduceWeights;
//分享内容
@property (nonatomic,strong) NSString       *content;
//分享图片
@property (nonatomic,strong) NSMutableArray *images;
//分享时间
@property (nonatomic,assign) NSUInteger     shareTime;
//被赞的次数
@property (nonatomic,assign) NSUInteger     favNum;
//分享的类型
@property (nonatomic,assign) eShareType      shareType;
//评论次数
@property (nonatomic,assign) NSUInteger     commentNum;

@end
