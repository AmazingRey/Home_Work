//
//  XKRWADView.h
//  XKRW
//
//  Created by Klein Mioke on 15/8/28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWAdService.h"

typedef NS_ENUM(int, XKRWADViewType) {
    XKRWADViewTypeBanner = 1
};

@interface XKRWADView : UIView

@property (nonatomic, readonly) XKRWADViewType type;

- (id)initWithType:(XKRWADViewType)type adEntities:(NSArray *)entities;

- (void)setClickAction:(void (^)(int index, XKRWAdEntity *entity))action closeAction:(void (^)())closeAction;

@end
