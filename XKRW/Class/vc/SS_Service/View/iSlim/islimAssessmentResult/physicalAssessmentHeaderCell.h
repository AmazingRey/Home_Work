//
//  physicalAssessmentHeaderCell.h
//  XKRW
//
//  Created by 忘、 on 15-2-3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface physicalAssessmentHeaderCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *statureLable;
@property (weak, nonatomic) IBOutlet UILabel *otherLable;
@property (weak, nonatomic) IBOutlet UILabel *habitLable;
@property (weak, nonatomic) IBOutlet UILabel *sportLable;
@property (weak, nonatomic) IBOutlet UILabel *dietLable;
@property (weak, nonatomic) IBOutlet UILabel *scorelable;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;



- (void)showRadar:(NSArray *)scoreArray;


@end
