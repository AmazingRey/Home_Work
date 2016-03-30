//
//  XKRWPersonalCircumstancesVC.m
//  XKRW
//
//  Created by 忘、 on 15-1-19.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWPersonalCircumstancesVC.h"
#import "XKRWPersonalCircumstancesFemaleCell.h"
#import "XKRWPersonalCircumstancesCell.h"
#import "XKRWPersonCircumstancesCell.h"
#import "XKRWUserService.h"
#import "XKRWServerPageService.h"

#define  x1  13

@interface XKRWPersonalCircumstancesVC ()<UITableViewDataSource,UITableViewDelegate>
{
    XKRWPersonCircumstancesCell *BMICell;
    XKRWPersonCircumstancesCell *BodyFatRateCell;
}
@end

@implementation XKRWPersonalCircumstancesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    
    // Do any additional setup after loading the view.
}

- (void)initView
{
    self.title = @"个人情况";
    [self addNaviBarBackButton];
    self.view.backgroundColor = colorSecondary_f4f4f4;
    circumstanceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)];
    circumstanceTableView.delegate = self;
    circumstanceTableView.dataSource = self;
    circumstanceTableView.backgroundColor = XK_BACKGROUND_COLOR;
    circumstanceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:circumstanceTableView];
    
    BMICell = LOAD_VIEW_FROM_BUNDLE(@"XKRWPersonCircumstancesCell");
    BodyFatRateCell = LOAD_VIEW_FROM_BUNDLE(@"XKRWPersonCircumstancesCell");
}

- (void)initData
{

}

- (NSInteger) getUserAge:(NSInteger )birthdayYear
{
    NSDate *nowdate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowdate];
    
    NSInteger year = [dateComponent year];
    
    return year-birthdayYear;
}


