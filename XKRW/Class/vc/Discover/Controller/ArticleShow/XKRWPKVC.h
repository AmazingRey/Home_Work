//
//  XKRWPKVC.h
//  XKRW
//
//  Created by 忘、 on 15/8/15.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@interface XKRWPKVC : XKRWBaseVC

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xbdhHeight;

@property (weak, nonatomic) IBOutlet UILabel *xkdhTitleLabel;
@property (nonatomic,strong) NSString* nid;
@property (weak, nonatomic) IBOutlet UIButton *zfButton;
@property (weak, nonatomic) IBOutlet UIButton *ffButton;

@property (weak, nonatomic) IBOutlet UILabel *pkTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pkImageView;

@property (weak, nonatomic) IBOutlet UILabel *pkStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *zfLabel;
@property (weak, nonatomic) IBOutlet UILabel *ffLabel;

@property (weak, nonatomic) IBOutlet UILabel *zfDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *ffDetailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *xbTipsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zfLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ffLabelConstraint;

@property (assign,nonatomic) BOOL isPresent;

- (void)initData;
@end
