//
//  XKRWModifyNickNameViewController.m
//  XKRW
//
//  Created by Leng on 14-4-2.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "CityListViewController.h"
#import "CustomDisplayerController.h"
#import <sqlite3.h>
#import "XKRWCityControlService.h"
#import "PYMethod.h"
#import <CoreLocation/CoreLocation.h>
#import "XKSilentDispatcher.h"
#import "XKRWUserService.h"
#import "XKRWCui.h"

/*
  GPS顶部视图
 功能：
    1、定位调用
    2、重定位
 */
 //定位 显示部分
@interface GPSView : UIView<CLLocationManagerDelegate>
{
    BOOL isLocationing;
}

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) UILabel * title;

@property (nonatomic, strong) UIButton * active;

@property (nonatomic) CLLocationManager * lm;

@property (nonatomic,assign)double latitude;

@property (nonatomic,assign)double longitude;

@property (nonatomic, strong) CLGeocoder * geoCoder;

@property (nonatomic, strong) UILabel * action;

- (void)startLocation;

- (void) updateCity:(NSString *) cityName;

@end

@implementation GPSView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 44)];
        _title.backgroundColor =[UIColor clearColor];
        _title.text = @"正在定位城市...";
        _title.font = [UIFont systemFontOfSize:16];
        _title.textColor = [UIColor colorFromHexString:@"#333333"];
        [self addSubview:_title];

    
        self.active =[UIButton buttonWithType:UIButtonTypeCustom];
        [_active setBackgroundColor:[UIColor clearColor]];
        _active.frame = CGRectMake(230, 0, 70, 44);
        _active.titleLabel.textAlignment = NSTextAlignmentRight;
        _active.titleLabel.font = [UIFont systemFontOfSize:16];
        [_active setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:UIControlStateNormal];
        [_active setTitle:@"GPS定位" forState:UIControlStateNormal];
        [_active addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    
        _active.hidden = YES;
        [self addSubview:_active];
        
        self.action = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 280, 44)];
        _action.backgroundColor =[UIColor clearColor];
        _action.text = @"";
        _action.font = [UIFont systemFontOfSize:16];
        _action.textColor = [UIColor colorFromHexString:@"#999999"];
        [self addSubview:_action];

    }
    return self;
}

//外部
- (void)startLocation{
    if (![XKRWUtil isNetWorkAvailable]) {
    
        _title.text = @"无法定位当前城市";
        
        return;
    
    }
    
    [self updateCity:nil];

    if (isLocationing) {
        return;
    }
    BOOL isLocationAva = [CLLocationManager locationServicesEnabled];
    if (isLocationAva) {
        _active.hidden = NO;
        
        _action.hidden = YES;
        if (!_lm) {
            self.lm = [[CLLocationManager alloc] init] ;
            _lm.delegate = self;
            _lm.desiredAccuracy = kCLLocationAccuracyBest;
            _lm.distanceFilter = 500000;
#if 1
            if(IOS_VERSION >= 8.0)
            {
                [_lm requestWhenInUseAuthorization];
            }
          
       
            
#endif
        }
        
        [_lm startUpdatingLocation];

        isLocationing = YES;
    }else{
        //请到《设置-隐私-定位服务》中开启服务
        _title.text = @"定位城市：";
        
        _action.text =@"请到《设置-隐私-定位服务》中开启服务";
        _action.font = [UIFont systemFontOfSize:12];
        _action.frame = CGRectMake(80, 0, 240, 44);
        _action.hidden = NO;
        
        _active.hidden = YES;
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [_lm requestWhenInUseAuthorization];

        }
            break;
            
        default:
            break;
    }
}

-(void)updateCity:(NSString *)cityName{
    
    if (cityName && cityName.length) {
        _title.text = [NSString stringWithFormat:@"定位城市：%@",cityName];
        _active.hidden = NO;
    }else{
        _title.text = @"正在定位城市...";
    }
}


//内部
- (void)locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation
{
    _latitude = newLocation.coordinate.latitude;
    
    _longitude = newLocation.coordinate.longitude;
    
    [_lm stopUpdatingLocation];
    [self startedReverseGeoderWithLatitude:_latitude longitude:_longitude];
}

