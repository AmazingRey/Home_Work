//
//  XKPullRefreshView.h
//  calorie
//
//  Created by JiangRui on 12-12-27.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//PullRefreshView类型上拉下拉
typedef enum
{
    XKPullRefreshViewTypeUp = 0x0001,     //上拉刷新
    XKPullRefreshViewTypeDown = 0x0010,   //下拉刷新
    XKPullRefreshViewTypeNone = 0x0000    //无刷新
} XKPullRefreshViewType;
//TableView上拉下拉协议
@class XKPullRefreshView;
@protocol XKPullRefreshProtocol <NSObject>
@optional
//下拉事件
-(void)pullDownTodo:(XKPullRefreshView *)view;
//设置headerView暂时未实现
-(UIView *)headerViewForPullRefreshView:(XKPullRefreshView *)view;

@required
//上拉事件
-(void)pullUpTodo:(XKPullRefreshView *)view;
@end

@interface XKPullRefreshView : UITableView
{
    XKPullRefreshViewType _type;
    UIView *_footerView;
}
//刷新代理
@property (nonatomic, assign) id<XKPullRefreshProtocol> refreshDelegate;
//类型
@property (nonatomic, assign) XKPullRefreshViewType pullRefreshType;
//头视图用于下拉刷新
@property (nonatomic, assign) UIView *headerView;
//foot视图用于上拉加载更多
@property (nonatomic, retain) UIView *footerView;
//是否正在加载更多，如果正在加载更多，上拉不触发事件
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) BOOL isLoadComplete;
@end
