//
//  XKRWAllCommentVC.h
//  XKRW
//
//  Created by 忘、 on 15-3-20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"

@interface XKRWAllCommentVC : XKRWBaseVC<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *commentTableView ;
    MJRefreshHeaderView *headerView;
    MJRefreshFooterView *footerView;
    
    NSMutableArray  *commentArray;  //评论数组
    
    UIImageView   *noNetworkImageView;
    UIView        *noNetworkView;
    BOOL   isHeadFlash;    //是上拉
}
@end
