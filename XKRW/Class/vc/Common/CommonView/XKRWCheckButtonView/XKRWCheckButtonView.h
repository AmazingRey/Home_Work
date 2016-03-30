//
//  XKRWCheckButtonView.h
//  XKRW
//
//  Created by XiKang on 14-11-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BadHabbitButtonStatus) {
    BadHabbtiButtonStatusUnselected,
    BadHabbtiButtonStatusSelected
};

#define BadHabbitButtonLengthShort 64.f
#define BadHabbitButtonLengthMiddle 75.f
#define BadHabbitButtonLengthLong 90.f
/**
 *  复选按钮
 */
@interface XKBadHabbitButton : UIButton

@property BadHabbitButtonStatus status;
@property (nonatomic, strong) NSString *text;
@property (nonatomic) NSInteger index;

- (instancetype)initWithFrame:(CGRect)frame andIsSelected:(BOOL)yesOrNo;
/**
 *  设置标题，index和相应事件
 *
 *  @param title 标题文字
 *  @param index 索引
 *  @param block 相应时间回调函数
 */
- (void)setTitle:(NSString *)title
        andIndex:(NSInteger)index
   andClickBlock:(void (^)(XKBadHabbitButton *))block;

@end

typedef NS_ENUM(NSInteger, XKRWCheckButtonViewStyle) {
    XKRWCheckButtonViewStyleSingle,
    XKRWCheckButtonViewStyleMultiple,
    XKRWCheckButtonViewStyleAllSelect,
    XKRWCheckButtonViewStyleWeekdayPicker
};

/**
 *  复选按钮的容器View
 */
@interface XKRWCheckButtonView : UIView

@property (nonatomic) NSInteger numberOfSelected;
@property (nonatomic) NSInteger numberOfLines;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic) XKRWCheckButtonViewStyle style;

- (id)initWithFrame:(CGRect)frame
      andTitleArray:(NSMutableArray *)array
    andSpacingWidth:(CGFloat)spacing
andCurrentSelectedButton:(NSInteger)selectedInedx
           andStyle:(XKRWCheckButtonViewStyle)style
       returnHeight:(void (^)(CGFloat))block
        clickButton:(void (^)(NSInteger))block2;

- (id)initWithFrame:(CGRect)frame
      andTitleArray:(NSMutableArray *)array
andCurrentSelectedButton:(NSInteger) selectedInedx
           andStyle:(XKRWCheckButtonViewStyle)style
       returnHeight:(void (^)(CGFloat height))block
        clickButton:(void (^)(NSInteger index))block2;
/**
 *  获取所有按钮的状态，1为选中，按Index位运算
 *
 *  @return 状态转换后数字之和
 */
- (int)getAllButtonState;
@end
