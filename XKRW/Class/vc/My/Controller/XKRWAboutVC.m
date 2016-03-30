//
//  XKRWAboutVC.m
//  XKRW
//
//  Created by yaowq on 14-2-28.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWAboutVC.h"
#import "XKRWUserService.h"
#import "XKRWManagementService.h"

@interface XKRWAboutVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int count ;
    NSMutableArray *rightArrs;
    NSMutableArray *dataArrs;
    UITableView     *maimTableView;
}

@property (nonatomic, strong) UILabel * qqGroup;

@end

@implementation XKRWAboutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    if ([taskID  isEqualToString:@"getyyUserInfo"]) {
        
        [XKRWCui hideProgressHud];
        
        NSDictionary *dic = (NSDictionary*)result;
        if ([[dic objectForKey:@"success"] integerValue] == 1 )
        {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            NSMutableArray *array = [NSMutableArray array];
            
            NSArray *contact = [[data objectForKey:@"contact"] componentsSeparatedByString:@","];
            NSArray *email = [[data objectForKey:@"email"] componentsSeparatedByString:@","];
            NSArray *tel = [[data objectForKey:@"tel"]componentsSeparatedByString:@","];
            NSDictionary *dic1 = @{@"瘦瘦公众号":[data objectForKey:@"wechat"],@"瘦瘦QQ群":[data objectForKey:@"qq"]};
            NSDictionary *dic2 = @{@"联系人":[contact objectAtIndex:0],@"电话":[tel objectAtIndex:0],@"邮箱":[email objectAtIndex:0],@"title":@"运营及媒体合作"};
            NSDictionary *dic3 = @{@"联系人":[contact objectAtIndex:1],@"电话":[tel objectAtIndex:1],@"邮箱":[email objectAtIndex:1],@"title":@"商务及广告合作"};
            
            [array addObject:dic1];
            [array addObject:dic2];
            [array addObject:dic3];
          
//            NSArray *arr = [dic objectForKey:@"data"];
//            XKLog(@"得到运营联系%@",arr);
        
            dataArrs = [NSMutableArray arrayWithArray:array] ;
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"contact"])
            {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"contact"];

            }
            
            [[NSUserDefaults standardUserDefaults ]setObject:dataArrs forKey:@"contact"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [maimTableView reloadData];
        }
        
        
    }
    
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [super handleDownloadProblem:problem withTaskID:taskID];
    [XKRWCui hideProgressHud];
}

-(void)drawSubViews{
    [self.view setBackgroundColor:XKBGDefaultColor];
    maimTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, XKScreenBounds.size.height- 69) style:UITableViewStyleGrouped];
    maimTableView.delegate=self;
    maimTableView.dataSource=self;
    maimTableView.backgroundColor=XKBGDefaultColor;
    [self.view addSubview:maimTableView];
//  添加头部的背景图
    
    
    UIImage *headImage ;
    
    if (XKAppWidth != 375) {
        headImage = [UIImage imageNamed:@"monkey_about"];

    }else{
         headImage = [UIImage imageNamed:@"monkey_about_750"];
    }
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headImage.size.height)];
    headerView.backgroundColor=XKBGDefaultColor;
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, headImage.size.height)];
    headeImageView.image=[UIImage imageNamed:@"monkey_about"];
    [headerView addSubview:headeImageView];
    maimTableView.tableHeaderView=headerView;
//  添加底部的view
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 80)];
    footerView.backgroundColor=XKBGDefaultColor;
//  标签版本
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-254/2,XKAppHeight>480? 80/2-33.5-2.5+20: 80/2-33.5-2.5, 254, 27)];
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [versionLabel setTextColor:[UIColor lightGrayColor]];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setFont:XKDefaultNumEnFontWithSize(13.f)];
    NSString *strCurrentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    versionLabel.text = [NSString stringWithFormat:@"IOS Ver %@",strCurrentVersion];
#ifdef XK_TEST
    int32_t userID = [(XKRWUserService *)[XKRWUserService sharedService] getUserId];
    versionLabel.text = [NSString stringWithFormat:@"版本 %@ 20140528 USERID = [%i]",strCurrentVersion,userID];
#endif
    
    UILabel *infroLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,XKAppHeight>480?30+2.5+20:45+2.5 , (XKAppWidth-40), 27)];
   
    [infroLabel setBackgroundColor:[UIColor clearColor]];
    [infroLabel setText:@"东软熙康出品 @熙康瘦瘦"];
    [infroLabel setTextColor:[UIColor lightGrayColor]];
    [infroLabel setTextAlignment:NSTextAlignmentCenter];
    [infroLabel setFont:[UIFont systemFontOfSize:14.0]];
    
