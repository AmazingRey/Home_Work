//
//  XKRWTopicListCell.h
//  XKRW
//
//  Created by Shoushou on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWTopicListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;

- (void)setTitles:(NSArray *)titles;
- (void)setLastCellStyle;
@end
