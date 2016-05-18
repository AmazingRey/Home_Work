//
//  XKRWStatisAnalysisView.h
//  XKRW
//
//  Created by ss on 16/5/3.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWStatiscHeadView.h"
#import "XKRWStatisticDetailView.h"

@interface XKRWStatisAnalysisView : UIView

@property (strong, nonatomic) XKRWStatiscHeadView *headView;
@property (strong, nonatomic) XKRWStatisticDetailView *eatDecreaseView;
@property (strong, nonatomic) XKRWStatisticDetailView *sportDecreaseView;
@property (strong, nonatomic) XKRWStatiscBussiness5_3 *bussiness;
@property (assign, nonatomic) BOOL isShowStatis;
- (instancetype)initWithFrame:(CGRect)frame withBussiness:(XKRWStatiscBussiness5_3 *)bussiness;
@end