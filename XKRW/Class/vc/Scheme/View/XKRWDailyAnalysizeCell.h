//
//  XKRWDailyAnalysizeCell.h
//  XKRW
//
//  Created by ss on 16/4/28.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWDailyAnalysizeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labLeft;
@property (strong, nonatomic) IBOutlet UILabel *labRight;
@property (assign, nonatomic)  AnalysizeType type;
@end
