//
//  XKRWSCPopSelector.m
//  XKRW
//
//  Created by Seth Chen on 16/1/22.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWSCPopSelector.h"
#import "Masonry.h"
#import "XKRWSCPopSelectorCell.h"
#import "XKRWGroupItem.h"
#import "XKRWGroupService.h"
#import "UIImageView+WebCache.h"

@interface XKRWSCPopSelector()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton * backGroundButton; ///< 背景
@property (nonatomic, strong) UIView * backGroundAlertView; ///< 载体
@property (nonatomic, strong) UILabel * titleLabel; ///<
@property (nonatomic, strong) XKRWUITableViewBase * selectTabel; ///<
@property (nonatomic, strong) UIButton * confimButton; ///<
@property (nonatomic, strong) UIButton * cancelButton; ///<

@property (nonatomic, strong) NSMutableArray <NSString *>* selectArr; ///<
@end

@implementation XKRWSCPopSelector

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectArr = [NSMutableArray array];
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backGroundButton = [[UIButton alloc]initWithFrame:self.bounds];
    self.backGroundButton.backgroundColor = [UIColor blackColor];
//    [self.backGroundButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    self.backGroundButton.alpha = .6;
    [self addSubview:self.backGroundButton];
    
    self.backGroundAlertView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backGroundAlertView.backgroundColor = [UIColor whiteColor];
    self.backGroundAlertView.layer.cornerRadius = 3;
    self.backGroundAlertView.clipsToBounds = YES;
    
    [self addSubview:self.backGroundAlertView];
    
    [self.backGroundAlertView  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.width.mas_equalTo(self.width - 100*(XKAppWidth/375));
        make.height.mas_equalTo(self.height - 300*(XKAppHeight/668));
        
    }];

    self.selectTabel = [[XKRWUITableViewBase alloc]initWithFrame:CGRectZero style:0];
    self.selectTabel.backgroundColor = XKBGDefaultColor;
    self.selectTabel.delegate = (id)self;
    self.selectTabel.dataSource = (id)self;
    self.selectTabel.rowHeight = 60;
    self.selectTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backGroundAlertView addSubview:self.selectTabel];
    
    [self.selectTabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backGroundAlertView.top + 50);
        make.bottom.mas_equalTo(self.backGroundAlertView.bottom - 55);
        make.leading.mas_equalTo(self.backGroundAlertView.left + 15);
        make.trailing.mas_equalTo(self.backGroundAlertView.right - 15);
    }];
    [self.selectTabel registerNib:[UINib nibWithNibName:NSStringFromClass([XKRWSCPopSelectorCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XKRWSCPopSelectorCell class])];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.text = @"新小组上线! 推荐加入";
    self.titleLabel.textColor = [UIColor darkGrayColor];
    [self.backGroundAlertView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.backGroundAlertView.right);
        make.top.mas_equalTo(self.backGroundAlertView.top);
        make.height.mas_equalTo(50);
        make.leading.mas_equalTo(self.backGroundAlertView.left);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.cancelButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundAlertView addSubview:self.cancelButton];
    
    
    self.confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confimButton setTitle:@"加入" forState:UIControlStateNormal];
    [self.confimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.confimButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    [self.confimButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [self.confimButton addTarget:self action:@selector(confimData:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundAlertView addSubview:self.confimButton];
    
    
    [self.confimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.bottom.equalTo(self.backGroundAlertView.mas_bottom);
        make.left.equalTo(self.backGroundAlertView.mas_left);
        make.right.equalTo(self.cancelButton.mas_left);
        make.width.equalTo(self.cancelButton.mas_width);
    }];
    
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.bottom.equalTo(self.backGroundAlertView.mas_bottom);
        make.left.equalTo(self.confimButton.mas_right);
        make.right.equalTo(self.backGroundAlertView.mas_right);
        make.width.equalTo(self.confimButton.mas_width);
    }];
    
    UIView * bottomLine = [UIView new];
    bottomLine.backgroundColor = XKSepDefaultColor;
    [self.backGroundAlertView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.backGroundAlertView.mas_width);
        make.left.equalTo(self.backGroundAlertView.mas_left);
        make.top.equalTo(self.cancelButton.mas_top);
        make.height.mas_equalTo(@(0.5));
    }];
    
    UIView * middleLine = [UIView new];
    middleLine.backgroundColor = XKSepDefaultColor;
    [self.backGroundAlertView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundAlertView.mas_centerX);
        make.width.mas_equalTo(@(0.5));
        make.height.equalTo(self.cancelButton.mas_height);
        make.top.equalTo(self.cancelButton.mas_top);
    }];
}

- (void)show
{
    [KeyWindow addSubview:self.backGroundButton];
    [KeyWindow addSubview:self.backGroundAlertView];
}

- (void)dismiss:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)confimData:(UIButton *)sender
{
    if (self.selectArr.count == 0) {
        [XKRWCui showInformationHudWithText:@"请至少选择一个小组"];
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(popSelectorData:)]) {
        [self.delegate popSelectorData:self.selectArr];
    }
    [self dismiss:nil];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    if (self.selectArr.count > 0) {
        [self.selectArr removeAllObjects];
    }
    
    for (XKRWGroupItem * item in _dataSource) {
        if (![self.selectArr containsObject:item.groupId]) {
            [self.selectArr addObject:item.groupId]; //默认全选
        }
    }
    [self.selectTabel reloadData];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setBackGroudColor:(UIColor *)backGroudColor
{
    _backGroudColor = backGroudColor;
    self.backGroundButton.backgroundColor = _backGroudColor;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKRWSCPopSelectorCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRWSCPopSelectorCell class]) forIndexPath:indexPath];
    
    XKRWGroupItem * item = self.dataSource[indexPath.row];
   
    cell.groupId = item.groupId;
    [cell.groupHeaderIcon setImageWithURL:[NSURL URLWithString:item.groupIcon] placeholderImage:nil];
    cell.groupTitle.text = item.groupName;
    
    
    if ([self.selectArr containsObject:item.groupId]) {
        [cell setButtonState:YES];
    }else{
        [cell setButtonState:NO];
    }
    
    cell.handle = ^(BOOL selected, NSString * groupid){
        
        if (selected) {
            if (![self.selectArr containsObject:groupid]) {
                [self.selectArr addObject:groupid];
            }
        }else{
            if ([self.selectArr containsObject:groupid]) {
                [self.selectArr removeObject:groupid];
            }
        }
    };
    
    return cell;
}

#pragma mark - Table view delegate

//In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end




