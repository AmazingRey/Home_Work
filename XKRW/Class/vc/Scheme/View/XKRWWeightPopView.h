//
//  XKRWWeightPopView.h
//  XKRW
//
//  Created by ss on 16/4/7.
//  Copyright © 2016年 XiKang. All rights reserved.
//

@protocol XKRWWeightPopViewDelegate <NSObject>
@optional
-(void)pressPopViewSure:(NSNumber *)inputNum;
-(void)pressPopViewCancle;
@end
#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface XKRWWeightPopView : UIView <UITextFieldDelegate,iCarouselDataSource,iCarouselDelegate>
@property (assign, nonatomic) id<XKRWWeightPopViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UIButton *btnBefore;
@property (weak, nonatomic) IBOutlet UIButton *btnLater;
- (IBAction)actBefore:(id)sender;
- (IBAction)actLater:(id)sender;

@property (weak, nonatomic) IBOutlet iCarousel *iCarouselView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *labInput;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;

@property (strong,nonatomic) NSArray *arrLabels;

- (IBAction)pressCancle:(id)sender;
- (IBAction)pressSure:(id)sender;

@end
