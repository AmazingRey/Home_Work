//
//  XKRWIntelligentListEnterCell.h
//  XKRW
//
//  Created by Shoushou on 16/1/12.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWIntelligentListEntity.h"

@interface XKRWIntelligentListEnterCell : UITableViewCell

- (void)setContentWithArray:(NSArray <XKRWIntelligentListEntity *> *)array;
- (void)IntelligentListIsNew:(NSString *)week_start;
- (void)XKRWIntelligentListEnterCellClicked;
@end
