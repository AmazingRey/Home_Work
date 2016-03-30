//
//  XKRWActionSheet.m
//  XKRW
//
//  Created by Shoushou on 16/1/5.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWActionSheet.h"
#import "XKRWShareView.h"
#import "XKRWActionSheetCell.h"
#import "XKRWActionSheetTitleHeader.h"

@interface XKRWActionSheet ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) NSString *destructiveTitle;
@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation XKRWActionSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];

    if (self) {
        self.frame = CGRectMake(0, XKAppHeight, XKAppWidth, XKAppHeight);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        self.backgroundColor = XKClearColor;
        self.hidden = YES;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = XKBGDefaultColor;
        self.tableView.userInteractionEnabled = YES;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        
        [self.tableView registerNib:[UINib nibWithNibName:@"XKRWActionSheetCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        [self addSubview:self.tableView];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle {
    self = [self init];
    
    if (self) {
        if (title != nil) {
            XKRWActionSheetTitleHeader *header = [[NSBundle mainBundle] loadNibNamed:@"XKRWActionSheetTitleHeader" owner:nil options:nil].lastObject;
            header.titleLabel.text = title;
            self.tableView.tableHeaderView = header;
        }
        
        [self setCancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitle:otherButtonTitle];
    }
    
    return self;
    
}

- (instancetype)initShareHeaderSheetWithCancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle {
    self = [self init];
    if (self) {
        XKRWShareView *shareView = [[NSBundle mainBundle] loadNibNamed:@"XKRWShareView" owner:nil options:nil].lastObject;
        
        typeof(self) __weak weakSelf = self;
        shareView.clickBlock = ^(NSInteger tag){
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(actionSheet:clickedHeaderAtIndex:)]) {
                [weakSelf.delegate actionSheet:weakSelf clickedHeaderAtIndex:tag];
                [weakSelf removeSelf];
            }
        };
        self.tableView.tableHeaderView = shareView;
        
        [self setCancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitle:otherButtonTitle];
    }
    return self;
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle {
    self.destructiveTitle = destructiveButtonTitle;
    self.cancelTitle = cancelButtonTitle;
    self.titles = [NSMutableArray array];
    
    if (otherButtonTitle != nil) {
        [self.titles addObject:otherButtonTitle];
    }
    [self resetDestructiveButtonIndex];
    [self.tableView reloadData];
    CGSize size = self.tableView.contentSize;
    self.tableView.size = size;
    
    self.tableView.origin = CGPointMake(0, XKAppHeight - size.height);
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    [self.titles addObject:title];
    [self.tableView reloadData];
    CGSize size = self.tableView.contentSize;
    self.tableView.origin = CGPointMake(0, XKAppHeight - size.height);
    self.tableView.size = size;
    [self resetDestructiveButtonIndex];
    
    return self.titles.count;
}

- (void)showInView:(UIView *)view {
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    self.hidden = NO;
    
    CGSize size = self.tableView.size;
    self.tableView.origin = CGPointMake(0, XKAppHeight - size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.origin = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        }
    }];
}

- (void)removeSelf {
    self.backgroundColor = XKClearColor;
    [UIView animateWithDuration:0.3 animations:^{
        self.origin = CGPointMake(0, XKAppHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)resetDestructiveButtonIndex {
    if (_destructiveTitle != nil) {
        self.destructiveButtonIndex = self.titles.count;
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIView *view = touch.view;
    if ([view isKindOfClass:NSClassFromString(@"XKRWActionSheet")]) {
        return YES;
    } else {
        return NO;
    }

}

#pragma mark - Cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKRWActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[XKRWActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0) {
        if (self.destructiveTitle != nil && indexPath.row == self.titles.count) {
            cell.titleLabel.textColor = XKWarningColor;
            cell.titleLabel.text = self.destructiveTitle;
        } else {
            cell.titleLabel.text = self.titles[indexPath.row];
        }

    } else {
        cell.titleLabel.text = self.cancelTitle;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.destructiveTitle != nil) {
            return self.titles.count + 1;
        } else {
            return self.titles.count;
        }
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_cancelTitle) {
        return 2;
    } else {
        return 1;  
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        typeof(self) __weak weakSelf = self;
        if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
            [_delegate actionSheet:weakSelf clickedButtonAtIndex:indexPath.row];
            [self removeSelf];
        }
    } else {
        if (self.cancelButtonClicked) {
            self.cancelButtonClicked();
        }
        [self removeSelf];
    }
    
}

#pragma mark Header

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    if (section == 1) {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
        header.backgroundColor = XKClearColor;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    } else {
        return 0;
    }
}

@end
