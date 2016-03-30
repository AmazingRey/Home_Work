//
//  XKRWIslimSportModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWStatusModel.h"
#import "XKRWsportRegulateModel.h"
#import "XKRWSportResultModel.h"
#import "XKRWsportAdviseModel.h"
#import "XKRWSportIntroductionModel.h"

@interface XKRWIslimSportModel : NSObject

@property (nonatomic,strong) NSString *comment;

@property (nonatomic,strong) XKRWStatusModel *model;
@property (nonatomic,assign) NSInteger total;
@property (nonatomic,strong) NSString *sportLevel;
@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,strong) XKRWsportRegulateModel *regulateModel;
@property (nonatomic,strong) XKRWsportAdviseModel *adviseModel;
@property (nonatomic,strong) XKRWSportResultModel *resultModel;
@property (nonatomic,strong) NSArray *introductionArray;
@end
