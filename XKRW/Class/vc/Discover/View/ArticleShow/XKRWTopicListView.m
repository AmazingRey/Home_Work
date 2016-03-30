//
//  XKRWTopicListView.m
//  XKRW
//
//  Created by Shoushou on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWTopicListView.h"
#import "XKRWTopicListCell.h"

@implementation XKRWTopicListView
{
    XKRWUITableViewBase *_tableView;
    NSMutableArray *_selfDataArray;
    NSInteger _numOfRows;
    BOOL _isfold;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, XKAppWidth, 1)];
    if (self) {
        _isfold = YES;

        _tableView = [[XKRWUITableViewBase alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 1) style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.scrollsToTop = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"XKRWTopicListCell" bundle:nil] forCellReuseIdentifier:@"topicListCell"];
        
        _foldCell = [[NSBundle mainBundle] loadNibNamed:@"XKRWFoldCell" owner:nil options:nil].lastObject;
        
        [self addSubview:_tableView];
    }
    return self;
}
- (void)setViewTitles:(NSArray *)titles {
    _selfDataArray = [NSMutableArray array];
    
    _numOfRows = (titles.count + 1)/2;
    for (int i = 0; i < _numOfRows; i++) {
        NSMutableArray *mutArray = [NSMutableArray array];
        
        if (i == _numOfRows - 1 && titles.count %2 ) {
            [mutArray addObject:titles.lastObject];
        } else {
            [mutArray addObject:titles[i * 2]];
            [mutArray addObject:titles[i * 2 + 1]];
        }
        [_selfDataArray addObject:mutArray];
    }
    
    
    [_tableView reloadData];
    [self resetFrame];
}

- (void)resetFrame {
    CGSize size = _tableView.contentSize;
    self.size = size;
    _tableView.size = size;
}

#pragma mark - Cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_numOfRows > 2) {
        
        if (_isfold) {
            return 3;
        } else {
            return _numOfRows + 1;
        }
    } else {
        return _numOfRows;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 2 || (_numOfRows >2 && !_isfold && indexPath.row < _numOfRows)) {
        XKRWTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicListCell" forIndexPath:indexPath];
        [cell setTitles:_selfDataArray[indexPath.row]];
        
        cell.leftBtn.tag = indexPath.row * 2;
        cell.rightBtn.tag = indexPath.row * 2 + 1;
        [cell.leftBtn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightBtn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (_numOfRows > 2 && ((_isfold && indexPath.row == 1) || (!_isfold && indexPath.row == _numOfRows - 1))) {
            [cell setLastCellStyle];
        }
        
        return cell;
        
    } else {
        
        return _foldCell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == [tableView numberOfRowsInSection:0] - 1 && _foldCell.foldCellClicked && [_foldCell respondsToSelector:@selector(foldCellClicked)]) {
        _isfold = !_isfold;
        if (_isfold) {
            [_foldCell fold];
        } else {
            [_foldCell unfold];
        }
        [UIView performWithoutAnimation:^{
            [tableView reloadData];
        }];
        [self resetFrame];
        _foldCell.foldCellClicked();
    }
    
}

#pragma mark - action

- (void)itemClicked:(UIButton *)sender {
    
    typeof(self) __weak weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(topicListView: didSelectItemAtIndex:)]) {
        [_delegate topicListView:weakSelf didSelectItemAtIndex:sender.tag];
    }
}

@end
