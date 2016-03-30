//
//  XKPickerView.m
//  MyPicker
//
//  Created by yaowq on 14-3-3.
//  Copyright (c) 2014年 yaowq. All rights reserved.
//

#import "XKPickerView.h"

@interface XKPickerViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XKPickerViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kPickerViewWidth, kCellHeight)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_titleLabel];

    }

    return self;
}

@end

@interface XKPickerView()

@property (strong, nonatomic) NSMutableDictionary  * selectDic;
@property (strong, nonatomic) NSMutableArray       * contents;
@property (strong, nonatomic) NSMutableArray       * alarmItems;
@property (nonatomic, assign) int                    contentLBH;
@end

@implementation XKPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        columnNumbers  = 0;
        self.bgColor   = [UIColor clearColor];
        self.width     = kPickerViewWidth;
        self.selectDic = [[NSMutableDictionary alloc] init];
        self.contents  = [NSMutableArray array];
        
        [self createGrayView];
    }
    return self;
}

- (void)createGrayView
{
    self.lineV = [[UIView alloc] initWithFrame:CGRectMake(0, (kPickerViewHeight-kCellHeight)/2+5, 190, kCellHeight)];
    [_lineV setBackgroundColor:XKMainToneColor_00b4b4];
    _lineV.alpha = .6;
    
    self.lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, (kPickerViewHeight-kCellHeight)/2+5-0.7, 190, 0.5)];
    [_lineView1 setBackgroundColor:[UIColor colorFromHexString:@"#b2b2b2"]];
    self.lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0,(kPickerViewHeight-kCellHeight)/2+5+kCellHeight+0.2, 190, 0.5)];
    [_lineView2 setBackgroundColor:[UIColor colorFromHexString:@"#b2b2b2"]];
    
    [self addSubview:_lineView1];
    [self addSubview:_lineView2];
    
    [self addSubview:_lineV];

}
//提醒项目选择
-(void)selectedRow:(int)row;
{
    if (row==0) {
        row=0;
    }
//    [self.selectDic setObject:[NSNumber numberWithInt:row] forKey:[NSNumber numberWithInt:column]];
    [self reloadData:row];
}
//时间点选择 两行  时  分
- (void)selectedRow:(NSInteger)row  InColumn:(NSInteger)column
{

    if(row < 0)
    {
        row = 0;
    }
    
    [self.selectDic setObject:[NSNumber numberWithInteger:row] forKey:[NSNumber numberWithInteger:column]];
    
    
    [self reloadData:column];
}
//重复周期选择 周一-周日
- (void)addContent
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    if (_contents && _contents.count) {
        [_contents removeAllObjects];
    }
    
    columnNumbers = [self numberOfColumn];
    
    
    for (int i = 0; i < columnNumbers; i++)
    {
        UITableView *tableView = nil;
        if (columnNumbers == 3) {
            if (i == 1) {
                tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*(_width/columnNumbers)+(self.frame.size.width - _width)/2 -20 + 27, 5, _width/columnNumbers, kPickerViewHeight) style:UITableViewStylePlain];
            }
            else {
                tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*(_width/columnNumbers)+(self.frame.size.width - _width)/2 -20 + i*20, 5, _width/columnNumbers, kPickerViewHeight) style:UITableViewStylePlain];
            }
        }
        else {
            tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*(_width/columnNumbers)+(self.frame.size.width - _width)/2, 5, _width/columnNumbers, kPickerViewHeight) style:UITableViewStylePlain];
        }
        
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = i;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = _bgColor;
        [self.contents addObject:tableView];
        [self addSubview:tableView];
        
    [self.selectDic setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:i]];
       
    }



}
-(void)resetLayoutWithFontSize:(int)fontSize{
   
    _contentLBH  = fontSize;
    
    for (UIView * view in self.contents) {
       CGRect frame = CGRectMake(view.tag * (_width/columnNumbers) + (self.frame.size.width - _width)/2, 5, _width/columnNumbers, kPickerViewHeight);
        
        view.frame = frame;
        if ([view isKindOfClass:[UITableView class]]) {

            UITableView * table = (UITableView *)view;
            
            [table reloadData];
        }
    }
}

- (void)reloadData
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            UITableView *tableV = (UITableView *)view;
            NSNumber *number = [self.selectDic objectForKey:[NSNumber numberWithInteger:tableV.tag]];
            
            [tableV setContentOffset:CGPointMake(tableV.contentOffset.x,[number intValue] *kCellHeight) animated:YES];
            [tableV reloadData];
        }
    }


}

- (void)reloadDataTwo
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            
            UITableView *tableV = (UITableView *)view;
            if (tableV.tag == 1 || tableV.tag == 2)
            {
                NSNumber *number = [self.selectDic objectForKey:[NSNumber numberWithInteger:tableV.tag]];
                
                [tableV setContentOffset:CGPointMake(tableV.contentOffset.x,[number intValue] *kCellHeight) animated:YES];
                [tableV reloadData];
            }
           
        }
    }
    
    
}

