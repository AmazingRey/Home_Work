//
//  XKRWGroupManageViewController.m
//  XKRW
//
//  Created by Seth Chen on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWGroupManageViewController.h"
#import "XKRWGroupApi.h"
#import "XKRWGroupItem.h"
#import "XKRWGroupService.h"
#import "XKRWUserService.h"

#define Width_Radio             [UIScreen mainScreen].bounds.size.width/375
#define MAX_WIDTH               108.5*Width_Radio
#define MIN_WIDTH               85*Width_Radio

#define BUTTON_HEIGHT           30
#define Gap_V                   16  //垂直的间距
#define Gap_H                   20//75/4  //水平的间距

typedef struct ButtonModel{
    CGPoint             origin;
    CGPoint             center;
    NSInteger           tag;
    NSUInteger          width;
    NSUInteger          height;
    NSUInteger          leadingGap;
    NSUInteger          trailingGap;
//    NSString            *title;
}ButtonModel;

@interface XKRWGroupManageViewController ()
{
    UILabel * __tipLabel;
    UIButton * __confimButton;
    
    NSInteger start__Y;
    
    
    XKRWGroupApi * __groupApi;
    NSMutableArray * __allGroupDataSource;
    
    NSMutableArray * __selectGroupDataSource;
}


@property (nonatomic, strong) UIScrollView * scroller;
@end

@implementation XKRWGroupManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XKBGDefaultColor;
//    NSString * testStr = @"草辣油哈希哦阿道夫";
    
    __allGroupDataSource = [NSMutableArray array];
    __selectGroupDataSource = [NSMutableArray array];
    __groupApi = [XKRWGroupApi new];

    [self.view addSubview:self.scroller];
    [self initAllgroupData];
    
    __tipLabel = ({
        UILabel * l = [UILabel new];
        l.frame = (CGRect){0, 0, XKAppWidth, 200-1};
        l.backgroundColor = [UIColor whiteColor];
        l.numberOfLines = 0;
        l.font = [UIFont systemFontOfSize:15];
        l.textColor = [UIColor darkGrayColor];
        l.textAlignment = NSTextAlignmentCenter;
        
        
        NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
        style.lineSpacing = 15;
        style.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:@"全新小组功能开启\n选择你感兴趣的话题"];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedStr.length)];
        
       
        [attributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]} range:NSMakeRange(0, 9)];
        l.attributedText = attributedStr;
        
        
        
        l;
    });
    [self.view addSubview:__tipLabel];
    
    __confimButton = ({
        UIButton * l = [UIButton new];
        l.frame = (CGRect){0, XKAppHeight - 51, XKAppWidth, 51};
        l.backgroundColor = [UIColor whiteColor];
        [l setTitle:@"确定" forState:UIControlStateNormal];
        [l setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [l setBackgroundImage:[UIImage createImageWithColor:XKSepDefaultColor] forState:UIControlStateHighlighted];
        [l addTarget:self action:@selector(confimed:) forControlEvents:UIControlEventTouchUpInside];
        l.titleLabel.font = [UIFont systemFontOfSize:18];
        
        
        UIView * line = [UIView new];
        line.backgroundColor = XKSepDefaultColor;
        line.frame = (CGRect){0, 0, XKAppWidth, 1};
        [l addSubview:line];
        l;
    });
    [self.view addSubview:__confimButton];
}

- (void)initAllgroupData
{
    if ([__groupApi registerTarget:self andResponseMethod:@selector(getGroupRes:)]) {
        [__groupApi getAllGroupBytype:1];
    } 
}

- (void)getGroupRes:(NSMutableArray *)data
{
    __allGroupDataSource = data;
   [self creatGroupButton:__allGroupDataSource inView:self.scroller];
    __tipLabel.frame = (CGRect){0, 0, XKAppWidth, start__Y-1};
}


- (NSArray *)creatRandomArr:(inout NSString *)longstr limitCount:(int)limit
{
    if (longstr.length >6) {
        longstr = [longstr substringToIndex:6];
    }
    
    NSMutableArray * strArr = [NSMutableArray array];
    
    for (int i = 0; i < limit; i ++) {
        
        int index = random()%4+2;
        [strArr addObject:[longstr substringToIndex:index]];
    }
    return strArr;
}



