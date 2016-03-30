//
//  SCCache.h
//  XKRW
//
//  Created by Seth Chen on 15/12/31.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCache : NSObject

/**<The name of the cache.*/
@property (nonatomic, copy) NSString *name;
/**<The data of the cache.*/
@property (nonatomic, strong) NSData *data;
/**<The date of the cache.*/
@property (nonatomic, copy) NSString *date;

@end
