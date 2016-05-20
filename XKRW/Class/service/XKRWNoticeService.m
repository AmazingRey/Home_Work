//
//  XKRWNoticeService.m
//  XKRW
//
//  Created by 忘、 on 15/8/3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWNoticeService.h"
#import "XKRWUserService.h"
#import "XKRWNewWebView.h"
#import "XKRWNavigationController.h"
#import "XKRW-Swift.h"
#import "XKRWUserService.h"
#import "XKRWPKVC.h"
#import "XKRW-Swift.h"
#import "ServiceBase5_1_2.h"
static XKRWNoticeService *shareInstance;

//插入消息 Sql语句
static  NSString *insertNoticeSql = @"INSERT INTO user_notice(comment_id,avater,honor,nickname,blogId,text,time,type,read,uid,md5_id) VALUES (:comment_id,:avater,:honor,:nickname,:blogId,:text,:time,:type,:read,:uid,:md5_id) ";



static  NSString *insertSyatemNoticeSql = @"INSERT INTO user_notice(avater,nickname,blogId,text,time,type,read,uid,md5_id) VALUES (:avater,:nickname,:blogId,:text,:time,:type,:read,:uid,:md5_id) ";

static  NSString *insertShoushouServerNoticeSql = @"INSERT INTO user_notice(avater,nickname,text,time,type,read,uid,md5_id) VALUES (:avater,:nickname,:text,:time,:type,:read,:uid,:md5_id) ";

static NSString *deleteShouShouServerSqlWithSpecialType = @"Delete From user_notice where type = 699";

@implementation XKRWNoticeService
{
    UIViewController *vc;
    UIWindow    *keyWindow;
    NSDictionary *noticeInfomation;
}
#pragma mark -- 重要通知---


+(instancetype)sharedService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWNoticeService alloc]init];
    });
    return shareInstance;
}



- (void)appOpenStateDealNotification:(NSDictionary *)notificationInfo{
    if ([[notificationInfo objectForKey:@"type"] integerValue] == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoteNormalNotification object:notificationInfo];
    }else if([[notificationInfo objectForKey:@"type"] integerValue] == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoteImportantNotification object:notificationInfo];
    }else if ([[notificationInfo objectForKey:@"type"] integerValue] == 2){
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoteCommentNotification object:notificationInfo];
    }else if ([[notificationInfo objectForKey:@"type"] integerValue] == 3){
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoteThumpUpNotification object:notificationInfo];
    }else if ([[notificationInfo objectForKey:@"type"] integerValue] == 4){
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoteSystemNotification object:notificationInfo];
    }else if ([[notificationInfo objectForKey:@"type"] integerValue] == 5)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RemotePKNotification object:
         notificationInfo];
    }else if ([[notificationInfo objectForKey:@"type"] integerValue] == 6)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoteServicerNotification object:
         notificationInfo];
    }else if ([[notificationInfo objectForKey:@"type"] integerValue] == 7)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RemotePostCommentNotification object:
         notificationInfo];
    }else if ([[notificationInfo objectForKey:@"type"] integerValue] == 8)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RemotePostThumpUpNotification object:
         notificationInfo];
    }
}



- (void)addNotificationInViewController:(UIViewController *) viewController andKeyWindow:(UIWindow *)window
{
    vc =viewController;
    keyWindow = window;
    noticeInfomation = [[NSDictionary alloc]init];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RemoteNotificationContent] == nil) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertView:) name:RemoteNormalNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImprotantNoticewindow:) name:RemoteImportantNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealThumpUpInfo:) name:RemoteThumpUpNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealCommentInfo:) name:RemoteCommentNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealsystemInfo:) name:RemoteSystemNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPKInfo:) name:RemotePKNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealShouShouServer:) name:RemoteServicerNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPostComment:) name:RemotePostCommentNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPostThumpUpInfo:) name:RemotePostThumpUpNotification object:nil];
    }
}

- (void)addAppCloseStateNotificationInViewController:(UIViewController *) viewController andKeyWindow:(UIWindow *)window
{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:RemoteNotificationContent]!= nil) {
        NSDictionary  *noticeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:RemoteNotificationContent];
        
        if ([[noticeInfo objectForKey:@"type"] integerValue] == 0) {
            [self showNormalInformation];
        }
        else if ([[noticeInfo objectForKey:@"type"] integerValue] == 1){
            [self showImprotantNoticewindow:noticeInfo];
        }else if ([[noticeInfo objectForKey:@"type"] integerValue] == 2){
            [self dealCommentInfoAndAppOpen:noticeInfo];
        }else if ([[noticeInfo objectForKey:@"type"] integerValue] == 3){
            [self dealThumpUpInfoAndAppOpen:noticeInfo];
        }else if ([[noticeInfo objectForKey:@"type"] integerValue] == 4){
            [self dealsystemInfoAndAppOpen:noticeInfo];
        }else if ([[noticeInfo objectForKey:@"type"] integerValue] == 5){
            [self dealPKInfoAndAppOpen:noticeInfo];
        }else if ([[noticeInfo objectForKey:@"type"] integerValue] == 6){
            [self dealShouShouServerAndAppOpen:noticeInfo];
        }else if ([[noticeInfo objectForKey:@"type"] integerValue] == 7){
            [self dealPostCommentAndAppOpen:noticeInfo];
        }else if ([[noticeInfo objectForKey:@"type"] integerValue] == 8){
            [self dealPostThumpUpInfoAndAppOpen:noticeInfo];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:RemoteNotificationContent];
        [self addNotificationInViewController:vc andKeyWindow:window];
    }
}

