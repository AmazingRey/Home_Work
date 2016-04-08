//
//  XKRWPersonalInfoVC.m
//  XKRW
//
//  Created by Jiang Rui on 14-2-25.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWChangeUserInfoVC.h"
#import "XKRWUserService.h"
#import "XKRWModifyNickNameVC.h"
#import "XKRWChangePWDViewController.h"
#import "XKRWChangeManifesto.h"
#import "XKRW-Swift.h"
@implementation PersonalInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexpath:(NSIndexPath*)indexpath
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.backgroundColor = XKClearColor;
        self.detailTextLabel.backgroundColor = XKClearColor;
        [self.detailTextLabel setFont:XKDefaultRegFontWithSize(16.f)];
        [self.textLabel setFont:XKDefaultRegFontWithSize(16.f)];
        
        self.right_btn = [[UIButton alloc] initWithFrame:CGRectMake(XKAppWidth-36.f, 0, 36.f, 44.f)];
        [self.right_btn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        
        self.degreeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(XKAppWidth- 74 - 36, (44-20)/2, 73.8, 20)];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        self.bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, XKAppWidth, .5)];
        _bottom.backgroundColor = XKSepDefaultColor;
        _bottom.hidden=NO;
        [self.contentView addSubview:self.right_btn];
        [self.contentView addSubview:_bottom];
        [self.contentView addSubview:self.degreeImageView];
   
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 43.5, XKAppWidth, .5)];
        line.backgroundColor = XK_ASSIST_LINE_COLOR;
        [self addSubview:line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.textColor = XK_TEXT_COLOR;
    CGPoint center = self.detailTextLabel.center;
    center.x -= 25;
    self.detailTextLabel.center = center;
}
@end


@interface XKRWChangeUserInfoVC ()<UIActionSheetDelegate>
{
    BOOL isThirdPartyLogin; //是否是第三方登录
}
@property (nonatomic,strong) UITableView *tableView;
@end

#pragma --mark  修改个人资料

@implementation XKRWChangeUserInfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改个人资料";
    [MobClick event:@"in_PersonInfo"];
    [self addNaviBarBackButton];

    [[XKRWUserService sharedService] setUserDestiWeight:[[XKRWUserService sharedService] getUserDestiWeight]];
    [[XKRWUserService sharedService] updatePlanCount];
    
    isThirdPartyLogin = [[XKRWUserService sharedService] getThirdPartyLogin];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = XKBGDefaultColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = XKClearColor;
    [self.view addSubview:_tableView];
    
    if(_entity == nil)
    {
        //获取用户荣誉数据
        [self getUserHonorData];
    }
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:@"in_MoreSelfInfo"];
    [_tableView reloadData];
}

-(void)modifityTheNickName{
    XKRWModifyNickNameVC *modifyNickName =  [[XKRWModifyNickNameVC alloc]init];
    [self.navigationController pushViewController:modifyNickName animated:YES];
}

-(void)changePWD{
    XKRWChangePWDViewController *changePWD = [[XKRWChangePWDViewController alloc]init];
    changePWD.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePWD animated:YES];
}

-(void)changemanifesto{
    XKRWChangeManifesto *changeManifesto = [[XKRWChangeManifesto alloc]init];
    [self.navigationController pushViewController:changeManifesto animated:YES];
    
}

- (void)entryGradeVC
{
    XKRWUserGradeVC *userGradeVC = [[XKRWUserGradeVC alloc]initWithNibName:@"XKRWUserGradeVC" bundle:nil];
//    userGradeVC.entity = _entity;
    [self.navigationController pushViewController:userGradeVC animated:YES];
}

- (void)getUserHonorData{
    [self downloadWithTaskID:@"getHonorData" outputTask:^id{
        return [[XKRWUserService sharedService] getUserHonorData];
    }];
    
}

#pragma --mark NetDeal

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    if ([taskID isEqualToString:@"getHonorData"]){
        _entity = [[XKRWUserHonorEnity alloc]init];
        NSDictionary *data = [result objectForKey:@"data"];
        _entity.nowDegree = [data objectForKey:@"now"];
        _entity.nextDegree = [data objectForKey:@"next"];
        _entity.nowDegreeProgress = [[data objectForKey:@"rank"] integerValue];
        _entity.nowExperience = [[data objectForKey:@"score"] integerValue];
        _entity.nextDegreeExperience = [[data objectForKey:@"up"] integerValue];
        [_tableView reloadData];
    }
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [super handleDownloadProblem:problem withTaskID:taskID];
}

#pragma mark Title and Value