//下面是取得地理位置信息,有城市街道信息等(iOS6和iOS6以下,貌似取出来的会不太一样)
- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude{
    CLLocation * coordinate2D = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: coordinate2D completionHandler:^(NSArray *array, NSError *error) {
        isLocationing = NO;
        
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *country = placemark.ISOcountryCode;
            NSString *city = placemark.locality;
            NSString * locat = placemark.administrativeArea;
            XKLog(@"---%@..........city  %@   locat  %@..cout:%d",country,city,locat,(uint32_t)[array count]);
     
            if (city && city.length) {
                if (_delegate && [_delegate respondsToSelector:@selector(silentUpdateCity:)]) {
                    [_delegate performSelector:@selector(silentUpdateCity:) withObject:city];
                }
                _title.text = [NSString stringWithFormat:@"定位城市：%@",city];
                
            }else{
                _title.text = [NSString stringWithFormat:@"定位城市：%@",locat];
                if (_delegate && [_delegate respondsToSelector:@selector(silentUpdateCity:)]) {
                    [_delegate performSelector:@selector(silentUpdateCity:) withObject:locat];
                }
            }
        }else{
            XKLog(@"据说 没网");
            _title.text = @"无法定位当前城市";
            //获取失败的处理
        }
    }];
    
}

- (void)stopLocation
{
    [_lm stopUpdatingLocation];
    
}

@end

/*
 城市地位/选择
 功能：
 1、定位当前位置信息
 2、通过列表用户手动选择位置信息
 3、保存位置信息
 */
//定位 显示部分



//城市列表
@interface CityListViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>{
    CustomDisplayerController *searchDisplayController;
}
@property (nonatomic, strong) UISearchBar * search;
@property (nonatomic, strong)    GPSView * gpsView ;
@property (nonatomic, strong)    NSArray * searchResults;  //存放搜索结果的数组

@property (nonatomic, copy) NSString * userCity;


@property (nonatomic,assign) int cityID;
@property (nonatomic,assign) int provinceID;
@property (nonatomic,assign) int districtID;


@end

@implementation CityListViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        [self initComment];
    }
    return self;
}




-(void)initComment{

    self.cities =[NSMutableDictionary dictionary];
    /*
     */
    self.arrayHotCity = [NSMutableArray arrayWithObjects:
                         @"上海市",@"北京市",@"广州市",@"深圳市",@"成都市",@"重庆市",@"天津市",@"杭州市",@"南京市",@"苏州市",@"武汉市",@"西安市",@"香港特别行政区",@"澳门特别行政区",@"台北市",nil];
    self.keys = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z", nil];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    [self addNaviBarBackButton];
    self.title = @"所在城市";
    
    self.search= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 44)];
    
    for (UIView *subView in _search.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subView removeFromSuperview];
            break;
        }
    }
    [_search setValue:@"取消" forKey:@"_cancelButtonText"];
    _search.delegate = self;
    _search.showsCancelButton = NO;
    _search.placeholder = @"请输入城市名称或首字母查询";
    _search.backgroundColor = XKBGDefaultColor;
    
    [self.view addSubview:_search];

    self.view.backgroundColor = XKBGDefaultColor;
    
    searchDisplayController =[[CustomDisplayerController alloc] initWithSearchBar:_search contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
    //取出用户之前位置时 更新gps
    
    self.gpsView =[[GPSView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 44)];
    [_gpsView updateCity:[[XKRWUserService sharedService] getUserCity]];
    _gpsView.delegate = self;
    _gpsView.backgroundColor =XKBGDefaultColor;
    
	// Do any additional setup after loading the view.
    CGRect rect =self.view.bounds;
    rect.origin.y += 44;
    rect.size.height -= 44;
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [XKUtil executeCodeWhenSystemVersionAbove:7.0 blow:0 withBlock:^{
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }];
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    [self.view addSubview:_tableView];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCityData];

    [self.gpsView startLocation];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void) silentUpdateCity:(NSString *) name{
    
    [self updateUserCity:name needSilent:YES];
}

-(void) updateUserCity:(NSString *)name{
    
    [self updateUserCity:name needSilent:NO];
}