- (void) showImprotantNoticewindow:(NSDictionary *)notification
{
    [self showInfomationToWindow:[[notification objectForKey:@"aps"]objectForKey:@"alert"] content:[notification objectForKey:@"content"] ];
}

- (void)showInfomationToWindow:(NSString *)title content:(NSString *)content
{
    UIView *background;
    for (UIView *view in [keyWindow subviews]) {
        if (view.tag == 1000) {
            background = view;
            [background removeFromSuperview];
        }
    }
    background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
    background.tag = 1000;
    background.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [keyWindow addSubview:background];
    
    UIView *showView;
    
    if (XKAppWidth == 320) {
        showView = [[UIView alloc]initWithFrame:CGRectMake((XKAppWidth-260)/2, 64+50, 260, XKAppHeight-64*2-100)];
    }else if (XKAppWidth == 375){
        showView = [[UIView alloc]initWithFrame:CGRectMake((XKAppWidth-300)/2, 64+50, 300, XKAppHeight-64*2-100)];
    }else{
        showView = [[UIView alloc]initWithFrame:CGRectMake((XKAppWidth-330)/2, 64+50, 330, XKAppHeight-64*2-100)];
    }
    
    showView.backgroundColor = [UIColor whiteColor];
    showView.layer.masksToBounds = YES;
    showView.layer.cornerRadius = 6;
    [background addSubview:showView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributedStr = [XKRWUtil createAttributeStringWithString:title font:XKDefaultFontWithSize(16.f) color:XK_TITLE_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    
    titleLabel.attributedText = attributedStr;
    
    CGRect rect   =[attributedStr  boundingRectWithSize:CGSizeMake(showView.width-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    titleLabel.frame = CGRectMake(20, 10, showView.width-40, rect.size.height+25);
    titleLabel.numberOfLines = 0;
    [showView addSubview:titleLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, titleLabel.bottom, showView.width-20, showView.height-60-titleLabel.height-15)];
    textView.editable = NO;
    textView.attributedText =  [XKRWUtil createAttributeStringWithString:content font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:7 alignment:NSTextAlignmentLeft];
    
    textView.font = XKDefaultFontWithSize(14.f);
    textView.backgroundColor = [UIColor whiteColor];
    [showView addSubview:textView];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake((showView.width-240)/2, textView.bottom+(60-32)/2, 240, 32);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"buttonGreenLong"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"buttonGreenLong_p"] forState:UIControlStateHighlighted];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [closeButton setTitle:@"确定" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeNotice) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:closeButton];
}


- (void)closeNotice
{
    NSArray *arrays =  [keyWindow subviews];
    for (UIView *view in arrays) {
        if (view.tag == 1000) {
            view.backgroundColor = [UIColor clearColor];
            [view removeFromSuperview];
        }
    }
}

- (void)showNormalInformation
{
    NSDictionary  *noticeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:RemoteNotificationContent];
    
    NSString *urlStr = [noticeInfo objectForKey:@"url"];
    
    if (urlStr.length == 0) {
        return;
    }
    XKRWNewWebView *webView  = [[XKRWNewWebView alloc]init];
    webView.webTitle = [[noticeInfo objectForKey:@"aps"]objectForKey:@"alert"];
    webView.contentUrl = [NSString stringWithFormat:@"%@?token=%@",[noticeInfo objectForKey:@"url"],[[XKRWUserService sharedService]getToken]];
    webView.showType = YES;
    
    [vc  presentViewController:[[XKRWNavigationController alloc]initWithRootViewController:webView withNavigationBarType:NavigationBarTypeDefault] animated:YES completion:^{
        
    }];

}

- (void)showNormalNotice:(NSDictionary *)dic
{
    NSString *urlStr = [dic objectForKey:@"url"];
    if (urlStr.length == 0) {
        return;
    }
    
    XKRWNewWebView *webView  = [[XKRWNewWebView alloc]init];
    webView.webTitle = [[dic objectForKey:@"aps"]objectForKey:@"alert"];
    webView.contentUrl = [dic objectForKey:@"url"];
    webView.showType = YES;
    
    [vc  presentViewController:[[XKRWNavigationController alloc]initWithRootViewController:webView withNavigationBarType:NavigationBarTypeDefault] animated:YES completion:^{
        
    }];
}

