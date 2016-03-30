//
//  XKRWSurfaceView.h
//  XKRW
//
//  Created by Shoushou on 15/8/13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWSurfaceView : UIView

- (instancetype)initWithFrame:(CGRect)frame Destination:(NSString *)destination andUserId:(NSInteger)currentUserId;

- (instancetype)initWithFrame:(CGRect)frame Destination:(NSString *)destination andUserId:(NSInteger)currentUserId completion:(void (^)(void))block;

@end
