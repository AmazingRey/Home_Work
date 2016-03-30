//
//  XKRWEvaluatingProblemCell.h
//  XKRW
//
//  Created by 忘、 on 15-1-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWiSlimBaseCell.h"

typedef void(^showPromptInfomationBlock)();

@protocol XKRWEvaluatingProblemCellDelegate <NSObject>
//通过选中状态刷新选中后的tableView   这里的参数这么定义的  数组的第一个元素表示 是第几个section
- (void)refreshSelectedStateFromResult:(NSInteger)Section isSelected:(NSInteger) state  selectTitle:(NSString *)title;
@end


@interface XKRWEvaluatingProblemCell : XKRWiSlimBaseCell<UITableViewDelegate,UITableViewDataSource>
{
  //  UIView  *progressBarView;
    
    UIImageView  *sortRemindImageView;
}

@property (nonatomic, strong) UITableView  *evaluatingTableView;

@property (nonatomic,assign) iSlimCellType   cellType;

@property (nonatomic,strong) NSArray  *cellTitleArray; //cell上的标题

@property (nonatomic,strong) UIColor *color; //左边的颜色

@property (strong, nonatomic) NSMutableArray *checkedArray;

@property (nonatomic,assign) BOOL  isShowLine;   //折叠的cell中是否显示lineView 

@property (nonatomic,assign) NSInteger  selectedSection;  //被选中的section

@property (nonatomic,assign) NSInteger mostSelectedNum;   // 最多选择的个数

@property (nonatomic,assign) id <XKRWEvaluatingProblemCellDelegate> refreshDelegate;

@property (nonatomic,assign) showPromptInfomationBlock block;

@property (nonatomic, assign) BOOL needLayoutSubviews;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                         page:(NSInteger)page
                iSlimCellType:(iSlimCellType)type
                   titleArray:(NSArray *)titles
                        color:(UIColor *)color;

@end