- (void)showPkNotice:(NSDictionary *)dic
{
    NSString *nid = [dic objectForKey:@"pk_id"];
    XKRWPKVC *pkVC = [[XKRWPKVC alloc] initWithNibName:@"XKRWPKVC" bundle:nil];
    pkVC.nid = nid;
    pkVC.isPresent = YES;
    [vc presentViewController:[[XKRWNavigationController alloc] initWithRootViewController:pkVC withNavigationBarType:NavigationBarTypeDefault]
                     animated:YES
                   completion:nil];
}


- (void)showAlertView:(NSNotification *)notification
{
    noticeInfomation = notification.object;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"推荐阅读" message:[[notification.object objectForKey:@"aps"]objectForKey:@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1000;
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex ==1) {
            [self showNormalNotice:noticeInfomation];
        }
    }else if (alertView.tag == 1001){
        if (buttonIndex ==1) {
            [self showPkNotice:noticeInfomation];
        }
    }
}

- (NSDictionary *)getNoticeDetailDataWithBlogId:(NSString *)blogId andCommentId:(NSString *)commentId andNoticeType:(NSInteger) type
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,@"/comment/detail/"]];
    NSDictionary *params;
    if(type == 7){
         params = @{@"blogid":blogId,@"comment_id":commentId,@"type":@2};
    }else{
        params = @{@"blogid":blogId,@"comment_id":commentId};
    }
    
    NSDictionary *result =  [self syncBatchDataWith:url andPostForm:params withLongTime:YES];
    return result;
}


- (void)insertNoticeListToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push
{
    NSMutableDictionary *sqlDic;
    if(push){
        sqlDic = [NSMutableDictionary dictionaryWithDictionary:@{@"comment_id":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"comment_id"] integerValue]],
                                                                 @"avater":[noticeDic  objectForKey:@"avatar"],
                                                                 @"blogId":[noticeDic  objectForKey:@"blog_id"],
                                                                 @"honor":[noticeDic  objectForKey:@"honor"],
                                                                 @"nickname":[noticeDic  objectForKey:@"nickname"],
                                                                 @"text":[noticeDic  objectForKey:@"text"],
                                                                 @"time":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"time"] integerValue]],
                                                                 @"type":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"type"] integerValue]],
                                                                 @"read":[NSNumber numberWithInteger:read],
                                                                 @"uid":[NSNumber  numberWithInteger:uid],
                                                                 @"md5_id":[noticeDic objectForKey:@"md5_id"]}];
    }else{
        
        NSString * redirect = [noticeDic objectForKey:@"redirect"];
        NSArray *idArray = [redirect componentsSeparatedByString:@"@"];
       
        sqlDic  = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                  @"avater":[noticeDic  objectForKey:@"avatar"],
                                                                  
                                                                  @"honor":[noticeDic  objectForKey:@"honor"],
                                                                  @"nickname":[noticeDic  objectForKey:@"nickname"],
                                                                  @"text":[noticeDic  objectForKey:@"content"],
                                                                  @"time":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"time"] integerValue]],
                                                                  @"type":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"type"] integerValue]],
                                                                  @"read":[NSNumber numberWithInteger:read],
                                                                  @"uid":[NSNumber  numberWithInteger:uid],
                                                                  @"md5_id":[noticeDic objectForKey:@"md5_id"]}];
        
        if(idArray .count < 2){
            NSString *blogID = [idArray objectAtIndex:0];
            [sqlDic setObject:blogID forKey:@"blogId"];
            [sqlDic setObject:@0 forKey:@"comment_id"];
        }else{
            NSString *commmentID = [idArray objectAtIndex:1];
            NSString *blogID = [idArray objectAtIndex:0];
            [sqlDic setObject:blogID forKey:@"blogId"];
            [sqlDic setObject:commmentID forKey:@"comment_id"];
        }
    }
    
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        BOOL success =  [db executeUpdate:insertNoticeSql withParameterDictionary:sqlDic];
        if(success){
            XKLog(@"%@",@"插入成功");
        }else{
            
        }
    }];
    

}

- (void)insertPostCommentNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push{
    
    
    
}

