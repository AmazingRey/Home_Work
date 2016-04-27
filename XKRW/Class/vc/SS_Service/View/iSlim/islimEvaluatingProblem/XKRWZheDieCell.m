//
//  XKRWZheDieCell.m
//  XKRW
//
//  Created by 忘、 on 15-2-4.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWZheDieCell.h"

@implementation XKRWZheDieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier page:(NSInteger)page
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier page:page];
    if (self) {
        [self initView];
       
    }
    return  self;
}



- (void)initSubviews
{
    if (44.f*[_sectionTitleArray count]+44.f*[_cellTitleArray count] > XKAppHeight) {
        self.height = 44.f*[_sectionTitleArray count]+44.f*[_cellTitleArray count] ;
    }else{
        self.height = XKAppHeight;
    }
    foldTableView.frame = CGRectMake(0, 0, XKAppWidth, self.height);
    self.contenHeight = 44.f * [_sectionTitleArray count] + 44.f * [_cellTitleArray count];
    [self initData];
}

- (void)initView
{
    if(foldTableView == nil)
    {
        foldTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-44) style:UITableViewStylePlain];
    }
    
    foldTableView.delegate = self;
    foldTableView.dataSource = self;
    foldTableView.scrollEnabled = NO;
    foldTableView.backgroundColor = [UIColor clearColor];
    
    foldTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:foldTableView];
    
}

- (void)initData
{
    if (checkStateArray == nil) {
        checkStateArray = [NSMutableArray arrayWithCapacity:_sectionTitleArray.count];
        
        for (int i =0 ; i <[_sectionTitleArray count ]; i++) {
            NSMutableArray *array = [NSMutableArray array];
            [checkStateArray addObject:array];
        }
    }
    
}

#pragma --mark UItableviewDelegate  UItableviewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectSection == section) {
           return  1;
    }else {
            return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f *[_cellTitleArray count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, XKAppWidth-65, 44)];
    titleLabel.text = [_sectionTitleArray objectAtIndex:section];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (44-10)/2, 10, 10)];
    imageView.tag = 20000+section;
    
    
    if ([[checkStateArray objectAtIndex:section] count]!= 0) {
        imageView.image = [UIImage imageNamed:@"circle_01_"];
         titleLabel.textColor = XKMainToneColor_29ccb1;
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"circle_02_"];
        titleLabel.textColor = colorSecondary_333333;
    }
    [view addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, XKAppWidth, view.height);
    button.tag = 100+section;
    [button addTarget:self action:@selector(foldButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.5, XKAppWidth, .5)];
    lineImage.backgroundColor = colorSecondary_e0e0e0;
    [view addSubview:lineImage];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectSection == indexPath.section) {
        static NSString *identifier = @"cell";
        XKRWEvaluatingProblemCell * cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        
        if (cell == nil ) {
            cell = [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.needLayoutSubviews = YES;
        }
        cell.cellTitleArray= _cellTitleArray;
        cell.cellType = _cellType;
        cell.refreshDelegate = self;
        cell.selectedSection = selectSection;
        cell.checkedArray = [checkStateArray objectAtIndex:selectSection];
        if (selectSection == [_sectionTitleArray count]-1) {

        }
        return cell;
        
    } else {
        return nil;
    }
}


#pragma --mark    action
-(void)foldButtonAction:(UIButton *)sender
{
    selectSection = sender.tag -100;
    [foldTableView reloadData];
}

#pragma --mark  XKRWEvaluatingProblemCellDelegate

- (void)refreshSelectedStateFromResult:(NSInteger)Section isSelected:(NSInteger)state selectTitle:(NSString *)title
{
   
    NSMutableArray *selectArray = [NSMutableArray arrayWithCapacity:1];
    [selectArray addObject:title];
    [checkStateArray replaceObjectAtIndex:Section withObject:selectArray];
    selectSection = [self getSelectSection:Section];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [foldTableView reloadData];
    });
}

/**
 *  <#Description#>
 *
 *  @param curSection <#curSection description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger) getSelectSection:(NSInteger) curSection
{
    if (curSection < [_sectionTitleArray count]-1) {
        if ([self checkAllOptionIsComplete:checkStateArray]) {
            return curSection;
        }else
        {
            return curSection+1;
        }
    }else
    {
        if ([self checkAllOptionIsComplete:checkStateArray]) {
            return curSection;
        }else{
            for (int i = 0; i <[checkStateArray count]; i++) {
                if ([[checkStateArray objectAtIndex:i] count] == 0) {
                    return i;
                }
            }

            return curSection;
        }
    }
}


#pragma mark - 重写父类方法

- (NSString *)getTheAnswerFromUserSelect
{
    XKLog(@"%@",checkStateArray);
    NSMutableString *zhedieStr = [NSMutableString string];
    
    for (int i = 0; i <[checkStateArray count]; i++) {
        if (zhedieStr.length == 0) {
            [zhedieStr appendString: [self getCustomCellSelect:_cellTitleArray checkArray:[checkStateArray objectAtIndex:i]]];
        }else{
            [zhedieStr appendFormat:@",%@",[self getCustomCellSelect:_cellTitleArray checkArray:[checkStateArray objectAtIndex:i]]];
        }
    }
    return zhedieStr;
}


- (BOOL)checkAllOptionIsComplete:(NSMutableArray *)checkArray
{
    for (int i = 0; i <[checkArray count]; i++) {
        if ([[checkArray objectAtIndex:i] count] == 0) {
            return NO;
        }
    }
    
    return YES;
}


- (void)saveAnswer {
    self.answer = [self getTheAnswerFromUserSelect];
    [super saveAnswer];
}

- (BOOL)checkComplete {
    if ([self checkAllOptionIsComplete:checkStateArray]) {
        return YES;
    } else {
        return NO;
    }
}


@end
