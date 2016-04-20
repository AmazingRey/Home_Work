//
//  XKRWRecordMore5_3View.h
//  XKRW
//
//  Created by ss on 16/4/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//
@protocol XKRWRecordMore5_3ViewDelegate <NSObject>
@optional
-(void)pressChangeEatPercent;
-(void)pressSetEatNotify;

@end
#import <UIKit/UIKit.h>
@interface XKRWRecordMore5_3View : UIView
@property (assign,nonatomic) id <XKRWRecordMore5_3ViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
- (IBAction)actChange:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSet;
- (IBAction)actSet:(id)sender;

@end
