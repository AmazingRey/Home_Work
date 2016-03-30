//
//  XKRWAdImageView.h
//  XKRW
//
//  Created by Shoushou on 15/12/3.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loadCompleteBlock)(BOOL isComplete);
@interface XKRWAdImageView : UIImageView

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *title;

@end
