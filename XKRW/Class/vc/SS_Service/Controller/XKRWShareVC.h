//
//  XKRWShareVC.h
//  XKRW
//
//  Created by Jiang Rui on 13-12-11.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"


@protocol XKRWShareVCDelegate <NSObject>
- (void)clearShareVCRedDot;
@end

@class XKRWShareEntity;
@interface XKRWShareVC : XKRWBaseVC
@property (nonatomic,strong) XKRWUITableViewBase *serviceTableView;
@property (nonatomic, strong) id <XKRWShareVCDelegate> delegate;

@end
