//
//  XKRWChangeMealPercentVC.m
//  XKRW
//
//  Created by 刘睿璞 on 16/4/24.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWChangeMealPercentVC.h"
#import "XKRWMealPercentSlider.h"

@interface XKRWChangeMealPercentVC ()

@end

@implementation XKRWChangeMealPercentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviBarBackButton];
    self.title = @"调整四餐比例";
    [self addMySlider];
}

-(void)addMySlider{
    //左右轨的图片
    UIImage *stetchLeftTrack= [UIImage imageNamed:@"HOT"];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"light_off_back.png"];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"star"];
    
    XKRWMealPercentSlider *sliderA=[[XKRWMealPercentSlider alloc]initWithFrame:CGRectMake(30, 20, 300, 50)];
    sliderA.backgroundColor = [UIColor grayColor];
    sliderA.value=0.5;
    sliderA.minimumValue=0.0;
    sliderA.maximumValue=1.0;
    [sliderA setMinimumTrackTintColor:[UIColor redColor]];
    [sliderA setMaximumTrackTintColor:[UIColor greenColor]];
//    [sliderA setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
//    [sliderA setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
//    [sliderA setThumbImage:thumbImage forState:UIControlStateHighlighted];
//    [sliderA setThumbImage:thumbImage forState:UIControlStateNormal];
    //滑块拖动时的事件
    [sliderA addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [sliderA addTarget:self action:@selector(sliderDragUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sliderA];
}
-(void)sliderDragUp{
    NSLog(@"sliderDragUp");
}
-(void)sliderValueChanged{
    NSLog(@"sliderValueChanged");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end