//
//  XKRWPhysicalAssessmentVC.m
//  XKRW
//
//  Created by 忘、 on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWPhysicalAssessmentVC.h"
#import "physicalAssessmentHeaderCell.h"
#import "XKRWphysicalAssessmentCell.h"
#import "physicalAssessmentSuggestCell.h"
#import "XKRWSchemeStepsModel.h"
#import "XKRWPersonalCircumstancesVC.h"  //个人情况
#import "XKRWDietCircumstancesVC.h"  //饮食情况
#import "XKRWExcerciseAssResultVC.h" //运动情况
#import "XKRWHabitStatusVC.h" //习惯情况
#import "XKRWComprehensiveAssResultVC.h"//综合情况

#import "XKRWThinbodystageModel.h"
#import "XKRWThinAssessVC.h"      //瘦身阶段

#import "XKRWProfessionalShareVC.h" //专业分享
#import "XKRWiSlimAssessmentVC.h"
#import "XKRWPayOrderVC.h"

@interface XKRWPhysicalAssessmentVC () <UIAlertViewDelegate>
{
    NSArray *titleArray;
    NSArray *resultArray;
    NSArray *flagArray;
    NSArray *imageArray;
    NSArray *describeArray;
    NSArray *detailArray;
}
@end

@implementation XKRWPhysicalAssessmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    
}

#pragma --mark Action

- (void)initView
{
    [MobClick event:@"in_iSlimA"];
    self.title = @"身体评估";
    [self addNaviBarBackButton];
    _resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)];
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _resultTableView.backgroundColor = XK_BACKGROUND_COLOR;
    
    [self.view addSubview:_resultTableView];
    
    
    UIView  *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 91)];
    footerView.backgroundColor = XK_BACKGROUND_COLOR;
    
    UIButton *reappraisalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reappraisalButton.frame = CGRectMake(0, (91-51)/2, XKAppWidth, 51);
    
//    [reappraisalButton setBackgroundImage:[UIImage imageNamed:@"buttonRed"] forState:UIControlStateNormal];
//    [reappraisalButton setBackgroundImage:[UIImage imageNamed:@"buttonRed_p"] forState:UIControlStateHighlighted];
    
    [reappraisalButton addTarget:self action:@selector(reappraisalAction:) forControlEvents:UIControlEventTouchUpInside];
    [reappraisalButton setTitle:@"重新评估" forState:UIControlStateNormal];
    [reappraisalButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [reappraisalButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [footerView addSubview: reappraisalButton];
    reappraisalButton.backgroundColor = [UIColor whiteColor];
    [reappraisalButton setBackgroundImage:[UIImage createImageWithColor:RGB(217, 217, 217, 1)] forState:UIControlStateHighlighted];
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    topline.backgroundColor = XKSepDefaultColor;
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, reappraisalButton.height-0.5, XKAppWidth, 0.5)];
    bottomline.backgroundColor = XKSepDefaultColor;
    [reappraisalButton addSubview:topline];
    [reappraisalButton addSubview:bottomline];
    
    _resultTableView.tableFooterView = footerView;
    
//    [self addNaviBarRightButtonWithNormalImageName:@"share" highlightedImageName:@"shareH"];
   
}


- (void)reappraisalAction:(UIButton *)button
{

    NSInteger chances = [[XKRWServerPageService sharedService] getEvaluateChances];

    if (chances > 0) {
        NSString *msg = [NSString stringWithFormat:@"你有%d次重新评估的机会，重新评估后，原来的评估将被替换，确定重新评估吗？",(int)chances];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];
    } else {
        NSString *msg = [NSString stringWithFormat:@"你的评估机会已经用完，评估需要重新购买，确定么？"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 2;
        [alert show];
    }
}


