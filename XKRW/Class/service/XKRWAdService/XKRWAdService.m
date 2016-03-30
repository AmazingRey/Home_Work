//
//  XKRWAdService.m
//  XKRW
//
//  Created by y on 14-11-13.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWAdService.h"
#import "XKRWUserDefaultService.h"
#import "XKRWAdEntity.h"
#import "XKRWShareAdverEntity.h"
#import "XKRWUtil.h"

@interface XKRWAdService ()

@property (nonatomic, strong) NSMutableDictionary *ads;

@property (nonatomic, assign) BOOL isDownloading;

@end

static XKRWAdService *shareInstance = nil;

@implementation XKRWAdService

//单例
+ (instancetype)sharedService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWAdService alloc] init];
    });
    return shareInstance;
}

+ (NSString *)getPositionCodeOfAdPosition:(XKRWAdPostion)position {
    NSString *code = nil;
    
    switch (position) {
        case XKRWAdPostionMainPage:
            code = @"index";
            break;
            
        default:
            break;
    }
    return code;
}

+ (XKRWAdPostion)getPositionWithCode:(NSString *)code {
    
    XKRWAdPostion position = 0;
    if ([code isEqualToString:@"index"]) {
        position = XKRWAdPostionMainPage;
    }
    return position;
}

// 瘦身分享广告
- (NSMutableArray *)downloadFitnessAdverFromServerWithPosition:(NSString *)position More:(NSNumber *)more
{
    NSURL *adverUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,KManagementAdInfo]];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:position,@"position",more,@"more", nil];
    NSDictionary *getAdverDic = [self syncBatchDataWith:adverUrl andPostForm:param];
    
    NSMutableArray *dataMutArray = [NSMutableArray array];
    XKLog(@"广告 %@",getAdverDic[@"data"]);
    
    for (NSDictionary *temp in getAdverDic[@"data"]) {
        XKRWShareAdverEntity *entity = [[XKRWShareAdverEntity alloc] init];
        entity.title = temp[@"title"];
        entity.imgSrc = temp[@"imgsrc"];
        entity.imgUrl = temp[@"imgurl"];
        entity.startTime = temp[@"startTime"];
        entity.endTime = temp[@"endTime"];
        entity.adId = temp[@"id"];
        [dataMutArray addObject:entity];
    }
    return dataMutArray;
}

- (void)downloadAdvertisementWithPosition:(XKRWAdPostion)position {
    
    self.isDownloading = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kNewServer, KManagementAdInfo];
    
    NSDictionary *rst = [self syncBatchDataWith:[NSURL URLWithString:urlString]
                                    andPostForm:@{@"position": [[self class] getPositionCodeOfAdPosition:position],
                                                  @"more": @1}
                                   withLongTime:NO];
    
    for (NSDictionary *params in rst[@"data"]) {
        
        XKRWAdEntity *entity = [[XKRWAdEntity alloc] init];
        entity.aid = [params[@"id"] intValue];
        entity.position_code = [[self class] getPositionCodeOfAdPosition:position];
        entity.position = position;
        
        entity.title = params[@"title"];
        entity.imgsrc = params[@"imgsrc"];
        entity.imgurl = params[@"imgurl"];
        entity.sort = [params[@"sort"] intValue];
        
        NSMutableArray *temp = self.ads[entity.position_code];
        if (!temp) {
            temp = [NSMutableArray array];
        }
        [temp addObject:entity];
        [self.ads setObject:temp forKey:entity.position_code];
    }
    self.isDownloading = NO;
}

- (BOOL)shouldShowAdAtPosition:(XKRWAdPostion)position {
    
    NSString *key = [NSString stringWithFormat:@"last_close_ad_date_%@", [[self class] getPositionCodeOfAdPosition:position]];
    
    NSDate *lastClose = [NSDate dateFromString:[[self userAdDefaults] stringForKey:key] withFormat:@"yyyy-MM-dd"];
    
    if ([lastClose isDayEqualToDate:[NSDate date]] ||
        ![XKRWUtil isNetWorkAvailable]) {
        return NO;
    }
    return YES;
}

- (void)closeAdAtPosition:(XKRWAdPostion)position {
    
    NSString *key = [NSString stringWithFormat:@"last_close_ad_date_%@", [[self class] getPositionCodeOfAdPosition:position]];
    [[self userAdDefaults] setObject:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:key];
    [self.userAdDefaults synchronize];
}

- (NSArray *)getAdsWithPosition:(XKRWAdPostion)position {
    
    return self.ads[[[self class] getPositionCodeOfAdPosition:position]];
}

- (NSMutableDictionary *)ads {
    if (!_ads) {
        _ads = [[NSMutableDictionary alloc] init];
    }
    return _ads;
}

- (NSUserDefaults *)userAdDefaults {
    
    int uid = (int)[XKRWUserDefaultService getCurrentUserId];
    return [[NSUserDefaults alloc] initWithSuiteName:[NSString stringWithFormat:@"%d_AD_default", uid]];
}

@end

