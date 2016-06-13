//
//  XKRWTabbarVC.h
//  XKRWTabbarVC
//
//  Created by Jiang Rui on 13-12-10.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface XKRWTabbarVC : UITabBarController
{
    @private
    UIButton *personBtn;
    UIButton *schemeBtn;
    UIButton *shareBtn;
    UIButton *moreBtn;
    UIImageView *tabbarBG;
}
- (void)createCustomTabBar;
- (void)exitTheAccount;


@end
