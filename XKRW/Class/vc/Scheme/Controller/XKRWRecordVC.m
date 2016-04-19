//
//  XKRWRecordVC.m
//  XKRW
//
//  Created by 忘、 on 16/4/13.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecordVC.h"
#import "KMSearchBar.h"
#import "XKRWRecordService4_0.h"
#import "KMSearchDisplayController.h"
#import "XKRWFoodCell.h"
#import "XKRWSportCell.h"
#import "XKRW-Swift.h"
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/iflyMSC.h>

@interface XKRWRecordVC ()<UISearchControllerDelegate,KMSearchDisplayControllerDelegate,IFlyRecognizerViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource> {
    UISegmentedControl *segmentCtl;
    NSString *searchKey;
    UIScrollView  *backgroundScrollView;
    UITableView  *recentRecordTableView;
    UITableView  *collectTableView;
    
    NSMutableArray     *dataArray;
    NSArray *recentRecordArray;
    NSString *tableName;
    XKRWRecordEntity4_0 *recordEntity4_0;
    KMSearchBar *recordSearchBar;
    KMSearchDisplayController *searchDisplayCtrl;
    IFlyRecognizerView *iFlyControl;
}

@end

@implementation XKRWRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

#pragma --mark UI
- (void) initView {
    if(_schemeType == eSchemeFood){
        self.title = @"记录运动";
        tableName = @"sport_record";
    }else{
        self.title = @"记录食物";
        tableName = @"food_record";
    }
    
    recordSearchBar = [[KMSearchBar alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 44)];
    
    recordSearchBar.delegate = self;
    recordSearchBar.barTintColor = XKBGDefaultColor;
  
    [recordSearchBar setSearchBarTextFieldColor:[UIColor whiteColor]];
    recordSearchBar.layer.borderWidth = 0.5;
    recordSearchBar.layer.borderColor = XK_ASSIST_LINE_COLOR.CGColor;
    recordSearchBar.showsBookmarkButton = true;
    recordSearchBar.showsScopeBar = true;
    
    [recordSearchBar setImage:[UIImage imageNamed:@"voice"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    recordSearchBar.placeholder = @"查询食物" ;
    searchDisplayCtrl = [[KMSearchDisplayController alloc] initWithSearchBar:recordSearchBar contentsController:self];
    searchDisplayCtrl.delegate = self ;
 //   searchDisplayCtrl.searchResultDelegate = self ;
 //   searchDisplayCtrl.searchResultDataSource = self ;
    
    searchDisplayCtrl.searchResultTableView.tag = 201 ;
    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWSearchResultCell" bundle:nil] forCellReuseIdentifier:@"searchResultCell"];
    

    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWSearchResultCategoryCell" bundle:nil] forCellReuseIdentifier:@"searchResultCategoryCell"];
    
    
    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWMoreSearchResultCell" bundle:nil] forCellReuseIdentifier:@"moreSearchResultCell"];
    
    
    searchDisplayCtrl.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
   
    [self.view addSubview:recordSearchBar];
    
    segmentCtl = [[UISegmentedControl alloc] initWithItems:@[@"最近吃过",@"收藏的食物"]];
    segmentCtl.frame = CGRectMake(15, 54, XKAppWidth - 30, 30);
    segmentCtl.tintColor = XKMainToneColor_29ccb1;
    segmentCtl.layer.masksToBounds = YES;
    segmentCtl.selectedSegmentIndex = 0;
    [segmentCtl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentCtl];
    
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentCtl.bottom+10, XKAppWidth, XKAppHeight - 50)];
    backgroundScrollView.contentSize = CGSizeMake(XKAppWidth * 2, XKAppHeight - 50);
    backgroundScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:backgroundScrollView];
    
    recentRecordTableView = [[UITableView alloc] initWithFrame:backgroundScrollView.bounds style:UITableViewStylePlain];
    recentRecordTableView.backgroundColor = [UIColor orangeColor];
    recentRecordTableView.tag = 10001;
    [recentRecordTableView registerNib:[UINib nibWithNibName:@"XKRWFoodRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"recentRecordCell"];
    [backgroundScrollView addSubview:recentRecordTableView];

    collectTableView = [[UITableView alloc] initWithFrame:backgroundScrollView.bounds style:UITableViewStylePlain];
    collectTableView.backgroundColor = [UIColor grayColor];
    collectTableView.tag = 10002;
    collectTableView.origin = CGPointMake(XKAppWidth, 0);
    [collectTableView registerClass:[XKRWFoodCell class] forCellReuseIdentifier:@"collectionFoodCell"];
    [collectTableView registerClass:[XKRWSportCell class] forCellReuseIdentifier:@"collectionSportCell"];
    [backgroundScrollView addSubview:collectTableView];
    
    
    iFlyControl = [[IFlyRecognizerView alloc]initWithCenter:CGPointMake(XKAppWidth/2, XKAppHeight/2)];
    [iFlyControl setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN] ];
    [iFlyControl setParameter:@"srview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH] ];
    [iFlyControl setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT] ];
    [iFlyControl setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE] ];
    [iFlyControl setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE] ];
    [iFlyControl setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT] ];
    [iFlyControl setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source" ];
    
    iFlyControl.delegate = self;
    iFlyControl.hidden = YES;
    [self.view addSubview:iFlyControl];

    
}

#pragma --mark Data

