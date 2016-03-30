//
//  PLSCScrollButtonView.h
//  PeiLinRopeSkipping
//
//  Created by Seth Chen on 16/1/9.
//  Copyright © 2016年 Lunarsam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PLSCScrollButtonView : UIView

/**
 *  .........Init selector.............................
 *
 *  @param frame       size
 *  @param norColor    normal's  Color
 *  @param selectColor select's  Color
 *  @param gap         gap width
 *  @param abool       default is no,if is yes ,will show a select's color line in the bottom..
 *  @param handler     handle method..
 */
- (instancetype)initWithFrame:(CGRect)frame
                     norColor:(UIColor *)norColor
                  selectColor:(UIColor *)selectColor
                      withGap:(CGFloat)gap
             isShowBottomline:(BOOL)abool
                      handler:(void(^)(NSInteger, UIButton*, UILabel*, PLSCScrollButtonView *, SEL ))handler;
/*!
 *   Set  the titles
 */
- (void)setTitles:(NSArray *)titles;

/*!
 *   External change button and line status  . For example  uiscroller  scroll change the  status.
 */
- (void)changeStates:(NSInteger)sender;

/*!
 *   Set  the Notices    tip:刷新notice 调此方法  设置为零不显示
 */
- (void)setNotices:(NSArray<NSString *> *)notices;

- (void)dismiss:(NSInteger )num;
@end