- (void)reloadData:(NSInteger) tag
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            UITableView *tableV = (UITableView *)view;
            if (tableV.tag == tag)
            {
                NSNumber *number = [self.selectDic objectForKey:[NSNumber numberWithInteger:tag]];
                
                [tableV setContentOffset:CGPointMake(tableV.contentOffset.x,[number intValue] *kCellHeight) animated:YES];
                 [tableV reloadData];
            }
           
        }
    }
    
    
}



//组数
- (NSInteger) numberOfColumn
{
    if ([self.pickerViewDelegate respondsToSelector:@selector(numbersOfColumnInPickerView:)]) {
        return [self.pickerViewDelegate numbersOfColumnInPickerView:self];
    }
    return 1;
}
//行数
- (NSInteger) numberOfRowsInColumn:(NSInteger)column
{
    if ([self.pickerViewDelegate respondsToSelector:@selector(pickerView:numberOfRowsInColumn:)]) {
        return [self.pickerViewDelegate pickerView:self numberOfRowsInColumn:column];
    }
    return 0;
}

//每行数据
- (NSString *)dataForRow:(NSInteger)row inColumn:(NSInteger)column
{
    
    if ([self.pickerViewDelegate respondsToSelector:@selector(pickerView:titleForRow:forColumn:)]) {
        return [self.pickerViewDelegate pickerView:self titleForRow:row forColumn:column];
    }
    return @"";
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [self numberOfRowsInColumn:tableView.tag]+kEmptyRows*2;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if (indexPath.row > kEmptyRows-1 && indexPath.row < [self numberOfRowsInColumn:tableView.tag]+kEmptyRows)
        {
           XKPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pickerViewCell"];
            if (cell == nil)
            {
                cell = [[XKPickerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickerViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = _bgColor;

            }
            
            cell.titleLabel.frame = CGRectMake(0, 0, _width/columnNumbers, kCellHeight);
            NSString *str = [self dataForRow:indexPath.row-kEmptyRows inColumn:tableView.tag];
            [cell.titleLabel setText:str];
            cell.titleLabel.font = [UIFont systemFontOfSize:_contentLBH?_contentLBH : 16];
            
            NSNumber *number = [self.selectDic objectForKey:[NSNumber numberWithInteger:tableView.tag]];
            
            if ([number intValue] == indexPath.row - kEmptyRows)
            {
                [cell.titleLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
            }
            
            else
            {
                [cell.titleLabel setTextColor:[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.0]];
            }
            
             return cell;

        }
        else
        {
          UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"pickerViewNoCell"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickerViewNoCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 cell.backgroundColor = _bgColor;
            }
        
            return cell;
        }

   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)sc
{
//    NSUInteger offset=round(sc.contentOffset.y/kCellHeight);
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:offset+3 inSection:0];
//    UITableView *tableView = (UITableView *)sc;
//    
//    XKPickerViewCell *middleCell = (XKPickerViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    
//    
//    for (int i = 0; i < [self numberOfRowsInColumn:tableView.tag]; i++)
//    {//遍历所有有内容的cell
//         NSIndexPath *indexP = [NSIndexPath indexPathForRow:i+3 inSection:0];
//        XKPickerViewCell *cell = (XKPickerViewCell *)[tableView cellForRowAtIndexPath:indexP];
//        if (cell == middleCell)
//        {
//            [cell.titleLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
//            
//        }
//        else
//        {
//            [cell.titleLabel setTextColor:[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.0]];
//            
//        }
//    }

}

-(void)scrollViewDidEndDragging:(UIScrollView *)sc willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self stopScroll:sc];

    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sc
{
     [self stopScroll:sc];
}

- (void)stopScroll:(UIScrollView *)sc
{
    NSUInteger offset=round(sc.contentOffset.y/kCellHeight);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:offset+3 inSection:0];
    UITableView *tableView = (UITableView *)sc;
    
    XKPickerViewCell *middleCell = (XKPickerViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
    for (int i = 0; i < [self numberOfRowsInColumn:tableView.tag]; i++)
    {//遍历所有有内容的cell
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:i+3 inSection:0];
        XKPickerViewCell *cell = (XKPickerViewCell *)[tableView cellForRowAtIndexPath:indexP];
        if (cell == middleCell)
        {
            [cell.titleLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
            
        }
        else
        {
            [cell.titleLabel setTextColor:[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.0]];
            
        }
    }

    //round()取整，使cell能与中间对齐
    CGPoint point = sc.contentOffset;

    if (point.y > sc.contentSize.height - sc.bounds.size.height ) {
        point.y = sc.contentSize.height - sc.bounds.size.height;
    }
    else if (point.y < 0) {
        point.y = 0;
    }
    
    [sc setContentOffset:CGPointMake(point.x, round(point.y/kCellHeight)*kCellHeight) animated:YES];
    
    int cellCountsOffset=round(point.y/kCellHeight);
    
//    UITableView *tableView = (UITableView *)sc;
    [self.selectDic setObject:[NSNumber numberWithInt:cellCountsOffset] forKey:[NSNumber numberWithInteger: tableView.tag]];
    
    [_pickerViewDelegate pickerView:self didSelectRow:cellCountsOffset inColumn:tableView.tag];

}



@end
