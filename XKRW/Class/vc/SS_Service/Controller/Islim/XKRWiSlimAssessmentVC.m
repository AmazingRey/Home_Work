//
//  XKRWiSlimAssessmentVC.m
//  XKRW
//
//  Created by XiKang on 15-1-22.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWiSlimAssessmentVC.h"
#import "AssessmentTableView.h"
#import "AssessmentProgressBar.h"
#import "XKRWCui.h"
#import "XKRWZheDieCell.h"
#import "XKRWUserService.h"
#import "XKRWBusinessException.h"
#import "XKRWComprehensiveAssResultVC.h"
#import "XKRWPhysicalAssessmentVC.h"

#import "XKRWServerPageService.h"

//test
#import "XKRWThinAssessVC.h"
#import "XKRWHabitStatusVC.h"
#import "XKRWSchemeStepsModel.h"

#import "XKRWThinbodystageModel.h"

@interface XKRWiSlimAssessmentVC () <AssessmentTableViewDelegate>

@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, strong) AssessmentTableView *tableView_1;
@property (nonatomic, strong) AssessmentTableView *tableView_2;

@property (nonatomic, strong) NSMutableArray *cellsArray;

@property (nonatomic, strong) NSArray *tableViews;
@property (nonatomic, strong) NSArray *colorArrays;
@property (nonatomic, strong) NSMutableArray *titleArrays;
@property (nonatomic, strong) NSMutableArray *contentArrays;

@property (nonatomic, strong) AssessmentProgressBar *progressBar;

@end

@implementation XKRWiSlimAssessmentVC

#pragma mark - System's Functions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:@"in_iSlimQ"];
    self.title = @"瘦身评估(26题)";
    [self addNaviBarBackButton];
    
    [self initData];
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize

- (void)initSubviews {
 
    _pageIndex = 0;
 
    _progressBar = [[AssessmentProgressBar alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 4.f)
                                                  numberOfStage:4];
    [_progressBar setStageColors:_colorArrays];
    [_progressBar setToStage:1];

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect tableFrame = CGRectMake(0, _progressBar.bottom, XKAppWidth, XKAppHeight - statusBarHeight - navigationBarHeight - _progressBar.height);
    
    _tableView_1 = [[AssessmentTableView alloc] initWithFrame:tableFrame
                                                        style:UITableViewStylePlain
                                                   customCell:_cellsArray[0]
                                                        title:_titleArrays[0]];
    
    __weak XKRWiSlimAssessmentVC *_weakSelf = self;
    
    [_tableView_1 setGotoPriorQuestion:^{
        [_weakSelf goToPriorQuestion];
    } nextQuestion:^{
        [_weakSelf goToNextQuestion];
    }];

    _tableView_2 = [[AssessmentTableView alloc] initWithFrame:tableFrame
                                                        style:UITableViewStylePlain
                                                   customCell:_cellsArray[1]
                                                        title:_titleArrays[1]];
    
    [_tableView_2 setGotoPriorQuestion:^{
        [_weakSelf goToPriorQuestion];
    } nextQuestion:^{
        [_weakSelf goToNextQuestion];
    }];
    /**
     *  组成tableview的数组
     */
    _tableViews = @[_tableView_1, _tableView_2];
 
    [self.view addSubview:_tableView_2];
    [self.view addSubview:_tableView_1];
    [self.view addSubview:_progressBar];
    
    _tableView_1.isShow = YES;
    _tableView_2.isShow = NO;
    
    _tableView_1.currentPageIndex = 0;
    _tableView_2.currentPageIndex = 1;
    
    _tableView_1.AssessmentDelegate = self;
    _tableView_2.AssessmentDelegate = self;
}