- (NSString *)getCellTitleWithIndexPath:(NSIndexPath*)indexPath
{
    NSArray *arr = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"账号",@"昵称",@"减肥宣言",@"称号", nil],
                    [NSArray arrayWithObjects:@"修改密码", nil],
                    nil];
    NSArray * tem = [arr objectAtIndex:indexPath.section];
    NSString *title;
    if (isThirdPartyLogin &&indexPath.section == 0 ) {
        title = [tem objectAtIndex:indexPath.row+1];
    }else{
        title = [tem objectAtIndex:indexPath.row];
    }
    return title;
}

- (NSString *)getCellValueWithIndexPath:(NSIndexPath*)indexPath
{
    NSString *value = nil;
    
    NSString* accountName=[[XKRWUserService sharedService]getUserAccountName];
    NSString* nickName=[[XKRWUserService sharedService]getUserNickName];
    NSString* menifesto=[[XKRWUserService sharedService]getUserManifesto];
    
    if (menifesto.length > 7) {
        menifesto = [NSString stringWithFormat:@"%@...",[menifesto substringToIndex:6]];
    }
    
    if (indexPath.section==0) {
        if (isThirdPartyLogin) {
            switch (indexPath.row) {
                case 0:
                    value=[nickName isEqualToString:@""]?@"设置昵称":nickName;
                    break;
                case 1:
                    value=[menifesto isEqualToString:@""] ?@"设置宣言":menifesto;
                    break;
                default:
                    break;
            }

        }else{
            switch (indexPath.row) {
                case 0:
                    value=accountName;
                    break;
                case 1:
                    value=[nickName isEqualToString:@""]?@"设置昵称":nickName;
                    break;
                case 2:
                    value=[menifesto isEqualToString:@""] ?@"设置宣言":menifesto;
                    break;
                default:
                    break;
            }
        }
   }
   else   if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                value = @"";
                break;
            default:
                break;
        }
    }
      return value;
}

#pragma --mark  UItableViewDelegate And  UItableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(isThirdPartyLogin)
    {
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if(isThirdPartyLogin){
            return 3;
        }else{
            return 4;
        }
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalInfoCell *cell = nil;

    NSString *cellId = @"personalInfoCellIndentifer";
    cell = [[PersonalInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId indexpath:indexPath];
    cell.textLabel.text = [self getCellTitleWithIndexPath:indexPath];
    cell.right_btn.hidden=NO;
    if(!isThirdPartyLogin)
    {
        if (indexPath.section ==0 && indexPath.row == 0)
        {
            cell.right_btn.hidden =  YES ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(!(indexPath.section == 0 && indexPath.row == 3)){
            cell.detailTextLabel.text = [self getCellValueWithIndexPath:indexPath];
            if(indexPath.section ==0 && indexPath.row != 0){
                cell.detailTextLabel.textColor = XKMainSchemeColor;
            }
            
            
        }else{
            [cell.degreeImageView setImageWithURL:[NSURL URLWithString:_entity.nowDegree] placeholderImage:nil options:SDWebImageRetryFailed];
        }

    }else{
        if(!(indexPath.section == 0 && indexPath.row == 2)){
            cell.detailTextLabel.text = [self getCellValueWithIndexPath:indexPath];
            if(indexPath.section ==0 && indexPath.row != 0){
                cell.detailTextLabel.textColor = XKMainSchemeColor;
            }
        }else{
            [cell.degreeImageView setImageWithURL:[NSURL URLWithString:_entity.nowDegree] placeholderImage:nil options:SDWebImageRetryFailed];
        }
    }
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 10)];
    sectionHeader.backgroundColor = [UIColor clearColor];
    
    
    
    UIView * sepTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, .5)];
    sepTop.backgroundColor = [UIColor colorFromHexString:@"#e0e0e0"];
    
    UIView * sepBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 9.5, XKAppWidth, .5)];
    sepBottom.backgroundColor = [UIColor colorFromHexString:@"#e0e0e0"];
    
    
    if (!section) {
        [sectionHeader addSubview: sepBottom];
        
    }else{
        [sectionHeader addSubview: sepTop];
        [sectionHeader addSubview: sepBottom];
    }
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10.f;
}

#pragma mark 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                if(isThirdPartyLogin){
                     [self modifityTheNickName];
                }
                break;
            case 1:
                if(isThirdPartyLogin){
                    [self changemanifesto];
                }else{
                    [self modifityTheNickName];
                }
                break;
            case 2:
                if(isThirdPartyLogin){
                    [self entryGradeVC];
                }else{
                   [self changemanifesto];
                }
                
                break;
            case 3:
            {
                [self entryGradeVC];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section==1){
        switch (indexPath.row) {
            case 0:
                [self changePWD];
                break;
            default:
                break;
        }
    }
}

#pragma mark - CustomViewPicker's delegate
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
