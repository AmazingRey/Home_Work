//
//  XKRWSportResultModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWSportResultModel : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *heart_lung;
@property (nonatomic,strong) NSString *power;
@property (nonatomic,strong) NSString *fp;

@property (nonatomic, strong) NSString *stDes;
@property (nonatomic, strong) NSString *hlDes;
@property (nonatomic, strong) NSString *pDes;
@property (nonatomic, strong) NSString *fpDes;

@property (nonatomic, assign) int fpFlag;
@property (nonatomic, assign) int hlFlag;
@property (nonatomic, assign) int pFlag;
@property (nonatomic, assign) int stFlag;

/**
 *  生成标题所用字符串数组，顺序：力量、运动量、心肺、脂肪
 *
 *  @return 标题字符串数组
 */
- (NSArray *)getDescriptionInTitle;

@end
