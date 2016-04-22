//
//  XKRWSurroundDegreeVC_5_3.m
//  XKRW
//
//  Created by 忘、 on 16/4/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWSurroundDegreeVC_5_3.h"
#import "XKRWRecordService4_0.h"
#define kDaySeconds 86400
#define LABELHEIGHT  30
#define CELLWIDTH    64

@interface XKRWSurroundDegreeVC_5_3 () <UITableViewDelegate ,UITableViewDataSource>{
    UIView *customView;
    UITableView *surroundTableView;
    UIButton *currentSelectBuuton;
    NSMutableArray *tempArray;
    NSString *maxValue;     //最大值
    NSString *minValue;     //最小值
//    CGFloat  lineHighest;
}

@end

@implementation XKRWSurroundDegreeVC_5_3

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     lineHighest = XKAppWidth - LABELHEIGHT -2*20 ;
    [self initData];
    [self initView];
    // Do any additional setup after loading the view.
}

#pragma --mark UI
- (void) initView {
    customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, XKAppWidth)];
    customView.backgroundColor = [UIColor whiteColor];
    UIView *rightLine  = [[UIView alloc]initWithFrame:CGRectMake(63, 0, 0.5, XKAppWidth)];
    rightLine.backgroundColor = XK_ASSIST_LINE_COLOR;
    [customView addSubview:rightLine];
    
    [XKRWUtil addViewUpLineAndDownLine:customView andUpLineHidden:YES DownLineHidden:NO];
    [self.view addSubview:customView];
    UIButton *popButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    popButton.frame = CGRectMake(0, 0, 64, 64);
    [popButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [popButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [popButton setBackgroundImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
    [customView addSubview:popButton];
    
    NSArray *array = @[@"体重",@"胸围",@"臂围",@"腰围",@"臀围",@"大腿围",@"小腿围"];
    
    for (NSInteger i = 0; i <[array count] ; i++) {
        UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.tag = 1000 + i;
        typeButton.titleLabel.font = XKDefaultFontWithSize(14);
        [typeButton setTitle: [array objectAtIndex:i] forState:UIControlStateNormal];
        [typeButton setTitleColor:colorSecondary_666666 forState:UIControlStateNormal];
        [typeButton setTitleColor:XKMainSchemeColor forState:UIControlStateHighlighted];
        [typeButton setTitleColor:XKMainSchemeColor forState:UIControlStateSelected];
        [typeButton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        
        typeButton.frame = CGRectMake(0, 50 + i*(XKAppWidth - 50*2)/6, 64, (XKAppWidth - 50*2)/6 );
        [customView addSubview:typeButton];
        if(i == 0) {
            typeButton.selected = YES;
            currentSelectBuuton = typeButton;
        }
    }
    
    surroundTableView = [[UITableView alloc] initWithFrame:CGRectMake((XKAppHeight -64 - XKAppWidth) /2 + 64, -(XKAppHeight -64 - XKAppWidth) /2, XKAppWidth, XKAppHeight- 64) style:UITableViewStylePlain];
    surroundTableView.delegate = self;
    surroundTableView .dataSource = self ;
    surroundTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    surroundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    surroundTableView.showsHorizontalScrollIndicator = NO;

    surroundTableView.showsVerticalScrollIndicator = NO;
    XKLog(@"%@",surroundTableView);
    [self.view addSubview:surroundTableView];
    
}

#pragma --mark Data
- (void) initData {
    NSDictionary *dic = [[XKRWRecordService4_0 sharedService] getAllCircumferenceAndWeightRecord];
    if (_dataType == eWeightType) {
        tempArray = [[dic objectForKey:@"weight"] objectForKey:@"content"];
    }else if(_dataType == eBustType ){
        tempArray = [[dic objectForKey:@"bust"] objectForKey:@"content"];
    }else if (_dataType == eArmType){
        tempArray = [[dic objectForKey:@"arm"] objectForKey:@"content"];
    }else if (_dataType == eThighType){
        tempArray = [[dic objectForKey:@"thigh"] objectForKey:@"content"];
    }else if(_dataType ==eWaistType ){
        tempArray = [[dic objectForKey:@"waistline"] objectForKey:@"content"];
    }else if (_dataType ==eHipType){
        tempArray = [[dic objectForKey:@"hipline"] objectForKey:@"content"];
    }else{
        tempArray = [[dic objectForKey:@"shank"] objectForKey:@"content"];
    }
    
    if ([tempArray count] == 0) {
        maxValue = minValue ;
    }else{
        NSArray * orderlyArray = [self dateSortFromMinToMax:[NSMutableArray arrayWithArray:tempArray]];
        maxValue = [[orderlyArray lastObject] objectForKey:@"value"];
        minValue = [[orderlyArray firstObject] objectForKey:@"value"];
    }
    
    [surroundTableView reloadData];
}


#pragma  --mark Action
- (void)popAction {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)changeType:(UIButton *)button {
    currentSelectBuuton.selected = NO;
    button.selected = YES;
    currentSelectBuuton = button;
    switch (button.tag) {
        case 1000:
            _dataType = eWeightType;
            break;
        case 1001:
            _dataType = eBustType;
            break;
        case 1002:
            _dataType = eArmType;
            break;
        case 1003:
            _dataType = eWaistType;
            break;
        case 1004:
            _dataType = eHipType;
            break;
        case 1005:
            _dataType = eThighType;
            break;
        case 1006:
            _dataType = ecalfType;
            break;
        default:
            break;
    }
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma --mark Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tempArray .count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"check";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);
        UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 64, LABELHEIGHT)];
        dateLabel.tag = 100;
        
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = XKDefaultFontWithSize(14.f);
        dateLabel.textColor = colorSecondary_666666;
        dateLabel.backgroundColor = [UIColor whiteColor];
        
        [cell.contentView addSubview:dateLabel];
     
        UILabel * dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, XKAppHeight - LABELHEIGHT, 64, LABELHEIGHT)];
        dataLabel.tag = 101;
        dataLabel.textAlignment = NSTextAlignmentCenter;
        dataLabel.font = XKDefaultFontWithSize(14.f);
        dataLabel.textColor = XKMainToneColor_29ccb1;
        dataLabel.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:dataLabel];
    }
    
    UILabel *dateLabel  = (UILabel *)[cell viewWithTag:100];

    NSLog(@"%@",[[tempArray objectAtIndex:indexPath.row] objectForKey:@"date"]);
    NSString *showDate = [XKRWUtil dateFormateWithDate:[[tempArray objectAtIndex:indexPath.row] objectForKey:@"date"] format:@"MM-dd"];
    dateLabel.text = [NSString stringWithFormat:@"%@",showDate];
    
    UILabel *dataLabel = (UILabel *)[cell viewWithTag:101];
     if (_dataType == eWeightType) {
         dataLabel.text = [NSString stringWithFormat:@"%@kg",[[tempArray objectAtIndex:indexPath.row] objectForKey:@"value"]];
     }else {
         dataLabel.text = [NSString stringWithFormat:@"%@cm",[[tempArray objectAtIndex:indexPath.row] objectForKey:@"value"]];
     }
    
    NSString *currentValue = [[tempArray objectAtIndex:indexPath.row] objectForKey:@"value"];
    
    [self drawImageViewInCell:currentValue And:indexPath andCell:cell];
    
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorFromHexString:@"#F9F9F9"];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

