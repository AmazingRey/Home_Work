//
//  XKRWRecordSingleMore5_3View.h
//  XKRW
//
//  Created by ss on 16/4/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//
@protocol XKRWRecordSingleMore5_3ViewDelegate <NSObject>
@optional
-(void)pressSetSportNotify;
@end

#import <UIKit/UIKit.h>

@interface XKRWRecordSingleMore5_3View : UIView
@property (assign ,nonatomic) id<XKRWRecordSingleMore5_3ViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnSet;
- (IBAction)actSet:(id)sender;
@property (assign ,nonatomic) energyType type;
@end
