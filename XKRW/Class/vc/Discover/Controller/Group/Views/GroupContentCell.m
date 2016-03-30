//
//  GroupContentCell.m
//  AFN_Test
//
//  Created by Seth Chen on 16/1/8.
//  Copyright © 2016年 xikang. All rights reserved.
//

#import "GroupContentCell.h"

@interface GroupContentCell ()
{
    CGFloat   __essenceChangeDistance;
    CGFloat   __helpChangeDistance;
    CGFloat   __hasImageChangeDistance;
    CGFloat   __timeChangeDistance;
}
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end

@implementation GroupContentCell

- (void)awakeFromNib {
    __essenceChangeDistance = .0;
    __helpChangeDistance = .0;
    __hasImageChangeDistance = .0;
    __timeChangeDistance = .0;
}

// override
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
//    self.separatorLine.backgroundColor = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    self.separatorLine.backgroundColor = [UIColor blackColor];
}

//         17        17        17        24
// 7.000000,24.000000,41.000000,58.000000,82.000000
- (void)setTopIndictor:(BOOL)top
       essenceIndictor:(BOOL)essence
          helpIndictor:(BOOL)help
      hasImageIndictor:(BOOL)hasImage
             timeLabel:(BOOL)time
{
    NSLog(@"%f,%f,%f,%f,%f",self.topIndictorLeadingConstraint.constant, self.essenceIndictorLeadingConstraint.constant, self.helpIndictorLeadingConstraint.constant, self.hasImageIndictorLeadingConstraint.constant, self.timeLabelLeadingConstraint.constant);
    
    if (top) {
        self.topIndictor.hidden = YES;
        
        __essenceChangeDistance = 17.0;
        __helpChangeDistance = 17.0;
        __hasImageChangeDistance = 17.0;
        __timeChangeDistance = 17.0;
    }else{
        self.topIndictor.hidden = NO;
        
        __essenceChangeDistance = .0;
        __helpChangeDistance = .0;
        __hasImageChangeDistance = .0;
        __timeChangeDistance = .0;
    }
    
    if (essence) {
        self.essenceIndctor.hidden = YES;
        
        __helpChangeDistance += 17.0;
        __hasImageChangeDistance += 17.0;
        __timeChangeDistance += 17.0;
    }else{
        self.essenceIndctor.hidden = NO;
        
        
    }
    
    if (help) {
        self.helpIndictor.hidden = YES;
        
        __hasImageChangeDistance += 17.0;
        __timeChangeDistance += 17.0;
    }else{
        self.helpIndictor.hidden = NO;
    }
    
    if (hasImage) {
        self.hasImageIndictor.hidden = YES;
        
        __timeChangeDistance += 24.0;
    }else{
        self.hasImageIndictor.hidden = NO;
    }
  
    self.essenceIndictorLeadingConstraint.constant = 24 - __essenceChangeDistance;
    self.helpIndictorLeadingConstraint.constant = 41 - __helpChangeDistance;
    self.hasImageIndictorLeadingConstraint.constant = 58 - __hasImageChangeDistance;
    self.timeLabelLeadingConstraint.constant = 82 - __timeChangeDistance;
}

@end
