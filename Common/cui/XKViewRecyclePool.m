//
//  XKViewRecyclePool.m
//  calorie
//
//  Created by Rick Liao on 12-12-11.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

// 本代码修改自Nimbus的NIViewRecycler.m
// Copyright 2011 Jeff Verkoeyen
// http://nimbuskit.info

#import "XKViewRecyclePool.h"

@interface XKViewRecyclePool()
@property (nonatomic, readwrite, retain) NSMutableDictionary* reuseIdentifiersToRecycledViews;
@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XKViewRecyclePool

@synthesize reuseIdentifiersToRecycledViews = _reuseIdentifiersToRecycledViews;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    if ((self = [super init])) {
        _reuseIdentifiersToRecycledViews = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver: self
               selector: @selector(reduceMemoryUsage)
                   name: UIApplicationDidReceiveMemoryWarningNotification
                 object: nil];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Warnings


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reduceMemoryUsage {
    [self removeAllViews];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView<XKViewReusable> *)dequeueReusableViewWithIdentifier:(NSString *)reuseIdentifier {
    NSMutableArray* views = [_reuseIdentifiersToRecycledViews objectForKey:reuseIdentifier];
    UIView<XKViewReusable>* view = [views lastObject];
    if (nil != view) {
        [views removeLastObject];
        if ([view respondsToSelector:@selector(prepareForReuse)]) {
            [view prepareForReuse];
        }
    }
    return view;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)recycleView:(UIView<XKViewReusable> *)view {
//    NIDASSERT([view isKindOfClass:[UIView class]]);
    
    NSString* reuseIdentifier = nil;
    if ([view respondsToSelector:@selector(reuseIdentifier)]) {
        reuseIdentifier = [view reuseIdentifier];;
    }
    if (nil == reuseIdentifier) {
        reuseIdentifier = NSStringFromClass([view class]);
    }
    
//    NIDASSERT(nil != reuseIdentifier);
    if (nil == reuseIdentifier) {
        return;
    }
    
    NSMutableArray* views = [_reuseIdentifiersToRecycledViews objectForKey:reuseIdentifier];
    if (nil == views) {
        views = [[NSMutableArray alloc] init];
        [_reuseIdentifiersToRecycledViews setObject:views forKey:reuseIdentifier];
    }
    [views addObject:view];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllViews {
    [_reuseIdentifiersToRecycledViews removeAllObjects];
}


@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XKReusableView

@synthesize reuseIdentifier = _reuseIdentifier;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:CGRectZero])) {
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    return [self initWithReuseIdentifier:nil];
}


@end