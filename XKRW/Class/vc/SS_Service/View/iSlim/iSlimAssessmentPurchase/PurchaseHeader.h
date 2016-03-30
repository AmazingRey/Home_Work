//
//  PurchaseHeader.h
//  XKRW
//
//  Created by XiKang on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWServerPageService.h"

@interface PurchaseHeader : UIView

@property (weak, nonatomic) IBOutlet UIButton *PurchaseButton;
@property (strong, nonatomic) IBOutlet UIView *chanceLabel;
@property (nonatomic, assign) PurchaseState state;
@property (weak, nonatomic) IBOutlet UILabel *curretPriceLabel;

- (void)initSubviewsWithState:(PurchaseState)state
                  clickButton:(void (^)(void))action;

- (void)setToState:(PurchaseState)state numberOfChances:(NSInteger)num;
/**
 *  当没有网络时，需要设置成不可点击状态
 */
- (void)setDisable;

- (void)loading;

- (void)setChances:(NSInteger)num;

- (IBAction)clickPurchase:(id)sender;

@end
