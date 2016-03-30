//
//  XKRWEvaluatingProblemCell.m
//  XKRW
//
//  Created by 忘、 on 15-1-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWEvaluatingProblemCell.h"

@implementation XKRWEvaluatingProblemCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_needLayoutSubviews) {
        [self initViewWithEvaluatingCellNum:[_cellTitleArray count] currentStageColor:_color];
        
        if (_cellType == iSlimCellTypeSort) {
            [self initData];
        }
    }
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                         page:(NSInteger)page
                iSlimCellType:(iSlimCellType)type
                   titleArray:(NSArray *)titles
                        color:(UIColor *)color {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier page:page];
    if (self) {
        self.cellTitleArray = titles;
        self.color = color;
        self.cellType = type;
        
        [self initViewWithEvaluatingCellNum:[_cellTitleArray count] currentStageColor:_color];
        
        if (_cellType == iSlimCellTypeSort) {
            [self initData];
        }
    }
    return self;
}

- (void)initViewWithEvaluatingCellNum:(NSInteger) cellNumber currentStageColor:(UIColor *)color;
{
   // self.contentView.backgroundColor = colorSecondary_f4f4f4;
    if(_evaluatingTableView == nil)
    {
        if (_cellType == iSlimcellTypeMultipleLine) {
            _evaluatingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 64.f*cellNumber)];
        }else
        {
            _evaluatingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 44.f*cellNumber)];
        }
    }
    _evaluatingTableView.delegate = self;
    _evaluatingTableView.dataSource = self;
    if (_cellType == iSlimCellTypeSort) {
        _evaluatingTableView.editing = YES;
    }
    _evaluatingTableView.scrollEnabled = NO;
    _evaluatingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_evaluatingTableView];
    
//    if (44.f*cellNumber > XKAppHeight) {
//        self.height = 44.f*cellNumber;
//    } else {
//        self.height = XKAppHeight;
//    }
    
    self.contenHeight = 44.f * cellNumber;
    
//    if (_cellType != iSlimCellTypeCustom) {
//        if(progressBarView == nil)
//        {
//            progressBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, self.height)];
//        }
//        progressBarView.backgroundColor = color;
//        progressBarView.alpha = 0.3;
//        [self addSubview:progressBarView];
//        if (_cellType == iSlimCellTypeSort) {
//            for (int i = 0; i <[_cellTitleArray count]; i++) {
//                UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44*i, 15, 44)];
//                numLabel.text = [NSString stringWithFormat:@"%i",i+1];
//                numLabel.textColor = XKMainToneColor_29ccb1;
//                numLabel.textAlignment = NSTextAlignmentCenter;
//                numLabel.font = XKDefaultFontWithSize(14.f);
////                [progressBarView addSubview:numLabel];
//            }
//        }
//    }else
    if (_cellType == iSlimCellTypeSort){
        UIImageView *numberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 8, 305)];
        numberImageView.image = [UIImage imageNamed:@"num_image"];
        
        [self addSubview:numberImageView];
    }

}


- (void)initData
{
    if (_checkedArray == nil) {
        _checkedArray = [NSMutableArray arrayWithCapacity:[_cellTitleArray count]];
        
        for (int i = 0; i < [_cellTitleArray count]; i++) {
            [_checkedArray addObject:[NSString stringWithFormat:@"%c",'A'+i]];
        }
    }
}

/**
 *  检查已经选择的个数
 */
- (BOOL)checkSelectedNum
{
    if ([_checkedArray count]==_mostSelectedNum &&[_checkedArray count]!=0) {
        return NO;
    }
    return YES;
}

#pragma --mark  UITableViewDatasource  UITableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellTitleArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel *titleLabel;
    UIView *lineView;
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
      //  cell.backgroundColor = colorSecondary_f4f4f4;
    }
  
    if(titleLabel == nil)
    {
        titleLabel = [[UILabel alloc]init];
    }
    if (_cellType == iSlimCellTypeSort) {
        titleLabel.frame = CGRectMake(40, (44-30)/2, 240, 30);
        if (indexPath.row == 0) {
            if ([[XKRWServerPageService sharedService] isShowSortRemindImageView]) {
                sortRemindImageView = [[UIImageView alloc]initWithFrame:CGRectMake(XKAppWidth-47-80,0, 80, 44)];
                sortRemindImageView.image = [UIImage imageNamed:@"sort_remind"];
                
                [cell.contentView addSubview:sortRemindImageView];
            }
           
        }
        
        
    }else if (_cellType == iSlimcellTypeMultipleLine)
    {
        titleLabel.frame = CGRectMake(35, (64-50)/2, 240, 50);
        titleLabel.numberOfLines = 0;
    }else if (_cellType == iSlimCellTypeCustom){
        titleLabel.frame = CGRectMake(50, (44-30)/2, 240, 30);
    }
    else{
      
        titleLabel.frame = CGRectMake(35, (44-30)/2, 240, 30);
        
    }
    
    if (_cellType == iSlimcellTypeMultipleLine) {
        NSMutableAttributedString *attributedStr = [XKRWUtil createAttributeStringWithString:[_cellTitleArray objectAtIndex:indexPath.row] font:XKDefaultFontWithSize(14.f) color:colorSecondary_666666 lineSpacing:3.5 alignment:NSTextAlignmentLeft];
        titleLabel.attributedText = attributedStr;
    }else{
        titleLabel.textColor = colorSecondary_666666;
        titleLabel.text = [_cellTitleArray objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    
   
    [cell.contentView addSubview:titleLabel];
    UIImageView *selectImageView = [[UIImageView alloc]init];
    
    if (_cellType != iSlimCellTypeSort) {
    //    if (_cellType == iSlimCellTypeCustom) {
            selectImageView.frame = CGRectMake(XKAppWidth-60, 0, 60, 44);
//        }else{
//            selectImageView.frame = CGRectMake(XKAppWidth-60, (64-44)/2, 60, 44);
//        }
         selectImageView.image = [UIImage imageNamed:@"SelectMulti"];
    }
    [cell.contentView addSubview:selectImageView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_cellType != iSlimCellTypeSort) {
        if ([_checkedArray containsObject:[_cellTitleArray objectAtIndex:indexPath.row]])
        {
            selectImageView.image = [UIImage imageNamed:@"SelectMulti_s"];
            [titleLabel setTextColor:XKMainToneColor_29ccb1];
        }else
        {
            selectImageView.image = [UIImage imageNamed:@"SelectMulti"];
            [titleLabel setTextColor:colorSecondary_666666];
        }
    }
    if (_cellType == iSlimCellTypeCustom) {
            lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, XKAppWidth, 0.5)];
        if(_isShowLine)
        {
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(30+(10-1)/2, 0 , 1, 44)];
            lineView1.backgroundColor = XKMainToneColor_29ccb1;
            [cell.contentView addSubview:lineView1];
        }
    }else
    {
        if (_cellType == iSlimcellTypeMultipleLine) {
            lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, XKAppWidth, 0.5)];
        }else
        {
            lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, XKAppWidth, 0.5)];
        }
    }
    lineView.backgroundColor = XK_ASSIST_LINE_COLOR;

    [cell.contentView addSubview:lineView];
    
 //   cell.contentView.backgroundColor = colorSecondary_f4f4f4;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_cellType == iSlimCellTypeCustom) {
