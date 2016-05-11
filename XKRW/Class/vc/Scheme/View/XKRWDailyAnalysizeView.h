//
//  XKRWDailyAnalysizeView.h
//  XKRW
//
//  Created by ss on 16/4/28.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWDailyAnalysizeCell.h"


@interface XKRWDailyAnalysizeView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UILabel *labTitle;
@property (strong, nonatomic) UILabel *labCal;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView *imgView;
@property (assign, nonatomic) AnalysizeType type;
@property (strong, nonatomic) NSMutableDictionary *dicData;
@property (strong, nonatomic) NSArray *arrSport;
//每日正常饮食摄入
@property (assign, nonatomic) CGFloat dailyNormal;
//饮食消耗
@property (assign, nonatomic) CGFloat dailyFoodDecrease;
//运动消耗
@property (assign, nonatomic) CGFloat dailySportDecrease;

- (instancetype)initWithFrame:(CGRect)frame type:(AnalysizeType)type;
@end