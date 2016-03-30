//
//  XKRWHabitStateCellTableViewCell.m
//  XKRW
//
//  Created by y on 15-1-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWHabitStateCellTableViewCell.h"


@implementation XKRWHabitStateCellTableViewCell
@synthesize connentLabel ;
@synthesize titleLabel;
@synthesize subTitleLabel,cell_h;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDescribeData:(NSDictionary *)dic
{
    CGFloat y1 = 10.0;
    CGFloat y2 = 40.0 ;
    CGFloat y3 = 70.0;
    
    UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, y1, XKAppWidth - 30 , 30)];
    tLabel.backgroundColor = [UIColor clearColor] ;
    tLabel.textAlignment = NSTextAlignmentLeft;
    tLabel.font = XKDefaultFontWithSize(16);
    tLabel.textColor = XK_TITLE_COLOR;
    
    tLabel.text=  [dic objectForKey:@"title"];
    
    [self.contentView addSubview:tLabel];
    
     y2 = y1 +tLabel.height + 5;
    NSArray *arr = [NSArray arrayWithArray:[dic objectForKey:@"arr"]];
    
    for (int i = 0 ; i< arr.count; i++) {
        
        UILabel *sTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, y2, XKAppWidth - 30 , 30)];
        
        sTitleLabel.backgroundColor = [UIColor clearColor] ;
        sTitleLabel.textAlignment = NSTextAlignmentLeft;
        sTitleLabel.font = XKDefaultFontWithSize(16);
        sTitleLabel.textColor = RGB(41, 207, 177, 1);
        
        sTitleLabel.text  = [[arr objectAtIndex:i] objectForKey:@"subTitle"];
        
        [self.contentView addSubview:sTitleLabel];
        
        y3 = y2 + sTitleLabel.height + 5;
        RTLabel *cLabel= [[RTLabel alloc]initWithFrame:CGRectMake(15, y3, XKAppWidth - 30 , 30)];
        cLabel.backgroundColor = [UIColor clearColor] ;
        cLabel.font = XKDefaultFontWithSize(14);
        cLabel.textColor = XK_TEXT_COLOR;
        
        
        cLabel.text = [[arr objectAtIndex:i]objectForKey:@"advice"];
        cLabel.lineSpacing = 3.5;
        cLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.contentView addSubview:cLabel];
        
        cLabel.frame = CGRectMake(15, y3, XKAppWidth - 30 , [(RTLabel*)cLabel optimumSize].height);
        //计算下面label 的 坐标
        CGFloat label_y = [(RTLabel *)cLabel optimumSize].height + cLabel.top + 30.f;
        y2 = label_y;
        cell_h = y2;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        line.backgroundColor = XK_ASSIST_LINE_COLOR;
        
        [self.contentView addSubview:line];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, cell_h - 0.5, XKAppWidth, 0.5)];
        line.backgroundColor = XK_ASSIST_LINE_COLOR;
        
        [self.contentView addSubview:line];
    }
}


- (CGFloat)getCellHeight
{
    CGFloat height = [(RTLabel*)self.connentLabel optimumSize].height + self.connentLabel.top + 15;
    return height;
}

@end
