//
//  XKRWPrivacyPassWordView.h
//  XKRW
//
//  Created by ss on 16/7/22.
//  Copyright © 2016年 XiKang. All rights reserved.
//

@protocol XKRWPrivacyPassWordVCDelegate <NSObject>
@optional
- (void)verifySucceed;

@end

#define SET_PRIVACYPASSWORD_FIRSTTIME @"setPrivacyPasswordFirstTime"
#define SET_PRIVACYPASSWORD_SUCCESS   @"setPrivacyPasswordSuccess"
#define DeleayTime                    .5

#import <UIKit/UIKit.h>

@interface XKRWPrivacyPassWordView : UIView <UITextFieldDelegate,UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) id<XKRWPrivacyPassWordVCDelegate> delegate;
@property (nonatomic, copy)   NSString *passWord;
@property (nonatomic, assign) PrivacyPasswordType privacyType;
@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, assign) BOOL showNavibar;

@property (strong, nonatomic) IBOutlet UIImageView *imageOne;

@property (strong, nonatomic) IBOutlet UIImageView        *imageTwo;
@property (strong, nonatomic) IBOutlet UIImageView        *imageThree;
@property (strong, nonatomic) IBOutlet UIImageView        *imageFour;
@property (strong, nonatomic) IBOutlet UITextField        *textField;
@property (strong, nonatomic) IBOutlet UILabel            *labelVerify;
@property (strong, nonatomic) IBOutlet UIButton           *forgetPasswordBtn;
@property (strong, nonatomic) IBOutlet UIButton           *configueLaterBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topImageTopConstraint;
@property (strong, nonatomic) IBOutlet UINavigationBar *naviBar;

- (IBAction)forgetPasswordAction:(id)sender;
- (IBAction)configueLaterAction:(id)sender;
@end