- (void)creatGroupButton:(NSArray *)buttons inView:(UIScrollView *)v
{
    ///<    计算总的分布页面个数...
    NSInteger countPage = (buttons.count -1)/24 + 1;
    
    ///<    start__Y = (View's height - (butotn's height + gap_v)*count of cells)/2
    ///<    计算初始的Y轴位置...为了居中显示的效果..
    
    start__Y  = 0;
    if (countPage == 1) {
        start__Y = (XKAppHeight - (BUTTON_HEIGHT+Gap_V)*((buttons.count - 1 )/3 +1))/2;
    }else{
        start__Y = (XKAppHeight - (BUTTON_HEIGHT+Gap_V)*8)/2;
    }

    
    ///<    左对齐
    NSMutableArray * rowsIndexs = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)]];
    
    CGFloat  maxpreWidth = 0;
    
    NSUInteger butotnsPageCount = 24;
    NSUInteger butotnsIndex = 0;
    NSUInteger preWidth = 0;
    
    for (int _i = 0; _i< countPage; _i++) {
        
        if (countPage - _i ==  1) {
            butotnsPageCount = buttons.count - _i*24;
        }else butotnsPageCount = 24;
        
        
        for (int i = 0; i <butotnsPageCount; i ++) {
            
            XKRWGroupItem * item = buttons[butotnsIndex];

            NSString * title = (NSString *)item.groupName;
            ButtonModel model;
            model.tag = butotnsIndex;
            
            CGPoint origin;
            NSUInteger rowIndex_ = 0;
            
            if (butotnsIndex>24) {
                rowIndex_ = ((NSNumber *)rowsIndexs[(i)%8]).integerValue;
                preWidth = rowIndex_;              ///<     换行
            }else{
                rowIndex_ = ((NSNumber *)rowsIndexs[(i)/3]).integerValue;
                if (i%3 == 0)preWidth = rowIndex_; ///<     换行
            }
            
            
            model.height = BUTTON_HEIGHT;
            model.width = title.length > 3?MAX_WIDTH:MIN_WIDTH;
            
            
            if (butotnsIndex>24) {
                origin.x = rowIndex_+Gap_H;
            }else{
                origin.x = preWidth+Gap_H ;//+ _i*rowIndex; //(i%3)*Gap_H+Gap_H+(i%3) * MAX_WIDTH;
            }
            
            
            if (butotnsIndex>24) { //不是第一页 竖着排
                origin.y = (i%8)*Gap_V+(i%8)*BUTTON_HEIGHT + start__Y;
            }else{ //第一页横着排
                origin.y = (i/3)*Gap_V+(i/3)*BUTTON_HEIGHT + start__Y;
            }
            
            
            model.origin = origin;
            
            preWidth = model.origin.x + model.width;
            if (preWidth > maxpreWidth) {
                maxpreWidth = preWidth;
            }
            
            
            if (butotnsIndex >= 24) {
                [rowsIndexs replaceObjectAtIndex:(i)%8 withObject:[NSNumber numberWithInteger:preWidth]];
            }else{
                if (i%3 == 2){
                    [rowsIndexs replaceObjectAtIndex:(i)/3 withObject:[NSNumber numberWithInteger:preWidth]]; ///     换页
                }
            }
            
            butotnsIndex ++;
            
            UIButton * B__ = [self creatButtonWithModel:model byCenter:NO];
            [B__ setTitle:title forState:UIControlStateNormal];
            [v addSubview:B__];
        }
        
    }
    v.contentSize = (CGSize){maxpreWidth + Gap_H , 667 -64-49};
    
}



- (UIButton *)creatButtonWithModel:(ButtonModel)model byCenter:(BOOL)abool
{
    UIButton * __B = [UIButton buttonWithType:UIButtonTypeCustom];
    __B.frame = (CGRect){model.origin.x,model.origin.y,model.width,model.height};
    if (abool) {
        __B.center = model.center;
    }
    __B.tag = model.tag;
    __B.backgroundColor = [UIColor whiteColor];
    __B.titleLabel.font = [UIFont systemFontOfSize:14];
    [__B setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    [__B addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    __B.layer.cornerRadius = 15;
    __B.clipsToBounds = YES;
    __B.layer.borderColor = XKMainSchemeColor.CGColor;
    __B.layer.borderWidth = 1;
    return __B;
}


- (UIScrollView *)scroller
{
    if (!_scroller) {
        _scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
        _scroller.backgroundColor = [UIColor whiteColor];
        _scroller.pagingEnabled = NO;
        _scroller.delaysContentTouches = NO;
        _scroller.showsVerticalScrollIndicator = NO;
        //        _scroller.alwaysBounceVertical = NO;
        //        _scroller.contentSize = (CGSize){SCREEN_WIDTH*2,_scroller.frame.size.height};
    }
    return _scroller;
}

- (void)buttonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = XKMainSchemeColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    }
    XKRWGroupItem * item =  __allGroupDataSource[sender.tag];
    
    if (sender.selected) {
        [__selectGroupDataSource addObject:item.groupId];
    }else{
        if ([__selectGroupDataSource containsObject:item.groupId]) {
            [__selectGroupDataSource removeObject:item.groupId];
        }
    }
}


- (void)confimed:(UIButton *)sender
{
    if (__selectGroupDataSource.count== 0) {
//        [XKRWCui showInformationHudWithText:@"请至少选择一个小组"];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return;
    }
    
    if (![XKUtil isNetWorkAvailable]) {
         [XKRWCui showInformationHudWithText:@"请检查网络再试"];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [XKRWCui showProgressHud:@"处理中"];
    [self downloadWithTaskID:@"addMultiGroup" outputTask:^id{
        return [[XKRWGroupService shareInstance] addMutilGroupbyGroupIds:__selectGroupDataSource];
    }];

}
- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {
    
    [super handleUploadProblem:problem withTaskID:taskID];
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    if ([taskID isEqualToString:@"addMultiGroup"]) {
        [XKDispatcher syncExecuteTask:^{
            [XKRWCui hideProgressHud];
            if (((NSString *)result).intValue == 1) {
                
                for (NSString * groupId in __selectGroupDataSource) {  //加入    全局的用户已加入过的小组
                    if (![[XKRWUserService sharedService].currentGroups containsObject:groupId]) {
                        [[XKRWUserService sharedService].currentGroups addObject: groupId];
                    }
                }
               
                if (__selectGroupDataSource.count > 0) {
                    [XKRWCui showInformationHudWithText:@"加入成功"];
                }
                [XKUtil postRefreshGroupTeamInDiscover];
                [XKDispatcher syncExecuteTask:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                } afterSeconds:1];
            }
        }];
    }
}

@end
