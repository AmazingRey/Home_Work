//
//  XKRWAddGroupViewCell.h
//  XKRW
//
//  Created by Seth Chen on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADView.h"

typedef BOOL(^ButtonClick)(BOOL, NSString *);

@interface XKRWAddGroupViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupheadImage;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCount;
@property (weak, nonatomic) IBOutlet UILabel *groupTitle;
@property (weak, nonatomic) IBOutlet UIButton *groupButton;

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) ButtonClick handle;

- (void)setjoinOrsignOutButtonSelected:(BOOL)selected;

@end



@interface XKRWAddGroupHeaderViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIView *line;

@end


@interface XKRWGroupADViewCell : UITableViewCell

@property (strong, nonatomic) ADView *adView;
@property (strong, nonatomic) UIView *line;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                       handle:(void(^)())handle;

@end