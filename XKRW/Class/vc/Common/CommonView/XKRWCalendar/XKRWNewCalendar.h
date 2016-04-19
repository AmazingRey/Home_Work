//
//  XKRWNewCalendar.h
//  XKRW
//
//  Created by 忘、 on 16/4/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWNewCalendar : UIView

- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                andResizeBlock:(void (^)(void))block;

@end
