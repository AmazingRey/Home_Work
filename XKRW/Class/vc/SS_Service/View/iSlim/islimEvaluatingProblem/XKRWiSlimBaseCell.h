//
//  XKRWiSlimBaseCell.h
//  XKRW
//
//  Created by XiKang on 15-2-2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWServerPageService.h"

typedef NS_ENUM(NSInteger, iSlimCellType) {
    iSlimCellTypeSingle = 0,
    iSlimCellTypeMultiple,
    iSlimCellTypeSort,
    iSlimCellTypeCustom,
    iSlimcellTypeMultipleLine
};
/**
 *  iSlim瘦身评估页面专用Cell，初始化时候必须指定page，用来保存答案。
 */
@interface XKRWiSlimBaseCell : UITableViewCell
@property (nonatomic, strong) id answer;
@property (nonatomic, assign) NSInteger page;
/**
 *  实际内容高度
 */
@property (nonatomic, assign) CGFloat contenHeight;
/**
 *  自定义初始化方法
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                         page:(NSInteger)page;
/**
 *  保存用户答案，只需要赋值给属性answer即可，再调用super方法，一定要注意顺序。
 */
- (void)saveAnswer;
/**
 *  检查当页问题是否完成，注意：千万不要调用super方法。
 */
- (BOOL)checkComplete;
/**
 *  获取选中的编号
 *
 *  @param index 选中的是第几个
 *
 *  @return 返回选项 A ，B，C
 */
- (NSString *)getUserSelect:(NSInteger)index;

/**
 *  获取自定义cell的选中结果
 *
 *  @param cellTitleArray cell标题
 *  @param checkArray     选中的cell
 *
 *  @return
 */
- (NSMutableString *)getCustomCellSelect:(NSArray *)cellTitleArray checkArray:(NSArray *)checkArray;

@end
