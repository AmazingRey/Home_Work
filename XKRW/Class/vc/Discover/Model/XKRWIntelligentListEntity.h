//
//  XKRWIntelligentListEntity.h
//  XKRW
//
//  Created by Shoushou on 16/1/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWIntelligentListEntity : NSObject

@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *levelUrl;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSInteger beLikedNum;

@end
