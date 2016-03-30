//
//  XKRWAddGroupViewCell.m
//  XKRW
//
//  Created by Seth Chen on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWAddGroupViewCell.h"

@implementation XKRWAddGroupViewCell
{
    BOOL  __buttonSelect;
}
- (void)awakeFromNib {
    // Initialization code
    self.groupButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.groupButton.layer.cornerRadius = 3;
    self.groupButton.clipsToBounds = YES;
    self.groupheadImage.layer.cornerRadius = self.groupheadImage.width/2;
    self.groupheadImage.clipsToBounds = YES;
    __buttonSelect = NO;
}

- (IBAction)joinOrsignOutTheGroup:(UIButton *)sender {
    
    if (self.handle) {
        BOOL success = self.handle(__buttonSelect, self.groupId);
        [self setjoinOrsignOutButtonSelected:success];
    }
}

- (void)setHandle:(ButtonClick)handle
{
    _handle = handle;
}

/*!
 *  设置按钮状态
 */
- (void)setjoinOrsignOutButtonSelected:(BOOL)selected
{
     __buttonSelect = selected;
    if (!selected) {
        self.groupButton.layer.borderColor = XKMainSchemeColor.CGColor;
        [self.groupButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
        [self.groupButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
        [self.groupButton setTitle:@"加入" forState:UIControlStateNormal];
        self.groupButton.userInteractionEnabled = YES;
    }else {
        self.groupButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.groupButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.groupButton setBackgroundImage:[UIImage createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        self.groupButton.userInteractionEnabled = NO;
        [self.groupButton setTitle:@"已加入" forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



/**
 *  header cell 
 */
@implementation XKRWAddGroupHeaderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    if (!self.title) {
        self.title = [UILabel new];
        self.title.frame = CGRectMake(15, 0, self.width - 30, self.height);
        self.title.font = [UIFont systemFontOfSize:16];
        self.title.backgroundColor = [UIColor whiteColor];
        self.title.textColor = [UIColor darkGrayColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.title];
    }
    if (!self.line) {
        self.line = [UIView new];
        self.line.frame = (CGRect){0, self.height - 0.5, self.width, 0.5};
        self.line.backgroundColor = XK_ASSIST_LINE_COLOR;
        [self.contentView addSubview:self.line];
    }
}

- (void)layoutSubviews
{
    self.title.frame = CGRectMake(15, 0, self.width - 30, self.height);
    self.line.frame = (CGRect){0, self.height - 0.5, self.width, 0.5};
}

@end


///<   ad view
@implementation XKRWGroupADViewCell
{
    void(^__handle)();
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier handle:(void(^)())handle
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        __handle = handle;
    }
    return self;
}

- (void)setup
{
    if (!self.adView) {
        self.adView = [[ADView alloc]initWithFrame:CGRectMake(0, 0, self.width-1, self.height)];
        self.adView.noticeDelegate = (id)self;
        self.adView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.adView];
    }
    if (!self.line) {
        self.line = [UIView new];
        self.line.frame = (CGRect){0, self.height - 0.5, self.width, 0.5};
        self.line.backgroundColor = XK_ASSIST_LINE_COLOR;
        [self.contentView addSubview:self.line];
    }
}

- (void)layoutSubviews
{
    self.adView.frame = CGRectMake(0, 0, self.width - 1, self.height);
    self.line.frame = (CGRect){0, self.height - 0.5, self.width, 0.5};
}

- (void)setADModel:(NSArray *)data
{
    self.adView.adlist = data;
}

- (void)adItemClick:(ADModel *)model
{
    if (__handle) {
        __handle(model);
    }
}


@end