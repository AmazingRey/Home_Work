//
//  XKPassthroughScrollView.h
//  calorie
//
//  Created by Rick Liao on 13-2-20.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKPassthroughScrollView : UIScrollView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;

@end
