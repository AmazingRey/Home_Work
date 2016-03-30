//
//  SCBackToUpView.h
//  XKRW
//
//  Created by Seth Chen on 15/12/10.
//  Copyright © 2015年 xikang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCBackToUpView : UIView

@property (nonatomic, strong) UIButton *backToupButton;         /**<the minitor button*/
@property (nonatomic, assign) UIScrollView *minitorScrollView;  /**<the minitor*/
@property (nonatomic, assign) CGFloat backOffsettY;             /**<the float to minitor*/

/**
 *  @athour Seth
 *
 *  @param rect        加载的范围
 *  @param minitor     监控对象
 *  @param optionImage 图片
 *
 *  @return self
 */
- (instancetype)initShowInSomeViewSize:(CGSize)rect
                               minitor:(UIScrollView *)minitor
                             withImage:(NSString *)optionImage;


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
