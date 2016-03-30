//
//  KMPopoverView.h
//  XKRW
//
//  Created by XiKang on 15-4-3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMPopoverCell.h"
/**
 *  方向枚举
 */
typedef NS_ENUM(int, KMDirection) {
    /**
     *  上
     */
    KMDirectionUp = 1,
    /**
     *  右
     */
    KMDirectionRight,
    /**
     *  下
     */
    KMDirectionDown,
    /**
     *  左
     */
    KMDirectionLeft
};

@class KMPopoverView;

@protocol KMPopoverViewDelegate <NSObject>

- (void)KMPopoverView:(KMPopoverView *)KMPopoverView clickButtonAtIndex:(NSInteger)index;

@end
/**
 *  Popover view
 */
@interface KMPopoverView : UIView

@property (nonatomic, strong) id <KMPopoverViewDelegate> delegate;
/**
 *  Initial function
 *
 *  @param frame     Origin of view, the width of view is fixed(screen width)
 *  @param direction The direction of arrow
 *  @param ratio     The position ratio of arrow
 *  @param type      See KMPopoverCellType
 *  @param titles    Array of titles
 *  @param images    Array of images
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
               arrowDirection:(KMDirection)direction
                positionratio:(CGFloat)ratio
                 withCellType:(KMPopoverCellType)type
                    andTitles:(NSArray *)titles
                       images:(NSArray *)images;
/**
 *  Set background color of view
 *
 *  @param backgroundColor backgroundColor
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor;
/**
 *  Set separate line's color
 *
 *  @param color SeparatorColor
 */
- (void)setSeparatorColor:(UIColor *)color;
/**
 *  Show in window
 */
- (void)addToWindow;
/**
 *  Show in window just under the right item in navigation bar
 *
 *  @param vc The view controller in the navigation controller
 */
- (void)addUnderOfNavigationBarRightItem:(UIViewController *)vc;

@end