- (void) initData {
    recordEntity4_0 = [[XKRWRecordService4_0 sharedService]getAllRecordOfDay:[NSDate today]];
    if (dataArray == nil){
        dataArray = [NSMutableArray array];
    }
    recentRecordArray = [[XKRWRecordService4_0 sharedService] queryRecent_20_RecordTable:tableName];
    XKLog(@"%@",[[XKRWRecordService4_0 sharedService] queryRecent_20_RecordTable:tableName]);
}


#pragma --mark Action

- (void)segmentChange:(UISegmentedControl *)segment {
    [UIView animateWithDuration:0.2 animations:^{
        backgroundScrollView.contentOffset = CGPointMake(segment.selectedSegmentIndex * XKAppWidth, 0);
    }];
}


#pragma --mark UISearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    CGRect frame = recordSearchBar.frame;
    frame.origin.y = 20;
    recordSearchBar.frame = frame;
    segmentCtl .hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchDisplayCtrl showSearchResultView];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:NO];
    [searchDisplayCtrl hideSearchResultView];
}


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    CGRect frame = recordSearchBar.frame;
    frame.origin.y = 0;
    recordSearchBar.frame = frame;
    segmentCtl .hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text.length > 0){
        searchKey = searchBar.text;
        [self downloadWithTaskID:@"search" outputTask:^id{
            
            return nil;
        }];
        
        if([searchBar resignFirstResponder])
        {
            [recordSearchBar setCancelButtonEnable:YES];
        }
    }
}



- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    [searchDisplayCtrl showSearchResultView];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    if (iFlyControl.hidden){
        iFlyControl.hidden = NO;
        [iFlyControl start];
    }else{
        iFlyControl.hidden = YES;
        [iFlyControl cancel];
        
    }
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 10001) {
        return recentRecordArray.count;
    } else if (tableView.tag == 10002) {
        return dataArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     let entity = self.searchResults[indexPath.row] as! XKRWSportEntity
     cell.setTitle(entity.sportName, logoURL: entity.sportActionPic, clickDetail: { (indexPath) -> () in
     
     self.search_bar.resignFirstResponder()
     self.search_bar.setCancelButtonEnable(true)
     
     let vc = XKRWSportDetailVC()
     vc.sportEntity = entity
     vc.sportID = entity.sportId
     //                            vc.isNeedHideNaviBarWhenPoped = false
     //                            self.isNeedHideNaviBarWhenPoped = true;
     
     vc.isPresent = true
     let nav = XKRWNavigationController(rootViewController: vc)
     weakSelf?.navigationController?.presentViewController(nav, animated: true, completion: nil)
     
     }, clickRecord: { (indexPath) -> () in
     
     self.search_bar.resignFirstResponder()
     self.search_bar.setCancelButtonEnable(true)
     
     let vc = XKRWSportAddVC()
     vc.sportEntity = entity
     vc.recordEneity = self.recordEntity
     //                            vc.isNeedHideNaviBarWhenPoped = false
     //                            self.isNeedHideNaviBarWhenPoped = true;
     
     vc.passMealTypeTemp = eSport;
     vc.needHiddenDate = true;
     
     vc.isPresent = true
     let nav = XKRWNavigationController(rootViewController: vc)
     weakSelf?.navigationController?.presentViewController(nav, animated: true, completion: nil)
     })
*/
    if (tableView.tag == 10001) {
        XKRWFoodRecordCell *recentRecordCell = [tableView dequeueReusableCellWithIdentifier:@"recentRecordCell" forIndexPath:indexPath];
        if ([tableName isEqualToString:@"food_record"]) {
            
        } else if ([tableName isEqualToString:@"sport_record"]) {
            XKRWSportEntity *entity = recentRecordArray[indexPath.row];
            
            [recentRecordCell setTitle:entity.sportName logoURL:entity.sportActionPic clickDetail:^(NSIndexPath * sportIndexPath) {
                XKRWSportDetailVC *vc = [[XKRWSportDetailVC alloc] init];
                vc.sportEntity = entity;
                vc.isPresent = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } clickRecord:^(NSIndexPath * sportIndexPath) {
                XKRWSportAddVC *addVC = [[XKRWSportAddVC alloc] init];
                addVC.sportEntity = entity;
                addVC.recordEneity = recordEntity4_0;
                addVC.passMealTypeTemp = eSport;
                addVC.needHiddenDate = YES;
                addVC.isPresent = YES;
                [self.navigationController presentViewController:addVC animated:YES completion:nil];
            }];
        }
        return recentRecordCell;
    } else if (tableView.tag == 10002) {
        
        if ([tableName isEqualToString:@"food_record"]) {
            
            return [XKRWFoodCell new];
        } else if ([tableName isEqualToString:@"sport_record"]) {
            
            return [XKRWSportCell new];
        }
    }
    return [UITableViewCell new];
}
#pragma --mark IFlyDelegate
// MARK: - iFly's delegate

- (void)onError:(IFlySpeechError *)error {
    if ([error errorCode] != 0){
        [XKRWCui  showInformationHudWithText:@"搜索失败"];
    }
}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
    if (resultArray != nil && resultArray.count > 0 ){
        
        NSLog(@"%@\n%@",resultArray,[[resultArray lastObject] allKeys].lastObject);
        
        recordSearchBar.text = [[[resultArray lastObject] allKeys] lastObject];
        [self searchBarSearchButtonClicked:recordSearchBar];
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
