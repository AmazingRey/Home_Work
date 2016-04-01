//
//  XKRWFocusView.h
//  XKRW
//
//  Created by Shoushou on 16/3/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWShareAdverEntity.h"

typedef void(^adClickBlock)(XKRWShareAdverEntity *adEntity);
@interface XKRWFocusView : UIView <UIScrollViewDelegate>
@property (nonatomic,copy) adClickBlock adImageClickBlock;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end
