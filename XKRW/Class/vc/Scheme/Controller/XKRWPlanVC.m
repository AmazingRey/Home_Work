//
//  XKRWPlanVC.m
//  XKRW
//
//  Created by 忘、 on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanVC.h"
#import "XKRWRecordAndTargetView.h"
#import "XKRWUITableViewBase.h"
#import "XKRWUITableViewCellbase.h"
#import "KMSearchBar.h"
#import "KMSearchDisplayController.h"

@interface XKRWPlanVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate, UISearchControllerDelegate,KMSearchDisplayControllerDelegate>
{
    XKRWUITableViewBase  *planTableView;
    KMSearchBar* searchBar;
    KMSearchDisplayController * searchDisplayCtrl;
}

@end

@implementation XKRWPlanVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

#pragma --mark UI
- (void)initView {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    planTableView = [[XKRWUITableViewBase alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight) style:UITableViewStylePlain];
    planTableView.delegate = self;
    planTableView.dataSource = self;
    [self.view addSubview:planTableView];
}

- (XKRWUITableViewCellbase *)setSearchAndRecordCell {
    XKRWUITableViewCellbase *cell = [[XKRWUITableViewCellbase alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchAndRecord"];
    cell.frame = CGRectMake(0, 0, XKAppWidth, 120);
    searchBar = [[KMSearchBar alloc]initWithFrame:CGRectMake(0, 20, XKAppWidth, 44)];
    
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor whiteColor];
//    searchBar.tintColor = XKGrayDefaultColor;
//    searchBar.layer.borderWidth = 0.5;
//    searchBar.layer.borderColor = XK_ASSIST_LINE_COLOR.CGColor ;
    
    searchBar.showsBookmarkButton = true;
    searchBar.showsScopeBar = true;
    
    [searchBar setImage:[UIImage imageNamed:@"voice"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    searchBar.placeholder = @"查询食物和运动" ;
    
    [cell.contentView addSubview:searchBar];
    
    searchDisplayCtrl = [[KMSearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayCtrl.delegate = self ;
    
    searchDisplayCtrl.searchResultDelegate = self ;
    searchDisplayCtrl.searchResultDataSource = self ;
    
    searchDisplayCtrl.searchResultTableView.tag = 201 ;
    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWSearchResultCell" bundle:nil] forCellReuseIdentifier:@"searchResultCell"];
    
    
  
    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWSearchResultCategoryCell" bundle:nil] forCellReuseIdentifier:@"searchResultCategoryCell"];
    

    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWMoreSearchResultCell" bundle:nil] forCellReuseIdentifier:@"moreSearchResultCell"];
    
    
    searchDisplayCtrl.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    XKRWRecordAndTargetView *recordAndTargetView = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordAndTargetView");
    recordAndTargetView.frame = CGRectMake(0, 64, cell.contentView.width, 30);
    recordAndTargetView.dayLabel.layer.masksToBounds = YES;
    recordAndTargetView.dayLabel.layer.cornerRadius = 16;
    recordAndTargetView.dayLabel.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    recordAndTargetView.dayLabel.layer.borderWidth = 1;
    
    recordAndTargetView.currentWeightLabel.layer.masksToBounds = YES;
    recordAndTargetView.currentWeightLabel.layer.cornerRadius = 16;
    recordAndTargetView.currentWeightLabel.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    recordAndTargetView.currentWeightLabel.layer.borderWidth = 1;
    
    [recordAndTargetView.weightButton addTarget:self action:@selector(setUserDataAction:) forControlEvents:UIControlEventTouchUpInside];
    [recordAndTargetView.calendarButton addTarget:self action:@selector(entryCalendarAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:recordAndTargetView];
    
    return cell;
}





#pragma --mark Action
- (void)setUserDataAction:(UIButton *)button {

}

- (void)entryCalendarAction:(UIButton *)button{

}

#pragma --mark Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XKRWUITableViewCellbase *cell  = [tableView dequeueReusableCellWithIdentifier:@"searchAndRecord"];
    if(cell == nil){
        cell = [self setSearchAndRecordCell];
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