- (void)insertShouShouServicerNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push {
    
    [[NSUserDefaults standardUserDefaults] setObject:[noticeDic  objectForKey:@"redirect"] forKey:[NSString stringWithFormat:@"redirect_%ld",uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *sqlDic;
    if (push){
        sqlDic  = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                  @"avater":[noticeDic  objectForKey:@"avatar"],
                                                                  
                                                                  @"nickname":[noticeDic  objectForKey:@"nickname"],
                                                                  @"text":[noticeDic  objectForKey:@"text"],
                                                                  @"time":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"time"] integerValue]],
                                                                  @"type":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"type"] integerValue]],
                                                                  @"read":[NSNumber numberWithInteger:read],
                                                                  @"uid":[NSNumber  numberWithInteger:uid],
                                                                  @"md5_id":[noticeDic objectForKey:@"md5_id"]}];

        
        
    
    }else{

        sqlDic  = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                  @"avater":[noticeDic  objectForKey:@"avatar"],
                                                                  
                                                                  @"nickname":[noticeDic  objectForKey:@"nickname"],
                                                                  @"text":[noticeDic  objectForKey:@"content"],
                                                                  @"time":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"time"] integerValue]],
                                                                  @"type":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"type"] integerValue]],
                                                                  @"read":[NSNumber numberWithInteger:read],
                                                                  @"uid":[NSNumber  numberWithInteger:uid],
                                                                  @"md5_id":[noticeDic objectForKey:@"md5_id"]}];
    }
    
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        BOOL success =  [db executeUpdate:insertShoushouServerNoticeSql withParameterDictionary:sqlDic];
        if(success){
            XKLog(@"%@",@"插入成功");
        }else{
            
        }
    }];
    
    [sqlDic setObject:[NSNumber numberWithInteger:699] forKey:@"type"];
    [sqlDic setObject:@"temp" forKey:@"md5_id"];
    if ([self executeSql:deleteShouShouServerSqlWithSpecialType]){
        [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
            BOOL success =  [db executeUpdate:insertShoushouServerNoticeSql withParameterDictionary:sqlDic];
            if(success){
                XKLog(@"%@",@"插入成功");
            }else{
                
            }
        }];
    }

}

- (void)insertUserToShoushouServiceNoticeToDatabase:(NSString *)replayInfo andUserId:(NSInteger)uid
{
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    
    NSMutableDictionary *sqlDic  = [NSMutableDictionary dictionaryWithDictionary:@{
                                                              @"avater":[[XKRWUserService sharedService] getUserAvatar],
                                                              
                                                              @"nickname":[[XKRWUserService sharedService] getUserNickName],
                                                              @"text":replayInfo,
                                                              @"time":[NSNumber numberWithInteger:time],
                                                              @"type":@"601",
                                                              @"read":@"1",
                                                              @"uid":[NSNumber  numberWithInteger:uid],
                                                              @"md5_id":[[XKRWUserService sharedService]  getUserAccountName]}];


    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        BOOL success =  [db executeUpdate:insertShoushouServerNoticeSql withParameterDictionary:sqlDic];
        if(success){
            XKLog(@"%@",@"插入成功");
        }else{
        
        }
    }];
    
    [sqlDic setObject:[NSNumber numberWithInteger:699] forKey:@"type"];
    [sqlDic setObject:@"temp" forKey:@"md5_id"];
    if ([self executeSql:deleteShouShouServerSqlWithSpecialType]){
        [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
            BOOL success =  [db executeUpdate:insertShoushouServerNoticeSql withParameterDictionary:sqlDic];
            if(success){
                XKLog(@"%@",@"插入成功");
            }else{
                
            }
        }];
    }


}




- (void)insertSystemNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push
{
    NSMutableDictionary *sqlDic ;
    if(push){
        sqlDic = [NSMutableDictionary dictionaryWithDictionary:@{@"avater":[noticeDic  objectForKey:@"avatar"],
                                                                 @"blogId":[noticeDic  objectForKey:@"blog_id"],
                                                                 
                                                                 @"nickname":[noticeDic  objectForKey:@"nickname"],
                                                                 @"text":[noticeDic  objectForKey:@"text"],
                                                                 @"time":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"time"] integerValue]],
                                                                 @"type":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"type"] integerValue]],
                                                                 @"read":[NSNumber numberWithInteger:read],
                                                                 @"uid":[NSNumber  numberWithInteger:uid]
                                                                 , @"md5_id":[noticeDic objectForKey:@"md5_id"]}];
    }else{
        
        sqlDic = [NSMutableDictionary dictionaryWithDictionary:@{@"avater":[noticeDic  objectForKey:@"avatar"],
                                                                 @"nickname":[noticeDic  objectForKey:@"nickname"],
                                                                 @"text":[noticeDic  objectForKey:@"content"],
                                                                 @"time":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"time"] integerValue]],
                                                                 @"type":[NSNumber numberWithInteger:[[noticeDic  objectForKey:@"type"] integerValue]],
                                                                 @"read":[NSNumber numberWithInteger:read],
                                                                 @"uid":[NSNumber  numberWithInteger:uid]
                                                                 , @"md5_id":[noticeDic objectForKey:@"md5_id"],
                                                                 @"blogId":[noticeDic objectForKey:@"redirect"]}];
    
    }
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        BOOL success =  [db executeUpdate:insertSyatemNoticeSql withParameterDictionary:sqlDic];
        if(success){
            XKLog(@"%@",@"插入成功");
        }
    }];

}

