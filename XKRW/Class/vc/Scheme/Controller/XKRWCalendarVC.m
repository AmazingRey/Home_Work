//
//  XKRWCalendarVC.m
//  XKRW
//
//  Created by 忘、 on 16/4/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWCalendarVC.h"
#import "XKRWPlanCalendarView.h"
@interface XKRWCalendarVC () {
    UIScrollView *calendarScrollView;
}

@end

@implementation XKRWCalendarVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController  setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView {
    self.view .backgroundColor = [UIColor whiteColor];
    calendarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
    calendarScrollView.contentSize = CGSizeMake(XKAppWidth, 700);
    [self.view addSubview:calendarScrollView];
    
    XKRWPlanCalendarView *headView = [[NSBundle mainBundle] loadNibNamed:@"XKRWPlanCalendarView" owner:self options:nil][0];
    headView.frame = CGRectMake(0, 0, XKAppWidth, 130);
    
    [self.view addSubview:headView];
    
    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popButton.frame = CGRectMake(0, 0, 64, 64);
    UIImage *image = [UIImage imageNamed:@"navigationBarback"];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, image.size.width, image.size.height)];
    imageview.image = image;
    [popButton addSubview:imageview];
    [popButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popButton];
}


#pragma --mark Action
- (void) popAction :(UIButton *) button {
    [self.navigationController popViewControllerAnimated:YES];
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
