//
//  XKRWMoreCommetCell.h
//  XKRW
//
//  Created by Shoushou on 15/10/25.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWMoreCommetCell : UITableViewCell

@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *nocommentImageView;
@property (nonatomic, strong) UIView *lineView;// 上面边界线
@property (nonatomic, strong) UIView *bottomLine; // 底端线

// 有评论
@property (nonatomic, assign) BOOL haveComment;

@end
