//
//  XKRWStarGatherNumVC.m
//  XKRW
//
//  Created by Jack on 15/7/17.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWStarGatherNumVC.h"
#import "NZLabel.h"
#import "XKRWAlgolHelper.h"
#define iphone6Width 375
#define iphone6PlusWidth 621
@interface XKRWStarGatherNumVC ()

@end

@implementation XKRWStarGatherNumVC

- (void)viewDidLoad {
    
    [MobClick event:@"clk_stars"];
    
    [super viewDidLoad];
    self.title = @"已收集";
    self.view.backgroundColor = XK_BACKGROUND_COLOR;
    
    [self addNaviBarBackButton];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 180)];
    
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    //星星数
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    starLabel.textAlignment = NSTextAlignmentCenter;
    starLabel.font = XKDefaultNumEnFontWithSize(37);
    starLabel.textColor = XK_STATUS_COLOR_STANDARD;
    
    if(!_starNum){
        starLabel.text = @"0";
    }else{
        starLabel.text = _starNum;
    }
    
    starLabel.frame = [starLabel.text boundingRectWithSize:CGSizeMake(XKAppWidth, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName: XKDefaultNumEnFontWithSize(37)}
                                                   context:nil];
    starLabel.center = CGPointMake(CGRectGetMidX(topView.bounds) + 10, CGRectGetMidY(topView.bounds) -  10);
    
    [topView addSubview:starLabel];
    
    //星星
    UIImageView *star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_starcollection"]];
    star.right = starLabel.left - 10;
    [star setCenterY:starLabel.center.y - 3];
    
    [topView addSubview:star];
    
    
    
    //超过80%瘦瘦用户
    NZLabel *exceedUserLabel = [[NZLabel alloc] init];
    exceedUserLabel.frame = CGRectMake(0, starLabel.bottom+10, XKAppWidth, 40);
    exceedUserLabel.text = [NSString stringWithFormat:@"超越 %@ 瘦瘦用户",[XKRWAlgolHelper calcUserPercentWithStarNum:[_starNum intValue]]];
    exceedUserLabel.textAlignment = NSTextAlignmentCenter;
    exceedUserLabel.textColor = XK_TEXT_COLOR;
    
    NSRange range1 = [exceedUserLabel.text rangeOfString:@"超越"];
    NSRange range2 =  [exceedUserLabel.text rangeOfString:@"瘦瘦用户"];
    
    NSRange colorRange = {range1.location + range1.length ,range2.location - (range1.location+range1.length)};
  
    exceedUserLabel.font = XKDefaultFontWithSize(14);
    [exceedUserLabel setFontColor:XK_STATUS_COLOR_STANDARD range:colorRange];
    
    [topView addSubview:exceedUserLabel];

    [self.view addSubview:topView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
