//
//  FeedbackCell.h
//  XKRW
//
//  Created by 忘、 on 15/5/7.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ReplyType) {
    USER = 0,
    
};

@interface FeedbackCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *leftHeadImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end
