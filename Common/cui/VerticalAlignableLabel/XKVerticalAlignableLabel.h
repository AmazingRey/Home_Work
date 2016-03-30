//
//  XKVerticalAlignableLabel.h
//  calorie
//
//  Created by Rick Liao on 12-12-25.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum XKTextVerticalAlignment {
    XKTextVerticalAlignmentTop = 0,
    XKVerticalAlignmentCenter,
    XKTextVerticalAlignmentBottom,
} XKTextVerticalAlignment;

@interface XKVerticalAlignableLabel : UILabel

@property (nonatomic, assign) XKTextVerticalAlignment textVerticalAlignment UI_APPEARANCE_SELECTOR;

@end
