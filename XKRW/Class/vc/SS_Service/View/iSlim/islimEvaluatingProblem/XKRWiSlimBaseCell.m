//
//  XKRWiSlimBaseCell.m
//  XKRW
//
//  Created by XiKang on 15-2-2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWiSlimBaseCell.h"

@implementation XKRWiSlimBaseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                         page:(NSInteger)page {
    
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    _page = page;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)saveAnswer {
    if (!self.answer) {
        XKLog(@"\nXKRWiSlimBaseCell:\n_answer is nil, will not save. This will lead to data error,\n**PLEASE CHECK YOUR CODE**\n");
        return;
    }
    [[XKRWServerPageService sharedService] saveAnswer:self.answer
                                                 step:self.page];
}


- (NSString *)getUserSelect:(NSInteger)index
{
    char *cstring = strcpy((char *)malloc(sizeof(char) * 2), "A");
    *cstring += index;
    NSString *string = [NSString stringWithCString:cstring
                                          encoding:NSUTF8StringEncoding];
    return string;
}

- (NSMutableString *)getCustomCellSelect:(NSArray *)cellTitleArray checkArray:(NSArray *)checkArray
{
    NSMutableString *multipleStr = [NSMutableString string];
    for (int i = 0 ; i <[cellTitleArray count]; i++) {
        for (int j = 0; j <[checkArray count]; j++) {
            if ([[checkArray objectAtIndex:j] isEqualToString:[cellTitleArray objectAtIndex:i]]) {
                NSString  *str = [self getUserSelect:i];
                
                if (multipleStr.length == 0) {
                    [multipleStr appendString:str];
                } else {
                    [multipleStr appendFormat:@",%@",str];
                }
            }
        }
    }
    return multipleStr;
}


- (BOOL)checkComplete {
    return YES;
}
@end
