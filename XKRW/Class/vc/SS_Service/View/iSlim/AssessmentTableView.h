//
//  AssessmentTableView.h
//  XKRW
//
//  Created by XiKang on 15-1-22.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWiSlimBaseCell.h"

@class AssessmentTableView;

@protocol AssessmentTableViewDelegate <NSObject>

- (void)AssessmentTableView:(AssessmentTableView *)tableview clickFooterViewButton:(id)sender;

@end

typedef NS_ENUM(NSInteger, XKDirection) {
    XKDirectionUp,
    XKDirectionRight,
    XKDirectionDown,
    XKDirectionLeft
};

@interface AssessmentTableView : UITableView

@property (nonatomic) NSInteger currentPageIndex;

@property (nonatomic) BOOL isShow;

@property (nonatomic, weak) id <AssessmentTableViewDelegate> AssessmentDelegate;
/**
 *  初始化方法，只有一个section和一个row，需要传显示的cell
 */
- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                   customCell:(XKRWiSlimBaseCell *)cell
                        title:(NSString *)title;
/**
 *  重置cell和title，然后刷新
 */
- (void)setCustomCell:(UITableViewCell *)cell title:(NSString *)title;
/**
 *  向某个方向消失
 */
- (BOOL)disappearToDirection:(XKDirection)direction;
/**
 *  从某个方向出现
 */
- (void)appearFromDirection:(XKDirection)direction;
/**
 *  设置去往下个题目或者上个题目时候执行的block
 */
- (void)setGotoPriorQuestion:(void (^)(void))prior nextQuestion:(void (^)(void))next;

@end
