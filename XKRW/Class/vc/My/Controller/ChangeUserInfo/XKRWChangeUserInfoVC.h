//
//  XKRWPersonalInfoVC.h
//  XKRW
//
//  Created by Jiang Rui on 14-2-25.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWPickerViewVC.h"
#import "XKRWSlimPartView.h"
#import "XKRWPickerSheet.h"
#import <XKRW-Swift.h>
@interface XKRWChangeUserInfoVC : XKRWBaseVC<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong) XKRWUserHonorEnity  *entity;
@end



@interface PersonalInfoCell : UITableViewCell
@property (nonatomic,strong) UIButton *right_btn;

@property (nonatomic, strong)UIView * bottom;
@property (nonatomic,strong) UILabel* mylabel;

@property (nonatomic,strong) UIImageView *degreeImageView;

@end
