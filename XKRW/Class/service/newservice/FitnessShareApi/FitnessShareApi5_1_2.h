//
//  FitnessShareApi5_1_2.h
//  XKRW
//
//  Created by Seth Chen on 15/12/11.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "ServiceBase5_1_2.h"

@interface FitnessShareApi5_1_2 : ServiceBase5_1_2

/**
 *  FitnessRecommend
 *
 *  @param page page
 */
- (void )getFitnessRecommendFromServerWithPage:(NSNumber *)page;

@end
