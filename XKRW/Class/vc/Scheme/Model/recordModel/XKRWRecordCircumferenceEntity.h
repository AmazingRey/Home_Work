//
//  XKRWRecordCircumferenceEntity.h
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWRecordCircumferenceEntity : NSObject
/**
 *  记录用户的id
 */
@property (nonatomic) float uid;
/**
 *  腰围
 */
@property (nonatomic) float waistline;
/**
 *  胸围
 */
@property (nonatomic) float bust;
/**
 *  臀围
 */
@property (nonatomic) float hipline;
/**
 *  臂围
 */
@property (nonatomic) float arm;
/**
 *  大腿围
 */
@property (nonatomic) float thigh;
/**
 *  小腿围
 */
@property (nonatomic) float shank;
/**
 *  记录时间
 */
@property (nonatomic, strong) NSDate *date;

@end
