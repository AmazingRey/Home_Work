//
//  KMHeaderTips.h
//  XKRW
//
//  Created by Klein Mioke on 15/8/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KMHeaderTipsType) {
    KMHeaderTipsTypeDefault = 1,
    KMHeaderTipsTypeClickable
};

@interface KMHeaderTips : UIView

@property (nonatomic, strong) UILabel       *textLabel;
@property (nonatomic, strong) UIImageView   *leftImageView;
@property (nonatomic, strong) UIButton      *closeButton;

@property (nonatomic, assign) KMHeaderTipsType type;

// -----  Initialization  ----- //

- (id)initWithFrame:(CGRect)frame text:(NSString *)text type:(KMHeaderTipsType)type;

// -----  Properties setting  ----- //
/**
 *  Set background color, Only above iOS 8.0, the blur effect can be shown
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor blur:(BOOL)blur;

- (void)setTextColor:(UIColor *)color andFont:(UIFont *)font;

// -----  Action  ----- //

- (void)startAnimationWithStartOrigin:(CGPoint)startPoint endOrigin:(CGPoint)endPoint;

- (void)startAnimationWithStartOrigin:(CGPoint)startPoint endOrigin:(CGPoint)endPoint animateOptions:(UIViewAnimationOptions)option;
- (void)free;

@end
