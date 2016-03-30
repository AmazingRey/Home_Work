//
//  XKRWCustomSegue.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-12.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWCustomSegue.h"

@implementation XKRWCustomSegue
//自定Segue 实现storyboard 无动画model
-(void)perform {
    [[self sourceViewController] presentViewController:[self destinationViewController] animated:NO completion:nil];
}

@end