//    UIImageView *separateImageV = [[UIImageView alloc] initWithFrame:CGRectMake(33, 56, 254, 32)];
//    [separateImageV setImage:[UIImage imageNamed:@"about_bottom_icon.png"]];
    
    [footerView addSubview:versionLabel];
    [footerView addSubview:infroLabel];
    maimTableView.tableFooterView=footerView;
    [self.view addSubview:maimTableView];
}

#pragma mark_ delegate




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArrs.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 1 ;
    if (section == 0 ) {
        num = 2;
    }
    else
    {
        num = 3 ;
    }
    
    return num;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString* cellID=@"cellID";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"瘦瘦微信公众号";
            cell.detailTextLabel.text = [[dataArrs objectAtIndex:0]objectForKey:@"瘦瘦公众号"];
            cell.textLabel.textColor = XK_TEXT_COLOR;
            cell.detailTextLabel.textColor = XK_TEXT_COLOR;
        }
        else{
            cell.textLabel.text = @"瘦瘦QQ群";
            cell.detailTextLabel.text = [[dataArrs objectAtIndex:0]objectForKey:@"瘦瘦QQ群"];
            cell.textLabel.textColor = XK_TEXT_COLOR;
            cell.detailTextLabel.textColor = XK_TEXT_COLOR;
        }

    }
    else
    {
        if (indexPath.row == 0 )
        {
            cell.textLabel.text = @"联系人";
            cell.detailTextLabel.text = [[dataArrs objectAtIndex:indexPath.section]objectForKey:@"联系人"];
            cell.textLabel.textColor = XK_TEXT_COLOR;
            cell.detailTextLabel.textColor = XK_TEXT_COLOR;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"电话";
            cell.detailTextLabel.text = [[dataArrs objectAtIndex:indexPath.section]objectForKey:@"电话"];
            cell.textLabel.textColor = XK_TEXT_COLOR;
            cell.detailTextLabel.textColor = XK_TEXT_COLOR;

        }
        else
        {
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = [[dataArrs objectAtIndex:indexPath.section]objectForKey:@"邮箱"];
            cell.textLabel.textColor = XK_TEXT_COLOR;
            cell.detailTextLabel.textColor = XK_TEXT_COLOR;

        }
        
    }
   
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = @"";
    if(section == 0 )
    {
        str = @"运营、媒体、商业合作";
    }
    else
    {
        str = [[dataArrs objectAtIndex:section]objectForKey:@"title"];
    }
   
    return str;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        return ;
    }
    else
    {
        if (indexPath.row == 1)
        {
            self.type = [[dataArrs objectAtIndex:indexPath.section]objectForKey:@"电话"];
            
            UIAlertView *arl = [[UIAlertView alloc]initWithTitle:@"拨打" message:self.type delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [arl show];
        }
        else if (indexPath.row == 2)
        {
            
            self.type  = [[dataArrs objectAtIndex:indexPath.section]objectForKey:@"邮箱"];
            UIAlertView *arl = [[UIAlertView alloc]initWithTitle:@"发送邮件" message:self.type delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [arl show];

        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if(buttonIndex == 1)
   {
    
        if ([self.type rangeOfString:@"@"].length > 0 ) {
            
            NSString *urls = [NSString stringWithFormat:@"mailto://%@",self.type];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urls]];
        }
        else
        {
            NSString *urls = [NSString stringWithFormat:@"tel://%@",self.type];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urls]];
        }
    
   }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于";
    
    [self addNaviBarBackButton];
    self.view.backgroundColor=XKBGDefaultColor;
    [self drawSubViews];
    dataArrs = [[NSMutableArray alloc]init];
    
    self.qqGroup = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, 270, 20)];
    _qqGroup.backgroundColor = [UIColor clearColor];
    _qqGroup.text = @"QQ群:216670626";
    _qqGroup.textColor = [UIColor colorFromHexString:@"#666666"];
    _qqGroup.font = XKDefaultFontWithSize(16.f);


    
    //从服务器上获取  最新的 联系人
    rightArrs = [[NSMutableArray alloc]init];
    
    if([XKUtil isNetWorkAvailable]) //
    {
        [XKRWCui showProgressHud:@"获取实时数据中"];
        XKDispatcherOutputTask block = ^(){
            return [[XKRWManagementService sharedService] getYyUserInfoFromServer];
        };
        [self downloadWithTaskID:@"getyyUserInfo" outputTask:block];
    }
    else
    {
        NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"contact"];
        dataArrs =  [NSMutableArray arrayWithArray:arr];
        [maimTableView reloadData];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick event:@"in_MoreAbout"];
}

