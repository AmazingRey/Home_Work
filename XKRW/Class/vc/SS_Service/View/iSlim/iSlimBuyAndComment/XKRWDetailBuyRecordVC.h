//
//  XKRWDetailBuyRecordVC.h
//  XKRW
//
//  Created by y on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWOrderRecordEntity.h"

@interface XKRWDetailBuyRecordVC : XKRWBaseVC<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;



@property(nonatomic,strong)XKRWOrderRecordEntity  *orderRecordEntity;

- (IBAction)senderAppraise:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *starNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *evLabel;

@end
