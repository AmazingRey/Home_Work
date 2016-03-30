//
//  XKRWLikeView.h
//  XKRW
//
//  Created by Shoushou on 16/1/15.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^likeViewClickBlock)(NSString *likeLabelText);

@interface XKRWLikeView : UIView

@property (nonatomic, copy) likeViewClickBlock likeButtonClicked;
- (void)setContentWithTitle:(NSString *)title ImageName:(NSString *)imageName ImageLabelText:(NSString *)imageLabelText;
- (void)hideLikePart;
- (void)setLikeTitle:(NSString *)title;
@end
