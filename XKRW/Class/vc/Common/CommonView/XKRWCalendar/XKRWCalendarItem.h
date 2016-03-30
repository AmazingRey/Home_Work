//
//  XKRWCalendarItem.h
//  XKRW
//
//  Created by XiKang on 14-11-11.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ITEM_HEIGHT 30.f
#define ITEM_WIDTH ([UIScreen mainScreen].bounds.size.width - 30.f) / 7.f

@interface XKRWCalendarItem : UIButton

@property BOOL outOfMonth;
@property BOOL isRecord;

- (id)initWithOrigin:(CGPoint)origin
           withTitle:(NSString *)title
              record:(BOOL)yesOrNo
          isSelected:(BOOL)isSelected
          outOfMonth:(BOOL)outOfMonth
             isToday:(BOOL)isToday
        onClickBlock:(void (^)(XKRWCalendarItem *item))block;

- (id)initWithOrigin:(CGPoint)origin
           withTitle:(NSString *)title
              record:(BOOL)yesOrNo
          isSelected:(BOOL)isSelected
          outOfMonth:(BOOL)outOfMonth
             isToday:(BOOL)isToday;

- (void)setDay:(NSString *)day outOfMonth:(BOOL)yesOrNO isToday:(BOOL)isToday isRecord:(BOOL)isRecord;
- (void)setHidden:(BOOL)hidden withAnimation:(BOOL)yesOrNo;

@end
