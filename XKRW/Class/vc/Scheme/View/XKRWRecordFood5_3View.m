//
//  XKRWRecordFood5_3View.m
//  XKRW
//
//  Created by ss on 16/4/13.
//  Copyright © 2016年 XiKang. All rights reserved.
//
#define labStatus_RecordWeight @"_labRecordWeight"
#define labStatus_PushMenu @"_labPushMenu"

#import "XKRWRecordFood5_3View.h"
#import "XKRWRecordFood5_3Cell.h"
#import "XKRWPushMenu5_3Cell.h"
#import "XKRWAlgolHelper.h"
#import "XKRWRecordMore5_3View.h"

@interface XKRWRecordFood5_3View () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
@property (strong ,nonatomic) XKRWRecordMore5_3View *moreView;

@end

@implementation XKRWRecordFood5_3View
@synthesize arrRecord = _arrRecord,arrMenu = _arrMenu;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordFood5_3View");
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.tableView.frame];
    _scrollView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    
    _tableRecord = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    _tableRecord.tag = 5031;
    [_tableRecord registerNib:[UINib nibWithNibName:@"XKRWRecordFood5_3Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"recordFoodCell"];
    
    _tableMenu = [[UITableView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    _tableMenu.tag = 5032;
    [_tableMenu registerNib:[UINib nibWithNibName:@"XKRWPushMenu5_3Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"pushMenuCell"];
    
    [_scrollView addSubview:_tableRecord];
    [_scrollView addSubview:_tableMenu];
    [self addSubview:_scrollView];
    
    _btnAnalyze.layer.cornerRadius = 5;
    _btnAnalyze.layer.borderWidth = 1;
    _btnAnalyze.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    
    _btnRecordSport.layer.cornerRadius = 5;
    _btnRecordSport.layer.borderWidth = 1;
    _btnRecordSport.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    
    _btnRecordFood.layer.cornerRadius = 5;
    _btnRecordFood.layer.borderWidth = 1;
    _btnRecordFood.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
}

-(void)setTitle{
    _labSeperate.hidden = NO;
    
    switch (_type) {
        case 1:
            _labRecordWeight.text = @"记录饮食";
            _labPushMenu.text = @"推荐食谱";
            _labRecordWeightNum.text = @"1111kcal";
            _labPushMenuNum.text = @"2222kcal";
            _labRecordWeight.textColor = XKMainToneColor_29ccb1;
            _labRecordWeightNum.textColor = XKMainToneColor_29ccb1;
            
            _btnAnalyze.hidden = NO;
            _btnRecordFood.hidden = NO;
            _btnRecordSport.hidden = YES;
            [self showViewControl:@[_arrowLeft]];
            break;
        case 2:
            _labRecordWeight.text = @"记录运动";
            _labPushMenu.text = @"运动计划";
            int cal = [XKRWAlgolHelper dailyConsumeSportEnergy];
            _labRecordWeightNum.text = [NSString stringWithFormat:@"%dkcal",cal];
            _labPushMenuNum.text = @"4444kcal";
            _labRecordWeight.textColor = XKMainToneColor_29ccb1;
            _labRecordWeightNum.textColor = XKMainToneColor_29ccb1;
            
            _btnAnalyze.hidden = YES;
            _btnRecordFood.hidden = YES;
            _btnRecordSport.hidden = NO;
            [self showViewControl:@[_arrowMiddle]];
            break;
        case 3:
            _labRecordWeight.text = @"";
            _labRecordWeightNum.text = @"";
            _labPushMenu.text = @"";
            _labPushMenuNum.text = @"";
            _labSeperate.hidden = YES;
            
            [_btnRecordWeight setTitle:@"今天，我改正了:" forState:UIControlStateNormal];
            [_btnRecordWeight sizeToFit];
            [self showViewControl:@[_arrowRight]];
            break;
        default:
            break;
    }
}

-(void)setType:(energyType)type{
    if (_type != type) {
        _type = type;
    }
    [self setTitle];
}

-(void)setArrRecord:(NSArray *)arrRecord{
    if (_arrRecord != arrRecord) {
        _arrRecord = arrRecord;
        _tableRecord.delegate = self;
        _tableRecord.dataSource = self;
        [_tableRecord reloadData];
    }
}

-(void)setArrMenu:(NSArray *)arrMenu{
    if (_arrMenu != arrMenu) {
        _arrMenu = arrMenu;
        _tableMenu.delegate = self;
        _tableMenu.dataSource = self;
        [_tableMenu reloadData];
    }
}

-(NSArray *)arrMenu{
    NSLog(@"Returning name: %@", _arrMenu);
    return _arrMenu;
}


-(void)scrollToPage:(NSInteger)page{
    if (_pageIndex == page) {
        return;
    }
    CGFloat offset = (page-1) *self.tableView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    _pageIndex = page;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (IBAction)actCancle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(RecordFoodViewpressCancle)]) {
        [self.delegate RecordFoodViewpressCancle];
    }
}

- (IBAction)actRecordWeight:(id)sender {
    _labRecordWeight.textColor = XKMainToneColor_29ccb1;
    _labRecordWeightNum.textColor = XKMainToneColor_29ccb1;
    _labPushMenu.textColor = colorSecondary_666666;
    _labPushMenuNum.textColor = colorSecondary_666666;
    [self scrollToPage:1];
    [self showViewControl:@[_btnAnalyze,_btnRecordFood]];
}

- (IBAction)actPushMenu:(id)sender {
    _labPushMenu.textColor = XKMainToneColor_29ccb1;
    _labPushMenuNum.textColor = XKMainToneColor_29ccb1;
    _labRecordWeight.textColor = colorSecondary_666666;
    _labRecordWeightNum.textColor = colorSecondary_666666;
    [self scrollToPage:2];
    [self showViewControl:@[_btnRecordSport]];
}

-(void)showViewControl:(NSArray *)objs{
    _arrowLeft.hidden = YES;
    _arrowMiddle.hidden = YES;
    _arrowRight.hidden = YES;
    
    _btnAnalyze.hidden = YES;
    _btnRecordFood.hidden = YES;
    _btnRecordSport.hidden = YES;
    for (UIView *obj in objs) {
        obj.hidden = NO;
    }
}

- (IBAction)actMore:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addMoreView)]) {
        [self.delegate addMoreView];
    }
    
}

