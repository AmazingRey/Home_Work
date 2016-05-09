//
//  XKRWStatiscHeadView.h
//  XKRW
//
//  Created by ss on 16/4/29.
//  Copyright © 2016年 XiKang. All rights reserved.
//

@protocol XKRWStatisticAnalysisPickerViewDelegate <NSObject>
@optional
-(void)makeAnalysisPickerViewAppear:(NSInteger)index withDicData:(NSDictionary *)dic;
@end

#import <UIKit/UIKit.h>
#import "XKRWStatiscBussiness5_3.h"

@interface XKRWStatiscHeadView : UIView <UIAlertViewDelegate>

@property (assign, nonatomic) id <XKRWStatisticAnalysisPickerViewDelegate> delegate;
@property (strong, nonatomic) UILabel *lab1;
@property (strong, nonatomic) UILabel *lab2;

@property (strong, nonatomic) UILabel *lab3;
@property (strong, nonatomic) UILabel *subLab3;

@property (strong, nonatomic) UILabel *lab4;
@property (strong, nonatomic) UILabel *subLab4;

@property (strong, nonatomic) UILabel *lab5;
@property (strong, nonatomic) UILabel *subLab5;

@property (strong, nonatomic) UILabel *lab6;
@property (strong, nonatomic) UILabel *subLab6;

@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;
@property (strong, nonatomic) UIView *view3;
@property (strong, nonatomic) UIView *view4;

@property (strong, nonatomic) UIButton *btnDown;
@property (strong, nonatomic) UIButton *btnQuestion;
@property (assign, nonatomic) StatisticType statisType;

/**
 *  所选择的周数 （第1周、第2周。。。）
 */
@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) XKRWStatiscBussiness5_3 *bussiness;
@property (strong, nonatomic) NSMutableDictionary *pickerDic;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) XKRWStatiscEntity5_3 *statiscEntity;
@property (strong, nonatomic) XKRWStatiscEntity5_3 *currentEntity;
- (instancetype)initWithFrame:(CGRect)frame type:(StatisticType)type withBussiness:(XKRWStatiscBussiness5_3 *)bussiness;
-(void)refreshControls;
@end
