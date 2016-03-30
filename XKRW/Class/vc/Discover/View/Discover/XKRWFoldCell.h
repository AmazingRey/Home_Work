//
//  XKRWFoldCell.h
//  XKRW
//
//  Created by Shoushou on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^foldBlock)();

@interface XKRWFoldCell : UITableViewCell
@property (nonatomic,copy) foldBlock foldCellClicked;

- (void)fold;
- (void)unfold;
@end
