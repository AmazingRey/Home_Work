//
//  XKRWShareAdverEntity.h
//  XKRW
//
//  Created by Shoushou on 15/10/25.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWShareAdverEntity : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) NSString *imgSrc;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) NSString *adId;
@property (nonatomic, strong) NSString *nid;
@property (nonatomic, strong) NSString *commerce_type;
@property (nonatomic, strong) NSString *type;
@end
