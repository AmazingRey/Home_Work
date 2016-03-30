//
//  XKRWTopicListView.h
//  XKRW
//
//  Created by Shoushou on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWFoldCell.h"

@class XKRWTopicListView;

@protocol XKRWTopicListViewDelegate <NSObject>

@optional
- (void)topicListView:(XKRWTopicListView *)topicListView didSelectItemAtIndex:(NSInteger)index;
@end

@interface XKRWTopicListView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<XKRWTopicListViewDelegate> delegate;
@property (nonatomic, strong) XKRWFoldCell *foldCell;
- (void)setViewTitles:(NSArray *)titles;

@end
