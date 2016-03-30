//
//  CustomKeyboard.h
//  keyboard
//
//  Created by zhaowang on 14-3-25.
//  Copyright (c) 2014年 anyfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFFNumericKeyboard;

@protocol AFFNumericKeyboardDelegate <NSObject>

- (void) numberKeyboardInput:(NSInteger) number andKeyBoard:(AFFNumericKeyboard *)keyBoard andTextField:(UITextField * )textField;
- (void) numberKeyboardBackspace:(AFFNumericKeyboard *)keyBoard andTextField:(UITextField * )textField;;

@optional

- (void) changeKeyboardType:(AFFNumericKeyboard *)keyBoard andTextField:(UITextField * )textField;;

@end

@interface AFFNumericKeyboard : UIView
{
    NSArray *arrLetter;
}
@property (nonatomic, assign) BOOL  needSysBoard;
@property (nonatomic,weak) id<AFFNumericKeyboardDelegate> delegate;
@property (nonatomic, weak)  UITextField * textField;
@end
