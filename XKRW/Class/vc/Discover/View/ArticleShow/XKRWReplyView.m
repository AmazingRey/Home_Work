//
//  XKRWReplyView.m
//  XKRW
//
//  Created by Shoushou on 15/12/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWReplyView.h"
#import "XKRWReplyCell.h"

@interface XKRWReplyView ()<UITableViewDelegate,UITableViewDataSource,XKRWReplyCellDelegate,TYAttributedLabelDelegate>
@property (nonatomic, strong) NSArray *entityArray;
@property (nonatomic, strong) UIImage *angleImage;
@property (nonatomic, strong) UIImageView *angleImageView;
@end

@implementation XKRWReplyView

- (instancetype)initWithDataArray:(NSArray *)dataArray {
    self = [super init];
    
    if (self) {
        self.backgroundColor = XKClearColor;
        if (dataArray.count) {
            _entityArray = dataArray;
            _angleImage = [UIImage imageNamed:@"assessment_xsj"];
            _angleImageView = [[UIImageView alloc] initWithImage:_angleImage];
            _angleImageView.frame = CGRectMake(10, 0, _angleImage.size.width, _angleImage.size.height);
            [self addSubview:_angleImageView];
            
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _angleImageView.bottom, XKAppWidth - 70 - 15, 0) style:UITableViewStylePlain];
            _tableView.layer.cornerRadius = 2.5;
            _tableView.scrollEnabled = NO;
            _tableView.backgroundColor = [UIColor colorFromHexString:@"#f4f4f4"];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_tableView registerClass:[XKRWReplyCell class] forCellReuseIdentifier:@"replyCell"];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [self addSubview:_tableView];
            
            [_tableView reloadData];
            CGFloat height = _tableView.contentSize.height;
            _tableView.frame = CGRectMake(0, _angleImageView.bottom - 1, XKAppWidth - 70 - 15, height);
            [self resetViewFrame];
        }
    } else {
        return nil;
    }
    
    return self;
}

- (void)resetViewFrame {
    self.frame = CGRectMake(70, 0, XKAppWidth - 70 - 15, CGRectGetHeight(_tableView.frame) + _angleImage.size.height);
}

#pragma mark - Cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _entityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKRWReplyCell *cell = [[XKRWReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"replyCell"];
    cell.entity = _entityArray[indexPath.row];
    return cell.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKRWReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"replyCell"];
    
    if (!cell) {
        cell = [[XKRWReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"replyCell"];
        }
    cell.entity = _entityArray[indexPath.row];
    cell.replyCellIndexPath = indexPath;
    cell.delegate = self;
    typeof(self) __weak weakSelf = self;
    cell.nickNameBlock = ^(NSString *nickName1){
        if (weakSelf.nickNameBlock1) {
            weakSelf.nickNameBlock1(nickName1);
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    typeof(self) __weak weakSelf = self;
    if (self.delegate) {
        [_delegate replyView:weakSelf didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Header&Footer
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 5)];
    header.backgroundColor = XKClearColor;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 5)];
    footer.backgroundColor = XKClearColor;
    return footer;
}


#pragma mark -XKRWReplyCellDelegate

- (void)replyCell:(XKRWReplyCell *)replyCell longPressedWithIndexPath:(NSIndexPath *)replyCellIndexPath {
    
    typeof(self) __weak weakSelf = self;
    if (self.delegate) {
        [_delegate replyView:weakSelf didLongPressedAtIndexPath:replyCellIndexPath];
    }
}

@end
