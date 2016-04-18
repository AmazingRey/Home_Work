//
//  XKRWPushMenu5_3Cell.h
//  XKRW
//
//  Created by ss on 16/4/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWPushMenu5_3Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *labMain;
@property (weak, nonatomic) IBOutlet UILabel *labSub;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIButton *btnArrow;

- (IBAction)actRight:(id)sender;
- (IBAction)actArrow:(id)sender;
@end
