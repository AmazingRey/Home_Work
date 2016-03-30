//
//  XKRWFoodTopView.h
//  XKRW
//
//  Created by zhanaofan on 14-2-7.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWFoodEntity.h"

@interface XKRWFoodTopView : UIView
//食物头像
//@property (nonatomic, strong) UIImageView    *logoIV;
//分享按钮
@property (nonatomic, strong) UIButton       *btnShared;
//食物对象
@property (nonatomic, strong) XKRWFoodEntity *foodEntity;

@property (nonatomic ,assign) BOOL  linePosition; //设置line的位置
//YES 为详情  NO 为记录
@property (nonatomic) BOOL isDetail;

- (void) setFoodEntity:(XKRWFoodEntity *)foodEntity;
-(XKRWFoodEntity *)getFoodEntity;

- (id)initWithFrameAndFoodEntity:(CGRect)frame foodEntity:(XKRWFoodEntity*)entity linePosition:(BOOL)linePosition isDetail:(BOOL)isDetail;

//-(void) setTitle:(NSString *) title;

@property (nonatomic,strong) UIButton  *collectBtn;

@end
