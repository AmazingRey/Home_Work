//
//  XKRWRecordFood5_3Cell.h
//  XKRW
//
//  Created by ss on 16/4/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWRecordFood5_3Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *labMain;
@property (weak, nonatomic) IBOutlet UILabel *labPresent;
@property (weak, nonatomic) IBOutlet UIButton *btnDown;
- (IBAction)actDown:(id)sender;

@end