/**
 *  从数据库获取消息（点赞消息，评论的消息）
 */
- (NSMutableArray *) getNoticeListFromDatabaseAndUserId:(NSInteger) userid andNoticeType:(NSString *) noticeTypeString
{
//    //设置可变参数
//    va_list args;
//    va_start (args, noticeType);
//    
//    NSMutableString *mutableString = [NSMutableString string];
//    
//    if(noticeType){
//        [mutableString appendString:[NSString stringWithFormat:@"%ld",noticeType]];
//        NSInteger nextArg;
//        while((nextArg = va_arg(args,  NSInteger)))
//        {
//            [mutableString appendString:[NSString stringWithFormat:@",%ld",nextArg]];
//        }
//        va_end(args);
//    }
    
    
    NSString *sql = [NSString stringWithFormat:@"select * from user_notice where uid = %ld and type in (%@) order by read , nid desc",(long)userid,noticeTypeString];
   
    NSMutableArray *array =  [self query:sql];
    
    NSMutableArray *noticeEntityArray = [NSMutableArray arrayWithCapacity:array.count];
    
    for (int i =  0 ; i < array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        XKRWPraiseAndCommitNoticeEntity *entity = [[XKRWPraiseAndCommitNoticeEntity alloc]init];
        entity.avater = [dic objectForKey:@"avater"];
        entity.blogId = [dic objectForKey:@"blogId"] != [NSNull null] ? [dic objectForKey:@"blogId"]:@"";
        entity.comment_id =  [dic objectForKey:@"comment_id"]==[NSNull null]? 0:[[dic objectForKey:@"comment_id"] integerValue] ;
        entity.userDegreeUrl = [dic objectForKey:@"honor"]==[NSNull null] ? @"":[dic objectForKey:@"honor"] ;
        entity.nickName = [dic objectForKey:@"nickname"];
        entity.read = [[dic objectForKey:@"read"] integerValue];
        entity.content = [dic objectForKey:@"text"];
        entity.type = [[dic objectForKey:@"type"] integerValue];
        entity.time = [XKRWUtil calculateTimeShowStr:[[dic objectForKey:@"time"] integerValue]];
        entity.nid =[[dic objectForKey:@"nid"] integerValue];
        entity.md5Id = [dic objectForKey:@"md5_id"];
        [noticeEntityArray addObject:entity];
    }
    return noticeEntityArray;
}


- (NSMutableArray *) getBePraiseFromDatabaseWithUserId:(NSInteger) userid
{
    NSString *sql = [NSString stringWithFormat:@"select * from user_notice where uid = %ld and type in (3,8) order by nid desc",(long)userid];
    
    NSMutableArray *array =  [self query:sql];
    
    NSMutableArray *noticeEntityArray = [NSMutableArray arrayWithCapacity:array.count];
    
    for (int i =  0 ; i < array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        
        XKRWBePraisedEntity * entity = [[XKRWBePraisedEntity alloc] init];
        entity.headImageUrl = [dic objectForKey:@"avater"];
        if([dic objectForKey:@"blogId"] != [NSNull null] &&  [[dic objectForKey:@"type"] integerValue] == 3){
            entity.blogId = [dic objectForKey:@"blogId"];
        }else  if([dic objectForKey:@"blogId"] != [NSNull null] &&  [[dic objectForKey:@"type"] integerValue] == 8){
            entity.postId = [dic objectForKey:@"blogId"];
        }
        entity.createTime = [[dic objectForKey:@"time"] integerValue];
        entity.userDegreeUrl = [dic objectForKey:@"honor"]==[NSNull null] ? @"":[dic objectForKey:@"honor"] ;
        entity.userNickName = [dic objectForKey:@"nickname"];
        entity.content = [dic objectForKey:@"text"];

        [noticeEntityArray addObject:entity];
    }
    return noticeEntityArray;
}


- (NSInteger) ShouShouServerChat:(NSInteger) userid {

    NSString *sql = [NSString stringWithFormat:@"select * from user_notice where uid = %ld and type = 6 order by nid desc",(long)userid];
    
    NSMutableArray *array =  [self query:sql];
    
    if(array.count > 0){
        NSString *sql = [NSString stringWithFormat:@"select * from user_notice where uid = %ld and type = 6 and read = 0 order by nid desc",(long)userid];
        NSMutableArray *chatArray =  [self query:sql];
        if(chatArray > 0){
            return chatArray.count;
        }else{
            return 0;
        }
    }else{
        return -1 ;
    }
}



- (void)dealPostThumpUpInfo:(NSNotification *)notification
{
    [self insertNoticeListToDatabase:notification.object andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:0 andIspush:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:BePraiseNoticeChanged object:nil];
}

