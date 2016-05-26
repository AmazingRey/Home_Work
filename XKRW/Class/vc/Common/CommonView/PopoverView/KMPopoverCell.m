//
//  KMPopoverCell.m
//  XKRW
//
//  Created by XiKang on 15-4-3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "KMPopoverCell.h"
#import <objc/runtime.h>
@interface KMPopoverCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation KMPopoverCell

- (instancetype)initWithType:(KMPopoverCellType)type width:(CGFloat)width reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.width = width;
        
        if (type == KMPopoverCellTypeOnlyText) {
            
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 44.f)];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            self.titleLabel.font = XKDefaultFontWithSize(16.f);
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:self.titleLabel];
            
        } else if (type == KMPopoverCellTypeImageAndText) {
            
            self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 12.f, 20, 20)];
            [self.contentView addSubview:self.headImageView];
            
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImageView.right, 0, self.width - self.headImageView.width - 15.f, 44.f)];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = XKDefaultFontWithSize(16.f);
            self.titleLabel.textColor = [UIColor whiteColor];;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            
            [self.contentView addSubview:self.titleLabel];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

- (void)setheadImage:(UIImage *)image {
    
    self.headImageView.image = image;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
