//
//  GroupContentCell.h
//  AFN_Test
//
//  Created by Seth Chen on 16/1/8.
//  Copyright © 2016年 xikang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotInddictor;

@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *topIndictor;
@property (weak, nonatomic) IBOutlet UIImageView *essenceIndctor;
@property (weak, nonatomic) IBOutlet UIImageView *helpIndictor;
@property (weak, nonatomic) IBOutlet UIImageView *hasImageIndictor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hottoTopConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topIndictorLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *essenceIndictorLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpIndictorLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hasImageIndictorLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelLeadingConstraint;


- (void)setTopIndictor:(BOOL)top
       essenceIndictor:(BOOL)essence
          helpIndictor:(BOOL)help
      hasImageIndictor:(BOOL)hasImage
             timeLabel:(BOOL)time;
@end
