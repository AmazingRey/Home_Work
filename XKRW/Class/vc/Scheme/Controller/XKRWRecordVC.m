//
//  XKRWRecordVC.m
//  XKRW
//
//  Created by 忘、 on 16/4/13.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecordVC.h"
#import "KMSearchBar.h"
#import "KMSearchDisplayController.h"
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/iflyMSC.h>

@interface XKRWRecordVC ()<UISearchControllerDelegate,KMSearchDisplayControllerDelegate,IFlyRecognizerViewDelegate,UISearchBarDelegate> {
    UISegmentedControl *segmentCtl;
    NSString *searchKey;
    UITableView  *recordTableView;
    
    NSMutableArray     *dataArray;
    
    KMSearchBar *recordSearchBar;
    KMSearchDisplayController *searchDisplayCtrl;
    IFlyRecognizerView *iFlyControl;
}

@end

@implementation XKRWRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

#pragma --mark UI
- (void) initView {
    if(_schemeType == eSchemeFood){
        self.title = @"记录运动";
    }else{
        self.title = @"记录食物";
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
    
    recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, segmentCtl.bottom+10, XKAppWidth, XKAppHeight - 50) style:UITableViewStylePlain];
    [self.view addSubview:recordTableView];
    
    
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
    if (dataArray == nil){
        dataArray = [NSMutableArray array];
    }
}


#pragma --mark Action

- (void)segmentChange:(UISegmentedControl *)segment {
    
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
