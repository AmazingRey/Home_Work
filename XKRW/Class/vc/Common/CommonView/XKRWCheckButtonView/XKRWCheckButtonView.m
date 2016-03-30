//
//  XKRWCheckButtonView.m
//  XKRW
//
//  Created by XiKang on 14-11-10.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWCheckButtonView.h"

@implementation XKBadHabbitButton
{
    void (^_click)(XKBadHabbitButton *);
}

- (instancetype)initWithFrame:(CGRect)frame andIsSelected:(BOOL)yesOrNo;
{
    if (self = [super initWithFrame:frame]) {
        CGRect rect = self.frame;
        rect.size.height = 16.f;
        self.frame = rect;
        self.layer.cornerRadius = 4.f;
        
        if (!yesOrNo) {
            self.status = BadHabbtiButtonStatusUnselected;
            [self setBackgroundColor:[UIColor clearColor]];
            [self setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
        } else {
            self.status = BadHabbtiButtonStatusSelected;
            [self setBackgroundColor:XKMainSchemeColor];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = XKMainSchemeColor.CGColor;
        [self.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        
        [self addTarget:self action:@selector(changeSelectedStatus) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title
        andIndex:(NSInteger)index
   andClickBlock:(void (^)(XKBadHabbitButton *))block
{
    [self setTitle:title forState:UIControlStateNormal];
    self.index = index;
    index ++;
    _click = block;
}

/**
 *  循环改变button的选中状态
 */
- (void)changeSelectedStatus
{
    if (self.status == BadHabbtiButtonStatusUnselected) {
        [self setButtonSelected];
    } else {
        [self setUnselected];
    }
    _click(self);
}

- (void)setUnselected
{
    self.status = BadHabbtiButtonStatusUnselected;
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
}

- (void)setButtonSelected
{
    self.status = BadHabbtiButtonStatusSelected;
    [self setBackgroundColor:XKMainSchemeColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
@end

@implementation XKRWCheckButtonView
{
    void (^_clickButton)(NSInteger);
    
    CGFloat _spacingWidth;
}
#pragma mark - intialize of Cell

- (id)initWithFrame:(CGRect)frame
      andTitleArray:(NSMutableArray *)array
    andSpacingWidth:(CGFloat)spacing
andCurrentSelectedButton:(NSInteger)selectedInedx
           andStyle:(XKRWCheckButtonViewStyle)style
       returnHeight:(void (^)(CGFloat))block
        clickButton:(void (^)(NSInteger))block2 {
    
    if (self = [super initWithFrame:frame]) {
        _spacingWidth = spacing;
        [self initWithArray:array andStyle:style andCurrentSelectedButton:selectedInedx returnHeight:block clickButton:block2];
    }
    return self;
}
/**
 *  View初始化
 */
- (id)initWithFrame:(CGRect)frame
      andTitleArray:(NSMutableArray *)array
    andCurrentSelectedButton:(NSInteger) selectedInedx
           andStyle:(XKRWCheckButtonViewStyle)style
       returnHeight:(void (^)(CGFloat height))block
        clickButton:(void (^)(NSInteger index))block2
{
    if (self = [self initWithFrame:frame andTitleArray:array andSpacingWidth:10.f andCurrentSelectedButton:selectedInedx andStyle:style returnHeight:block clickButton:block2]) {
    }
    return self;
}

- (void)initWithArray:(NSMutableArray *)array
             andStyle:(XKRWCheckButtonViewStyle)style
        andCurrentSelectedButton:(NSInteger) selectedInedx
         returnHeight:(void (^)(CGFloat height))block
          clickButton:(void (^)(NSInteger index))block2
{
    
    self.numberOfSelected = 0;
    self.style = style;
    self.numberOfLines = 1;
    
    int index = 0;
    CGFloat _xPoint = 0.f;
    CGFloat _yPoint = 0.f;
    
    self.buttonArray = [NSMutableArray array];
    /**
     *  初始化复选按钮们
     */
   // for (NSString *title in array) {
    NSArray *stateArray = nil;
    if (style == XKRWCheckButtonViewStyleWeekdayPicker) {
        stateArray = [self getSelectStateOfBinary:selectedInedx andCount:array.count];
    }
  
    for (int i = 0; i < [array count]; i ++) {
        
        NSString *title = [array objectAtIndex:i];
        
//        if (_xPoint + [self getLengthWithString:title] > self.frame.size.width) {
//            _xPoint = 0.f;
//            _yPoint += 44.f;
//            self.numberOfLines ++;
//        }
        XKBadHabbitButton *button = nil;
        BOOL isSelected = NO;
        
        if (self.style == XKRWCheckButtonViewStyleWeekdayPicker) {
            isSelected = [stateArray[i] boolValue];
            
        } else {
            if (i == selectedInedx) {
                isSelected = YES;
            } else {
                isSelected = NO;
            }
        }
        button = [[XKBadHabbitButton alloc]
                  initWithFrame:CGRectMake(_xPoint, _yPoint, [self getLengthWithString:title], 16.f)
                  andIsSelected:isSelected];
       
        if (self.style == XKRWCheckButtonViewStyleWeekdayPicker) {
            _xPoint += [self getLengthWithString:title] + _spacingWidth;
        } else {
            _xPoint += [self getLengthWithString:title] + _spacingWidth;
        }
        
        [button setTitle:title
                andIndex:index
           andClickBlock:^(XKBadHabbitButton * button) {
               [self checkNumberOfSelectedButtonWithNewStatus:button.status];
               
               if (style == XKRWCheckButtonViewStyleSingle) {
                   for (XKBadHabbitButton *btn in self.buttonArray) {
                       if (btn.status == BadHabbtiButtonStatusSelected
                           && (button != btn)) {
                           [btn setUnselected];
                       }
                   }
               }
               block2(button.index);
           }];
        
        [self.buttonArray addObject:button];
        [self addSubview:button];
        index ++;
        
        if (style == XKRWCheckButtonViewStyleAllSelect) {
         
            [button setButtonSelected];
            button.enabled = NO;
        }
    }
    [self resizeWidth];
    
    /**
     *  传回重绘过的视图大小，调节TableView中得高度
     */
    block(self.frame.size.height);
    _clickButton = block2;
}

- (int)getAllButtonState
{
    int states = 0;
    for (XKBadHabbitButton *button in self.buttonArray) {
        int temp = 0;
        if (button.status == BadHabbtiButtonStatusSelected) {
            temp = 1 << button.index;
        }
        states += temp;
    }
    return states;
}

- (NSArray *)getSelectStateOfBinary:(NSInteger)binary andCount:(NSInteger)count
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i ++) {
        if ((binary & (1 << i)) >> i) {
            [result addObject:[NSNumber numberWithBool:YES]];
        } else {
            [result addObject:[NSNumber numberWithBool:NO]];
        }
    }
    return result;
}

#pragma mark - other functions
/**
 *  检查选中状态的按钮数量
 *
 *  @param status 按钮的新状态
 */
- (void)checkNumberOfSelectedButtonWithNewStatus:(BadHabbitButtonStatus)status
{
    if (status == BadHabbtiButtonStatusSelected) {
        self.numberOfSelected ++;
    } else {
        self.numberOfSelected --;
    }
}

/**
 *  重绘视图宽度
 */
- (void)resizeWidth
{
    CGFloat width = self.width;
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
/**
 *  通过中文字数返回相应复选框宽度
 *
 *  @param text 中文字符串
 *
 *  @return 对应复选框长度
 */
- (CGFloat)getLengthWithString:(NSString *)text
{
    if (self.style == XKRWCheckButtonViewStyleWeekdayPicker) {
        return 35.f;
    }
    if (text.length <= 3) {
        return 64.f;
    } else {
        return 90.f;
    }
}


@end
