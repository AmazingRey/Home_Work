//
//  XKRWMoreView.h
//  XKRW
//
//  Created by Shoushou on 15/11/25.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBlock)(void);

@interface XKRWMoreView : UIView

@property (copy, nonatomic) clickBlock viewClicked;
@property (strong, nonatomic) IBOutlet UILabel *pushLabel;

@end