-(void) updateUserCity:(NSString *)name needSilent:(BOOL) need{
    NSArray * cityTemp = [[XKRWCityControlService shareService] getCityListWithCityName:name];
    NSDictionary * temp = [cityTemp lastObject];
    int cID = 0;
    int pID = 0;
    cID = [[temp objectForKey:@"id"] intValue];
    pID = [[temp objectForKey:@"pid"] intValue];
    self.userCity = name;
    
    if (need) {
        [[XKRWUserService sharedService] setUserCity:[NSString stringWithFormat:@"%d,%d,%d",pID,cID,_districtID]];

        [XKSilentDispatcher asynExecuteTask:^{
           
            [[XKRWCityControlService shareService] updateLocationInfoWithCity:cID andProvence:pID andDes:_districtID];

        }];
        
    }else{
        
        [self updateCID:cID andPID:pID];
    }
}

-(void) updateCID:(int) cid andPID:(int)pid{
    self.cityID = cid;
    self.provinceID = pid;
    self.districtID = 0;
    if (_userCity && _userCity.length) {
        XKLog(@"保存 城市   %@",_userCity);

        [self uploadWithTask:^{
            
            [[XKRWCityControlService shareService] updateLocationInfoWithCity:_cityID andProvence:_provinceID andDes:_districtID];
        } message:@"城市变更中..."] ;
        
    }
    
}

-(void)savePersonalInfo {
    
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"没有网络无法修改资料哦"];
        return;
    }
    
    [self uploadWithTask:^{
        [[XKRWUserService sharedService] uploadUserInfoToRemoteServerByToken:[[XKRWUserService sharedService] getToken]];
    }];
}

-(void)didUpload{
    
    [[XKRWUserService sharedService] setUserCity:[NSString stringWithFormat:@"%d,%d,%d",_provinceID,_cityID,_districtID]];
    [[XKRWUserService sharedService] saveUserInfo];
    
    [XKRWCui showInformationHudWithText:@"城市变更成功..."];

    [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];

}
-(void)finallyJobWhenUploadFail{
    [XKRWCui showInformationHudWithText:@"城市变更失败..."];
}