- (void)popView {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)initData
{
    titleArray = @[@"身材:",@"饮食:",@"运动:",@"习惯:",@"其他:"];

    resultArray = @[_model.bodyModel.model.name,_model.dietModel.model.name,_model.sportmodel.model.name,_model.habitModel.model.name,_model.otherFactorsModel.model.name];
    
    flagArray =@[@(_model.bodyModel.model.flag),@(_model.dietModel.model.flag),@(_model.sportmodel.model.flag),@(_model.habitModel.model.flag),@(_model.otherFactorsModel.model.flag)];
    
    imageArray = @[@"icon_301_2",@"icon_302_2",@"icon_303_2",@"icon_304_2",@"icon_305_2"];
    
    describeArray =@[_model.bodyModel.model.word,_model.dietModel.model.word,_model.sportmodel.model.word,_model.habitModel.model.word,_model.otherFactorsModel.model.word];
    
    detailArray = @[_model.bodyModel.model.desc,_model.dietModel.model.desc,_model.sportmodel.model.desc,_model.habitModel.model.desc,_model.otherFactorsModel.model.desc];
    
    
}

#pragma --mark  tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"headerCell";
        physicalAssessmentHeaderCell *headCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (headCell == nil) {
            headCell = LOAD_VIEW_FROM_BUNDLE(@"physicalAssessmentHeaderCell");
        }
        
        headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        XKLog(@"%@",_model);
        headCell.statureLable.text = _model.bodyModel.model.name;
        [XKRWUtil setLabelColor:headCell.statureLable colorFlag:_model.bodyModel.model.flag];
        headCell.otherLable.text = _model.otherFactorsModel.model.name;
        [XKRWUtil setLabelColor:headCell.otherLable colorFlag:_model.otherFactorsModel.model.flag];
        headCell.dietLable.text = _model.dietModel.model.name;
        [XKRWUtil setLabelColor:headCell.dietLable colorFlag:_model.dietModel.model.flag];
        headCell.sportLable.text = _model.sportmodel.model.name;
        [XKRWUtil setLabelColor:headCell.sportLable colorFlag:_model.sportmodel.model.flag];
        headCell.habitLable.text = _model.habitModel.model.name;
        [XKRWUtil setLabelColor:headCell.habitLable colorFlag:_model.habitModel.model.flag];
        NSArray * scoreArray = @[@(_model.bodyModel.model.score *5),
                                @(_model.dietModel.model.score*5),
                                 @(_model.sportmodel.model.score*5),
                                 @(_model.habitModel.model.score*5),
                                   @(_model.otherFactorsModel.model.score*5),
                                ];
        
        NSInteger score = _model.bodyModel.model.score+_model.otherFactorsModel.model.score+_model.dietModel.model.score+_model.sportmodel.model.score+_model.habitModel.model.score;
        headCell.scorelable.text =[NSString stringWithFormat:@"%ld",(long)score];
        
        headCell.scorelable.textColor = XKMainToneColor_29ccb1;
      
        if( 84 < score  && score <= 100 )
        {
            headCell.picImageView.image = [UIImage imageNamed:@"3-7"];
        }
        else if (score >72 && score <= 84)
        {
            headCell.picImageView.image = [UIImage imageNamed:@"0-3"];
        }
        else if (score > 60 && score <= 72)
        {
            headCell.picImageView.image = [UIImage imageNamed:@"-3-0"];
        }
        else if (score > 48 && score <= 60)
        {
            headCell.picImageView.image = [UIImage imageNamed:@"-6-3"];
        }
        else if (score > 36 && score <= 48)
        {
            headCell.picImageView.image = [UIImage imageNamed:@"-9-6"];
        }
        else if (score > 24 && score <= 36)
        {
            headCell.picImageView.image = [UIImage imageNamed:@"-12-9"];
        }
        else if (score > 12 && score <= 24)
        {
            headCell.picImageView.image = [UIImage imageNamed:@"-15-12"];
        }
        else if (score >= 0 && score <= 12)
        {
            headCell.picImageView.image = [UIImage imageNamed:@"-18-15"];
        }

        
        if(score >=90 && score <=100)
        {
            headCell.contentLable.text = @"减重效率极高";
        }else if (score >=70){
            headCell.contentLable.text = @"减重效率较高";
        }else{
            headCell.contentLable.text = @"减重效率较低";
        }
        
        [headCell showRadar:scoreArray];
        
        return headCell;
    }else if (indexPath.section == 6){
        
        static NSString *identifier = @"physicalAssessmentCell";
        physicalAssessmentSuggestCell *suggestCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (suggestCell == nil) {
            suggestCell = LOAD_VIEW_FROM_BUNDLE(@"physicalAssessmentSuggestCell");
        }
        suggestCell.contentView.userInteractionEnabled = YES;
       
        suggestCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return suggestCell;
    } else {
    
        static NSString *identifier = @"AssessmentCell";
    
        XKRWphysicalAssessmentCell * cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
        if (cell == nil) {
            cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWphysicalAssessmentCell");
        }
       
        cell.titleLable.text = [titleArray objectAtIndex:indexPath.section-1];
        cell.contentLable.text = [resultArray objectAtIndex:indexPath.section-1];
        
        [cell.showButton setTitle:[describeArray objectAtIndex:indexPath.section-1] forState:UIControlStateNormal];
        cell.showButton.layer.masksToBounds = YES;
        cell.showButton.layer.cornerRadius = 10;
        [XKRWUtil setButtonBackgroundColor:cell.showButton colorFlag:[[flagArray objectAtIndex:indexPath.section-1] integerValue]];
        
        
        [XKRWUtil setLabelColor:cell.contentLable colorFlag:[[flagArray objectAtIndex:indexPath.section-1] integerValue] ];
        
        NSMutableAttributedString *attributedStr = [XKRWUtil createAttributeStringWithString:[detailArray objectAtIndex:indexPath.section-1] font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:6
                                                     alignment:NSTextAlignmentLeft];
        
        CGRect rect = [attributedStr boundingRectWithSize:CGSizeMake(XKAppWidth-130.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGRect frame = cell.detailedContentLable.frame;
        frame.size.height = rect.size.height+10;
        cell.detailedContentLable.frame = frame;
        cell.detailedContentLable.attributedText =attributedStr;
        cell.detailedContentLable.numberOfLines = 0;
        
        
        cell.showImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.section-1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 340.f;
    }
    else if (indexPath.section == 6) {
        
        static NSString *identifier = @"physicalAssessmentCell";
        physicalAssessmentSuggestCell *suggestCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (suggestCell == nil) {
            suggestCell = LOAD_VIEW_FROM_BUNDLE(@"physicalAssessmentSuggestCell");
        }
        
        XKLog(@"%f",[XKRWUtil getViewSize:suggestCell].height);
        
        return [XKRWUtil getViewSize:suggestCell].height;
    } else {
        
        return 184.f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 6) {
        return 0.f;
    }else
    {
        return 10.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
 
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * up=[[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    up.backgroundColor=[UIColor colorFromHexString:@"#e0e0e0"];
    UIView * down=[[UIView alloc]initWithFrame:CGRectMake(0, 9.5, XKAppWidth, 0.5)];
    down.backgroundColor=[UIColor colorFromHexString:@"#e0e0e0"];
    
    if (section==6) {
        return nil;
    }else{
        [view addSubview:up];
        [view addSubview:down];
    }
    return view;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            XKRWPersonalCircumstancesVC *personalCircumstancesVC =  [[XKRWPersonalCircumstancesVC alloc]init];
            personalCircumstancesVC.bodyModel = _model.bodyModel;
            [self.navigationController pushViewController:personalCircumstancesVC animated:YES];
        }
            break;
            
        case 2:
        {
            XKRWDietCircumstancesVC *dietCircumstancesVC = [[XKRWDietCircumstancesVC alloc]init];
            dietCircumstancesVC.dietModel = _model.dietModel;
            [self.navigationController pushViewController:dietCircumstancesVC animated:YES];
        }
            break;

        case 3: {
            XKRWExcerciseAssResultVC *VC = [[XKRWExcerciseAssResultVC alloc] initWithNibName:@"XKRWExcerciseAssResultVC" bundle:nil];
            VC.iSlimModel = _model;
            
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 4:
        {
            XKRWIslimModel  *islimModel = _model;
            //              //习惯 页面
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            NSMutableArray *headData = [[NSMutableArray alloc]init];
            if (islimModel.habitModel.secretionArray.count != 0)
            {
                for (XKRWDescribeModel * obj in islimModel.habitModel.secretionArray ) {
                    [dataArray addObject:obj];
                    [headData addObject:obj.result];
                }
            }
            if (islimModel.habitModel.reduceCalArray.count != 0) {
                for (XKRWDescribeModel * obj in islimModel.habitModel.reduceCalArray ) {
                    [dataArray addObject:obj];
                    [headData addObject:obj.result];
                    
                }
            }
            if (islimModel.habitModel.bodyConsumeArray.count != 0 )
            {
                for (XKRWDescribeModel * obj in islimModel.habitModel.bodyConsumeArray ) {
                    [dataArray addObject:obj];
                    [headData addObject:obj.result];
                }
            }
            
            //再次组装个数据   归类到 三大类  减少热量摄入   增强身体消耗   改善内分泌
            //热量摄入
            NSMutableArray  *CalorieIntakeArray = [[NSMutableArray alloc]init];
            
            //身体消耗
            NSMutableArray   *bodyUsesArray = [[NSMutableArray alloc]init];
            
            //内分泌
            NSMutableArray   *endocrineArray = [[NSMutableArray alloc]init];
            
            NSMutableArray  *haibtMutArray = [[NSMutableArray alloc]init];
            
            for(int i = 0; i < dataArray.count; i ++)
            {
                XKRWDescribeModel *describeModel = dataArray[i];
                if([describeModel.result  isEqualToString:@"饮酒频繁"] || [describeModel.result  isEqualToString:@"经常零食"] || [describeModel.result  isEqualToString:@"饮料"] )
                {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:describeModel.result,@"subTitle",describeModel.advise,@"advice", nil];
                    [CalorieIntakeArray addObject:dic];
                }
                
                 if([describeModel.result hasPrefix:@"体力活动"] ||  [describeModel.result  hasPrefix:@"娱乐活动"])
                {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:describeModel.result,@"subTitle",describeModel.advise,@"advice", nil];
                    [bodyUsesArray addObject:dic];
                }
                
                if([describeModel.result  isEqualToString:@"熬夜频繁"])
                {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:describeModel.result,@"subTitle",describeModel.advise,@"advice", nil];
                    [endocrineArray addObject:dic];
                }
            }
            //组装
            
            if (CalorieIntakeArray.count != 0)
            {
                NSDictionary  *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"减少热量摄入",@"title",CalorieIntakeArray,@"arr", nil];
                [haibtMutArray addObject:dic];
            }
            
            if (bodyUsesArray.count != 0)
            {
                NSDictionary  *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"增强身体消耗",@"title",bodyUsesArray,@"arr", nil];
                [haibtMutArray addObject:dic];
            }
            
            if (endocrineArray.count != 0)
            {
                NSDictionary  *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"改善内分泌",@"title",endocrineArray,@"arr", nil];
                [haibtMutArray addObject:dic];
            }
            
            XKLog(@"当前的 习惯 数据 %@",haibtMutArray);
            XKLog(@"12312312%@", islimModel.habitModel.otherDescribeModel);
            
            if(haibtMutArray.count == 0  && islimModel.habitModel.otherDescribeModel != nil)
            {
               NSDictionary  *dic = [NSDictionary dictionaryWithObjectsAndKeys: islimModel.habitModel.otherDescribeModel.result,@"subTitle", islimModel.habitModel.otherDescribeModel.advise,@"advice", nil];
                 [CalorieIntakeArray addObject:dic];
               NSDictionary  *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"title",CalorieIntakeArray,@"arr", nil];
                [haibtMutArray addObject:dic2];

            }
            
            XKRWHabitStatusVC *vc = [[XKRWHabitStatusVC alloc]init];
            vc.dataArray = haibtMutArray;
            vc.headDataArray = headData;
            [self.navigationController  pushViewController:vc animated:YES];
            break;
        }

        case 5: {
            
            XKRWComprehensiveAssResultVC *vc = [[XKRWComprehensiveAssResultVC alloc] initWithNibName:@"XKRWComprehensiveAssResultVC" bundle:nil];
            vc.iSlimModel = _model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            //阶段
            XKRWThinAssessVC *thinAssessVC = [[XKRWThinAssessVC alloc] init];
            thinAssessVC.model = _model;
            [self.navigationController pushViewController:thinAssessVC animated:YES];
        }
            break;
        default:
            break;
    }

}

#pragma mark - UIAlertView's delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        
        if (buttonIndex) {
            
            XKRWiSlimAssessmentVC *vc = [[XKRWiSlimAssessmentVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (alertView.tag == 2) {
        
        if (buttonIndex) {

            XKRWPayOrderVC *vc = [[XKRWPayOrderVC alloc] initWithPID:10000];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
