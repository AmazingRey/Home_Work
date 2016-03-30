//
//  XKViewRecyclePool.h
//  calorie
//
//  Created by Rick Liao on 12-12-11.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

// 本代码修改自Nimbus的NIViewRecycler.h
// Copyright 2011 Jeff Verkoeyen
// http://nimbuskit.info

#import <UIKit/UIKit.h>

/**
 * The protocol for a recyclable view.
 */
@protocol XKViewReusable <NSObject>

@optional
@property (nonatomic, readwrite, copy) NSString* reuseIdentifier;

/**
 * Called immediately after the view has been dequeued from the recycled view pool.
 */
- (void)prepareForReuse;

@end


/**
 * An object for efficiently reusing views by recycling and dequeuing them from a pool of views.
 *
 * This sort of object is what UITableView and NIPagingScrollView use to recycle their views.
 */
@interface XKViewRecyclePool : NSObject
- (UIView<XKViewReusable> *)dequeueReusableViewWithIdentifier:(NSString *)reuseIdentifier;
- (void)recycleView:(UIView<XKViewReusable> *)view;
- (void)removeAllViews;
@end


/**
 * A simple view implementation of the XKRecyclableView protocol.
 *
 * This view class can easily be used with a XKViewRecycler.
 */
@interface XKReusableView : UIView <XKViewReusable>

// Designated initializer.
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readwrite, copy) NSString* reuseIdentifier;

@end