- (void)dealPostThumpUpInfoAndAppOpen:(NSDictionary *)notification {
    [self insertNoticeListToDatabase:notification andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:0 andIspush:YES];
    
    XKRWBePraisedVC *praisedVC = [[XKRWBePraisedVC alloc]initWithNibName:@"XKRWBePraisedVC" bundle:nil];
    praisedVC.dataType = bePraiseDataTypeFromDataBase;
    praisedVC.present = YES;
    [vc presentViewController:[[XKRWNavigationController alloc]initWithRootViewController:praisedVC withNavigationBarType:NavigationBarTypeDefault] animated:YES completion:^{
    }];
}


/**
 *  处理点赞
 */
- (void)dealThumpUpInfo:(NSNotification *)notification
{
    [self insertNoticeListToDatabase:notification.object andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:0 andIspush:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:BePraiseNoticeChanged object:nil];
}

- (void)dealThumpUpInfoAndAppOpen:(NSDictionary *)notification
{
     [self insertNoticeListToDatabase:notification andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:0 andIspush:YES];
    
    XKRWBePraisedVC *praisedVC = [[XKRWBePraisedVC alloc]initWithNibName:@"XKRWBePraisedVC" bundle:nil];
    praisedVC.dataType = bePraiseDataTypeFromDataBase;
    praisedVC.present = YES;
    [vc presentViewController:[[XKRWNavigationController alloc]initWithRootViewController:praisedVC withNavigationBarType:NavigationBarTypeDefault] animated:YES completion:^{
    }];}

- (void)dealCommentInfoAndAppOpen:(NSDictionary *)notification
{
    [self insertNoticeListToDatabase:notification andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:1 andIspush:YES];
    
//    NSDictionary *  noticeDic = notification.object;
    XKRWPraiseAndCommitNoticeEntity *entity = [[XKRWPraiseAndCommitNoticeEntity alloc]init];
    entity.avater = [notification objectForKey:@"avatar"];
    entity.blogId = [notification objectForKey:@"blog_id"];
    entity.comment_id = [[notification objectForKey:@"comment_id"] integerValue];
    entity.userDegreeUrl = [notification objectForKey:@"honor"];
    entity.nickName = [notification objectForKey:@"nickname"];
    entity.read = 1;
    entity.content = [notification objectForKey:@"text"];
    entity.type = [[notification objectForKey:@"type"] integerValue];
    entity.time = [XKRWUtil dateFormatWithTime:[[notification objectForKey:@"time"] integerValue]];
    XKRWMyNoticeDetailVC *noticeDetailVC = [[XKRWMyNoticeDetailVC alloc] initWithNibName:@"XKRWMyNoticeDetailVC" bundle:nil];
    noticeDetailVC.headEntity = entity;
    noticeDetailVC.isPresent = YES;
    [vc presentViewController:[[XKRWNavigationController alloc]initWithRootViewController:noticeDetailVC withNavigationBarType:NavigationBarTypeDefault] animated:YES completion:^{
    }];
}

//处理系统消息
- (void)dealsystemInfoAndAppOpen:(NSDictionary *)notification
{
    [self insertSystemNoticeToDatabase:notification andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:1 andIspush:YES];
    
   
    XKRWPraiseAndCommitNoticeEntity *entity = [[XKRWPraiseAndCommitNoticeEntity alloc]init];
    entity.avater = [notification objectForKey:@"avater"];
    entity.blogId = [notification objectForKey:@"blog_id"];
    entity.nickName = [notification objectForKey:@"nickname"];
    entity.read = 1;
    entity.content = [notification objectForKey:@"text"];
    entity.type = [[notification objectForKey:@"type"] integerValue];
    entity.time = [XKRWUtil dateFormatWithTime:[[notification objectForKey:@"time"] integerValue]];
    
    XKRWNoticeCenterVC *centerVC =  [[XKRWNoticeCenterVC alloc]initWithNibName:@"XKRWNoticeCenterVC" bundle:nil];
    centerVC.isPresent = YES;
//     __weak XKRWNoticeCenterVC *noticeCenterVC = centerVC ;
    [vc presentViewController:[[XKRWNavigationController alloc]initWithRootViewController:centerVC withNavigationBarType:NavigationBarTypeDefault] animated:YES completion:^{
//        noticeCenterVC.title = @"消息中心";
//        [noticeCenterVC addNaviBarBackButton];
    }];
}

// APP 关闭状态下 处理PK
- (void)dealPKInfoAndAppOpen:(NSDictionary *)notification
{
    noticeInfomation = notification;
    NSString *nid =  [noticeInfomation objectForKey:@"pk_id"];
    XKRWPKVC *pkVC = [[XKRWPKVC alloc]initWithNibName:@"XKRWPKVC" bundle:nil];
    pkVC.nid = nid;
    pkVC.isPresent = YES;
    [vc  presentViewController:[[XKRWNavigationController alloc] initWithRootViewController:pkVC withNavigationBarType:NavigationBarTypeDefault] animated:YES completion:nil];
}

