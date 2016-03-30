//
//  XKPullRefreshView.m
//  calorie
//
//  Created by JiangRui on 12-12-27.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "XKPullRefreshView.h"

@interface XKPullRefreshView()<UITableViewDelegate>

//TableViewDelegate(外部)
@property (nonatomic, assign) id<UITableViewDelegate> tableDelegate;
@end

@implementation XKPullRefreshView
@synthesize pullRefreshType = _type;
@synthesize footerView = _footerView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setDelegate:(id<UITableViewDelegate>)delegate
{
    super.delegate = self;
    self.tableDelegate = delegate;
}
-(void)setPullRefreshType:(XKPullRefreshViewType)pullRefreshType
{
    _type = pullRefreshType;
    if (_type == 1) {
        self.footerView = nil;
    }
}
-(void)setTableFooterView:(UIView *)tableFooterView
{
    self.footerView = tableFooterView;
    [super setTableFooterView:tableFooterView];
}
-(void)loadMore
{
    [self.refreshDelegate pullUpTodo:self];
}
#pragma mark --scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isLoading || self.isLoadComplete) {
        return;
    }
    
    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    if (scrollPosition <= 0) {
        self.isLoading = YES;
        [self loadMore];
    }
}
#pragma mark --TableViewDelegate 传递代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return [self.tableDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.tableDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }

}
@end
