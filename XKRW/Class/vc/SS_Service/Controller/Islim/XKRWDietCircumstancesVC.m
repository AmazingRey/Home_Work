//
//  XKRWDietCircumstancesVC.m
//  XKRW
//
//  Created by 忘、 on 15-1-27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWDietCircumstancesVC.h"
#import "XKRWDescribeModel.h"

@interface XKRWDietCircumstancesVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray  *dietArray;
    NSArray  *titleArray;
}
@end

@implementation XKRWDietCircumstancesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initData
{
    dietArray = @[_dietModel.dietaryStatueArray,_dietModel.caloriesCtrlModel,_dietModel.repastPlanModel,_dietModel.extraMealModel];
    titleArray =@[@"饮食模式",@"热量控制",@"餐次安排",@"加餐偏好"];
}

- (void)initView
{
    self.title = @"饮食情况";
    
    [self addNaviBarBackButton];
    
    self.view.backgroundColor = colorSecondary_f4f4f4;
    
    dietCircumstancesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)];
    dietCircumstancesTableView.delegate = self;
    dietCircumstancesTableView.dataSource = self;
    dietCircumstancesTableView.backgroundColor = XK_BACKGROUND_COLOR;
    dietCircumstancesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    [self.view addSubview:dietCircumstancesTableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * up=[[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    up.backgroundColor=[UIColor colorFromHexString:@"#e0e0e0"];
    UIView * down=[[UIView alloc]initWithFrame:CGRectMake(0, 9.5, XKAppWidth, 0.5)];
    down.backgroundColor=[UIColor colorFromHexString:@"#e0e0e0"];
    
    if (section== [titleArray count]) {
        return nil;
    }else{
        [view addSubview:up];
        [view addSubview:down];
    }
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    
        XKRWIslimDietHeaderCell *headerCell = LOAD_VIEW_FROM_BUNDLE(@"XKRWIslimDietHeaderCell");
        headerCell.calorieControlLabel.text = _dietModel.caloriesCtrlModel.result;
        [XKRWUtil setLabelColor:headerCell.calorieControlLabel colorFlag:_dietModel.caloriesCtrlModel.flag];
        
        XKRWDescribeModel *describeModel = [_dietModel.dietaryStatueArray objectAtIndex:0];
        headerCell.dietModelLabel.text = describeModel.result;
        [XKRWUtil setLabelColor:headerCell.dietModelLabel colorFlag:describeModel.flag];
        
        if ([_dietModel.dietaryStatueArray count]>1) {
            XKRWDescribeModel *describeModel1 =  [_dietModel.dietaryStatueArray objectAtIndex:1];
            headerCell.dietModelLabel1.text = describeModel1.result;
            [XKRWUtil setLabelColor:headerCell.dietModelLabel1 colorFlag:describeModel1.flag];
        }
       
        headerCell.mealArrangeLabel.text = _dietModel.repastPlanModel.result;
        [XKRWUtil setLabelColor:headerCell.mealArrangeLabel colorFlag:_dietModel.repastPlanModel.flag];
        headerCell.extraPreferenceLabel.text =_dietModel.extraMealModel.result;
        [XKRWUtil setLabelColor:headerCell.extraPreferenceLabel colorFlag:_dietModel.extraMealModel.flag];
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        return headerCell;
    }else if (indexPath.section == 1)
    {
        XKRWIslimDietCell *cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWIslimDietCell");
      
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = [titleArray objectAtIndex:indexPath.section-1];
        NSArray  *array = [dietArray objectAtIndex:indexPath.section-1];
        XKRWDescribeModel *describeModel = [array objectAtIndex:0];
    
        
        cell.tagLabel.text = describeModel.result;
        cell.tagLabel.textAlignment = NSTextAlignmentCenter;
        cell.tagLabel.layer.masksToBounds = YES;
        cell.tagLabel.layer.cornerRadius = 10;
        cell.tagLabel.frame =[self resetLabelFrame:cell.tagLabel labelText:describeModel.result];
        
        
        CGSize tagSize = [XKRWUtil sizeOfStringWithFont:describeModel.result width:CGFLOAT_MAX font:[UIFont systemFontOfSize:14.f]];
        cell.tagLabelWidth.constant = tagSize.width + 20;
        
        XKRWDescribeModel *describeModel1 = nil;
//        if ([array count] > 1) {
//            describeModel1 = [array objectAtIndex:1];
//            cell.tagLabel1.text =describeModel1.result;
//            cell.tagLabel1.textAlignment = NSTextAlignmentCenter;
//            cell.tagLabel1.layer.masksToBounds = YES;
//            cell.tagLabel1.layer.cornerRadius = 10;
//            CGRect tagLabel1Rect =  cell.tagLabel1.frame;
//            tagLabel1Rect.origin.x = cell.tagLabel.right+10;
//            cell.tagLabel1.frame = tagLabel1Rect;
//            
//            cell.tagLabel1.frame =[self resetLabelFrame:cell.tagLabel1 labelText:describeModel1.result];
//            [XKRWUtil setLabelBackgroundColor:cell.tagLabel1 colorFlag:describeModel1.flag];
//        }
       
         NSMutableAttributedString * attributedStr;
        if (describeModel1 == nil) {
            attributedStr =[XKRWUtil createAttributeStringWithString:[NSString stringWithFormat:@"%@",describeModel.advise] font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:6 alignment:NSTextAlignmentLeft];
        }else
        {
            attributedStr =[XKRWUtil createAttributeStringWithString:[NSString stringWithFormat:@"%@\n\%@",describeModel.advise,describeModel1.advise] font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:6 alignment:NSTextAlignmentLeft];
        }

        CGRect rect   =[attributedStr  boundingRectWithSize:CGSizeMake(XKAppWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        cell.detailLabel.attributedText = attributedStr;
        cell.detailLabel.numberOfLines = 0;
        CGRect frame =  cell.detailLabel.frame ;
        frame.size.height =rect.size.height+10;
        cell.detailLabel.frame = frame;
        [XKRWUtil setLabelBackgroundColor:cell.tagLabel colorFlag:describeModel.flag];
        
        
        
        return cell;
    }
    else
    {
        static NSString *identifier = @"identifier";
    
        XKRWIslimDietCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
        if (cell == nil) {
            cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWIslimDietCell");
        }
    
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = [titleArray objectAtIndex:indexPath.section-1];
        XKRWDescribeModel *model = [dietArray objectAtIndex:indexPath.section-1];
        cell.tagLabel.text = model.result;
        cell.tagLabel.textAlignment = NSTextAlignmentCenter;
        cell.tagLabel.layer.masksToBounds = YES;
        cell.tagLabel.layer.cornerRadius = 10;
        
        CGSize tagSize = [XKRWUtil sizeOfStringWithFont:model.result width:CGFLOAT_MAX font:[UIFont systemFontOfSize:14.f]];
        cell.tagLabelWidth.constant = tagSize.width + 20;
        

        cell.tagLabel.frame = [self resetLabelFrame:cell.tagLabel labelText:model.result];
        NSMutableAttributedString * attributedStr =[XKRWUtil createAttributeStringWithString:model.advise font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:6 alignment:NSTextAlignmentLeft];
        CGRect rect   =[attributedStr  boundingRectWithSize:CGSizeMake(XKAppWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        cell.detailLabel.attributedText = attributedStr;
        cell.detailLabel.numberOfLines = 0;
        CGRect frame =  cell.detailLabel.frame ;
        frame.size.height =rect.size.height+10;
        cell.detailLabel.frame = frame;
        [XKRWUtil setLabelBackgroundColor:cell.tagLabel colorFlag:model.flag];
    
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 280.f;
    }else if (indexPath.section == 1)
    {
        NSArray  *array = [dietArray objectAtIndex:indexPath.section-1];
        XKRWDescribeModel *describeModel = [array objectAtIndex:0];
        XKRWDescribeModel *describeModel1 = nil;
        if ([array count] > 1) {
            describeModel1 = [array objectAtIndex:1];
        }
        NSMutableAttributedString * attributedStr;
        if (describeModel1 == nil) {
            attributedStr =[XKRWUtil createAttributeStringWithString:[NSString stringWithFormat:@"%@",describeModel.advise] font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:6 alignment:NSTextAlignmentLeft];
        }else
        {
            attributedStr =[XKRWUtil createAttributeStringWithString:[NSString stringWithFormat:@"%@\n\%@",describeModel.advise,describeModel1.advise] font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:6 alignment:NSTextAlignmentLeft];
        }
        CGRect rect   =[attributedStr  boundingRectWithSize:CGSizeMake(XKAppWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        return 40.f + rect.size.height+15;
        
    }
    else{
         XKRWDescribeModel *model =[dietArray objectAtIndex:indexPath.section-1];
        NSMutableAttributedString * attributedStr =[XKRWUtil createAttributeStringWithString:model.advise font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:6 alignment:NSTextAlignmentLeft];
        CGRect rect   =[attributedStr  boundingRectWithSize:CGSizeMake(XKAppWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return 40.f + rect.size.height+15 ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 0;
    }else
    {
        return 10.f;
    }
}



- (UIColor *)setColorFromResultLevel:(NSString *)level
{
    UIColor *color;
    if ([level isEqualToString:@"-3"]) {
        color = [UIColor colorFromHexString:@"ff6b6b"];
    }else if ([level isEqualToString:@"-2"])
    {
        color = [UIColor colorFromHexString:@"ff7f7f"];
    }else if ([level isEqualToString:@"-1"])
    {
        color = [UIColor colorFromHexString:@"ff884c"];
    }else if ([level isEqualToString:@"0"])
    {
        color = [UIColor colorFromHexString:@"29ccb1"];
    }
    else if ([level isEqualToString:@"1"])
    {
        color = [UIColor colorFromHexString:@"cc52"];
    }
    else if ([level isEqualToString:@"2"])
    {
        color = [UIColor colorFromHexString:@"aac814"];
    }
    return color;
}

- (CGRect )resetLabelFrame:(UILabel *)label labelText:(NSString*)str
{
    CGRect tagLabelFrame = label.frame;
    if (str.length <= 3) {
        tagLabelFrame.size.width = 50;
    }else if (str.length < 5 &&str.length > 3)
    {
        tagLabelFrame.size.width = 75;
    }else if (str.length < 7 &&str.length >= 5)
    {
        tagLabelFrame.size.width = 100;
    }
    else
    {
        tagLabelFrame.size.width = 120;
    }
    
    return tagLabelFrame;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