- (void) addCooperationContactWithInfoDic:(NSDictionary *) contactinfo{
    
//    UIView * bg =[[UIView alloc] initWithFrame:CGRectMake(0, 20 + count * 120, 320, 120)];
    /*
     kind 合作分类
     name 联系人姓名
     tel  电话
     qq   qq
     mail 邮箱
     */
    int xPox = 25;
    int height = 20;
    int titleWidth = 50;
    int infoWidth = 220;
    int sepDiff = 21;
    
    int contentStart = 36;
    
    UIFont * titFont = XKDefaultFontWithSize(16);
    
    UIColor * titleColor = [UIColor colorFromHexString:@"#666666"];
    UIColor * infoColor = [UIColor colorFromHexString:@"#666666"];
    
    
    UILabel * titleD =[[UILabel alloc] initWithFrame:CGRectMake(xPox, 15, 280, height)];
    titleD.text = [contactinfo objectForKey:@"kind"];
    titleD.backgroundColor =[UIColor clearColor];
    titleD.font = XKDefaultFontWithSize(16);
    titleD.textColor = titleColor;
//    [bg addSubview:titleD];
    
//    UIView * sep =[[UIView alloc] initWithFrame:CGRectMake(xPox, 36, 270, 1)];
//    sep.backgroundColor = [UIColor lightGrayColor];
//    [bg addSubview:sep];
    
    UILabel * titleC =[[UILabel alloc] initWithFrame:CGRectMake(xPox, contentStart, titleWidth, height)];
    titleC.text = @"联系人:";
    titleC.backgroundColor =[UIColor clearColor];
    titleC.font = titFont;
    titleC.textColor = titleColor;
//    [bg addSubview:titleC];
//姓名
    UILabel * infoC =[[UILabel alloc] initWithFrame:CGRectMake(xPox + titleWidth, contentStart, infoWidth, height)];
    infoC.text = [contactinfo objectForKey:@"name"];
    infoC.backgroundColor =[UIColor clearColor];
    infoC.textColor = infoColor;
    infoC.font = titFont;
//    [bg addSubview:infoC];
    
    
    UILabel * titleTel =[[UILabel alloc] initWithFrame:CGRectMake(xPox, contentStart + sepDiff, titleWidth, height)];
    titleTel.text = @"电话:";
    titleTel.backgroundColor =[UIColor clearColor];
    titleTel.font = titFont;
    titleTel.textColor = titleColor;
//    [bg addSubview:titleTel];
//电话
    UILabel * infoTel =[[UILabel alloc] initWithFrame:CGRectMake(xPox + titleWidth - 15, contentStart+ sepDiff , infoWidth, height)];
    infoTel.text = [contactinfo objectForKey:@"tel"];
    infoTel.backgroundColor =[UIColor clearColor];
    infoTel.textColor = infoColor;
    infoTel.font = titFont;
//    [bg addSubview:infoTel];
    
//    
//    UILabel * titleQQ =[[UILabel alloc] initWithFrame:CGRectMake(xPox, contentStart + sepDiff * 2, titleWidth, height)];
//    titleQQ.text = @"QQ:";
//    titleQQ.backgroundColor =[UIColor clearColor];
//    titleQQ.font = titFont;
//    titleQQ.textColor = titleColor;
//    [bg addSubview:titleQQ];
////qq
//    UILabel * infoQQ =[[UILabel alloc] initWithFrame:CGRectMake(xPox + titleWidth - 21, contentStart+ sepDiff * 2, infoWidth, height)];
//    infoQQ.text = [contactinfo objectForKey:@"qq"];
//    infoQQ.backgroundColor =[UIColor clearColor];
//    infoQQ.textColor = infoColor;
//    infoQQ.font = titFont;
//    [bg addSubview:infoQQ];
//    
//    
    UILabel * titleMail =[[UILabel alloc] initWithFrame:CGRectMake(xPox, contentStart + sepDiff * 2, titleWidth, height)];
    titleMail.text = @"邮箱:";
    titleMail.textColor = titleColor;
    titleMail.backgroundColor =[UIColor clearColor];
    titleMail.font = titFont;
//    [bg addSubview:titleMail];
//邮箱
    UILabel * infoMail =[[UILabel alloc] initWithFrame:CGRectMake(xPox + titleWidth - 15, contentStart+ sepDiff * 2, infoWidth, height)];
    infoMail.text = [contactinfo objectForKey:@"mail"];
    infoMail.backgroundColor =[UIColor clearColor];
    infoMail.textColor = infoColor;
    infoMail.font = titFont;
//    [bg addSubview:infoMail];
    
    
//    [self.view addSubview:bg];
    
    count ++;

    
    CGRect rect = _qqGroup.frame;
    rect.origin.y = count * 120 + 35;
    _qqGroup.frame  = rect;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