#pragma --mark  UItableViewDataSource  UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * up=[[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    up.backgroundColor=[UIColor colorFromHexString:@"#e0e0e0"];
    UIView * down=[[UIView alloc]initWithFrame:CGRectMake(0, 9.5, XKAppWidth, 0.5)];
    down.backgroundColor=[UIColor colorFromHexString:@"#e0e0e0"];
    
    if (section==0) {
        [view addSubview:up];
        [view addSubview:down];
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
    XKLog(@"%@",_bodyModel);
    if (indexPath.section == 0 ) {
        if ([_bodyModel.gender integerValue]== 0) {
            XKRWPersonalCircumstancesCell *cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWPersonalCircumstancesCell");
            cell.ageLabel.text = [NSString stringWithFormat:@"%@岁",_bodyModel.age];
            cell.heightLabel.text = [NSString stringWithFormat:@"%@cm",_bodyModel.height];
            cell.weightLabel.text =[NSString stringWithFormat:@"%@kg",_bodyModel.weight];
            cell.BMILabel.text = [NSString stringWithFormat:@"%@(%@)",_bodyModel.BMI,_bodyModel.BMIStatus];
            cell.BMRLabel.text = [NSString stringWithFormat:@"%@(%@)",_bodyModel.bodyFatPercentage,_bodyModel.fatPctStatus];
            cell.bestWeightLabel.text = [NSString stringWithFormat:@"%.1fKg",_bodyModel.bestWeight];
            cell.metabolicLabel.text = [NSString stringWithFormat:@"%ldKcal",(long)_bodyModel.BMR];
            cell.caloriesLabel.text = [NSString stringWithFormat:@"%ldKcal",(long)_bodyModel.lowestCalCtrl];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
//            cell.resultLabel.text = _bodyModel.fatStandard;
//            
//            if(_bodyModel.fatSTFlag == 0)
//            {
//                cell.bodyTypeImageView.image = [UIImage imageNamed:@"photo_man"];
//                cell.statImageView.image = [UIImage imageNamed:@"tag_02"];
//            }else{
//                cell.bodyTypeImageView.image = [UIImage imageNamed:@"photo_pear_"];
//                 cell.statImageView.image = [UIImage imageNamed:@"tag_05"];
//            }
            
            return cell;
        }else
        {
            XKRWPersonalCircumstancesFemaleCell *cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWPersonalCircumstancesFemaleCell");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.ageLabel.text = [NSString stringWithFormat:@"%@岁",_bodyModel.age];
            cell.heightLabel.text = [NSString stringWithFormat:@"%@cm",_bodyModel.height];
            cell.weightLabel.text =[NSString stringWithFormat:@"%@kg",_bodyModel.weight];
            
            cell.chestlineLabel.text = [NSString stringWithFormat:@"%@cm",_bodyModel.chest];
            cell.waistlineLabel.text = [NSString stringWithFormat:@"%@cm",_bodyModel.waist];
            cell.hiplalineLabel.text = [NSString stringWithFormat:@"%@cm",_bodyModel.hipline];
            cell.thighlineLabel.text = [NSString stringWithFormat:@"%@cm",_bodyModel.thigh];
            cell.shanklineLable.text = [NSString stringWithFormat:@"%@cm",_bodyModel.calf];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
    }else if(indexPath.section == 1)
    {
        
        BMICell.selectionStyle = UITableViewCellSelectionStyleNone;
//        BMICell.stateImageView.image = [UIImage imageNamed:@"bar_bodyfat_01"];
        CGPoint center = BMICell.stateImageView.center;
        center.x = XKAppWidth /2;
        BMICell.stateImageView.center = center;
        
        CGRect frame = BMICell.locationImageView.frame;
        if ([_bodyModel.BMI floatValue]<=13) {
            frame.origin.x = (XKAppWidth-240)/2-8;
        }
        else if ([_bodyModel.BMI floatValue]<=18.5) {
             frame.origin.x = (XKAppWidth-240)/2+55*(([_bodyModel.BMI floatValue]-13)*10)/((18.5-13)*10)-8;
        }else if ([_bodyModel.BMI floatValue]<=24)
        {
            frame.origin.x = (XKAppWidth-240)/2+55+45*(([_bodyModel.BMI floatValue]-18.5)*10)/((24-18.5)*10)-8;
        }else if ([_bodyModel.BMI floatValue]<=28)
        {
            frame.origin.x = (XKAppWidth-240)/2+100+45*(([_bodyModel.BMI floatValue]-24)*10)/((28-24)*10)-8;
        }else if ([_bodyModel.BMI floatValue]<=35)
        {
            frame.origin.x = (XKAppWidth-240)/2+145+95*(([_bodyModel.BMI floatValue]-28)*10)/((35-28)*10)-8;
        }else
        {
            frame.origin.x = (XKAppWidth-240)/2+240-8;
        }
       
        BMICell.locationImageView.frame = frame;
        
        BMICell.descriptionLabel.frame = CGRectMake(15, 45, XKAppWidth-30, [BMICell getCurrentCellHeight:_bodyModel.BMISdisc]);
        BMICell.descriptionText = _bodyModel.BMISdisc;
        BMICell.weightStateLabel.text = _bodyModel.BMIStatus;
        BMICell.weightStateLabel.layer.cornerRadius = 10;
        BMICell.weightStateLabel.layer.masksToBounds = YES;
        [XKRWUtil setLabelBackgroundColor:BMICell.weightStateLabel colorFlag:_bodyModel.BMISflag];
        BMICell.titleLabel.text = [NSString stringWithFormat:@"BMI: %@",_bodyModel.BMI] ;//@"BMI: 24.5";
        
        return BMICell;
    }else if (indexPath.section == 2)
    {
        
        BodyFatRateCell.stateImageView.image = [UIImage imageNamed:@"bar_bodyfat_.png"];
        CGPoint center = BodyFatRateCell.stateImageView.center;
        center.x = XKAppWidth /2;
        BodyFatRateCell.stateImageView.center = center;
        
        BodyFatRateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BodyFatRateCell.descriptionLabel.frame = CGRectMake(15, 122, XKAppWidth-30, [BodyFatRateCell getCurrentCellHeight:[NSString stringWithFormat:@"%@\n%@",_bodyModel.fatPctdisc1,_bodyModel.fatPctdisc2]]);
        BodyFatRateCell.descriptionText = [NSString stringWithFormat:@"%@\n%@",_bodyModel.fatPctdisc1,_bodyModel.fatPctdisc2];
        
        BodyFatRateCell.titleLabel.text = [NSString stringWithFormat:@"体脂率: %@",_bodyModel.bodyFatPercentage];//@"体脂率: 25%";
        BodyFatRateCell.weightStateLabel.text = _bodyModel.fatPctStatus;
        [XKRWUtil setLabelBackgroundColor:BodyFatRateCell.weightStateLabel colorFlag:_bodyModel.fatPctFlag];
        
        
        if (BodyFatRateCell.titleLabel.text.length >10) {
            BodyFatRateCell.weightStateLabel.frame = CGRectMake(138, 11, 50, 22);
        }else if (BodyFatRateCell.titleLabel.text.length == 10){
            BodyFatRateCell.weightStateLabel.frame = CGRectMake(128, 11, 50, 22);
        }
        else if (BodyFatRateCell.titleLabel.text.length == 9){
            BodyFatRateCell.weightStateLabel.frame = CGRectMake(118, 11, 50, 22);
        }else if (BodyFatRateCell.titleLabel.text.length == 8)
        {
            BodyFatRateCell.weightStateLabel.frame = CGRectMake(108, 11, 50, 22);
        }
        else{
            BodyFatRateCell.weightStateLabel.frame = CGRectMake(103, 11, 50, 22);
        }
        
        
        BodyFatRateCell.weightStateLabel.layer.cornerRadius = 10;
        BodyFatRateCell.weightStateLabel.layer.masksToBounds = YES;
        CGRect frame = BodyFatRateCell.locationImageView.frame;
        if ([_bodyModel.bodyFatPercentage floatValue] <=4) {
            frame.origin.x = (XKAppWidth-240)/2-8;
        }else if ([_bodyModel.bodyFatPercentage floatValue] <=18){
            frame.origin.x = (XKAppWidth-240)/2+48*(([_bodyModel.bodyFatPercentage floatValue]-4)*100)/((18-4)*100)-8;
        }else if ([_bodyModel.bodyFatPercentage floatValue] <=23){
            frame.origin.x = (XKAppWidth-240)/2+48+48*(([_bodyModel.bodyFatPercentage floatValue]-18)*100)/((23-18)*100)-8;
        }else if ([_bodyModel.bodyFatPercentage floatValue] <=28){
            frame.origin.x = (XKAppWidth-240)/2+48*2+48*(([_bodyModel.bodyFatPercentage floatValue]-23)*100)/((28-23)*100)-8;
        }else if ([_bodyModel.bodyFatPercentage floatValue] <=33){
            frame.origin.x = (XKAppWidth-240)/2+48*3+48*(([_bodyModel.bodyFatPercentage floatValue]-28)*100)/((33-28)*100)-8;
        }else if ([_bodyModel.bodyFatPercentage floatValue] <=40){
            frame.origin.x = (XKAppWidth-240)/2+48*4+48*(([_bodyModel.bodyFatPercentage floatValue]-33)*100)/((40-33)*100)-8;
        }else
        {
            frame.origin.x = (XKAppWidth-240)/2+240-8;
        }
        
        
        BodyFatRateCell.locationImageView.frame = frame;
        return BodyFatRateCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 340.f;
    }else if (indexPath.section == 1) {
        CGFloat height = 122 + [BMICell getCurrentCellHeight:_bodyModel.BMISdisc];
        
        return height;
    }else
    {
         CGFloat height =  122 +[BodyFatRateCell getCurrentCellHeight:[NSString stringWithFormat:@"%@\n%@",_bodyModel.fatPctdisc1,_bodyModel.fatPctdisc2]];
        
        return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.f;
    }else{
        return 10.f;
    }
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