#pragma --mark 横屏
- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

#pragma --mark Util
//数组进行排序  找出最大以及最小值
- (NSMutableArray *)dateSortFromMinToMax:(NSMutableArray *)array
{
    for (int i =0; i < array.count-1; i++) {
        for (int j =i+1; j< array.count; j++) {
            if([[[array objectAtIndex:i] objectForKey:@"value"] floatValue] > [[[array objectAtIndex:j] objectForKey:@"value"] floatValue])
            {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}

#pragma --mark drawAction

- (void)drawImageViewInCell:(NSString *)currentValue And:(NSIndexPath *) indexPath andCell:(UITableViewCell *)cell
{

    CGPoint prevPoint;
    CGPoint currentPoint;
    CGPoint nextPoint;
    NSString *nextValue;
    NSString *prevValue;
    UIImageView *imageView = [[UIImageView alloc]init];
    
    imageView.image = [UIImage imageNamed:@"girth_btn_point_mark_640"];
    
    if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
        currentPoint = CGPointMake((CELLWIDTH)/2 ,(XKAppHeight -12)/2);
    }else {
        currentPoint = CGPointMake((CELLWIDTH)/2, (LABELHEIGHT +10) + ((XKAppHeight - 2*(LABELHEIGHT +10)) -((currentValue.floatValue - minValue.floatValue) *(XKAppHeight - 2*(LABELHEIGHT +10) ) /(maxValue.floatValue - minValue.floatValue))));
    }
    
    imageView.frame = CGRectMake(currentPoint.x-12/2, currentPoint.y-12/2, 12, 12);
    
    if (indexPath.row != 0) {
        prevValue = [[tempArray objectAtIndex:indexPath.row -1] objectForKey:@"value"];

        if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
            prevPoint = CGPointMake(0, LABELHEIGHT + 6 + (XKAppHeight - 2*LABELHEIGHT)/2  );
        }else{
            prevPoint = CGPointMake(0, (LABELHEIGHT +10) + ((XKAppHeight - 2*(LABELHEIGHT +10)) -( (prevValue.floatValue +(currentValue.floatValue -prevValue.floatValue)/2  - minValue.floatValue) *(XKAppHeight - 2*(LABELHEIGHT +10) ) /(maxValue.floatValue - minValue.floatValue)) ));
        }
        [self drawLineInView:cell.contentView fromPoint:prevPoint toTargetPoint:currentPoint];
    }
    
    if (tempArray.count > indexPath.row +1) {
        nextValue = [[tempArray objectAtIndex:indexPath.row+1] objectForKey:@"value"];

        if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
            nextPoint = CGPointMake(CELLWIDTH, LABELHEIGHT + 6 + (XKAppHeight - 2*LABELHEIGHT)/2 );
        }else{
            nextPoint = CGPointMake(CELLWIDTH, (LABELHEIGHT +10) + ((XKAppHeight - 2*(LABELHEIGHT +10)) -( (nextValue.floatValue +(currentValue.floatValue -nextValue.floatValue)/2  - minValue.floatValue) *(XKAppHeight - 2*(LABELHEIGHT +10) ) /(maxValue.floatValue - minValue.floatValue))));
        }
        [self drawLineInView:cell.contentView fromPoint:currentPoint toTargetPoint:nextPoint];
    }
    
    [cell.contentView addSubview:imageView];
}


- (void)drawLineInView:(UIView *)view fromPoint:(CGPoint) currentPoint toTargetPoint:(CGPoint) targetPoint
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(currentPoint.x, currentPoint.y)];
    [path addLineToPoint:CGPointMake(targetPoint.x, targetPoint.y)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = view.bounds;
    pathLayer.bounds = view.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = XKMainToneColor_29ccb1.CGColor;//粗线的颜色
    
    
    pathLayer.lineWidth = 1;
    
    pathLayer.lineJoin = kCALineJoinRound;
    [view.layer addSublayer:pathLayer];
    
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
