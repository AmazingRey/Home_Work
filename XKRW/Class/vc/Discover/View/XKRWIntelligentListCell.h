//
//  XKRWIntelligentListCell.h
//  XKRW
//
//  Created by Shoushou on 16/1/12.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWIntelligentListEntity.h"

typedef void(^selfClickBlock)(NSString *userName);

@interface XKRWIntelligentListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *bgButton;
@property (copy, nonatomic) selfClickBlock cellClickBlock;

- (void)setContentWithEntity:(XKRWIntelligentListEntity *)entity rankNum:(NSInteger)rankNum;
@end
