//
//  XKRWZheDieCell.h
//  XKRW
//
//  Created by 忘、 on 15-2-4.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWiSlimBaseCell.h"
#import "XKRWEvaluatingProblemCell.h"

@interface XKRWZheDieCell : XKRWiSlimBaseCell<UITableViewDelegate,UITableViewDataSource,XKRWEvaluatingProblemCellDelegate>
{
    UITableView  *foldTableView;  // tableView
    NSMutableArray *selectedArr;  //已经选过的 标题
//    UIView  *progressBarView;
    NSInteger  selectSection;  //选中的section
//    UIView     *lineView1;
//    UIView     *lineView2;
    NSMutableArray  *checkStateArray;
}

- (void)initSubviews;
@property (nonatomic,strong) NSArray *sectionTitleArray;  //Section 上显示的标题
@property (nonatomic,strong) NSArray *cellTitleArray;     //折叠的cell上显示的标题
@property (nonatomic,assign) iSlimCellType  cellType;     //cell的类型
@property (nonatomic,strong) UIColor *color; //左边的颜色

@end
