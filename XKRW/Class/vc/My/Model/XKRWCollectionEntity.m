//
//  XKRWCollectionEntity.m
//  XKRW
//
//  Created by Jack on 15/5/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWCollectionEntity.h"

@implementation XKRWCollectionEntity
- (instancetype)init
{
    if (self = [super init]) {
        self.uid = [XKRWUserDefaultService getCurrentUserId];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
//        self.cid        = [dict[@"cid"] integerValue];
        self.uid          = [dict[@"uid"] integerValue];
        self.collectType  = [dict[@"collect_type"] integerValue];
        self.originalId   = [dict[@"original_id"] integerValue];
        self.collectName  = dict[@"collect_name"];
        self.imageUrl     = dict[@"image_url"];
        self.contentUrl   = dict[@"content_url"];
        self.categoryType = [dict[@"category_type"] integerValue];
        self.date         = [NSDate dateWithTimeIntervalSince1970:[dict[@"date"] integerValue]];
//        [NSDate dateFromString:dict[@"date"] withFormat:@"yyyy-MM-dd"];
//        self.sync       = [dict[@"sync"] integerValue];
        self.foodEnergy   = [dict[@"food_energy"] integerValue];
        //还少一些字段的
    }
    return self;
}

- (NSDictionary *)dictionaryInCollectionTable
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
//    [dic setObject:[NSNumber numberWithInteger:self.cid] forKey:@"cid"];
    if (!self.collectName) {
        self.collectName = @"";
    }
    [dic setObject:self.collectName forKey:@"collect_name"];
    [dic setObject:[NSNumber numberWithInteger:self.uid] forKey:@"uid"];
    [dic setObject:[NSNumber numberWithInteger:self.originalId] forKey:@"original_id"];
    [dic setObject:[NSNumber numberWithInteger:self.collectType] forKey:@"collect_type"];
    [dic setObject:[NSNumber numberWithInteger:self.categoryType] forKey:@"category_type"];

    //时间不能为空 加个时间判断
    if(!self.date)
    {
        self.date = [NSDate date];
    }

    /*!
     *   解决重复点击崩溃的bug....15/11/20.
     */
    @try {
        if ([self.date respondsToSelector:@selector(timeIntervalSince1970)]) {
            NSTimeInterval timeInterval = [self.date timeIntervalSince1970];
            [dic setObject:@(timeInterval) forKey:@"date"];
        }
    }
    @catch (NSException *exception) {
           [dic setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"date"];
    }
   

    if (!self.imageUrl) {
        self.imageUrl = @"";
    }
    [dic setObject:self.imageUrl forKey:@"image_url"];
    if (!self.contentUrl) {
        self.contentUrl = @"";
    }
    [dic setObject:self.contentUrl forKey:@"content_url"];
    [dic setObject:[NSNumber numberWithInteger:self.foodEnergy] forKey:@"food_energy"];
//    [dic setObject:[NSNumber numberWithInteger:self.sync] forKey:@"sync"];
    
    return dic;
}



@end
