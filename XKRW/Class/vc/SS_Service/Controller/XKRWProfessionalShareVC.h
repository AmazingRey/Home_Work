//
//  XKRWProfessionalShareVC.h
//  XKRW
//
//  Created by y on 15-1-26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKColorProgressView.h"

@interface XKRWProfessionalShareVC : XKRWBaseVC<UITextFieldDelegate>
{
    UIView *bg;
    UIImage     *shareImg;
    UITextField  *infoTextf;

}
@property (weak, nonatomic) IBOutlet UILabel *fatlabel;
@property (weak, nonatomic) IBOutlet UILabel *foodStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *habitLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScorllView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (weak, nonatomic) IBOutlet UILabel *nowDateLabel;
@property (strong, nonatomic)  XKColorProgressView *fanrenProView;
@property (strong, nonatomic)  XKColorProgressView *shoushouProView;
@property (strong, nonatomic)  XKColorProgressView *islimProView;
@property (weak, nonatomic) IBOutlet UIImageView *houziImgView;
@property (weak, nonatomic) IBOutlet UILabel *fanrenSate;
@property (weak, nonatomic) IBOutlet UILabel *shoushouSate;
@property (weak, nonatomic) IBOutlet UILabel *silmSate;

- (IBAction)closeTheVC:(id)sender;
- (IBAction)wechatShare:(id)sender;
- (IBAction)pengyouquanShare:(id)sender;
- (IBAction)qqzoneShare:(id)sender;

- (IBAction)weiboShare:(id)sender;

@end