-(void)popView{

    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - 获取城市数据
-(void)getCityData
{
    //添加城市数据
    
    for (NSString * key in _keys) {
        
        NSArray * arrtemp = [[XKRWCityControlService shareService] getCityListWithKey:key];
        if (arrtemp && arrtemp.count) {
            [self.cities setObject:arrtemp forKey:key];
        }

    }
         
    //添加热门城市
    NSString *strHot = @"热";
    [self.keys insertObject:strHot atIndex:0];
    [self.cities setObject:_arrayHotCity forKey:strHot];

    
    [_tableView reloadData];
}

#pragma mark - tableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView  isEqual:self.searchDisplayController.searchResultsTableView]){ //表示当前tableView显示的是搜索结果
        return 0;
    }else{
        
        if (!section) {
            return 22 + 44;
        }
        return 22.0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView  isEqual:self.searchDisplayController.searchResultsTableView]){ //表示当前tableView显示的是搜索结果
        return nil;
    }else{
        
        NSString * color = @"#e6e6e6";
        if (!section) {
            UIView *bgView = [tableView viewWithTag:669988];
            if (!bgView) {
                bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 20)];
                bgView.backgroundColor = [UIColor colorFromHexString:color];
                bgView.tag =669988;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 44, XKAppWidth-70, 20)];
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.textColor = [UIColor colorFromHexString:@"#333333"];
                titleLabel.font = [UIFont systemFontOfSize:15];
                titleLabel.text = @"热门城市";
            
                [bgView addSubview:titleLabel];
                [bgView addSubview:_gpsView];
            }
            return bgView;
        }
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 20)];
        bgView.backgroundColor = [UIColor colorFromHexString:color];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, XKAppWidth-70, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        NSString *key = [_keys objectAtIndex:section];
        if ([key rangeOfString:@"热"].location != NSNotFound) {
            titleLabel.text = @"热门城市";
        }
        else
            titleLabel.text = key;
        
        [bgView addSubview:titleLabel];
        
        return bgView;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([tableView  isEqual:self.searchDisplayController.searchResultsTableView]){ //表示当前tableView显示的是搜索结果
        return nil;
    }else{
        
        return _keys;
    
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView  isEqual:self.searchDisplayController.searchResultsTableView]){ //表示当前tableView显示的是搜索结果
        return 1;
    }else{
        
    // Return the number of sections.
    return [_keys count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if ([tableView  isEqual:self.searchDisplayController.searchResultsTableView]){ //表示当前tableView显示的是搜索结果
        rows = [_searchResults count];
    }else{
        //此处可以展示所有的数据，一般本地搜索可用到，如“电话簿”
        NSString *key = [_keys objectAtIndex:section];
        NSArray *citySection = [_cities objectForKey:key];
        if (citySection && citySection.count) {
            rows = [citySection count];
        }

    }
    return rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView  isEqual:self.searchDisplayController.searchResultsTableView]){ //表示当前tableView显示的是搜索结果
        static NSString *CellIdentifier = @"resCell";
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
        }
        
        cell.textLabel.text = [[_searchResults objectAtIndex:indexPath.row] objectForKey:@"name"];
        return cell;
    }else{
    
        
        
        static NSString *CellIdentifier = @"Cell";
        
        NSString *key = [_keys objectAtIndex:indexPath.section];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
        }
        NSString * cityName = nil;
        if ([key isEqualToString:@"热"]) {
            NSArray * arrContent = [_cities objectForKey:key];
            cityName = [arrContent  objectAtIndex:indexPath.row];
        }else{
            NSArray * arrContent = [_cities objectForKey:key];
            NSDictionary * dicContent = [arrContent  objectAtIndex:indexPath.row];
            cityName = [dicContent objectForKey:@"name"];
        }
        
        cell.textLabel.text = cityName;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int cID = 0;
    int pID = 0;
    NSString * cShow = nil;
    
    if ([tableView  isEqual:self.searchDisplayController.searchResultsTableView]){ //表示当前tableView显示的是搜索结果
        
        NSDictionary * cityTemp = [_searchResults objectAtIndex:indexPath.row];
        cID = [[cityTemp objectForKey:@"id"] intValue];
        pID = [[cityTemp objectForKey:@"pid"] intValue];
        cShow = [cityTemp objectForKey:@"name"];
        
    }else{
        
        NSString *key = [_keys objectAtIndex:indexPath.section];

        if ([key isEqualToString:@"热"]) {
            NSArray * arrContent = [_cities objectForKey:key];
            cShow = [arrContent  objectAtIndex:indexPath.row];
           NSArray * cityTemp = [[XKRWCityControlService shareService] getCityListWithCityName:cShow];
            NSDictionary * temp = [cityTemp lastObject];
            
            cID = [[temp objectForKey:@"id"] intValue];
            pID = [[temp objectForKey:@"pid"] intValue];
            
        }else{
            NSArray * arrContent = [_cities objectForKey:key];
            NSDictionary * dicContent = [arrContent  objectAtIndex:indexPath.row];
            cShow = [dicContent objectForKey:@"name"];
            cID = [[dicContent objectForKey:@"id"] intValue];
            pID = [[dicContent objectForKey:@"pid"] intValue];
            
        }
        
    }

    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"无网络无法修改城市哦"];
        return;
    }
    
    
    [self updateUserCity:cShow];
    [self updateCID:cID andPID:pID];
    
    XKLog(@"name  %@ id %d  pid %d  ",cShow,cID,pID);

}
#pragma  searchbar delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self.search setShowsCancelButton:YES animated:NO];
    for (UIView *subView in _search.subviews){
        if([subView isKindOfClass:[UIButton class]]){
            [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    BOOL keySearch = YES;    
    if (!searchText.length) {
        
        return;
    }
    
    char ch = 0;
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	const char* pszHZ = [searchText cStringUsingEncoding:encode];
	
	 int high = (unsigned char)(pszHZ[0]);
        // 32-> 空格
    ch = (char)high;
    if((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')){
        keySearch = YES;
    }else{
        keySearch = NO;
    }
    
    if (keySearch) {
        
        self.searchResults = [[XKRWCityControlService shareService] getCityListWithKey:[PYMethod getPinYin:searchText]];
    }else{
        
        self.searchResults = [[XKRWCityControlService shareService] getCityListWithCityName:searchText];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    [self filterContentForSearchText:searchString];
        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
        for( UIView *subview in tableView1.subviews ) {
            if( [subview class] == [UILabel class] ) {
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                lbl.text = @"没有结果";
            }
        }

    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
