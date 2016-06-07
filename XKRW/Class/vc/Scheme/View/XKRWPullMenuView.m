//
//  XKRWPullMenuView.m
//  XKRW
//
//  Created by ss on 16/6/6.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPullMenuView.h"
#import "Masonry.h"
#import "XKRWPullMenuNormalCell.h"
#import "XKRWPullMenuTextCell.h"

@implementation XKRWPullMenuView
{
    CGFloat tableHeight;
    NSString *cellidenty;
    CGFloat arrowImageWidth;
    CGFloat arrowImageHeight;
    BOOL isNotPureText;
}

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)itemArray imageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemArray = itemArray;
        self.imageArray = imageArray;
        isNotPureText = self.imageArray.count == self.itemArray.count;
        if (isNotPureText) {
            arrowImageWidth = 10;
            arrowImageHeight = 5;
            cellidenty = @"pullMenuNormalCell";
        }else{
            arrowImageWidth = 13;
            arrowImageHeight = 7;
            cellidenty = @"pullMenuTextCell";
        }
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        [self addSubview:self.arrowImageView];
    }
    return self;
}

-(UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = self.frame;
        frame.origin.y = arrowImageHeight - 1;
        frame.size.height -= arrowImageHeight - 1;
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.scrollEnabled = false;
        _tableView.separatorColor = XKSepDefaultColor;
        _tableView.layer.borderWidth = 0.5;
        _tableView.layer.borderColor = [UIColor colorFromHexString:@"#c8c8c8"].CGColor;
        _tableView.layer.cornerRadius = 5;
        _tableView.backgroundColor = [UIColor colorFromHexString:@"f0f0f0"];
        _tableView.clipsToBounds = YES;
    }
    return _tableView;
}

-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        CGRect frame = self.frame;
        if (isNotPureText) {
            frame.origin.x = frame.size.width - 30;
        }else{
            frame.origin.x = frame.size.width - 23;
        }
        frame.size.width = arrowImageWidth;
        frame.size.height = arrowImageHeight;
        _arrowImageView = [[UIImageView alloc] initWithFrame:frame];
        _arrowImageView.image = [UIImage imageNamed:@"triangle5_3"];
    }
    return _arrowImageView;
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = (self.frame.size.height - self.arrowImageView.frame.size.height + 1)/self.itemArray.count;
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cellidenty isEqualToString:@"pullMenuNormalCell"]) {
        XKRWPullMenuNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
        if (!cell) {
            cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWPullMenuNormalCell");
        }
        NSString *str = [self.itemArray objectAtIndex:indexPath.row];
        UIImage *image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
        cell.label.text = str;
        cell.imgView.image = image;
        
        return cell;
    }else if ([cellidenty isEqualToString:@"pullMenuTextCell"]){
        XKRWPullMenuTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
        if (!cell) {
            cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWPullMenuTextCell");
        }
        NSString *str = [self.itemArray objectAtIndex:indexPath.row];
        cell.lab.text = str;
        return cell;
    }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pressBtnWithText:[self.itemArray objectAtIndex:indexPath.row]];
}

#pragma mark XKRWPullMenuViewDelegate
-(void)pressBtnWithText:(NSString *)str{
    if ([self.delegate respondsToSelector:@selector(pressPullViewWithTitleString:)]) {
        [self.delegate pressPullViewWithTitleString:str];
    }
}

@end