//        return 44.f;
//    }else
//    {
//        return 64.f;
//    }
    if (_cellType == iSlimcellTypeMultipleLine) {
        return 64.f;
    }else
    {
        return 44.f;
    }
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellType == iSlimCellTypeSort) {
         return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
 
    id  source =   [_checkedArray objectAtIndex:sourceIndexPath.row];
    [_checkedArray removeObjectAtIndex:sourceIndexPath.row];
    [_checkedArray insertObject:source atIndex:destinationIndexPath.row];
    
    if (sortRemindImageView) {
        sortRemindImageView.hidden = YES;
        [[XKRWServerPageService sharedService] setShowSortRemindImageView:NO];
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (_cellType != iSlimCellTypeSort) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_checkedArray];
        if (_cellType == iSlimCellTypeMultiple) {
            
            
            if ([array containsObject:@"无"] ||[array containsObject:@"没有"] || [[_cellTitleArray objectAtIndex:indexPath.row] isEqualToString:@"无"]|| [[_cellTitleArray objectAtIndex:indexPath.row] isEqualToString:@"没有"] ) {
                [array removeAllObjects];
              
            }
            
            
            if ([array containsObject:[_cellTitleArray objectAtIndex:indexPath.row]])
            {
                [array removeObject:[_cellTitleArray objectAtIndex:indexPath.row]];
            }
            else
            {
                if ([self checkSelectedNum]) {
                    [array addObject:[_cellTitleArray objectAtIndex:indexPath.row]];
                }else
                {
                    _block();
                }
            }
        }else{
            [array removeAllObjects];
            [array addObject:[_cellTitleArray objectAtIndex:indexPath.row]];
        }
        self.checkedArray = array;
        [tableView reloadData];
        
        if (_cellType == iSlimCellTypeCustom) {
            if([self.refreshDelegate respondsToSelector:@selector(refreshSelectedStateFromResult:isSelected:selectTitle:)])
            {
                [self.refreshDelegate refreshSelectedStateFromResult:_selectedSection isSelected:1 selectTitle:[_cellTitleArray objectAtIndex:indexPath.row]];
            }
        }
        
    }
    
}

#pragma mark - 重写父类方法

/**
 *  通过用户选择获取用户答案
 *
 *  @return 返回用户答案
 */
- (NSString *)getTheAnswerFromUserSelect
{

    NSLog(@"%@",_checkedArray);
    
    if (_cellType == iSlimCellTypeSingle || _cellType == iSlimcellTypeMultipleLine) {
        for(int i = 0;i <[_cellTitleArray count];i++)
        {
            if ([[_checkedArray objectAtIndex:0] isEqualToString:[_cellTitleArray objectAtIndex:i]]) {
                return [self getUserSelect:i];
            }
        }
        return nil;
    }else if (_cellType == iSlimCellTypeMultiple){
        return [self getCustomCellSelect:_cellTitleArray checkArray:_checkedArray];
    }else if (_cellType == iSlimCellTypeSort){
        
        NSMutableString *sortStr = [NSMutableString string];
        
        
        for (int i = 0; i <[_checkedArray count]; i++) {
            NSString *str = [NSString stringWithFormat:@"%@",[_checkedArray objectAtIndex:i]];
            
            if (sortStr.length == 0 ) {
                [sortStr appendString:str];
            }else{
                [sortStr appendFormat:@",%@",str];
            }
        }
        return sortStr;
    }
    
    
    
    return nil;
}




- (void)saveAnswer {
    self.answer = [self getTheAnswerFromUserSelect];
    [super saveAnswer];
}

- (BOOL)checkComplete {
    NSString *str = [self getTheAnswerFromUserSelect];
    if (str != nil && str.length != 0) {
         return YES;
    } else {
        return NO;
    }
}


@end
