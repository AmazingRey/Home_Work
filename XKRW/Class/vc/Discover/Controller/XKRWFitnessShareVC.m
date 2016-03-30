//
//  XKRWFitnessShareVC.m
//  XKRW
//
//  Created by Shoushou on 15/9/14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWFitnessShareVC.h"
#import "XKRWRecommendListVC.h"
#import "XKRWBlogMyListVC.h"
#import "XKRWUtil.h"
#import "define.h"
#import "XKRWConstValue.h"
#import "XKRW-Swift.h"

@interface XKRWFitnessShareVC ()<UIScrollViewDelegate>
{
    XKRWRecommendListVC *recommendListVC;
    XKRWBlogMyListVC *blogMyListVC;
}
@property (nonatomic, strong) UIScrollView *bgView;
@property (nonatomic, strong) UISegmentedControl *segmentCtl;

@end

@implementation XKRWFitnessShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNaviBarBackButton];
    [self addNaviBarSegmentBtn];
    [self addNaviBarRightButtonWithNormalImageName:@"icon_write" highlightedImageName:@"icon_write_p" selector:@selector(editArticleItemClicked)];
    
    [self initUI];

    [MobClick event:@"in_SlimmingShare"];

}

- (void) addNaviBarSegmentBtn {
    NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:XKDefaultFontWithSize(14), NSFontAttributeName, nil];
    NSDictionary *selectedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil];
    
    _segmentCtl = [[UISegmentedControl alloc] initWithItems:@[@"推荐",@"我的"]];
    [_segmentCtl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    [_segmentCtl setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
    
    _segmentCtl.center = CGPointMake(XKAppWidth/2, 22);
    _segmentCtl.size = CGSizeMake(120, 30);
    _segmentCtl.tintColor = [UIColor colorFromHexString:@"#d5f5f3"];
    _segmentCtl.layer.masksToBounds = YES;
    _segmentCtl.layer.borderWidth = 1.5;
    _segmentCtl.layer.borderColor = [UIColor colorFromHexString:@"#d5f5f3"].CGColor;
    _segmentCtl.layer.cornerRadius = 15;
    _segmentCtl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segmentCtl;
    [_segmentCtl addTarget:self action:@selector(turnToMyShareOrRecommend:) forControlEvents:UIControlEventValueChanged];
}

- (void)initUI {
    
    _bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth , XKAppHeight - 64)];
    _bgView.backgroundColor = XKClearColor;
    _bgView.contentSize = CGSizeMake(XKAppWidth*2, _bgView.height);
    _bgView.pagingEnabled = YES;
    _bgView.scrollEnabled = NO;
    _bgView.scrollsToTop = NO;
    [self.view addSubview:_bgView];
    
    recommendListVC = [[XKRWRecommendListVC alloc] init];
    [self addChildViewController:recommendListVC];
    [_bgView addSubview:recommendListVC.view];
    
    blogMyListVC = [[XKRWBlogMyListVC alloc] init];
    blogMyListVC.view.origin = CGPointMake(XKAppWidth, 0);
    [self addChildViewController:blogMyListVC];
    [_bgView addSubview:blogMyListVC.view];
    
    recommendListVC.tableView.scrollsToTop = YES;
    blogMyListVC.myArticleTable.scrollsToTop = NO;
}

#pragma mark - Action
- (void)turnToMyShareOrRecommend:(UISegmentedControl *)segmentCtl {
    
    if (segmentCtl.selectedSegmentIndex == 1) {
        self.myType = XKRWMyShareType;
        recommendListVC.tableView.scrollsToTop = NO;
        blogMyListVC.myArticleTable.scrollsToTop = YES;
        [_bgView scrollRectToVisible:CGRectMake(XKAppWidth, 0, XKAppWidth , XKAppHeight - 64) animated:YES];
       
    } else {
        self.myType = XKRWFitnessShareType;
        recommendListVC.tableView.scrollsToTop = YES;
        blogMyListVC.myArticleTable.scrollsToTop = NO;
        [_bgView scrollRectToVisible:CGRectMake(0, 0, XKAppWidth , XKAppHeight - 64) animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 点击事件
// 写分享
- (void)editArticleItemClicked {
    [MobClick event:@"clk_WriteShare"];
    XKRWArticleEditVC *vc = [[XKRWArticleEditVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
