//
//  XKRWBlogEnterCell.h
//  XKRW
//
//  Created by Shoushou on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^iSlimShareAction)();

@class XKRWArticleListEntity;

@interface XKRWBlogEnterCell : UITableViewCell
- (void)setContentWithEntity:(XKRWArticleListEntity *)entity;

@property (nonatomic,strong) iSlimShareAction islimShareActionBlock;
@end
