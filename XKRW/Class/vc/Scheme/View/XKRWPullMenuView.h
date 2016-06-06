//
//  XKRWPullMenuView.h
//  XKRW
//
//  Created by ss on 16/6/6.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XKRWPullMenuViewDelegate <NSObject>
@optional
-(void)pressPullViewWithTitleString:(NSString *)str;

@end

@interface XKRWPullMenuView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) id<XKRWPullMenuViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSArray *imageArray;

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)itemArray imageArray:(NSArray *)imageArray;

@end