- (IBAction)actAnalyze:(id)sender {
}

- (IBAction)actRecordSport:(id)sender {
}

- (IBAction)actRecordFood:(id)sender {
}

#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 5031) {
        return _arrRecord.count;
    }else if (tableView.tag == 5032){
        return _arrMenu.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identify = @"";
    XKRWRecordSchemeEntity *entity;
     if (tableView.tag == 5031) {
         identify = @"recordFoodCell";
         entity = [_arrRecord lastObject];
         XKRWRecordFood5_3Cell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
         cell.leftImage.image = [UIImage imageNamed:[self getImageNameWithType:entity.type]];
         cell.labMain.text = [self getNameWithType:entity.type];
         return  cell;
     }else if (tableView.tag == 5032){
        identify = @"pushMenuCell";
        entity = [_arrMenu objectAtIndex:indexPath.row];
        XKRWPushMenu5_3Cell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        cell.leftImage.image = [UIImage imageNamed:[self getImageNameWithType:entity.type]];
        cell.labMain.text = [self getNameWithType:entity.type];
         return  cell;
     }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)getImageNameWithType:(RecordType)type{
    NSString *imgName = @"";
    switch (type) {
        case 0:
            imgName = @"sports5_3";
            break;
        case 1:
            imgName = @"breakfast5_3";
            break;
        case 2:
            imgName = @"lunch5_3";
            break;
        case 3:
            imgName = @"dinner5_3";
            break;
        case 4:
            imgName = @"addmeal5_3";
            break;
            
        default:
            break;
    }
    return imgName;
}

-(NSString *)getNameWithType:(RecordType)type{
    NSString *name = @"";
    switch (type) {
        case 0:
            name = @"运动";
            break;
        case 1:
            name = @"早餐";
            break;
        case 2:
            name = @"午餐";
            break;
        case 3:
            name = @"晚餐";
            break;
        case 4:
            name = @"加餐";
            break;
            
        default:
            break;
    }
    return name;
}
@end