/**
 *  处理PK 消息
 *
 *  @param notification <#notification description#>
 */
- (void)dealPKInfo:(NSNotification *)notification
{
    noticeInfomation = notification.object;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"收到“大家来PK”的通知，是否查看？" message:[[notification.object objectForKey:@"aps"]objectForKey:@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1001;
    alertView.delegate = self;
    [alertView show];
}

/**
 *  处理瘦瘦客服 App关闭状态下
 *
 *  @param notification <#notification description#>
 */
- (void)dealShouShouServerAndAppOpen:(NSDictionary *)notification {
    [self insertShouShouServicerNoticeToDatabase:notification andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:0 andIspush:YES];
    
    XKRWNoticeCenterVC *centerVC =  [[XKRWNoticeCenterVC alloc]initWithNibName:@"XKRWNoticeCenterVC" bundle:nil];
    centerVC.isPresent = YES;
    [vc presentViewController:[[XKRWNavigationController alloc]initWithRootViewController:centerVC withNavigationBarType:NavigationBarTypeDefault] animated:YES completion:^{
        
    }];

}

/**
 *  处理瘦瘦客服 App打开状态下
 *
 *  @param notification
 */
- (void)dealShouShouServer:(NSNotification *)notification {
    [self insertShouShouServicerNoticeToDatabase:notification.object andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:0 andIspush:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CommentAndSystemNoticeChanged object:nil];
   
}

/**
 *  处理帖子评论 App关闭状态下
 *
 *  @param notification <#notification description#>
 */
- (void)dealPostCommentAndAppOpen:(NSDictionary *)notification {
    [self dealCommentInfoAndAppOpen:notification];
}

/**
 *  处理帖子评论 App打开状态下
 *
 *  @param notification <#notification description#>
 */
- (void)dealPostComment:(NSNotification *)notification {
    [self dealCommentInfo:notification];
}



//处理系统消息
- (void)dealsystemInfo:(NSNotification *)notification
{
     [self insertSystemNoticeToDatabase:notification.object andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:0 andIspush:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:CommentAndSystemNoticeChanged object:nil];
}

/**
 *  处理评论
 */
- (void)dealCommentInfo:(NSNotification *)notification
{
    [self insertNoticeListToDatabase:notification.object andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:0 andIspush:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:CommentAndSystemNoticeChanged object:nil];

}

- (void)dealShouShouServerOpenToChatVC:(NSNotification *)notification{
    [self insertShouShouServicerNoticeToDatabase:notification.object andUserId:[[XKRWUserService sharedService] getUserId] andIsRead:0 andIspush:YES];

    XKRWNoticeCenterVC *centerVC =  [[XKRWNoticeCenterVC alloc]initWithNibName:@"XKRWNoticeCenterVC" bundle:nil];
    centerVC.isPresent = YES;
    [vc presentViewController:[[XKRWNavigationController alloc]initWithRootViewController:centerVC withNavigationBarType:NavigationBarTypeDefault] animated:YES completion:^{
     
    }];
}

- (BOOL) setAllNoticeHadRead:(NSInteger)uid
{
    NSString *updataSql = [NSString stringWithFormat:@"UPDATE user_notice set read = 1 where uid = %ld and type in (2,7)",(long)uid];
    BOOL  success = [self executeSql:updataSql];
    if(success){
        [[NSNotificationCenter  defaultCenter] postNotificationName:CommentAndSystemNoticeChanged object:nil];
    }
    XKLog(@"%d",success);
    
    return success;
}


- (BOOL) setChatNoticeHadRead:(NSInteger)uid
{
    NSString *updataSql = [NSString stringWithFormat:@"UPDATE user_notice set read = 1 where uid = %ld and type = 6 ",(long)uid];
    BOOL  success = [self executeSql:updataSql];
    if(success){
        [[NSNotificationCenter  defaultCenter] postNotificationName:CommentAndSystemNoticeChanged object:nil];
    }
    XKLog(@"%d",success);
    
    return success;

}

- (BOOL) setSystemNoticeHadRead:(NSInteger)uid
{
    NSString *updataSql = [NSString stringWithFormat:@"UPDATE user_notice set read = 1 where uid = %ld and type in (4,9,10) ",(long)uid];
    BOOL  success = [self executeSql:updataSql];
    if(success){
        [[NSNotificationCenter  defaultCenter] postNotificationName:CommentAndSystemNoticeChanged object:nil];
    }
    XKLog(@"%d",success);
    return success;
}


- (BOOL) setCurrentNoticeHadRead:(NSInteger)uid andNid:(NSInteger)nid
{
    NSString *updataSql = [NSString stringWithFormat:@"UPDATE user_notice set read = 1 where uid = %ld and nid = %ld",(long)uid,(long)nid];
    BOOL  success = [self executeSql:updataSql];
    if(success){
        [[NSNotificationCenter  defaultCenter] postNotificationName:CommentAndSystemNoticeChanged object:nil];
    }
    return success;
}

- (NSInteger) getUnreadBePraisedNoticeNum
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM user_notice WHERE uid = %ld and type in (3,8) and read = 0 ",(long)[[XKRWUserService sharedService] getUserId]];
    NSMutableArray *array = [self query:sql];
    return array.count;
}

