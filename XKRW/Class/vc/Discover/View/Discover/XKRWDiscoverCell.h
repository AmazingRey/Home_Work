//
//  XKRWDiscoverCell.h
//  XKRW
//
//  Created by Klein Mioke on 15/9/1.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  发现页面cell类型
 */
typedef NS_ENUM(int, XKRWDiscoverCellType){
    /**
     *  只有大图
     */
    XKRWDiscoverCellTypeOnlyImage = 1,
    /**
     *  只有标题
     */
    XKRWDiscoverCellTypeOnlyTitle,
    /**
     *  小图+标题
     */
    XKRWDiscoverCellTypeImageAndTitle,
    /**
     *  小图+标题+内容
     */
    XKRWDiscoverCellTypeDefault,
    /**
     *  标题+内容
     */
    XKRWDiscoverCellTypeTitleAndDetail
};

extern NSString * getDiscoverCellTypeDescription(XKRWDiscoverCellType type);

@interface XKRWDiscoverCell : UITableViewCell

@property (nonatomic, assign) XKRWDiscoverCellType type;

- (instancetype)initWithType:(XKRWDiscoverCellType)type;

@end
