//
//  XKRWDailyAnalysizeView.m
//  XKRW
//
//  Created by ss on 16/4/28.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWDailyAnalysizeView.h"
#import "Masonry.h"
#import "XKRWAlgolHelper.h"
#import "XKRWRecordService4_0.h"

@implementation XKRWDailyAnalysizeView
{
    NSString *containerImageName;
}

- (instancetype)initWithFrame:(CGRect)frame type:(AnalysizeType)type andSportArray:(NSArray *)sportArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _arrSport = sportArray;
        //每日正常饮食摄入
        _dailyNormal = [XKRWAlgolHelper dailyIntakEnergy];
        //饮食消耗
        _dailyFoodDecrease = [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:efoodCalories andDate:[NSDate date]];
        //运动消耗
        _dailySportDecrease = [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:eSportCalories andDate:[NSDate date]];
        
        [self makeViewAutoLayout];
    }
    return self;
}

-(void)makeViewAutoLayout{
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(@25);
    }];
    
    [self.labCal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.labTitle.mas_bottom);
    }];
    
    if (_type == 1) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@32);
            make.width.mas_equalTo(XKAppWidth - 64);
            make.height.mas_equalTo(66);
            make.top.mas_equalTo(self.labCal.mas_bottom).offset(20);
        }];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@32);
            make.width.mas_equalTo(XKAppWidth - 64);
            make.height.mas_equalTo(66 + 10);
            make.top.mas_equalTo(self.labCal.mas_bottom).offset(10);
            make.bottom.mas_equalTo(_tableView.mas_bottom);
            
            UIImage *boxImage =  [UIImage imageNamed:containerImageName];
            UIImage *stretchImage = [ boxImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 25, 25, 25)];
            _imgView.image = stretchImage;
        }];
    }
    if (_dailySportDecrease != 0 && _type == 2){
    
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@32);
            make.width.mas_equalTo(XKAppWidth - 64);
            make.height.mas_equalTo([[self.dicData objectForKey:[NSNumber numberWithInteger:_type]] count] *33);
            make.top.mas_equalTo(self.labCal.mas_bottom).offset(20);
        }];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@32);
            make.width.mas_equalTo(XKAppWidth - 64);
            make.height.mas_equalTo(_arrSport.count *33 + 10);
            make.top.mas_equalTo(self.labCal.mas_bottom).offset(10);
            make.bottom.mas_equalTo(_tableView.mas_bottom);
            UIImage *boxImage =  [UIImage imageNamed:containerImageName];
            UIImage *stretchImage = [ boxImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 25, 25, 25)];
            _imgView.image = stretchImage;
        }];
}
}

#pragma mark getter Method
-(NSMutableDictionary *)dicData{
    if (!_dicData) {
        NSMutableDictionary *dicEat = [NSMutableDictionary dictionary];
        [dicEat setObject:[NSString stringWithFormat:@"%.0fkcal",_dailyNormal] forKey:@"正常所需热量"];
        [dicEat setObject:[NSString stringWithFormat:@"%.0fkcal",_dailyFoodDecrease] forKey:@"实际摄入"];
        
        NSMutableDictionary *dicSport = [NSMutableDictionary dictionary];
        for (NSDictionary *dic in _arrSport) {
            NSNumber *calorie = [dic objectForKey:@"calorie"];
            [dicSport setObject:[NSString stringWithFormat:@"%dkcal",calorie.intValue] forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]]];
        }
        
        _dicData = [NSMutableDictionary dictionary];
        [_dicData setObject:dicEat forKey:[NSNumber numberWithInteger:1]];
        [_dicData setObject:dicSport forKey:[NSNumber numberWithInteger:2]];
    }
    return _dicData;
}

-(UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labTitle.text = _type == 1? @"少吃了" : @"运动消耗";
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.textColor = colorSecondary_333333;
        _labTitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

-(UILabel *)labCal{
    if (!_labCal) {
        _labCal = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labCal.text = _type == 1? [NSString stringWithFormat:@"%.0fkcal",_dailyNormal-_dailyFoodDecrease]: [NSString stringWithFormat:@"%.0fkcal",_dailySportDecrease];
        
        _labCal.textAlignment = NSTextAlignmentCenter;
        _labCal.textColor = XKMainToneColor_29ccb1;
        _labCal.font = [UIFont systemFontOfSize:27];
        [self addSubview:_labCal];
    }
    return _labCal;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth - 64, 33*2)];
        [_tableView registerNib:[UINib nibWithNibName:@"XKRWDailyAnalysizeCell" bundle:nil] forCellReuseIdentifier:@"dailyAnalysizeCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setScrollEnabled:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_tableView];
    }
    return _tableView;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 98)];

   
        if (_arrSport.count == 1) {
            if (XKAppWidth == 320) {
                containerImageName = @"date_indicator320_Small";// 532
            }else{
                containerImageName = @"date_indicator_Small";// 622
            }
        }else{
            if (XKAppWidth == 320) {
                containerImageName = @"date_indicator320_Big";// 532
            }else{
                containerImageName = @"date_indicator_Big"; //622
            }
        }
         UIImage *img = [UIImage imageNamed:containerImageName];
        _imgView.image = img;
        [self addSubview:_imgView];
    }
    return _imgView;
}

#pragma mark UITableview datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [[self.dicData objectForKey:[NSNumber numberWithInteger:_type]] count];
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
}

-(XKRWDailyAnalysizeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKRWDailyAnalysizeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dailyAnalysizeCell"];
    if (!cell) {
        cell = LOAD_VIEW_FROM_BUNDLE(@"XKRWDailyAnalysizeCell");
    }
    NSDictionary *tmpDic = [self.dicData objectForKey:[NSNumber numberWithInteger:_type]];
    NSArray *tmpArr = [[[tmpDic allKeys] reverseObjectEnumerator] allObjects];
    NSString *tmpStr = [tmpArr objectAtIndex:indexPath.row];
    cell.labLeft.text = tmpStr;
    cell.labRight.text = [tmpDic objectForKey:tmpStr];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
@end