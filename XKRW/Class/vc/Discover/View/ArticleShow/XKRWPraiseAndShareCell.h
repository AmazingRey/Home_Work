//
//  XKRWPraiseAndShareCell.h
//  XKRW
//
//  Created by Shoushou on 15/9/21.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PraiseAndShareDelegate <NSObject>
- (void)postUMShareStr:(NSString *)str;
- (void)postLikeStr:(NSString*)str;
- (void)postReport:(NSString *)str;
@end

@interface XKRWPraiseAndShareCell : UITableViewCell

@property (nonatomic, assign) BOOL hiddenLikePart;
@property (nonatomic, strong) UILabel *praisesLabel;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UILabel *likeLabel;

@property (nonatomic, weak) id <PraiseAndShareDelegate> praiseAndShareDelegate;

@end