- (void)initData {
    
//    _colorArrays = @[[UIColor colorWithRed:255/255.f green:105/255.f blue:110/255.f alpha:1.f],
//                     [UIColor colorWithRed:167/255.f green:230/255.f blue:221/255.f alpha:1.f],
//                     [UIColor colorWithRed:201/255.f green:230/255.f blue:190/255.f alpha:1.f],
//                     [UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    _colorArrays = @[HEXCOLOR(@"#ff6b6b"), HEXCOLOR(@"#29ccb1"), HEXCOLOR(@"#83cc52"), HEXCOLOR(@"3ff884c")];
    
    _titleArrays = [NSMutableArray arrayWithArray:@[@"请确认以下你的目前情况",
                     @"你每日的进餐情况（你每天吃几餐）",
                     @"以下7类食物哪类你吃的比较多（请从多到少由1-7进行排序）",
                     @"你每餐吃多少",
                     @"你每个月聚餐/应酬的频率",
                     @"除三餐外你最爱吃哪类食物",
                     @"过去一个月的运动习惯是",
                     @"你常去哪些地方运动",
                     @"你的身体是否有不适合运动的疾病（如膝盖、腰椎疾病等）（可多选）",
                     @"你慢跑（约6-8公里/小时）的最高纪录是",
                     @[@"你能连续做多少个俯卧撑",@"你能连续做多少个仰卧起坐"],
                     @"你每日的体力活动水平是",
                     @"你每天可自由支配时间时长是",
                     @"是否经常熬夜(12点以后睡觉或上夜班)",
                     @"你经常喝酒吗",
                     @"你经常吃零食吗",
                     @"你的休闲娱乐项目有哪些（可多选）",
                     @"你每日喝多少水",
                     @"你父母的身体情况",
                     @"你什么时候开始明显发胖的",
                     @"你最近2-3个月体重有变化吗",
                     @"你曾用过以下哪种方法减肥（多选）",
                     @"如有以下疾病史，请如实选择",
                     @"当你感到紧张或者有压力时怎么放松自己（多选）",
                     @"请根据个人真实情况选择是否有出现过以下情况（偶尔出现请选择”否“）",
                     @"以下是对你性格行为的简单评估，请根据个人情况如实选择"]];
    
    _contentArrays = [NSMutableArray arrayWithArray:@[@[@"人群/职业", @"性别", @"出生", @"身高", @"体重", @"腰围（必填）", @"臀围（必填）", @"体脂率"],
                       @[@"一日三餐正常饮食（偶尔加餐）",@"一日两餐",@"饮食时间不定，餐次不定",@"少吃多餐（至少五餐）",@"正在节食（热量摄入低于800kcal/日）"],
                       @[@"蔬菜类（青菜、菌菇）",@"水果类（苹果、香蕉）",@"谷薯类（大米、红薯、土豆）",@"肉蛋类（猪肉、鸡蛋）",@"奶类、豆类（牛奶、大豆）",@"坚果、零食类（瓜子、薯片）",@"油脂类（烹调油、肥肉）"],
                       @[@[@"早餐",@"午餐",@"晚餐",@"加餐"],@[@"不吃/吃很少",@"7分饱或以内",@"最多8分饱",@"吃饱为止",@"吃到撑（暴饮暴食）"]],
                       @[@"没有",@"偶尔（1-2次）",@"较少（3-5次）",@"经常（6-8次）",@"频繁（9次以上）"],
                       @[@"糖果类",@"甜品、糕点",@"坚果类",@"水果类",@"奶制品",@"新鲜蔬菜",@"膨化食品、干脆面等"],
                       @[@"经常(每周3次以上)",@"偶尔(每周一到两次)",@"很少(两周一次)",@"没运动(一个月没有运动)"],
                       @[@"家里",@"学校",@"健身房",@"办公室",@"公园、小区、广场",@"户外、郊外",@"几乎不运动"],
                       @[@"无",@"腰部疾病",@"腿部疾病",@"手臂疾病",@"颈部疾病"],
                       @[@"5分钟及以内",@"6-10分钟",@"11-20分钟",@"21-30分钟",@"31分钟及以上"],
                       @[@[@"15个及以内",@"16-30个",@"31-45个",@"46-60个",@"61个及以上"],@[@"20个及以内",@"21-30个",@"31-40个",@"41-60个",@"61个及以上"]],
                       @[@"极轻体力，一天中的大部分时间是坐着（如银行柜员、办公室工作）",@"轻体力，一天中的大部分时间是站着（如教师、服务员）",@"中体力，一天中的大部分时间在做体力活动(如售货员、快递员)",@"重体力，一天中的大部分时间在做重体力活动（如搬运工、建筑工）"],
                       @[@"1小时以内",@"1-2小时",@"2-3小时",@"3-4小时",@"4小时以上"],
                       @[@"没有",@"偶尔(一周一次)",@"一般(一周2-3次)",@"经常(一周4-5次)",@"频繁(几乎每天)"],
                       @[@"没有",@"偶尔(一周一次)",@"一般(一周2-3次)",@"经常(一周4-5次)",@"频繁(5次以上)"],
                       @[@"没有",@"偶尔",@"一般",@"经常",@"频繁"],
                       @[@"上网、玩游戏",@"看电视、电影",@"逛街、购物",@"散步",@"健身房锻炼",@"打球、踢球",@"户外运动（郊区、野外）"],
                       @[@"很少",@"想起来就喝，量不大",@"每天有意识的补水，平均每天6-8杯",@"会经常口渴，每天喝大量的水"],
                       @[@"其中一方有超重、肥胖",@"两人都有超重、肥胖",@"都没有"],
                       @[@"婴幼儿时期(从小就胖)",@"青春期（11-17岁）",@"孕期及产后",@"大学时期",@"工作后"],
                       @[@"相对稳定、偶尔上下波动",@"体重持续缓慢的下降",@"体重持续增加（变化在2-5公斤以内）",@"体重快速增加（变化大于5公斤）"],
                       @[@"没有",@"运动减肥",@"少量控制饮食",@"中医减肥（针灸、拔罐、按摩等）",@"吃减肥药",@"节食减肥"],
                       @[@"无",@"高血压",@"糖尿病",@"心脏疾病",@"腰部受伤或曾受过伤",@"内分泌性疾病"],
                       @[@"睡觉",@"大吃大喝",@"户外游玩",@"做运动：如跑步、跳舞等",@"安静的听音乐",@"KTV、酒吧等娱乐场所"],
                       @[@[@"睡眠无规律且失眠",@"胃肠不好（如胃溃疡）",@"会为财务困扰",@"常常白天也会觉得疲倦",@"觉得自己非常无用",@"常常觉得不快乐",@"怕与人相处",@"很难控制自己的情绪、思维",@"觉得胸闷、心烦"],@[@"是",@"否"]],
                       @[@[@"我不是个很容易气馁的人",@"我觉得现在工作比以前轻松",@"我可以做到不让自己失望",@"我善于为自己设置目标",@"我善于遵守承诺，尤其是关于自己的",@"我会为自己安排得很周密",@"我的个性稳重、能控制好自己的情绪"],@[@"完全符合",@"有些符合",@"不确定",@"有些不符合",@"完全不符合"]]
                       ]];
    
    int index = 0;
    // NO.1
    iSlimBaseInfoCell *cell_1 = [[iSlimBaseInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@"iSlimBaseInfoCell"
                                                                    page:0];
    [cell_1 setEvaluateGender:^(XKSex gender) {
        
        if (gender != eSexFemale) {
            [_titleArrays replaceObjectAtIndex:10 withObject:@"你能连续做多少个俯卧撑"];
            [_contentArrays replaceObjectAtIndex:10 withObject:@[@"15个及以内",@"16-30个",@"31-45个",@"46-60个",@"61个及以上"]];
            
        } else {
            [_titleArrays replaceObjectAtIndex:10 withObject:@"你能连续做多少个仰卧起坐"];
            [_contentArrays replaceObjectAtIndex:10 withObject:@[@"20个及以内",@"21-30个",@"31-40个",@"41-60个",@"61个及以上"]];
        }
        // No.11
        XKRWEvaluatingProblemCell *cell_11 =
        [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"test"
                                                    page:10
                                           iSlimCellType:iSlimCellTypeSingle
                                              titleArray:_contentArrays[10]
                                                   color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
        [_cellsArray replaceObjectAtIndex:10 withObject:cell_11];
    }];
    index ++;
    // NO.2
    XKRWEvaluatingProblemCell *cell_2 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.3
    XKRWEvaluatingProblemCell *cell_3 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSort
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // NO.4
    XKRWZheDieCell *cell_4 = [[XKRWZheDieCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"test"
                                                             page:index];
    cell_4.cellTitleArray = [[_contentArrays objectAtIndex:index] objectAtIndex:1];
    cell_4.sectionTitleArray = [[_contentArrays objectAtIndex:index] objectAtIndex:0];
    cell_4.cellType = iSlimCellTypeCustom;
    
    cell_4.color =[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f];
    [cell_4 initSubviews];
    
    index ++;
    // No.5
    XKRWEvaluatingProblemCell *cell_5 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.6
    XKRWEvaluatingProblemCell *cell_6 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    cell_6.cellType = iSlimCellTypeSingle;
//    cell_6.mostSelectedNum = 3;
//    cell_6.block = ^{
//        [XKRWCui showInformationHudWithText:@"最多选三项"];
//    };
    index ++;
    // No.7
    XKRWEvaluatingProblemCell *cell_7 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.8
    XKRWEvaluatingProblemCell *cell_8 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    cell_8.cellType = iSlimCellTypeSingle;
    index ++;
    // No.9
    XKRWEvaluatingProblemCell *cell_9 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    cell_9.cellType = iSlimCellTypeMultiple;
    index ++;
    // No.10
    XKRWEvaluatingProblemCell *cell_10 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.11
    XKRWEvaluatingProblemCell *cell_11 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    
    index ++;
    // No.12
    XKRWEvaluatingProblemCell *cell_12 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimcellTypeMultipleLine
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
   
    index ++;
    // No.13
    XKRWEvaluatingProblemCell *cell_13 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.14
    XKRWEvaluatingProblemCell *cell_14 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.15
    XKRWEvaluatingProblemCell *cell_15 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.16
    XKRWEvaluatingProblemCell *cell_16 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.17
    XKRWEvaluatingProblemCell *cell_17 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeMultiple
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.18
    XKRWEvaluatingProblemCell *cell_18 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.19
    XKRWEvaluatingProblemCell *cell_19 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.20
    XKRWEvaluatingProblemCell *cell_20 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.21
    XKRWEvaluatingProblemCell *cell_21 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.22
    XKRWEvaluatingProblemCell *cell_22 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeMultiple
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.23
    XKRWEvaluatingProblemCell *cell_23 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeSingle
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.24
    XKRWEvaluatingProblemCell *cell_24 =
    [[XKRWEvaluatingProblemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"test"
                                                page:index
                                       iSlimCellType:iSlimCellTypeMultiple
                                          titleArray:_contentArrays[index]
                                               color:[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f]];
    index ++;
    // No.25
    XKRWZheDieCell *cell_25 = [[XKRWZheDieCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"test"
                                                              page:index];
    cell_25.cellTitleArray = [[_contentArrays objectAtIndex:index] objectAtIndex:1];
    cell_25.sectionTitleArray = [[_contentArrays objectAtIndex:index] objectAtIndex:0];
    cell_25.cellType = iSlimCellTypeCustom;
    cell_25.color =[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f];
    [cell_25 initSubviews];
    
    index ++;
    // No.26
    XKRWZheDieCell *cell_26 = [[XKRWZheDieCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"test"
                                                               page:index];
    cell_26.cellTitleArray = [[_contentArrays objectAtIndex:index] objectAtIndex:1];
    cell_26.sectionTitleArray = [[_contentArrays objectAtIndex:index] objectAtIndex:0];
    cell_26.cellType = iSlimCellTypeCustom;
    cell_26.color =[UIColor colorWithRed:250/255.f green:204/255.f blue:186/255.f alpha:1.f];
    [cell_26 initSubviews];
    
    _cellsArray = [NSMutableArray arrayWithArray:@[cell_1, cell_2, cell_3, cell_4, cell_5, cell_6, cell_7, cell_8, cell_9, cell_10, cell_11, cell_12, cell_13, cell_14, cell_15, cell_16, cell_17, cell_18, cell_19, cell_20, cell_21, cell_22, cell_23, cell_24, cell_25, cell_26]];
}

#pragma mark - AssessmentTableView's Delegate

- (void)AssessmentTableView:(AssessmentTableView *)tableview clickFooterViewButton:(id)sender {
//    XKLog(@"%@", [[XKRWServerPageService sharedService] getAnswers]);
    [self loadResultFromRemote];
}

#pragma mark - Network Request
- (void)loadResultFromRemote
{
    if (![XKUtil isNetWorkAvailable]) {
        [XKRWCui hideProgressHud];
        [XKRWCui showInformationHudWithText:@"没有网络，请检查网络设置"];
        return;
    }
    [XKRWCui showProgressHud:@"获取评估结果中"];
    XKDispatcherOutputTask block = ^(){ 
        
        return [[XKRWServerPageService sharedService] uploadEvaluateAnswer];
    };
    
    
    [self downloadWithTaskID:@"getIslim" outputTask:block];
    
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"getIslim"])
    {
        XKLog(@"%@",result);
        
            XKRWPhysicalAssessmentVC *physicalVC = [[XKRWPhysicalAssessmentVC alloc]init];
            physicalVC.model = result;
            [self.navigationController pushViewController:physicalVC animated:YES];
        }

}


/**
 *  方案网络请求失败后 处理数据
 *
 *  @param problem
 *  @param taskID
 */
- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    if ([taskID isEqualToString:@"getIslim"]) {
        if ([problem isKindOfClass:[XKRWBusinessException class]]) {
            XKRWBusinessException *exception =  (XKRWBusinessException *)problem;
             [XKRWCui showInformationHudWithText:exception.detail];
        }
        XKLog(@"获取答案失败");
        
  
    }
}


- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

#pragma mark - Main Functions

- (void)goToPriorQuestion {
    
    if (_pageIndex == 0) {
        [XKRWCui showInformationHudWithText:@"已经是第一题了"];
        return;
    }
    for (AssessmentTableView *tableView in _tableViews) {
        
        if (!tableView.isShow) {
            tableView.currentPageIndex = --_pageIndex;
            [tableView setCustomCell:_cellsArray[_pageIndex] title:_titleArrays[_pageIndex]];
            
            [tableView appearFromDirection:XKDirectionUp];
            
            XKLog(@"Current Page: %ld", (long)_pageIndex);
        } else
        {
            [tableView disappearToDirection:XKDirectionDown];
        }
    }
    if (_pageIndex < 1) {
        [_progressBar setToStage:1];
    } else if (_pageIndex < 6) {
        [_progressBar setToStage:2];
    } else if (_pageIndex < 11) {
        [_progressBar setToStage:3];
    } else {
        [_progressBar setToStage:4];
    }
}

- (void)goToNextQuestion {
    if (_pageIndex == _cellsArray.count - 1) {
        return;
    }
    
    if (_pageIndex == 0) {
        [[XKRWServerPageService sharedService] setShowPullUpImageView:NO];
    }

    BOOL flag = NO;
    AssessmentTableView *showed = nil, *unshowed = nil;
    
    for (AssessmentTableView *tableView in _tableViews) {
        if (tableView.isShow) {
            showed = tableView;
        } else {
            unshowed = tableView;
        }
    }
    
    flag = [showed disappearToDirection:XKDirectionUp];
    
    if (flag) {
        unshowed.currentPageIndex = ++_pageIndex;
        [unshowed setCustomCell:_cellsArray[_pageIndex] title:_titleArrays[_pageIndex]];
        
        [unshowed appearFromDirection:XKDirectionDown];
        
        XKLog(@"Current Page: %ld", (long)_pageIndex);
    }
    if (_pageIndex < 1) {
        [_progressBar setToStage:1];
    } else if (_pageIndex < 6) {
        [_progressBar setToStage:2];
    } else if (_pageIndex < 11) {
        [_progressBar setToStage:3];
    } else {
        [_progressBar setToStage:4];
    }
}

- (void)popView {
    
    [[XKRWServerPageService sharedService] deleteAnswers];
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    iSlimBaseInfoCell *cell = _cellsArray[0];
    if (cell.upDownImageView.superview) {
        
        [cell.upDownImageView removeFromSuperview];
    }
    
//    [super popView];
}

@end
