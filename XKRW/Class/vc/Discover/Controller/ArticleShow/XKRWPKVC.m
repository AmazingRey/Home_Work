//
//  XKRWPKVC.m
//  XKRW
//
//  Created by 忘、 on 15/8/15.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWPKVC.h"
#import "XKRWManagementService5_0.h"
#import "UIImageView+WebCache.h"
#import "XKRWArticleDetailEntity.h"
#import "XKHudHelper.h"
#import "masonry.h"

@interface XKRWPKVC ()
{
    BOOL      _canShowDetail;       /**<能否显示全部内容*/
    float     _viewHeight;          /**<动态页面内容的高度*/
    
    CGFloat   _xbdhLabelHeight ;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pkImageViewHeight;

@end

@implementation XKRWPKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"大家来PK";
    
    _zfButton.layer.masksToBounds = YES;
    _zfButton.layer.cornerRadius = 4;
    
    _ffButton.layer.masksToBounds = YES;
    _ffButton.layer.cornerRadius = 4;
    
    _zfButton.backgroundColor = [UIColor whiteColor];
    _ffButton.backgroundColor = [UIColor whiteColor];
    _zfButton.layer.borderColor = XKMainSchemeColor.CGColor;
    _zfButton.layer.borderWidth = 1;
    _ffButton.layer.borderColor = [UIColor redColor].CGColor;
    _ffButton.layer.borderWidth = 1;
    [_zfButton setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
    [_zfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_ffButton setBackgroundImage:[UIImage createImageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];
    [_ffButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    if ([[XKRWManagementService5_0 sharedService] checkHadPKNum:_nid]) {
        _zfButton.enabled = NO;
        _ffButton.enabled = NO;
        _zfButton.layer.borderColor = [UIColor colorFromHexString:@"#c6c7cb"].CGColor;
        _ffButton.layer.borderColor = [UIColor colorFromHexString:@"#c6c7cb"].CGColor;
        [_zfButton setTitleColor:[UIColor colorFromHexString:@"#c6c7cb"] forState:UIControlStateNormal];
        [_ffButton setTitleColor:[UIColor colorFromHexString:@"#c6c7cb"] forState:UIControlStateNormal];
    }
    [self addNaviBarBackButton];
    _canShowDetail = NO;
    [self initData];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    if([XKRWUtil isNetWorkAvailable]){
        [[XKHudHelper instance] showProgressHudAnimationInView:self.view];
        [self downloadWithTaskID:@"getPKInfo" outputTask:^id{
            return [[XKRWManagementService5_0 sharedService]getPKDetailFromServerByNid:_nid];
        }];
    }else{
        [self showRequestArticleNetworkFailedWarningShow];
    }
}


- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    if ([taskID isEqualToString:@"getPKInfo"]) {
        [self hiddenRequestArticleNetworkFailedWarningShow];
        XKRWArticleDetailEntity *entity = (XKRWArticleDetailEntity *)result;
        NSString *time = entity.content[@"jzrq"];
        NSDate *pkTime =  [NSDate dateFromString:time withFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *nowDate = [NSDate date];
        if ([pkTime compare:nowDate] == NSOrderedAscending) {
            _ffButton.hidden = YES;
            _zfButton.hidden = YES;
            _pkStateLabel.text = @"PK结束";
            _canShowDetail = YES;
        }else{
            if (![[XKRWManagementService5_0 sharedService] checkHadPKNum:_nid]) {
                _xbTipsLabel.hidden = YES;
                _xkdhTitleLabel.hidden = YES;
                _canShowDetail = NO;
            }else{
                _canShowDetail = YES;
            }
            _pkStateLabel.text = [NSString stringWithFormat:@"截止日期:%@",time];
        }
        
        [_pkImageView setImageWithURL:entity.content[@"pic"]
                     placeholderImage:[UIImage imageNamed:@"sportsdetails_normal"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                if (image != nil) {
                                    CGFloat  height  =  (XKAppWidth-50)*image.size.height/image.size.width ;
                                    self.pkImageViewHeight.constant = height;
                                }
                            }];
        
        _pkTitleLabel.text = entity.content[@"title"];
        
        _zfLabel.text = [NSString stringWithFormat:@"正方观点:%@",entity.zfps];
        _ffLabel.text = [NSString stringWithFormat:@"反方观点:%@",entity.ffps];
        
        _zfLabelConstraint.constant = _zfLabel.width/2+ 16 - _zfButton.width/2;
        
        _ffLabelConstraint.constant = _ffLabel.width/2 +16 - _ffButton.width/2;
        
        NSString *ffgd = entity.content[@"ffgd"];
        NSString *zfgd = entity.content[@"zfgd"];
        NSString *xbdh = entity.content[@"xbdh"];
    //    xbdh = [xbdh stringByReplacingOccurrencesOfString:@"\\n" withString:@"\\r\n"];
        NSString *longStr;
        
        if (ffgd.length > zfgd.length) {
            longStr = ffgd;
        }else{
            longStr = zfgd;
        }
        
        NSMutableAttributedString *zfgdattributedString = [XKRWUtil createAttributeStringWithString:zfgd font:XKDefaultFontWithSize(15.f) color:colorSecondary_666666 lineSpacing:3 alignment:NSTextAlignmentCenter];
        NSMutableAttributedString *ffgdattributedString = [XKRWUtil createAttributeStringWithString:ffgd font:XKDefaultFontWithSize(15.f) color:colorSecondary_666666 lineSpacing:3 alignment:NSTextAlignmentCenter];
        
        _zfDetailLabel.attributedText = zfgdattributedString;
        _ffDetailLabel.attributedText = ffgdattributedString;
        
        NSMutableAttributedString *attributedString = [XKRWUtil createAttributeStringWithString:longStr font:XKDefaultFontWithSize(15.f) color:colorSecondary_666666 lineSpacing:3 alignment:NSTextAlignmentLeft];
        
        CGRect rect   =[attributedString  boundingRectWithSize:CGSizeMake(XKAppWidth/2-15-16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if (!_canShowDetail) {
            _lineHeightConstraint.constant = rect.size.height + 70;

        }else{
            _lineHeightConstraint.constant = rect.size.height + 30;
        }
        
        NSMutableAttributedString *xbdhAttributedString = [XKRWUtil createAttributeStringWithString:xbdh font:XKDefaultFontWithSize(15.f) color:colorSecondary_666666 lineSpacing:3 alignment:NSTextAlignmentLeft];
        
        CGRect xbdhRect = [xbdhAttributedString boundingRectWithSize:CGSizeMake(XKAppWidth - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        _xbdhLabelHeight = xbdhRect.size.height;
        _xbTipsLabel.attributedText = xbdhAttributedString;
//        _xbTipsLabel.backgroundColor = [UIColor redColor];
        _xbdhHeight.constant = _xbdhLabelHeight + 10;
        [[XKHudHelper instance]hideProgressHudAnimationInView:self.view];
    }
    
    if ([taskID isEqualToString:@"upLoadPKNum"]) {
        NSLog(@"%@",result);
        [XKRWCui showInformationHudWithText:@"投票成功"];
        _zfLabel.text = [NSString stringWithFormat:@"正方观点:%@",[result objectForKey:@"zfps"]];
        _ffLabel.text = [NSString stringWithFormat:@"反方观点:%@",[result objectForKey:@"ffps"]];
        
        [[XKRWManagementService5_0 sharedService] setHadPKNum:_nid];
        
        _zfButton.layer.borderColor = [UIColor colorFromHexString:@"#c6c7cb"].CGColor;
        _ffButton.layer.borderColor = [UIColor colorFromHexString:@"#c6c7cb"].CGColor;
        [_zfButton setTitleColor:[UIColor colorFromHexString:@"#c6c7cb"] forState:UIControlStateNormal];
        [_ffButton setTitleColor:[UIColor colorFromHexString:@"#c6c7cb"] forState:UIControlStateNormal];

        _xbTipsLabel.hidden = NO;
        _xkdhTitleLabel.hidden = NO;
        _canShowDetail = YES;
        
        
        
    }
    [self resetViewHeight];
}



- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [[XKHudHelper instance]hideProgressHudAnimationInView:self.view];
    [self showRequestArticleNetworkFailedWarningShow];
    [super handleDownloadProblem:problem withTaskID:taskID];
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}


- (void)resetViewHeight
{
    if (!_canShowDetail) {
        _viewHeight = 280 + _lineHeightConstraint.constant + 40;
    }else{
        _zfButton.hidden = YES;
        _ffButton.hidden = YES;
        _viewHeight = 280 + _lineHeightConstraint.constant + 60 + _xbdhLabelHeight ;
    }
    
    if (_viewHeight > XKAppHeight) {
        _viewHeightConstraint.constant = _viewHeight + 64;
    }else{
        _viewHeightConstraint.constant = XKAppHeight + 64;
    }
}

- (void)popView {
    
    if(_isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [super popView];
    }
}

- (void)reLoadDataFromNetwork:(UIButton *)button
{
    [self initData];
}


- (IBAction)pkAction:(UIButton *)sender {
    NSString *updateStr;
    
    if (sender.tag == 1000) {
        updateStr = @"1";
    }else{
        updateStr = @"0";
    }
    
    if([XKRWUtil isNetWorkAvailable]){
        [self downloadWithTaskID:@"upLoadPKNum" outputTask:^{
            return  [[XKRWManagementService5_0 sharedService] uploadTogetherPK:updateStr andPKId:_nid];
        
        }];
    }else{
        [XKRWCui showInformationHudWithText:@"网络连接有问题,请稍后再试"];
    }
    
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
