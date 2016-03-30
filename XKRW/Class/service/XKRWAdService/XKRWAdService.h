//
//  XKRWAdService.h
//  XKRW
//
//  Created by y on 14-11-13.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWUserService.h"

@class XKRWAdEntity;

typedef NS_ENUM(int, XKRWAdPostion) {
    XKRWAdPostionMainPage = 1,
};

@interface XKRWAdService : XKRWBaseService

//单例
+ (instancetype)sharedService;

+ (NSString *)getPositionCodeOfAdPosition:(XKRWAdPostion)position;
/// 下载指定位置的广告
- (void)downloadAdvertisementWithPosition:(XKRWAdPostion)position;
/// 判断position位置广告是否显示
- (BOOL)shouldShowAdAtPosition:(XKRWAdPostion)position;
/// 关闭position位置的广告
- (void)closeAdAtPosition:(XKRWAdPostion)position;
/// 根据位置获取广告实体对象数组
- (NSArray *)getAdsWithPosition:(XKRWAdPostion)position;

- (NSUserDefaults *)userAdDefaults;

// 获取瘦身广告
- (NSMutableArray *)downloadFitnessAdverFromServerWithPosition:(NSString *)position More:(NSNumber *)more;
@end
