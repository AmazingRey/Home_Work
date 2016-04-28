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
#import "XKRWSportDetailVC.h"

@interface XKRWRecordVC ()<UISearchControllerDelegate,KMSearchDisplayControllerDelegate,IFlyRecognizerViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource> {
    UISegmentedControl *segmentCtl;
    NSString *searchKey;
    UIScrollView  *backgroundScrollView;
    UITableView  *recentRecordTableView;
    UITableView  *collectTableView;
    UIView *nonCollectionView;
    UIView *nonRecentRecordView;
    
    NSArray *segementTitles;
    NSMutableArray     *dataArray;
    NSArray *recentRecordArray;
    NSString *tableName;
    XKRWRecordEntity4_0 *recordEntity4_0;
    NSInteger collectionType;
    RecordType foodRecordType;
    
    KMSearchBar *recordSearchBar;
    KMSearchDisplayController *searchDisplayCtrl;
    IFlyRecognizerView *iFlyControl;
    
    NSArray *searchResults;
    
    NSString *recordSearchBarplaceText;
 
}

@end

@implementation XKRWRecordVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

#pragma --mark UI
- (void)setFoodRecordType {
   
    switch (_mealType) {
        case eSport:
            foodRecordType = RecordTypeSport;
            break;
        case eMealBreakfast:
            foodRecordType = RecordTypeBreakfirst;
            break;
        case eMealLunch:
            foodRecordType = RecordTypeLanch;
            break;
        case eMealDinner:
            foodRecordType = RecordTypeDinner;
            break;
        case eMealSnack:
            foodRecordType = RecordTypeSnack;
            break;
        default:
            break;
    }

}
- (void) initView {
    
    UILabel *noRecentRecordLabel = [[UILabel alloc] init];
    noRecentRecordLabel.font = XKDefaultFontWithSize(14);
    noRecentRecordLabel.textColor = XK_ASSIST_TEXT_COLOR;
    if(_schemeType == eSchemeFood){
        self.title = @"记录食物";
        tableName = @"food_record";
        segementTitles = @[@"最近吃过",@"收藏的食物"];
        collectionType = 1;
        recordSearchBarplaceText = @"查询食物";
        noRecentRecordLabel.text = @"最近没有任何饮食记录哦~";
    }else{
        self.title = @"记录运动";
        tableName = @"sport_record";
        segementTitles = @[@"最近做过",@"收藏的运动"];
         recordSearchBarplaceText = @"查询运动";
        collectionType = 2;
        noRecentRecordLabel.text = @"最近没有任何运动记录哦~";
    }
    
    [self setFoodRecordType];
    
    recordSearchBar = [[KMSearchBar alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 44)];
    
    recordSearchBar.delegate = self;
    recordSearchBar.barTintColor = XKBGDefaultColor;
  
//    [recordSearchBar setSearchBarTextFieldColor:[UIColor whiteColor]];
    recordSearchBar.layer.borderWidth = 0.5;
    recordSearchBar.layer.borderColor = XK_ASSIST_LINE_COLOR.CGColor;
    recordSearchBar.showsBookmarkButton = true;
    recordSearchBar.showsScopeBar = true;
    
    [recordSearchBar setImage:[UIImage imageNamed:@"voice"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    recordSearchBar.placeholder = recordSearchBarplaceText ;
    searchDisplayCtrl = [[KMSearchDisplayController alloc] initWithSearchBar:recordSearchBar contentsController:self];
    searchDisplayCtrl.delegate = self ;
    searchDisplayCtrl.searchResultDelegate = self ;
    searchDisplayCtrl.searchResultDataSource = self ;
    searchDisplayCtrl.searchResultTableView.tag = 201 ;
   
    [searchDisplayCtrl.searchResultTableView registerNib:[UINib nibWithNibName:@"XKRWFoodRecordCell" bundle:nil] forCellReuseIdentifier:@"searchResultCell"];
    searchDisplayCtrl.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
   
    [self.view addSubview:recordSearchBar];
    
    segmentCtl = [[UISegmentedControl alloc] initWithItems:segementTitles];
    segmentCtl.frame = CGRectMake(15, 54, XKAppWidth - 30, 30);
    segmentCtl.tintColor = XKMainToneColor_29ccb1;
    segmentCtl.layer.masksToBounds = YES;
    segmentCtl.selectedSegmentIndex = 0;
    [segmentCtl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentCtl];
    
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentCtl.bottom+10, XKAppWidth, XKAppHeight - 50)];
    backgroundScrollView.contentSize = CGSizeMake(XKAppWidth * 2, XKAppHeight - 50);
    backgroundScrollView.contentOffset = CGPointMake(0, 0);
    backgroundScrollView.scrollEnabled = NO;
    [self.view addSubview:backgroundScrollView];
    
    recentRecordTableView = [[UITableView alloc] initWithFrame:backgroundScrollView.bounds style:UITableViewStylePlain];
    recentRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recentRecordTableView.delegate = self;
    recentRecordTableView.dataSource = self;
    recentRecordTableView.tag = 10001;
    [recentRecordTableView registerNib:[UINib nibWithNibName:@"XKRWFoodRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"recentRecordCell"];
    [backgroundScrollView addSubview:recentRecordTableView];

    collectTableView = [[UITableView alloc] initWithFrame:backgroundScrollView.bounds style:UITableViewStylePlain];
    collectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    collectTableView.delegate = self;
    collectTableView.dataSource = self;
    collectTableView.tag = 10002;
    collectTableView.origin = CGPointMake(XKAppWidth, 0);
    [collectTableView registerClass:[XKRWSportCell class] forCellReuseIdentifier:@"collectionSportCell"];
    [backgroundScrollView addSubview:collectTableView];
    
    nonRecentRecordView = [[UIView alloc] initWithFrame:recentRecordTableView.frame];
    nonRecentRecordView.backgroundColor = [UIColor whiteColor];
    nonRecentRecordView.hidden = YES;
    UIImage *noRecentRecordImage = [UIImage imageNamed:@"nothing_"];
    UIImageView *noRecentRecordImageView = [[UIImageView alloc] initWithImage:noRecentRecordImage];
    noRecentRecordImageView.size = noRecentRecordImage.size;
    noRecentRecordImageView.center = CGPointMake(XKAppWidth / 2.0, nonRecentRecordView.height / 2.0);
    [nonRecentRecordView addSubview:noRecentRecordImageView];
    [noRecentRecordLabel sizeToFit];
    noRecentRecordLabel.center = CGPointMake(XKAppWidth / 2.0, 0);
    noRecentRecordLabel.top = noRecentRecordImageView.bottom + 20;
    [nonRecentRecordView addSubview:noRecentRecordLabel];
    [backgroundScrollView insertSubview:nonRecentRecordView aboveSubview:recentRecordTableView];
    
    nonCollectionView = [[UIView alloc] initWithFrame:collectTableView.frame];
    nonCollectionView.backgroundColor = [UIColor whiteColor];
    UIImage *nonCollectionImage = [UIImage imageNamed:@"me_none_640"];
    UIImageView *nonCollectionImageView = [[UIImageView alloc] initWithImage:nonCollectionImage];
    nonCollectionImageView.size = nonCollectionImage.size;
    nonCollectionImageView.center = CGPointMake(XKAppWidth / 2.0, nonCollectionView.height / 2.0);
    [nonCollectionView addSubview:nonCollectionImageView];
    nonCollectionView.hidden = YES;
    [backgroundScrollView insertSubview:nonCollectionView aboveSubview:collectTableView];
    
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
    [dataArray addObjectsFromArray:[[XKRWCollectionService sharedService] queryCollectionWithType:collectionType]];
    
    // deal with haven't collectionData
    if (!dataArray || !dataArray.count) {
        nonCollectionView.hidden = NO;
    } else {
        nonCollectionView.hidden = YES;
    }

    [collectTableView reloadData];
    recentRecordArray = [[XKRWRecordService4_0 sharedService] queryRecent_20_RecordTable:tableName];
    
    // deal with no recent record
    if (!recentRecordArray || !recentRecordArray.count) {
        nonRecentRecordView.hidden = NO;
    } else {
        nonRecentRecordView.hidden = YES;
    }
    [recentRecordTableView reloadData];
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
    [self initData];
    segmentCtl.hidden = NO;
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

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text.length > 0){
        searchKey = searchBar.text;
        [self downloadWithTaskID:@"search" outputTask:^id{
            
            return [[XKRWSearchService sharedService] searchWithKey:searchKey type:XKRWSearchTypeAll page:1 pageSize:30];
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
    }else if (tableView.tag == 201) {
        return searchResults.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 10002) {
        if (collectionType == 1) {
            return 64.f;
        } else if (collectionType == 0) {
            return 44.f;
        }
    } else if (tableView.tag == 10001) {
        return 88;
    } else if (tableView.tag == 201){
        return 83;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;
    if (tableView.tag == 10001) {
        XKRWFoodRecordCell *recentRecordCell = [tableView dequeueReusableCellWithIdentifier:@"recentRecordCell" forIndexPath:indexPath];
        if ([tableName isEqualToString:@"food_record"]) {
            XKRWFoodEntity *recentRecordFoodEntity = recentRecordArray[indexPath.row];
            [recentRecordCell setTitle:recentRecordFoodEntity.foodName logoURL:recentRecordFoodEntity.foodLogo clickDetail:^(NSIndexPath * recordFoodIndexPath) {
                XKRWFoodDetailVC *foodDetailVC = [[XKRWFoodDetailVC alloc] init];
                foodDetailVC.foodId = recentRecordFoodEntity.foodId;
                foodDetailVC.foodName = recentRecordFoodEntity.foodName;
                foodDetailVC.date = [NSDate date];
                [weakSelf.navigationController pushViewController:foodDetailVC animated:YES];
                
            } clickRecord:^(NSIndexPath * recordFoodIndexPath) {
                XKRWRecordFoodEntity *recordEntity = [XKRWRecordFoodEntity new];
                XKRWFoodEntity *tempEntity = [[XKRWFoodService shareService] syncQueryFoodWithId:recentRecordFoodEntity.foodId];
                recordEntity.date = recordEntity4_0.date;
                recordEntity.foodId = tempEntity.foodId;
                recordEntity.foodLogo = tempEntity.foodLogo;
                recordEntity.foodName = tempEntity.foodName;
                recordEntity.foodNutri = tempEntity.foodNutri;
                recordEntity.foodEnergy = tempEntity.foodEnergy;
                recordEntity.foodUnit = tempEntity.foodUnit;
                recordEntity.recordType = foodRecordType;
                XKRWAddFoodVC4_0 *addFoodVC = [[XKRWAddFoodVC4_0 alloc] init];
                addFoodVC.foodRecordEntity = recordEntity;
                [XKRWAddFoodVC4_0 presentAddFoodVC:addFoodVC onViewController:self];
                
            }];

        } else if ([tableName isEqualToString:@"sport_record"]) {
            XKRWSportEntity *entity = recentRecordArray[indexPath.row];
            
            [recentRecordCell setTitle:entity.sportName logoURL:entity.sportActionPic clickDetail:^(NSIndexPath * sportIndexPath) {
                XKRWSportDetailVC *vc = [[XKRWSportDetailVC alloc] init];
                XKRWSportEntity *detailSportEntity = [[XKRWSportService shareService] syncQuerySportWithId:entity.sportId];
                vc.sportEntity = detailSportEntity;
                vc.sportID = entity.sportId;
                vc.sportName = entity.sportName;
                vc.isPresent = NO;
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } clickRecord:^(NSIndexPath * sportIndexPath) {
                XKRWSportAddVC *addVC = [[XKRWSportAddVC alloc] init];
                addVC.sportEntity = entity;
                addVC.recordEneity = recordEntity4_0;
                addVC.passMealTypeTemp = eSport;
                addVC.needHiddenDate = YES;
                addVC.isPresent = YES;
                [weakSelf.navigationController presentViewController:addVC animated:YES completion:nil];
            }];
        }
        return recentRecordCell;
    } else if (tableView.tag == 10002) {
        
        if ([tableName isEqualToString:@"food_record"]) {
            XKRWFoodCell *foodCell = [tableView dequeueReusableCellWithIdentifier:@"collectionFoodCell"];
            if (foodCell == nil) {
                foodCell = [[XKRWFoodCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"collectionFoodCell"];
                
            }
            if ([dataArray count] > indexPath.row) {
                NSDictionary *dict_value = (NSDictionary*)[dataArray objectAtIndex:indexPath.row];
                [foodCell setCollectCellValue:dict_value];
            }

            return foodCell;
        } else if ([tableName isEqualToString:@"sport_record"]) {
            
            return [XKRWSportCell new];
        }
    }else if (tableView.tag == 201){
        XKRWFoodRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
        cell.indexPath = indexPath ;
        
        if(_schemeType == eSchemeSport){
            XKRWSportEntity *sportEntity = [searchResults objectAtIndex:indexPath.row];
            [cell setTitle:sportEntity.sportName logoURL:sportEntity.sportActionPic clickDetail:^(NSIndexPath * indexPath) {
                [recordSearchBar resignFirstResponder];
                [recordSearchBar setCancelButtonEnable:YES];
                
                XKRWSportDetailVC *sportDetailVC = [[XKRWSportDetailVC alloc] init];
                sportDetailVC.sportEntity = sportEntity;
                sportDetailVC.sportID = sportEntity.sportId;
                sportDetailVC.isPresent = YES;
                XKRWNavigationController *nav = [[XKRWNavigationController alloc]initWithRootViewController:sportDetailVC];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            } clickRecord:^(NSIndexPath * indexPath) {
                [recordSearchBar resignFirstResponder];
                [recordSearchBar setCancelButtonEnable:YES];
                
                XKRWSportAddVC *sportAddVC = [[XKRWSportAddVC alloc] init];
                sportAddVC.sportEntity = sportEntity;
                sportAddVC.sportID = sportEntity.sportId;
                
                sportAddVC.passMealTypeTemp = eSport;
                sportAddVC.needHiddenDate = true;
                
                sportAddVC.isPresent = true;
                XKRWNavigationController *nav = [[XKRWNavigationController alloc]initWithRootViewController:sportAddVC];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }];
            
        }else {
            XKRWFoodEntity *foodEntity = [searchResults objectAtIndex:indexPath.row];
            [cell setTitle:foodEntity.foodName logoURL:foodEntity.foodLogo clickDetail:^(NSIndexPath * indexPath) {
                [recordSearchBar resignFirstResponder];
                [recordSearchBar setCancelButtonEnable:YES];
                XKRWFoodDetailVC *foodDetailVC = [[XKRWFoodDetailVC alloc] init];
                foodDetailVC.foodEntity = foodEntity;
                foodDetailVC.isPresent = YES;
                XKRWNavigationController *nav = [[XKRWNavigationController alloc]initWithRootViewController:foodDetailVC];
                [weakSelf presentViewController:nav animated:YES completion:nil];
                
            } clickRecord:^(NSIndexPath * indexPath) {
                [recordSearchBar resignFirstResponder];
                [recordSearchBar setCancelButtonEnable:YES];
                XKRWRecordFoodEntity *recordFoodEntity = [[XKRWRecordFoodEntity alloc] init];
                recordFoodEntity.date = recordEntity4_0.date;
                recordFoodEntity.foodId = foodEntity.foodId;
                recordFoodEntity.foodLogo = foodEntity.foodLogo;
                recordFoodEntity.foodName = foodEntity.foodName;
                recordFoodEntity.foodNutri = foodEntity.foodNutri;
                recordFoodEntity.foodEnergy = foodEntity.foodEnergy;
                recordFoodEntity.foodUnit = foodEntity.foodUnit;
                recordFoodEntity.recordType = foodRecordType;
                XKRWAddFoodVC4_0 *addFoodVC = [[XKRWAddFoodVC4_0 alloc] init];
                addFoodVC.foodRecordEntity = recordFoodEntity;
                [XKRWAddFoodVC4_0 presentAddFoodVC:addFoodVC onViewController:self];
            }];
        
        }
        return  cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 10001) {
        return;
        
    } else if (tableView.tag == 10002) {
        
        if (collectionType == 1) {
            if ([dataArray count] > indexPath.row) {
                XKRWFoodDetailVC *vc = [[XKRWFoodDetailVC alloc ]init];
                vc.foodId = [[dataArray[indexPath.row] valueForKey:@"original_id"] intValue];
                vc.foodName = [dataArray[indexPath.row] valueForKey:@"collect_name"];
                
                vc.date = [NSDate date];
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        } else if (collectionType == 2) {
            if ([dataArray count] > indexPath.row) {
                
                XKRWSportDetailVC *vc = [[XKRWSportDetailVC alloc]init];
                vc.sportID = [[dataArray[indexPath.row] valueForKey:@"original_id"] intValue];
                vc.sportName = [dataArray[indexPath.row] valueForKey:@"collect_name"];
                vc.date = [NSDate date];
                vc.needHiddenDate = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else return;
            
        }
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

#pragma --mark  NetWorkDeal
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    if ([taskID isEqualToString:@"search"]){
    
        if (_schemeType == eSchemeSport) {
            searchResults = [result objectForKey:@"sport"];
        } else {
            searchResults = [result objectForKey:@"food"];
        }
        if(!searchDisplayCtrl.isShowSearchResultTableView){
            [searchDisplayCtrl showSearchResultTableView];
        }
        [searchDisplayCtrl reloadSearchResultTableView];
        return ;
    }
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    [super handleDownloadProblem:problem withTaskID:taskID];
    
 }

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication {
    return YES;
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
