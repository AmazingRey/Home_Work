//
//  XKRWAgreementVC.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-23.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWAgreementVC.h"
#import "XKRWCui.h"

@interface XKRWAgreementVC ()

@property (nonatomic,strong) UITextView *agreementTextView;

@end

@implementation XKRWAgreementVC

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
    self.forbidAutoAddCloseButton = YES;
    [super viewDidLoad];
    self.title = @"瘦瘦服务条款";
    self.navigationItem.hidesBackButton = YES;
    //定义view背景色
    self.view.backgroundColor = XKBGDefaultColor;
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];

    rightItemButton.frame = CGRectMake(0, 0, 44, 44);
    [rightItemButton setTitle:@"关闭" forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rightItemButton addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
    
    //从文本读取服务条款显示
    self.agreementTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    _agreementTextView.backgroundColor = [UIColor clearColor];
    _agreementTextView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    _agreementTextView.editable = NO;
    _agreementTextView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_agreementTextView];
    NSString *file = [[NSBundle mainBundle] pathForResource:@"licences" ofType:@"txt"];
    __autoreleasing NSError *error = nil;
    NSString *agreement = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        _agreementTextView.text = agreement;
    }
    else {
        [XKRWCui showAlertWithMessage:@"用户协议读取失败"];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect rect = self.view.bounds;
    rect.origin.x = 10;
    rect.size.width = XKAppWidth-15;
    _agreementTextView.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

@end
