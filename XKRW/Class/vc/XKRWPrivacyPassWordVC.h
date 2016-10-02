//
//  XKRWPrivacyPassWordVC.h
//  XKRW
//
//  Created by ss on 16/6/12.
//  Copyright © 2016年 XiKang. All rights reserved.
//


@protocol XKRWPrivacyPassWordVCDelegate <NSObject>
@optional
- (void)verifySucceed;

@end
#import "XKRWBaseVC.h"

@interface XKRWPrivacyPassWordVC : UIViewController <UITextFieldDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) id<XKRWPrivacyPassWordVCDelegate> delegate;
@property (nonatomic, copy)   NSString *passWord;
@property (nonatomic, assign) PrivacyPasswordType privacyType;
@property (nonatomic, assign) BOOL isVerified;
@end
