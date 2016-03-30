//
//  XKRWShareView.h
//  XKRW
//
//  Created by Shoushou on 16/1/5.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XKRWShareViewBlock)(NSInteger tag);
@interface XKRWShareView : UIView
@property (strong, nonatomic) IBOutlet UIButton *wxBtn;
@property (strong, nonatomic) IBOutlet UIButton *pyqBtn;
@property (strong, nonatomic) IBOutlet UIButton *wbBtn;
@property (strong, nonatomic) IBOutlet UIButton *qqBtn;


@property (copy, nonatomic) XKRWShareViewBlock clickBlock;
@end
