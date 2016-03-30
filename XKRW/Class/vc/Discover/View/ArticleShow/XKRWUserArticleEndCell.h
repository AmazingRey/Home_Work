//
//  XKRWUserArticleEndCell.h
//  XKRW
//
//  Created by Klein Mioke on 15/10/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWUserArticleEndCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (strong, nonatomic) void(^clickTopicAction)(void);

@end
