
//
//  main.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-9.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        @try {
              return UIApplicationMain(argc, argv, nil, NSStringFromClass([XKRWAppDelegate class]));
        }
        @catch (NSException *exception) {
                XKLog(@"=============\nCatch exception:\n%@",exception);
        }
    }
}
