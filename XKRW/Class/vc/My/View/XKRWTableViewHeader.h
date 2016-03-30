
//
//  XKRWTableViewHeader.h
//  XKRW
//
//  Created by 忘、 on 15/7/4.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWTableViewHeader : NSObject <UIScrollViewDelegate>

#pragma mark - 类方法 
/**
 *  生成一个XKRWTableViewHeader实例
 *
 *  @param scrollView
 *  @param expandView 可以伸展的背景View
 *
 *  @return CExpandHeader 对象
 */
+ (id)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView;


#pragma mark - 成员方法
/**
 *
 *
 *  @param scrollView
 *  @param expandView
 */
- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView;

/**
 *  监听scrollViewDidScroll方法
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

@end