- (BOOL)deleteUnreadBePraisedNotice
{
    NSString *sql = [NSString stringWithFormat:@"DELETE  FROM user_notice WHERE uid = %ld and type in (3,8) and read = 0 ",(long)[[XKRWUserService sharedService] getUserId]];
    BOOL success = [self executeSql:sql];
    if(success){
        [[NSNotificationCenter defaultCenter] postNotificationName:BePraiseNoticeChanged object:nil];
    }
    return success;
}

- (NSInteger) getUnreadCommentOrSystemNoticeNum
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM user_notice WHERE uid = %ld and type in (2,4,7,6,9,10) and read = 0 ",(long)[[XKRWUserService sharedService] getUserId]];
    NSMutableArray *array = [self query:sql];
    return array.count;
}

- (NSInteger) getAllUnreadNoticeNum
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM user_notice WHERE uid = %ld  and read = 0 ",(long)[[XKRWUserService sharedService] getUserId]];
    NSMutableArray *array = [self query:sql];
    return array.count;
}

- (BOOL)deleteNoticeWithNid:(NSInteger)nid
{
    NSString *sql = [NSString stringWithFormat:@"DELETE  FROM user_notice WHERE nid = %ld ",(long)nid];
    BOOL success = [self executeSql:sql];
    if(success){
        [[NSNotificationCenter defaultCenter] postNotificationName:CommentAndSystemNoticeChanged object:nil];
    }
    return success;
}

- (NSDictionary *)getAllNoticeInfomationFromNetWorkWithTime:(NSNumber *)time AndMessageType:(NSString *)type
{
    NSURL *noticeUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@&type=message&do=get",kNoticeServer,kGetNotice,[[XKRWUserService sharedService] getToken]]];
    
    NSDictionary *result =  [self syncBatchDataWith:noticeUrl andPostForm:nil withLongTime:YES];
    return result;
}

- (NSArray *) getAllShouShouServerAndUserReplayFromDatabaseWithUserId:(NSInteger) uid{
    NSString * sql = [NSString stringWithFormat:@"select avater,md5_id,nickname,nid,read,text,time,type from user_notice where uid = %ld and type in (6,601) order by time asc",(long)uid];
    
    NSMutableArray *array =  [self query:sql];
    
    NSMutableArray *chatInfoArray = [NSMutableArray arrayWithCapacity:[array count]];
    
    for (int i = 0 ; i < array.count ;i++  ){
        NSDictionary *dic = [array objectAtIndex:i];
        XKRWChatMessageModel *messageModel = [[XKRWChatMessageModel alloc] init];
        messageModel.message = [dic objectForKey:@"text"];
        messageModel.time = [[dic objectForKey:@"time"] integerValue];
        if([[dic objectForKey:@"type"] integerValue] == 6){
            messageModel.senderType = MessgeSendTypeFromOther;
        }else{
            messageModel.senderType = MessgeSendTypeFromMain;
        }
        messageModel.imageUrl = [dic objectForKey:@"avater"];
        [chatInfoArray addObject:messageModel];
    }
    
    return chatInfoArray;
}

- (BOOL) sendChatInfoToShouShouServer:(NSString *)content{

    NSString *redirect =  [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"redirect_%ld",[[XKRWUserService sharedService] getUserId]]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,@"/user/chat/"]];
    NSDictionary *params = @{@"content":content,@"redirect":redirect};
    NSDictionary *result =  [self syncBatchDataWith:url andPostForm:params withLongTime:YES];
    if([[result objectForKey:@"success"] integerValue]){
        return YES;
    }
    return NO;
}


- (void)insertThumpNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push
{
    [self insertNoticeListToDatabase:noticeDic andUserId:uid andIsRead:0 andIspush:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:BePraiseNoticeChanged object:nil];
}

- (void)insertDeleteNoticeToDatabase:(NSDictionary *)noticeDic andUserId:(NSInteger)uid andIsRead:(NSInteger) read andIspush:(BOOL) push{
     [self insertNoticeListToDatabase:noticeDic andUserId:uid andIsRead:0 andIspush:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:CommentAndSystemNoticeChanged object:nil];
}


@end
